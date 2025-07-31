from fastapi import FastAPI, Depends, HTTPException, UploadFile, File, Query, Form
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse, FileResponse
from sqlalchemy.orm import Session
from sqlalchemy import func, text
from typing import List, Optional
import pandas as pd
import chardet
import io
import json
from datetime import datetime, date
import csv
import os
from dotenv import load_dotenv

# Load environment variables（統一環境）
# 本番はsystemd環境変数、開発はコマンドライン環境変数を使用
load_dotenv('.env', override=False)

# WAMサービスのimport
try:
    from wam_service import WamService
    WAM_SERVICE_AVAILABLE = True
except ImportError as e:
    print(f"⚠️  WAM Service import failed: {e}")
    WAM_SERVICE_AVAILABLE = False

def parse_date(date_string):
    """複数の日付フォーマットに対応した日付パース"""
    if not date_string or not date_string.strip():
        return None
    
    date_formats = [
        '%Y-%m-%d',     # 2025-04-01
        '%Y/%m/%d',     # 2025/04/01
        '%Y/%m/%d',     # 2025/4/1 (同じフォーマットだが、先頭ゼロなし対応のため残す)
    ]
    
    for fmt in date_formats:
        try:
            return datetime.strptime(date_string.strip(), fmt).date()
        except ValueError:
            continue
    
    # 日付として認識できない場合はNoneを返す
    return None

def parse_amount(amount_string):
    """カンマ区切りの数値文字列を整数に変換"""
    if not amount_string or not amount_string.strip():
        return 0
    
    try:
        # カンマを除去して整数に変換
        return int(amount_string.strip().replace(',', ''))
    except ValueError:
        return 0

# 開発環境用設定 - 環境変数から直接取得（.envファイルは使用しない）
import os

# 統一環境設定（データベースのみ分離）
PORT = int(os.getenv("PORT", "8000"))
DATABASE_NAME = os.getenv("DATABASE_NAME", "nagaiku_budget")
FRONTEND_URL = "https://nagaiku.top/budget"

print(f"🚀 統一バックエンド起動:")
print(f"   PORT: {PORT}")
print(f"   DATABASE: {DATABASE_NAME}")
print(f"   FRONTEND_URL: {FRONTEND_URL}")

from database import get_db, create_tables, Transaction, Grant, BudgetItem, Allocation, FreeeToken, FreeeSync, Category
from schemas import (
    TransactionCreate, Transaction as TransactionSchema, TransactionWithAllocation,
    GrantCreate, Grant as GrantSchema,
    BudgetItemCreate, BudgetItem as BudgetItemSchema, BudgetItemWithGrant,
    AllocationCreate, Allocation as AllocationSchema,
    ImportResponse, PreviewResponse,
    FreeeAuthResponse, FreeeTokenResponse, FreeeSyncRequest, FreeeSyncResponse,
    CategoryCreate, Category as CategorySchema
)
from freee_service import FreeeService

app = FastAPI(title="NPO Budget Management System - 統一環境")

# CORS設定（統一）
allowed_origins = [
    FRONTEND_URL,
    "http://160.251.170.97:3000",
    "http://localhost:3000"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allow_headers=["*"],
)

# Create tables on startup
@app.on_event("startup")
def startup_event():
    create_tables()
    print(f"✅ 開発環境データベーステーブル作成完了")

# Debug endpoint for database connection
@app.get("/api/debug/db-info")
def get_db_info():
    import os
    from database import get_database_url
    
    database_url = get_database_url()
    
    return {
        "environment": ENVIRONMENT,
        "node_env": NODE_ENV,
        "port": PORT,
        "frontend_url": FRONTEND_URL,
        "database_url": database_url,
        "is_dev_db": "budget_dev" in database_url,
        "is_prod_db": "budget_dev" not in database_url and "nagaiku_budget" in database_url
    }

# Health check endpoint
@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "environment": ENVIRONMENT,
        "port": PORT,
        "timestamp": datetime.now().isoformat()
    }

# Transactions endpoints
@app.get("/api/transactions", response_model=List[TransactionWithAllocation])
def get_transactions(skip: int = 0, limit: int = 1000, db: Session = Depends(get_db)):
    transactions = db.query(Transaction).offset(skip).limit(limit).all()
    
    # Add allocation info
    result = []
    for transaction in transactions:
        transaction_dict = {
            "id": transaction.id,
            "journal_number": transaction.journal_number,
            "journal_line_number": transaction.journal_line_number,
            "date": transaction.date,
            "description": transaction.description,
            "amount": transaction.amount,
            "account": transaction.account,
            "supplier": transaction.supplier,
            "item": transaction.item,
            "memo": transaction.memo,
            "remark": transaction.remark,
            "department": transaction.department,
            "management_number": transaction.management_number,
            "freee_deal_id": transaction.freee_deal_id,
            "created_at": transaction.created_at,
            "budget_item": None,
            "allocated_amount": None
        }
        
        # Get allocation info
        allocation = db.query(Allocation).filter(Allocation.transaction_id == transaction.id).first()
        if allocation:
            budget_item = db.query(BudgetItem).filter(BudgetItem.id == allocation.budget_item_id).first()
            if budget_item:
                grant = db.query(Grant).filter(Grant.id == budget_item.grant_id).first()
                transaction_dict["budget_item"] = {
                    "id": budget_item.id,
                    "name": budget_item.name,
                    "category": budget_item.category,
                    "budgeted_amount": budget_item.budgeted_amount,
                    "grant_id": budget_item.grant_id,
                    "grant_name": grant.name if grant else "",
                    "grant_status": grant.status if grant else "active",
                    "display_name": f"{grant.name if grant else ''}-{budget_item.name}"
                }
            transaction_dict["allocated_amount"] = allocation.amount
        
        result.append(transaction_dict)
    
    return result

@app.put("/api/transactions/{transaction_id}", response_model=TransactionSchema)
def update_transaction(transaction_id: int, transaction_update: dict, db: Session = Depends(get_db)):
    db_transaction = db.query(Transaction).filter(Transaction.id == transaction_id).first()
    if not db_transaction:
        raise HTTPException(status_code=404, detail="Transaction not found")
    
    for field, value in transaction_update.items():
        if hasattr(db_transaction, field):
            setattr(db_transaction, field, value)
    
    db.commit()
    db.refresh(db_transaction)
    return db_transaction

@app.delete("/api/transactions/{transaction_id}")
def delete_transaction(transaction_id: int, db: Session = Depends(get_db)):
    db_transaction = db.query(Transaction).filter(Transaction.id == transaction_id).first()
    if not db_transaction:
        raise HTTPException(status_code=404, detail="Transaction not found")
    
    # Delete related allocations first
    db.query(Allocation).filter(Allocation.transaction_id == transaction_id).delete()
    
    db.delete(db_transaction)
    db.commit()
    return {"message": "Transaction deleted successfully"}

@app.post("/api/transactions/import", response_model=ImportResponse)
async def import_transactions(file: UploadFile = File(...), db: Session = Depends(get_db)):
    try:
        # Read file content
        contents = await file.read()
        
        # Improved encoding detection with fallback
        detected = chardet.detect(contents)
        encoding = detected['encoding'] if detected and detected['encoding'] else 'utf-8'
        
        try:
            df = pd.read_csv(io.BytesIO(contents), encoding=encoding)
        except UnicodeDecodeError:
            # Try with different encodings if the detected one fails
            for fallback_encoding in ['shift_jis', 'cp932', 'utf-8', 'latin-1']:
                try:
                    df = pd.read_csv(io.BytesIO(contents), encoding=fallback_encoding)
                    break
                except UnicodeDecodeError:
                    continue
            else:
                raise HTTPException(status_code=400, detail="ファイルの文字エンコーディングを判定できませんでした")
        
        # Check required columns - flexible approach for amount columns
        essential_columns = ['借方勘定科目', '貸方勘定科目', '仕訳番号', '仕訳行番号', '取引日', '取引内容']
        amount_columns = ['借方金額', '貸方金額']
        
        # Check essential columns
        missing_essential = [col for col in essential_columns if col not in df.columns]
        if missing_essential:
            available_columns = list(df.columns)
            raise HTTPException(
                status_code=400, 
                detail=f"必須列が見つかりません: {', '.join(missing_essential)}。利用可能な列: {', '.join(available_columns)}"
            )
        
        # Check if at least one amount column exists
        available_amount_columns = [col for col in amount_columns if col in df.columns]
        if not available_amount_columns:
            available_columns = list(df.columns)
            raise HTTPException(
                status_code=400, 
                detail=f"金額列が見つかりません。借方金額または貸方金額のいずれかが必要です。利用可能な列: {', '.join(available_columns)}"
            )
        
        # Filter transactions with 【事】or 【管】
        mask = (
            df['借方勘定科目'].str.startswith(('【事】', '【管】'), na=False) |
            df['貸方勘定科目'].str.startswith(('【事】', '【管】'), na=False)
        )
        filtered_df = df[mask]
        
        imported_count = 0
        updated_count = 0
        created_count = 0
        
        for _, row in filtered_df.iterrows():
            try:
                # 支払のみを対象とするため、借方の【事】【管】勘定科目のみ処理
                if str(row['借方勘定科目']).startswith(('【事】', '【管】')):
                    account = row['借方勘定科目']
                    # Try to get amount from available amount columns
                    amount = 0
                    if '借方金額' in df.columns and pd.notna(row['借方金額']):
                        try:
                            amount = int(float(row['借方金額'])) if str(row['借方金額']).strip() else 0
                        except (ValueError, TypeError):
                            amount = 0
                else:
                    # 貸方の【事】【管】は収入の可能性が高いのでスキップ
                    continue
                
                # Skip transactions with zero or negative amounts (e.g., income transactions)
                if amount <= 0:
                    continue
                
                # Check if transaction already exists by journal_number and journal_line_number
                existing = db.query(Transaction).filter(
                    Transaction.journal_number == int(row['仕訳番号']),
                    Transaction.journal_line_number == int(row['仕訳行番号'])
                ).first()
                
                if existing:
                    # Update existing transaction
                    existing.date = pd.to_datetime(row['取引日']).date()
                    existing.description = row['取引内容'] if pd.notna(row['取引内容']) else ''
                    existing.amount = amount
                    existing.account = account
                    existing.supplier = row['借方取引先名'] if pd.notna(row['借方取引先名']) else row['貸方取引先名'] if pd.notna(row['貸方取引先名']) else ''
                    existing.item = row['借方品目'] if pd.notna(row['借方品目']) else ''
                    existing.memo = row['借方メモ'] if pd.notna(row['借方メモ']) else ''
                    existing.remark = row['借方備考'] if pd.notna(row['借方備考']) else ''
                    existing.department = row['借方部門'] if pd.notna(row['借方部門']) else ''
                    existing.management_number = row['管理番号'] if pd.notna(row['管理番号']) else ''
                    existing.raw_data = row.to_json()
                    
                    updated_count += 1
                else:
                    # Create new transaction
                    transaction_id = f"{row['仕訳番号']}_{row['仕訳行番号']}"
                    
                    transaction = Transaction(
                        id=transaction_id,
                        journal_number=int(row['仕訳番号']),
                        journal_line_number=int(row['仕訳行番号']),
                        date=pd.to_datetime(row['取引日']).date(),
                        description=row['取引内容'] if pd.notna(row['取引内容']) else '',
                        amount=amount,
                        account=account,
                        supplier=row['借方取引先名'] if pd.notna(row['借方取引先名']) else row['貸方取引先名'] if pd.notna(row['貸方取引先名']) else '',
                        item=row['借方品目'] if pd.notna(row['借方品目']) else '',
                        memo=row['借方メモ'] if pd.notna(row['借方メモ']) else '',
                        remark=row['借方備考'] if pd.notna(row['借方備考']) else '',
                        department=row['借方部門'] if pd.notna(row['借方部門']) else '',
                        management_number=row['管理番号'] if pd.notna(row['管理番号']) else '',
                        raw_data=row.to_json()
                    )
                    
                    db.add(transaction)
                    created_count += 1
                
                imported_count += 1
            except Exception as e:
                print(f"Error processing row: {e}")
                continue
        
        db.commit()
        
        return ImportResponse(
            message=f"{imported_count}件の取引を処理しました（新規作成: {created_count}件、更新: {updated_count}件）",
            total_checked=len(df),
            imported_count=imported_count,
            updated_count=updated_count,
            created_count=created_count
        )
    except HTTPException:
        raise
    except Exception as e:
        error_msg = str(e) if str(e) else f"{type(e).__name__}: 不明なエラー"
        print(f"Import error: {error_msg}")
        raise HTTPException(status_code=500, detail=f"ファイルの処理中にエラーが発生しました: {error_msg}")

@app.post("/api/transactions/preview", response_model=PreviewResponse)
async def preview_transactions(file: UploadFile = File(...)):
    try:
        contents = await file.read()
        
        # Improved encoding detection with fallback
        detected = chardet.detect(contents)
        encoding = detected['encoding'] if detected and detected['encoding'] else 'utf-8'
        
        try:
            df = pd.read_csv(io.BytesIO(contents), encoding=encoding)
        except UnicodeDecodeError:
            # Try with different encodings if the detected one fails
            for fallback_encoding in ['shift_jis', 'cp932', 'utf-8', 'latin-1']:
                try:
                    df = pd.read_csv(io.BytesIO(contents), encoding=fallback_encoding)
                    break
                except UnicodeDecodeError:
                    continue
            else:
                raise HTTPException(status_code=400, detail="ファイルの文字エンコーディングを判定できませんでした")
        
        # Check required columns - flexible approach for amount columns
        essential_columns = ['借方勘定科目', '貸方勘定科目', '仕訳番号', '仕訳行番号', '取引日', '取引内容']
        amount_columns = ['借方金額', '貸方金額']
        
        # Check essential columns
        missing_essential = [col for col in essential_columns if col not in df.columns]
        if missing_essential:
            available_columns = list(df.columns)
            raise HTTPException(
                status_code=400, 
                detail=f"必須列が見つかりません: {', '.join(missing_essential)}。利用可能な列: {', '.join(available_columns)}"
            )
        
        # Check if at least one amount column exists
        available_amount_columns = [col for col in amount_columns if col in df.columns]
        if not available_amount_columns:
            available_columns = list(df.columns)
            raise HTTPException(
                status_code=400, 
                detail=f"金額列が見つかりません。借方金額または貸方金額のいずれかが必要です。利用可能な列: {', '.join(available_columns)}"
            )
        
        # Filter transactions
        mask = (
            df['借方勘定科目'].str.startswith(('【事】', '【管】'), na=False) |
            df['貸方勘定科目'].str.startswith(('【事】', '【管】'), na=False)
        )
        filtered_df = df[mask]
        
        # Create preview data
        preview_data = []
        for _, row in filtered_df.head(10).iterrows():
            try:
                if str(row['借方勘定科目']).startswith(('【事】', '【管】')):
                    account = row['借方勘定科目']
                    # Try to get amount from available amount columns
                    amount = 0
                    if '借方金額' in df.columns and pd.notna(row['借方金額']):
                        try:
                            amount = int(float(row['借方金額'])) if str(row['借方金額']).strip() else 0
                        except (ValueError, TypeError):
                            amount = 0
                else:
                    account = row['貸方勘定科目']
                    amount = 0
                    if '貸方金額' in df.columns and pd.notna(row['貸方金額']):
                        try:
                            amount = int(float(row['貸方金額'])) if str(row['貸方金額']).strip() else 0
                        except (ValueError, TypeError):
                            amount = 0
                
                preview_data.append({
                    'id': f"{row['仕訳番号']}_{row['仕訳行番号']}",
                    'date': str(row['取引日']),
                    'description': row['取引内容'] if pd.notna(row['取引内容']) else '',
                    'amount': amount,
                    'account': account,
                    'supplier': row['借方取引先名'] if pd.notna(row['借方取引先名']) else row['貸方取引先名'] if pd.notna(row['貸方取引先名']) else ''
                })
            except Exception as e:
                print(f"Error processing row: {e}")
                continue
        
        return PreviewResponse(
            total_rows=len(df),
            filtered_rows=len(filtered_df),
            preview=preview_data
        )
    except HTTPException:
        raise
    except Exception as e:
        error_msg = str(e) if str(e) else f"{type(e).__name__}: 不明なエラー"
        print(f"Preview error: {error_msg}")
        raise HTTPException(status_code=500, detail=f"ファイルの処理中にエラーが発生しました: {error_msg}")

# Grants endpoints
@app.get("/api/grants", response_model=List[GrantSchema])
def get_grants(db: Session = Depends(get_db)):
    return db.query(Grant).all()

@app.post("/api/grants", response_model=GrantSchema)
def create_grant(grant: GrantCreate, db: Session = Depends(get_db)):
    db_grant = Grant(**grant.dict())
    db.add(db_grant)
    db.commit()
    db.refresh(db_grant)
    return db_grant

@app.put("/api/grants/{grant_id}", response_model=GrantSchema)
def update_grant(grant_id: int, grant_update: dict, db: Session = Depends(get_db)):
    db_grant = db.query(Grant).filter(Grant.id == grant_id).first()
    if not db_grant:
        raise HTTPException(status_code=404, detail="Grant not found")
    
    for field, value in grant_update.items():
        if hasattr(db_grant, field):
            setattr(db_grant, field, value)
    
    db.commit()
    db.refresh(db_grant)
    return db_grant

@app.delete("/api/grants/{grant_id}")
def delete_grant(grant_id: int, db: Session = Depends(get_db)):
    db_grant = db.query(Grant).filter(Grant.id == grant_id).first()
    if not db_grant:
        raise HTTPException(status_code=404, detail="Grant not found")
    
    # Check if there are budget items using this grant
    budget_items = db.query(BudgetItem).filter(BudgetItem.grant_id == grant_id).first()
    if budget_items:
        raise HTTPException(status_code=400, detail="Cannot delete grant with associated budget items")
    
    db.delete(db_grant)
    db.commit()
    return {"message": "Grant deleted successfully"}

# Categories API
@app.get("/api/categories", response_model=List[CategorySchema])
def get_categories(db: Session = Depends(get_db)):
    return db.query(Category).filter(Category.is_active == True).all()

@app.post("/api/categories", response_model=CategorySchema)
def create_category(category: CategoryCreate, db: Session = Depends(get_db)):
    # Check if category already exists
    existing = db.query(Category).filter(Category.name == category.name).first()
    if existing:
        raise HTTPException(status_code=400, detail="Category already exists")
    
    db_category = Category(**category.dict())
    db.add(db_category)
    db.commit()
    db.refresh(db_category)
    return db_category

@app.put("/api/categories/{category_id}", response_model=CategorySchema)
def update_category(category_id: int, category_update: dict, db: Session = Depends(get_db)):
    db_category = db.query(Category).filter(Category.id == category_id).first()
    if not db_category:
        raise HTTPException(status_code=404, detail="Category not found")
    
    for field, value in category_update.items():
        if hasattr(db_category, field):
            setattr(db_category, field, value)
    
    db.commit()
    db.refresh(db_category)
    return db_category

@app.delete("/api/categories/{category_id}")
def delete_category(category_id: int, db: Session = Depends(get_db)):
    db_category = db.query(Category).filter(Category.id == category_id).first()
    if not db_category:
        raise HTTPException(status_code=404, detail="Category not found")
    
    db_category.is_active = False
    db.commit()
    return {"message": "Category deleted successfully"}

# Budget Items endpoints
@app.get("/api/budget-items", response_model=List[BudgetItemWithGrant])
def get_budget_items(db: Session = Depends(get_db)):
    print(f"📥 予算項目一覧取得リクエスト")
    budget_items = db.query(BudgetItem).join(Grant).all()
    print(f"📋 データベースから取得した項目数: {len(budget_items)}")
    
    result = []
    for budget_item in budget_items:
        # ID=11の項目をデバッグ出力
        if budget_item.id == 11:
            print(f"🔍 ID=11項目の詳細: id={budget_item.id}, remarks='{budget_item.remarks}', name='{budget_item.name}'")
        
        result.append({
            "id": budget_item.id,
            "name": budget_item.name,
            "category": budget_item.category,
            "budgeted_amount": budget_item.budgeted_amount,
            "grant_id": budget_item.grant_id,
            "grant_name": budget_item.grant.name,
            "display_name": f"{budget_item.grant.name}-{budget_item.name}",
            "remarks": budget_item.remarks,
            "planned_start_date": budget_item.planned_start_date,
            "planned_end_date": budget_item.planned_end_date
        })
    
    return result

@app.post("/api/budget-items", response_model=BudgetItemSchema)
def create_budget_item(budget_item: BudgetItemCreate, db: Session = Depends(get_db)):
    print(f"📝 予算項目作成リクエスト: {budget_item.dict()}")
    
    db_item = BudgetItem(**budget_item.dict())
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    
    print(f"✅ 作成された予算項目: ID={db_item.id}, データ={db_item.__dict__}")
    return db_item

@app.put("/api/budget-items/{budget_item_id}", response_model=BudgetItemSchema)
def update_budget_item(budget_item_id: int, budget_item_update: dict, db: Session = Depends(get_db)):
    from datetime import datetime
    
    print(f"🔄 予算項目更新リクエスト: ID={budget_item_id}, データ={budget_item_update}")
    
    db_item = db.query(BudgetItem).filter(BudgetItem.id == budget_item_id).first()
    if not db_item:
        print(f"❌ 予算項目が見つかりません: ID={budget_item_id}")
        raise HTTPException(status_code=404, detail="Budget item not found")
    
    print(f"📝 更新前データ: {db_item.__dict__}")
    
    for field, value in budget_item_update.items():
        if hasattr(db_item, field):
            old_value = getattr(db_item, field)
            
            # 日付フィールドの特別処理
            if field in ['planned_start_date', 'planned_end_date'] and value:
                if isinstance(value, str):
                    # ISO形式の文字列の場合は日付部分のみ抽出
                    if 'T' in value:
                        value = value.split('T')[0]
                    # YYYY-MM-DD形式の文字列をdateオブジェクトに変換
                    try:
                        value = datetime.strptime(value, '%Y-%m-%d').date()
                    except ValueError:
                        print(f"⚠️ 無効な日付形式: {value}")
                        value = None
            
            setattr(db_item, field, value)
            print(f"  {field}: {old_value} → {value}")
        else:
            print(f"⚠️  不明なフィールド: {field} = {value}")
    
    try:
        db.commit()
        db.refresh(db_item)
        print(f"✅ 更新後データ: {db_item.__dict__}")
        
        # データベースから改めて取得して保存を確認
        verification_item = db.query(BudgetItem).filter(BudgetItem.id == budget_item_id).first()
        print(f"🔍 確認用データ: {verification_item.__dict__}")
        return db_item
    except Exception as commit_error:
        print(f"❌ コミットエラー: {commit_error}")
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Database commit failed: {str(commit_error)}")

@app.delete("/api/budget-items/{budget_item_id}")
def delete_budget_item(budget_item_id: int, db: Session = Depends(get_db)):
    db_item = db.query(BudgetItem).filter(BudgetItem.id == budget_item_id).first()
    if not db_item:
        raise HTTPException(status_code=404, detail="Budget item not found")
    
    db.delete(db_item)
    db.commit()
    return {"message": "Budget item deleted successfully"}

# Allocations endpoints
@app.get("/api/allocations", response_model=List[AllocationSchema])
def get_allocations(db: Session = Depends(get_db)):
    return db.query(Allocation).all()

@app.post("/api/allocations", response_model=AllocationSchema)
def create_allocation(allocation: AllocationCreate, db: Session = Depends(get_db)):
    # Remove existing allocation for this transaction
    existing = db.query(Allocation).filter(Allocation.transaction_id == allocation.transaction_id).first()
    if existing:
        db.delete(existing)
    
    db_allocation = Allocation(**allocation.dict())
    db.add(db_allocation)
    db.commit()
    db.refresh(db_allocation)
    return db_allocation

@app.put("/api/allocations/{allocation_id}", response_model=AllocationSchema)
def update_allocation(allocation_id: int, allocation_update: dict, db: Session = Depends(get_db)):
    db_allocation = db.query(Allocation).filter(Allocation.id == allocation_id).first()
    if not db_allocation:
        raise HTTPException(status_code=404, detail="Allocation not found")
    
    for field, value in allocation_update.items():
        if hasattr(db_allocation, field):
            setattr(db_allocation, field, value)
    
    db.commit()
    db.refresh(db_allocation)
    return db_allocation

@app.delete("/api/allocations/{allocation_id}")
def delete_allocation(allocation_id: int, db: Session = Depends(get_db)):
    db_allocation = db.query(Allocation).filter(Allocation.id == allocation_id).first()
    if not db_allocation:
        raise HTTPException(status_code=404, detail="Allocation not found")
    
    db.delete(db_allocation)
    db.commit()
    return {"message": "Allocation deleted successfully"}

@app.post("/api/allocations/batch")
def create_batch_allocations(allocations: List[AllocationCreate], db: Session = Depends(get_db)):
    for allocation in allocations:
        # Remove existing allocation for this transaction
        existing = db.query(Allocation).filter(Allocation.transaction_id == allocation.transaction_id).first()
        if existing:
            db.delete(existing)
        
        db_allocation = Allocation(**allocation.dict())
        db.add(db_allocation)
    
    db.commit()
    return {"message": f"{len(allocations)}件の割り当てを作成しました"}

# Reports endpoints
@app.get("/api/reports/cross-table")
def get_cross_table(start_date: str, end_date: str, db: Session = Depends(get_db)):
    try:
        # PostgreSQL-compatible query for cross-tabulation with grant names (including unallocated)
        query = """
        WITH allocated_data AS (
            SELECT 
                CONCAT(g.name, '-', bi.name) as budget_item,
                TO_CHAR(t.date, 'YYYY-MM') as month,
                SUM(a.amount) as total
            FROM allocations a
            JOIN transactions t ON a.transaction_id = t.id
            JOIN budget_items bi ON a.budget_item_id = bi.id
            JOIN grants g ON bi.grant_id = g.id
            WHERE t.date BETWEEN :start_date AND :end_date
            GROUP BY g.name, bi.name, TO_CHAR(t.date, 'YYYY-MM')
        ),
        unallocated_data AS (
            SELECT 
                '未割当' as budget_item,
                TO_CHAR(t.date, 'YYYY-MM') as month,
                SUM(t.amount) as total
            FROM transactions t
            LEFT JOIN allocations a ON t.id = a.transaction_id
            WHERE t.date BETWEEN :start_date AND :end_date
              AND a.transaction_id IS NULL
            GROUP BY TO_CHAR(t.date, 'YYYY-MM')
        )
        SELECT budget_item, month, total FROM allocated_data
        UNION ALL
        SELECT budget_item, month, total FROM unallocated_data
        ORDER BY budget_item, month
        """
        
        # Use text() for raw SQL with proper parameter binding
        results = db.execute(text(query), {"start_date": start_date, "end_date": end_date})
        
        # Convert to pivot format
        pivot_data = {}
        for row in results:
            budget_item = row[0]  # budget_item
            month = row[1]        # month
            total = row[2]        # total
            
            if budget_item not in pivot_data:
                pivot_data[budget_item] = {}
            pivot_data[budget_item][month] = total
        
        return pivot_data
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"クロス集計表の取得中にエラーが発生しました: {str(e)}")

@app.get("/api/reports/category-cross-table")
def get_category_cross_table(start_date: str, end_date: str, db: Session = Depends(get_db)):
    try:
        # カテゴリごとのクロス集計クエリ (including unallocated)
        query = """
        WITH allocated_data AS (
            SELECT 
                COALESCE(bi.category, '未分類') as category,
                TO_CHAR(t.date, 'YYYY-MM') as month,
                SUM(a.amount) as total
            FROM allocations a
            JOIN transactions t ON a.transaction_id = t.id
            JOIN budget_items bi ON a.budget_item_id = bi.id
            JOIN grants g ON bi.grant_id = g.id
            WHERE t.date BETWEEN :start_date AND :end_date
            GROUP BY COALESCE(bi.category, '未分類'), TO_CHAR(t.date, 'YYYY-MM')
        ),
        unallocated_data AS (
            SELECT 
                '未割当' as category,
                TO_CHAR(t.date, 'YYYY-MM') as month,
                SUM(t.amount) as total
            FROM transactions t
            LEFT JOIN allocations a ON t.id = a.transaction_id
            WHERE t.date BETWEEN :start_date AND :end_date
              AND a.transaction_id IS NULL
            GROUP BY TO_CHAR(t.date, 'YYYY-MM')
        )
        SELECT category, month, total FROM allocated_data
        UNION ALL
        SELECT category, month, total FROM unallocated_data
        ORDER BY category, month
        """
        
        # Use text() for raw SQL with proper parameter binding
        results = db.execute(text(query), {"start_date": start_date, "end_date": end_date})
        
        # Convert to pivot format
        pivot_data = {}
        for row in results:
            category = row[0]     # category
            month = row[1]        # month
            total = row[2]        # total
            
            if category not in pivot_data:
                pivot_data[category] = {}
            pivot_data[category][month] = total
        
        return pivot_data
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"カテゴリ別クロス集計表の取得中にエラーが発生しました: {str(e)}")

# CSV Export/Import endpoints
@app.get("/api/export/grants-budget-allocations")
def export_grants_budget_allocations(db: Session = Depends(get_db)):
    """助成金・予算項目データをCSVでエクスポート（割当データは含まない）"""
    # データを取得（報告終了を除外）
    grants = db.query(Grant).filter(Grant.status != "報告終了").all()
    budget_items = db.query(BudgetItem).join(Grant).filter(Grant.status != "報告終了").all()
    
    # CSVデータを作成
    output = io.StringIO()
    
    # BOMを追加（Excel用）
    output.write('\ufeff')
    
    writer = csv.writer(output)
    
    # 助成金データ
    writer.writerow(['[助成金データ]'])
    writer.writerow(['ID', '名称', '助成金コード', '総額', '開始日', '終了日', 'ステータス'])
    for grant in grants:
        writer.writerow([
            grant.id,
            grant.name,
            grant.grant_code or '',
            grant.total_amount or '',
            grant.start_date.strftime('%Y-%m-%d') if grant.start_date else '',
            grant.end_date.strftime('%Y-%m-%d') if grant.end_date else '',
            grant.status
        ])
    
    writer.writerow([])  # 空行
    
    # 予算項目データ
    writer.writerow(['[予算項目データ]'])
    writer.writerow(['ID', '助成金ID', '名称', 'カテゴリ', '予算額', '備考'])
    for item in budget_items:
        writer.writerow([
            item.id,
            item.grant_id,
            item.name,
            item.category or '',
            item.budgeted_amount,
            item.remarks or ''
        ])
    
    output.seek(0)
    
    return StreamingResponse(
        io.BytesIO(output.getvalue().encode('utf-8')),
        media_type='text/csv',
        headers={
            'Content-Disposition': f'attachment; filename=grants_budget_{datetime.now().strftime("%Y%m%d_%H%M%S")}.csv'
        }
    )

@app.get("/api/export/allocations")
def export_allocations(
    db: Session = Depends(get_db),
    start_date: Optional[str] = Query(None),
    end_date: Optional[str] = Query(None)
):
    """割当データのみをCSVでエクスポート"""
    # 割当データを取引・予算項目・助成金情報と共に取得
    query = db.query(
        Allocation.id,
        Allocation.transaction_id,
        Allocation.budget_item_id,
        Allocation.amount,
        Transaction.date,
        Transaction.description,
        Transaction.supplier,
        BudgetItem.name.label('budget_item_name'),
        Grant.name.label('grant_name')
    ).join(
        Transaction, Allocation.transaction_id == Transaction.id
    ).join(
        BudgetItem, Allocation.budget_item_id == BudgetItem.id
    ).join(
        Grant, BudgetItem.grant_id == Grant.id
    )
    
    # 期間フィルタリング
    if start_date:
        query = query.filter(Transaction.date >= start_date)
    if end_date:
        query = query.filter(Transaction.date <= end_date)
    
    allocations = query.order_by(Transaction.date.desc()).all()
    
    # CSVデータを作成
    output = io.StringIO()
    
    # BOMを追加（Excel用）
    output.write('\ufeff')
    
    writer = csv.writer(output)
    
    # ヘッダー行
    writer.writerow([
        'ID', '取引ID', '予算項目ID', '金額', '取引日', 
        '摘要', '仕入先', '予算項目名', '助成金名'
    ])
    
    # データ行
    for allocation in allocations:
        writer.writerow([
            allocation.id,
            allocation.transaction_id,
            allocation.budget_item_id,
            allocation.amount,
            allocation.date.strftime('%Y-%m-%d') if allocation.date else '',
            allocation.description or '',
            allocation.supplier or '',
            allocation.budget_item_name,
            allocation.grant_name
        ])
    
    output.seek(0)
    
    return StreamingResponse(
        io.BytesIO(output.getvalue().encode('utf-8')),
        media_type='text/csv',
        headers={
            'Content-Disposition': f'attachment; filename=allocations_{datetime.now().strftime("%Y%m%d_%H%M%S")}.csv'
        }
    )

@app.get("/api/export/all-data")
def export_all_data(
    db: Session = Depends(get_db),
    start_date: Optional[str] = Query(None),
    end_date: Optional[str] = Query(None)
):
    """取引・助成金・予算項目・割当の統合データをCSVでエクスポート"""
    # 全データを結合して取得
    query = db.query(
        Transaction.id.label('transaction_id'),
        Transaction.journal_number,
        Transaction.journal_line_number,
        Transaction.date,
        Transaction.description,
        Transaction.amount,
        Transaction.account,
        Transaction.supplier,
        Transaction.item,
        Transaction.memo,
        Transaction.remark,
        Transaction.department,
        Transaction.management_number,
        Allocation.id.label('allocation_id'),
        Allocation.amount.label('allocated_amount'),
        BudgetItem.id.label('budget_item_id'),
        BudgetItem.name.label('budget_item_name'),
        BudgetItem.category,
        BudgetItem.budgeted_amount,
        Grant.id.label('grant_id'),
        Grant.name.label('grant_name'),
        Grant.total_amount.label('grant_total_amount'),
        Grant.start_date.label('grant_start_date'),
        Grant.end_date.label('grant_end_date'),
        Grant.status.label('grant_status')
    ).outerjoin(
        Allocation, Transaction.id == Allocation.transaction_id
    ).outerjoin(
        BudgetItem, Allocation.budget_item_id == BudgetItem.id
    ).outerjoin(
        Grant, BudgetItem.grant_id == Grant.id
    )
    
    # 期間フィルタリング
    if start_date:
        query = query.filter(Transaction.date >= start_date)
    if end_date:
        query = query.filter(Transaction.date <= end_date)
    
    result = query.all()
    
    # CSVデータを作成
    output = io.StringIO()
    
    # BOMを追加（Excel用）
    output.write('\ufeff')
    
    writer = csv.writer(output)
    
    # ヘッダー行
    writer.writerow([
        '取引ID', '仕訳番号', '行番号', '取引日', '取引内容', '金額',
        '勘定科目', '取引先', '品目', 'メモ', '備考', '部門', '管理番号',
        '割当ID', '割当金額', '予算項目ID', '予算項目名', 'カテゴリ', '予算額',
        '助成金ID', '助成金名', '助成金総額', '助成金開始日', '助成金終了日', '助成金ステータス'
    ])
    
    # データ行
    for row in result:
        writer.writerow([
            row.transaction_id,
            row.journal_number,
            row.journal_line_number,
            row.date.strftime('%Y-%m-%d') if row.date else '',
            row.description or '',
            row.amount,
            row.account or '',
            row.supplier or '',
            row.item or '',
            row.memo or '',
            row.remark or '',
            row.department or '',
            row.management_number or '',
            row.allocation_id or '',
            row.allocated_amount or '',
            row.budget_item_id or '',
            row.budget_item_name or '',
            row.category or '',
            row.budgeted_amount or '',
            row.grant_id or '',
            row.grant_name or '',
            row.grant_total_amount or '',
            row.grant_start_date.strftime('%Y-%m-%d') if row.grant_start_date else '',
            row.grant_end_date.strftime('%Y-%m-%d') if row.grant_end_date else '',
            row.grant_status or ''
        ])
    
    output.seek(0)
    
    return StreamingResponse(
        io.BytesIO(output.getvalue().encode('utf-8')),
        media_type='text/csv',
        headers={
            'Content-Disposition': f'attachment; filename=all_data_{datetime.now().strftime("%Y%m%d_%H%M%S")}.csv'
        }
    )

@app.post("/api/preview/grants-budget-allocations", response_model=PreviewResponse)
async def preview_grants_budget_allocations(file: UploadFile = File(...)):
    """助成金・予算項目・割当データのCSVプレビュー"""
    try:
        # ファイル内容を読み取り
        contents = await file.read()
        
        # 文字エンコーディングを検出
        detected = chardet.detect(contents)
        encoding = detected['encoding'] or 'utf-8'
        
        # CSVデータを解析
        text_data = contents.decode(encoding)
        
        # BOMを削除
        if text_data.startswith('\ufeff'):
            text_data = text_data[1:]
        
        lines = text_data.strip().split('\n')
        reader = csv.reader(lines)
        
        # セクションごとにデータを分離
        grants_data = []
        budget_items_data = []
        allocations_data = []
        
        current_section = None
        
        for row in reader:
            if not row or not row[0]:
                continue
                
            if row[0] == '[助成金データ]':
                current_section = 'grants'
                continue
            elif row[0] == '[予算項目データ]':
                current_section = 'budget_items'
                continue
            elif row[0] == '[割当データ]':
                current_section = 'allocations'
                continue
            elif row[0] in ['ID', 'ID', 'ID']:  # ヘッダー行をスキップ
                continue
                
            if current_section == 'grants':
                grants_data.append(row)
            elif current_section == 'budget_items':
                budget_items_data.append(row)
            elif current_section == 'allocations':
                allocations_data.append(row)
        
        # プレビューデータを作成
        preview_data = []
        
        # 助成金データのプレビュー
        for i, row in enumerate(grants_data[:10]):  # 最初の10件のみ
            if len(row) >= 6:
                preview_data.append({
                    'section': '助成金',
                    'row_number': i + 1,
                    'data': {
                        'ID': row[0] if len(row) > 0 else '',
                        '名前': row[1] if len(row) > 1 else '',
                        '総額': row[2] if len(row) > 2 else '',
                        '開始日': row[3] if len(row) > 3 else '',
                        '終了日': row[4] if len(row) > 4 else '',
                        'ステータス': row[5] if len(row) > 5 else ''
                    }
                })
        
        # 予算項目データのプレビュー
        for i, row in enumerate(budget_items_data[:10]):  # 最初の10件のみ
            if len(row) >= 5:
                preview_data.append({
                    'section': '予算項目',
                    'row_number': i + 1,
                    'data': {
                        'ID': row[0] if len(row) > 0 else '',
                        '助成金ID': row[1] if len(row) > 1 else '',
                        '名前': row[2] if len(row) > 2 else '',
                        'カテゴリ': row[3] if len(row) > 3 else '',
                        '予算額': row[4] if len(row) > 4 else ''
                    }
                })
        
        # 割当データのプレビュー
        for i, row in enumerate(allocations_data[:10]):  # 最初の10件のみ
            if len(row) >= 3:
                preview_data.append({
                    'section': '割当',
                    'row_number': i + 1,
                    'data': {
                        '取引ID': row[0] if len(row) > 0 else '',
                        '予算項目ID': row[1] if len(row) > 1 else '',
                        '金額': row[2] if len(row) > 2 else ''
                    }
                })
        
        return PreviewResponse(
            file_name=file.filename,
            total_rows=len(grants_data) + len(budget_items_data) + len(allocations_data),
            preview=preview_data
        )
        
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"プレビューエラー: {str(e)}")

@app.post("/api/import/allocations")
async def import_allocations(file: UploadFile = File(...)):
    """割当データをCSVからインポート"""
    print("=== STARTING ALLOCATION IMPORT ===")
    # 新しいセッションを作成してバッチ処理を無効化
    from database import engine
    from sqlalchemy.orm import sessionmaker
    
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    db = SessionLocal()
    
    try:
        print("=== READING FILE ===")
        # ファイル内容を読み取り
        contents = await file.read()
        
        # 文字エンコーディングを検出
        detected = chardet.detect(contents)
        encoding = detected['encoding'] or 'utf-8'
        
        # CSVデータを解析
        text_data = contents.decode(encoding)
        
        # BOMを削除
        if text_data.startswith('\ufeff'):
            text_data = text_data[1:]
        
        lines = text_data.strip().split('\n')
        reader = csv.reader(lines)
        
        # ヘッダー行をスキップ
        next(reader, None)
        
        import_stats = {
            'allocations_created': 0,
            'allocations_updated': 0,
            'errors': []
        }
        
        # 割当データのインポート
        for row in reader:
            if len(row) < 3:
                continue
            try:
                # CSVの構造: ID(空), 取引ID, 予算項目ID, 金額
                if len(row) >= 4:
                    allocation_id, transaction_id, budget_item_id, amount = row[:4]
                else:
                    # ID列がない場合
                    allocation_id = ""
                    transaction_id, budget_item_id, amount = row[:3]
                
                # 既存の割当を確認（IDが空欄でない場合のみ）- 生SQLで実行
                existing_allocation_id = None
                if allocation_id and str(allocation_id).strip():
                    try:
                        result = db.execute(text("SELECT id FROM allocations WHERE id = :id"), {"id": int(allocation_id)}).fetchone()
                        if result:
                            existing_allocation_id = result[0]
                    except ValueError:
                        import_stats['errors'].append(f"割当ID {allocation_id}: 無効なIDです")
                        continue
                
                # 空文字列チェック
                if not budget_item_id or str(budget_item_id).strip() == '':
                    import_stats['errors'].append(f"行 {len(import_stats['errors']) + 1}: 予算項目IDが空です")
                    continue
                
                if not transaction_id or str(transaction_id).strip() == '':
                    import_stats['errors'].append(f"行 {len(import_stats['errors']) + 1}: 取引IDが空です")
                    continue
                
                # 数値変換チェック
                try:
                    budget_item_id_int = int(budget_item_id)
                except ValueError:
                    import_stats['errors'].append(f"行 {len(import_stats['errors']) + 1}: 予算項目ID '{budget_item_id}' が無効です")
                    continue
                
                # 取引と予算項目の存在確認 - 生SQLで実行
                transaction_check = db.execute(text("SELECT id FROM transactions WHERE id = :id"), {"id": transaction_id}).fetchone()
                budget_item_check = db.execute(text("SELECT id FROM budget_items WHERE id = :id"), {"id": budget_item_id_int}).fetchone()
                
                if not transaction_check:
                    import_stats['errors'].append(f"取引ID {transaction_id} が見つかりません")
                    continue
                
                if not budget_item_check:
                    import_stats['errors'].append(f"予算項目ID {budget_item_id_int} が見つかりません")
                    continue
                
                # 空文字列や無効な値をチェック
                if not amount or str(amount).strip() == '':
                    import_stats['errors'].append(f"割当ID {allocation_id}: 金額が空です")
                    continue
                
                try:
                    # 金額フィールドのクリーニング
                    amount_str = str(amount).strip()
                    # カンマ、円マーク、円文字を削除
                    amount_str = amount_str.replace(',', '').replace('¥', '').replace('円', '')
                    # 前後の空白を再度削除
                    amount_str = amount_str.strip()
                    amount_value = int(float(amount_str))
                    print(f"処理中: {amount} -> {amount_str} -> {amount_value}")
                except (ValueError, TypeError) as e:
                    import_stats['errors'].append(f"割当ID {allocation_id}: 金額が無効です ({amount}) - {str(e)}")
                    print(f"金額変換エラー: {amount} - {str(e)}")
                    continue
                
                # transaction_idは文字列として保持
                transaction_id_value = str(transaction_id).strip() if transaction_id else None
                
                allocation_data = {
                    'transaction_id': transaction_id_value,
                    'budget_item_id': budget_item_id_int,
                    'amount': amount_value
                }
                
                if existing_allocation_id:
                    # 更新（textを使用した完全な生SQL）
                    try:
                        db.execute(
                            text("UPDATE allocations SET transaction_id = :transaction_id, budget_item_id = :budget_item_id, amount = :amount WHERE id = :id"),
                            {
                                "transaction_id": allocation_data['transaction_id'],
                                "budget_item_id": allocation_data['budget_item_id'],
                                "amount": allocation_data['amount'],
                                "id": existing_allocation_id
                            }
                        )
                        db.commit()
                        import_stats['allocations_updated'] += 1
                    except Exception as update_error:
                        import_stats['errors'].append(f"割当ID {allocation_id}: 更新エラー - {str(update_error)}")
                        db.rollback()
                        continue
                else:
                    # 新規作成（textを使用した完全な生SQL）
                    try:
                        if allocation_id and str(allocation_id).strip():
                            # IDが指定されている場合
                            allocation_id_int = int(allocation_id)
                            db.execute(
                                text("INSERT INTO allocations (id, transaction_id, budget_item_id, amount, created_at) VALUES (:id, :transaction_id, :budget_item_id, :amount, :created_at)"),
                                {
                                    "id": allocation_id_int,
                                    "transaction_id": allocation_data['transaction_id'],
                                    "budget_item_id": allocation_data['budget_item_id'],
                                    "amount": allocation_data['amount'],
                                    "created_at": datetime.now()
                                }
                            )
                        else:
                            # IDが空欄の場合は、既存チェックしてから自動採番
                            while True:
                                # 最大IDを取得して+1
                                max_id_result = db.execute(text("SELECT COALESCE(MAX(id), 0) + 1 FROM allocations")).fetchone()
                                next_id = max_id_result[0] if max_id_result else 1
                                
                                # そのIDが既に存在しないかチェック
                                existing_check = db.execute(text("SELECT id FROM allocations WHERE id = :id"), {"id": next_id}).fetchone()
                                if not existing_check:
                                    break
                                # 存在する場合はもう一度ループ
                            
                            db.execute(
                                text("INSERT INTO allocations (id, transaction_id, budget_item_id, amount, created_at) VALUES (:id, :transaction_id, :budget_item_id, :amount, :created_at)"),
                                {
                                    "id": next_id,
                                    "transaction_id": allocation_data['transaction_id'],
                                    "budget_item_id": allocation_data['budget_item_id'],
                                    "amount": allocation_data['amount'],
                                    "created_at": datetime.now()
                                }
                            )
                            
                            # シーケンスを更新
                            try:
                                db.execute(text("SELECT setval('allocations_id_seq', :next_id)"), {"next_id": next_id})
                            except:
                                # シーケンスが存在しない場合は無視
                                pass
                        db.commit()
                        import_stats['allocations_created'] += 1
                    except Exception as create_error:
                        import_stats['errors'].append(f"割当ID {allocation_id}: 作成エラー - {str(create_error)}")
                        db.rollback()
                        continue
                    
            except Exception as e:
                import_stats['errors'].append(f"割当データエラー: {str(e)}")
                db.rollback()
        
        # 最終コミット（各行で既にコミット済みのため不要だが、念のため）
        try:
            db.commit()
        except Exception as commit_error:
            # 既に各行でコミットしているため、エラーは無視
            pass
        
        return {
            "message": "割当データのインポートが完了しました",
            "stats": import_stats
        }
        
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"割当データインポートエラー: {str(e)}")
    finally:
        db.close()

@app.post("/api/import/grants-budget")
async def import_grants_budget(file: UploadFile = File(...), db: Session = Depends(get_db)):
    """助成金・予算項目データをCSVからインポート"""
    try:
        # ファイル内容を読み取り
        contents = await file.read()
        
        # 文字エンコーディングを検出
        detected = chardet.detect(contents)
        encoding = detected['encoding'] or 'utf-8'
        
        # CSVデータを解析
        text_data = contents.decode(encoding)
        
        # BOMを削除
        if text_data.startswith('\ufeff'):
            text_data = text_data[1:]
        
        lines = text_data.strip().split('\n')
        reader = csv.reader(lines)
        
        # セクションごとにデータを分離
        grants_data = []
        budget_items_data = []
        
        current_section = None
        
        for row in reader:
            if not row or not row[0]:
                continue
                
            if row[0] == '[助成金データ]':
                current_section = 'grants'
                continue
            elif row[0] == '[予算項目データ]':
                current_section = 'budget_items'
                continue
            elif row[0] in ['ID', 'ID']:  # ヘッダー行をスキップ
                continue
                
            if current_section == 'grants':
                grants_data.append(row)
            elif current_section == 'budget_items':
                budget_items_data.append(row)
        
        import_stats = {
            'grants_created': 0,
            'grants_updated': 0,
            'budget_items_created': 0,
            'budget_items_updated': 0,
            'errors': []
        }
        
        # 助成金データのインポート
        for row in grants_data:
            if len(row) < 6:
                continue
            try:
                # 新フォーマット（助成金コード含む）と旧フォーマットに対応
                if len(row) >= 7:
                    grant_id, name, grant_code, total_amount, start_date, end_date, status = row[:7]
                else:
                    grant_id, name, total_amount, start_date, end_date, status = row[:6]
                    grant_code = ''
                
                # grant_idの空文字列チェックと数値変換
                if not grant_id or str(grant_id).strip() == '':
                    import_stats['errors'].append(f"行 {len(import_stats['errors']) + 1}: 助成金IDが空です")
                    continue
                
                try:
                    grant_id_int = int(grant_id)
                except ValueError:
                    import_stats['errors'].append(f"行 {len(import_stats['errors']) + 1}: 助成金ID '{grant_id}' が無効です")
                    continue
                
                # 既存の助成金を確認
                existing_grant = db.query(Grant).filter(Grant.id == grant_id_int).first()
                
                grant_data = {
                    'name': name,
                    'grant_code': grant_code,
                    'total_amount': parse_amount(total_amount),
                    'start_date': parse_date(start_date),
                    'end_date': parse_date(end_date),
                    'status': status
                }
                
                if existing_grant:
                    # 更新
                    for key, value in grant_data.items():
                        setattr(existing_grant, key, value)
                    import_stats['grants_updated'] += 1
                else:
                    # 新規作成
                    new_grant = Grant(id=grant_id_int, **grant_data)
                    db.add(new_grant)
                    import_stats['grants_created'] += 1
                    
            except Exception as e:
                import_stats['errors'].append(f"助成金データエラー: {str(e)}")
        
        # 助成金データをフラッシュして、予算項目処理時に参照可能にする
        db.flush()
        
        # 予算項目データのインポート
        for row in budget_items_data:
            if len(row) < 5:
                import_stats['errors'].append(f"予算項目データが不完全です（{len(row)}列）: {row}")
                continue
            try:
                # 安全にアンパック（余分な列は無視）
                budget_item_id = row[0] if len(row) > 0 else ''
                grant_id = row[1] if len(row) > 1 else ''
                name = row[2] if len(row) > 2 else ''
                category = row[3] if len(row) > 3 else ''
                budgeted_amount = row[4] if len(row) > 4 else ''
                remarks = row[5] if len(row) > 5 else ''
                
                # 既存の予算項目を確認
                existing_budget_item = db.query(BudgetItem).filter(BudgetItem.id == int(budget_item_id)).first()
                
                # 助成金の存在確認
                grant = db.query(Grant).filter(Grant.id == int(grant_id)).first()
                if not grant:
                    import_stats['errors'].append(f"助成金ID {grant_id} が見つかりません（予算項目ID: {budget_item_id}）")
                    continue
                
                budget_item_data = {
                    'grant_id': int(grant_id),
                    'name': name,
                    'category': category if category else None,
                    'budgeted_amount': parse_amount(budgeted_amount),
                    'remarks': remarks if remarks else None
                }
                
                if existing_budget_item:
                    # 更新
                    for key, value in budget_item_data.items():
                        setattr(existing_budget_item, key, value)
                    import_stats['budget_items_updated'] += 1
                else:
                    # 新規作成
                    new_budget_item = BudgetItem(id=int(budget_item_id), **budget_item_data)
                    db.add(new_budget_item)
                    import_stats['budget_items_created'] += 1
                    
            except Exception as e:
                import_stats['errors'].append(f"予算項目データエラー: {str(e)}")
        
        # データベースにコミット
        db.commit()
        
        return {
            "message": "助成金・予算項目データのインポートが完了しました",
            "stats": import_stats
        }
        
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"助成金・予算項目インポートエラー: {str(e)}")

@app.post("/api/import/grants-budget-allocations")
async def import_grants_budget_allocations(file: UploadFile = File(...), db: Session = Depends(get_db)):
    """助成金・予算項目・割当データをCSVからインポート"""
    try:
        # ファイル内容を読み取り
        contents = await file.read()
        
        # 文字エンコーディングを検出
        detected = chardet.detect(contents)
        encoding = detected['encoding'] or 'utf-8'
        
        # CSVデータを解析
        text_data = contents.decode(encoding)
        
        # BOMを削除
        if text_data.startswith('\ufeff'):
            text_data = text_data[1:]
        
        lines = text_data.strip().split('\n')
        reader = csv.reader(lines)
        
        # セクションごとにデータを分離
        grants_data = []
        budget_items_data = []
        allocations_data = []
        
        current_section = None
        
        for row in reader:
            if not row or not row[0]:
                continue
                
            if row[0] == '[助成金データ]':
                current_section = 'grants'
                continue
            elif row[0] == '[予算項目データ]':
                current_section = 'budget_items'
                continue
            elif row[0] == '[割当データ]':
                current_section = 'allocations'
                continue
            elif row[0] in ['ID', 'ID', 'ID']:  # ヘッダー行をスキップ
                continue
                
            if current_section == 'grants':
                grants_data.append(row)
            elif current_section == 'budget_items':
                budget_items_data.append(row)
            elif current_section == 'allocations':
                allocations_data.append(row)
        
        import_stats = {
            'grants_created': 0,
            'grants_updated': 0,
            'budget_items_created': 0,
            'budget_items_updated': 0,
            'allocations_created': 0,
            'allocations_updated': 0,
            'errors': []
        }
        
        # 助成金データのインポート
        for row in grants_data:
            if len(row) < 6:
                continue
            try:
                # 新フォーマット（助成金コード含む）と旧フォーマットに対応
                if len(row) >= 7:
                    grant_id, name, grant_code, total_amount, start_date, end_date, status = row[:7]
                else:
                    grant_id, name, total_amount, start_date, end_date, status = row[:6]
                    grant_code = ''
                
                # grant_idの空文字列チェックと数値変換
                if not grant_id or str(grant_id).strip() == '':
                    import_stats['errors'].append(f"行 {len(import_stats['errors']) + 1}: 助成金IDが空です")
                    continue
                
                try:
                    grant_id_int = int(grant_id)
                except ValueError:
                    import_stats['errors'].append(f"行 {len(import_stats['errors']) + 1}: 助成金ID '{grant_id}' が無効です")
                    continue
                
                # 既存の助成金を確認
                existing_grant = db.query(Grant).filter(Grant.id == grant_id_int).first()
                
                grant_data = {
                    'name': name,
                    'grant_code': grant_code,
                    'total_amount': parse_amount(total_amount),
                    'start_date': parse_date(start_date),
                    'end_date': parse_date(end_date),
                    'status': status
                }
                
                if existing_grant:
                    # 更新
                    for key, value in grant_data.items():
                        setattr(existing_grant, key, value)
                    import_stats['grants_updated'] += 1
                else:
                    # 新規作成
                    new_grant = Grant(id=grant_id_int, **grant_data)
                    db.add(new_grant)
                    import_stats['grants_created'] += 1
                    
            except Exception as e:
                import_stats['errors'].append(f"助成金データエラー: {str(e)}")
        
        # 助成金データをフラッシュして、予算項目処理時に参照可能にする
        db.flush()
        
        # 予算項目データのインポート
        for row in budget_items_data:
            if len(row) < 5:
                import_stats['errors'].append(f"予算項目データが不完全です（{len(row)}列）: {row}")
                continue
            try:
                # 安全にアンパック（余分な列は無視）
                item_id = row[0] if len(row) > 0 else ''
                grant_id = row[1] if len(row) > 1 else ''
                name = row[2] if len(row) > 2 else ''
                category = row[3] if len(row) > 3 else ''
                budgeted_amount = row[4] if len(row) > 4 else ''
                remarks = row[5] if len(row) > 5 else ''
                
                # item_idとgrant_idの空文字列チェックと数値変換
                if not item_id or str(item_id).strip() == '':
                    import_stats['errors'].append(f"行 {len(import_stats['errors']) + 1}: 予算項目IDが空です")
                    continue
                
                if not grant_id or str(grant_id).strip() == '':
                    import_stats['errors'].append(f"行 {len(import_stats['errors']) + 1}: 助成金IDが空です")
                    continue
                
                try:
                    item_id_int = int(item_id)
                except ValueError:
                    import_stats['errors'].append(f"行 {len(import_stats['errors']) + 1}: 予算項目ID '{item_id}' が無効です")
                    continue
                
                try:
                    grant_id_int = int(grant_id)
                except ValueError:
                    import_stats['errors'].append(f"行 {len(import_stats['errors']) + 1}: 助成金ID '{grant_id}' が無効です")
                    continue
                
                # 既存の予算項目を確認
                existing_item = db.query(BudgetItem).filter(BudgetItem.id == item_id_int).first()
                
                item_data = {
                    'grant_id': grant_id_int,
                    'name': name,
                    'category': category,
                    'budgeted_amount': parse_amount(budgeted_amount),
                    'remarks': remarks if remarks else None
                }
                
                if existing_item:
                    # 更新
                    for key, value in item_data.items():
                        setattr(existing_item, key, value)
                    import_stats['budget_items_updated'] += 1
                else:
                    # 新規作成
                    new_item = BudgetItem(id=item_id_int, **item_data)
                    db.add(new_item)
                    import_stats['budget_items_created'] += 1
                    
            except Exception as e:
                import_stats['errors'].append(f"予算項目データエラー: {str(e)}")
        
        # 割当データのインポート
        for row in allocations_data:
            if len(row) < 4:
                continue
            try:
                allocation_id, transaction_id, budget_item_id, amount = row
                
                # 空文字列チェック
                if not budget_item_id or str(budget_item_id).strip() == '':
                    import_stats['errors'].append(f"行 {len(import_stats['errors']) + 1}: 予算項目IDが空です")
                    continue
                
                # 数値変換チェック
                try:
                    budget_item_id_int = int(budget_item_id)
                except ValueError:
                    import_stats['errors'].append(f"行 {len(import_stats['errors']) + 1}: 予算項目ID '{budget_item_id}' が無効です")
                    continue
                
                # 既存の割当を確認
                existing_allocation = None
                allocation_id_int = None
                if allocation_id and str(allocation_id).strip():
                    try:
                        allocation_id_int = int(allocation_id)
                        existing_allocation = db.query(Allocation).filter(Allocation.id == allocation_id_int).first()
                    except ValueError:
                        import_stats['errors'].append(f"割当ID {allocation_id}: 無効なIDです")
                        continue
                else:
                    existing_allocation = None
                
                # 空文字列や無効な値をチェック
                if not amount or str(amount).strip() == '':
                    import_stats['errors'].append(f"割当ID {allocation_id}: 金額が空です")
                    continue
                
                try:
                    # 金額フィールドのクリーニング
                    amount_str = str(amount).strip()
                    # カンマ、円マーク、円文字を削除
                    amount_str = amount_str.replace(',', '').replace('¥', '').replace('円', '')
                    # 前後の空白を再度削除
                    amount_str = amount_str.strip()
                    amount_value = int(float(amount_str))
                    print(f"処理中: {amount} -> {amount_str} -> {amount_value}")
                except (ValueError, TypeError) as e:
                    import_stats['errors'].append(f"割当ID {allocation_id}: 金額が無効です ({amount}) - {str(e)}")
                    print(f"金額変換エラー: {amount} - {str(e)}")
                    continue
                
                # transaction_idは文字列として保持
                transaction_id_value = str(transaction_id).strip() if transaction_id else None
                
                allocation_data = {
                    'transaction_id': transaction_id_value,
                    'budget_item_id': budget_item_id_int,
                    'amount': amount_value
                }
                
                if existing_allocation:
                    # 更新（textを使用した完全な生SQL）
                    try:
                        db.execute(
                            text("UPDATE allocations SET transaction_id = :transaction_id, budget_item_id = :budget_item_id, amount = :amount WHERE id = :id"),
                            {
                                "transaction_id": allocation_data['transaction_id'],
                                "budget_item_id": allocation_data['budget_item_id'],
                                "amount": allocation_data['amount'],
                                "id": existing_allocation.id
                            }
                        )
                        db.commit()
                        import_stats['allocations_updated'] += 1
                    except Exception as update_error:
                        import_stats['errors'].append(f"割当ID {allocation_id}: 更新エラー - {str(update_error)}")
                        db.rollback()
                        continue
                else:
                    # 新規作成（textを使用した完全な生SQL）
                    try:
                        if allocation_id and str(allocation_id).strip():
                            # IDが指定されている場合
                            allocation_id_int = int(allocation_id)
                            db.execute(
                                text("INSERT INTO allocations (id, transaction_id, budget_item_id, amount, created_at) VALUES (:id, :transaction_id, :budget_item_id, :amount, :created_at)"),
                                {
                                    "id": allocation_id_int,
                                    "transaction_id": allocation_data['transaction_id'],
                                    "budget_item_id": allocation_data['budget_item_id'],
                                    "amount": allocation_data['amount'],
                                    "created_at": datetime.now()
                                }
                            )
                        else:
                            # IDが空欄の場合は、既存チェックしてから自動採番
                            while True:
                                # 最大IDを取得して+1
                                max_id_result = db.execute(text("SELECT COALESCE(MAX(id), 0) + 1 FROM allocations")).fetchone()
                                next_id = max_id_result[0] if max_id_result else 1
                                
                                # そのIDが既に存在しないかチェック
                                existing_check = db.execute(text("SELECT id FROM allocations WHERE id = :id"), {"id": next_id}).fetchone()
                                if not existing_check:
                                    break
                                # 存在する場合はもう一度ループ
                            
                            db.execute(
                                text("INSERT INTO allocations (id, transaction_id, budget_item_id, amount, created_at) VALUES (:id, :transaction_id, :budget_item_id, :amount, :created_at)"),
                                {
                                    "id": next_id,
                                    "transaction_id": allocation_data['transaction_id'],
                                    "budget_item_id": allocation_data['budget_item_id'],
                                    "amount": allocation_data['amount'],
                                    "created_at": datetime.now()
                                }
                            )
                            
                            # シーケンスを更新
                            try:
                                db.execute(text("SELECT setval('allocations_id_seq', :next_id)"), {"next_id": next_id})
                            except:
                                # シーケンスが存在しない場合は無視
                                pass
                        db.commit()
                        import_stats['allocations_created'] += 1
                    except Exception as create_error:
                        import_stats['errors'].append(f"割当ID {allocation_id}: 作成エラー - {str(create_error)}")
                        db.rollback()
                        continue
                    
            except Exception as e:
                import_stats['errors'].append(f"割当データエラー: {str(e)}")
                db.rollback()
        
        # 最終コミット（各行で既にコミット済みのため不要だが、念のため）
        try:
            db.commit()
        except Exception as commit_error:
            # 既に各行でコミットしているため、エラーは無視
            pass
        
        return {
            'message': 'インポートが完了しました',
            'stats': import_stats
        }
        
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"インポート中にエラーが発生しました: {str(e)}")

# Dashboard Statistics endpoint
@app.get("/api/dashboard/stats")
def get_dashboard_stats(db: Session = Depends(get_db)):
    """ダッシュボードの統計情報を取得"""
    try:
        # Total transactions
        total_transactions = db.query(Transaction).count()
        
        # Total amount
        total_amount_result = db.query(func.sum(Transaction.amount)).scalar()
        total_amount = total_amount_result if total_amount_result else 0
        
        # Allocated transactions (transactions that have allocations)
        allocated_transactions = db.query(Transaction).filter(
            Transaction.id.in_(
                db.query(Allocation.transaction_id).distinct()
            )
        ).count()
        
        # Unallocated transactions
        unallocated_transactions = total_transactions - allocated_transactions
        
        return {
            "totalTransactions": total_transactions,
            "totalAmount": total_amount,
            "allocatedTransactions": allocated_transactions,
            "unallocatedTransactions": unallocated_transactions
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"統計情報の取得中にエラーが発生しました: {str(e)}")

# Admin endpoints
@app.delete("/api/admin/reset-all-data")
def reset_all_data(db: Session = Depends(get_db)):
    """全データを削除する（管理者用）"""
    try:
        # すべてのテーブルのデータを削除
        db.query(Allocation).delete()
        db.query(Transaction).delete()
        db.query(BudgetItem).delete()
        db.query(Grant).delete()
        db.query(FreeeToken).delete()
        db.query(FreeeSync).delete()
        db.commit()
        
        return {"message": "全データが正常に削除されました", "clear_cache": True}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"データ削除中にエラーが発生しました: {str(e)}")

@app.get("/api/admin/download/specification")
def download_specification():
    """システム仕様書をダウンロード"""
    # rootとtanakaユーザー両方のパスを試す
    possible_paths = [
        "/root/nagaiku-budget/SYSTEM_SPECIFICATION.md",
        "/home/tanaka/nagaiku-budget/SYSTEM_SPECIFICATION.md"
    ]
    
    file_path = None
    for path in possible_paths:
        if os.path.exists(path):
            file_path = path
            break
    
    if not file_path:
        raise HTTPException(status_code=404, detail="仕様書ファイルが見つかりません")
    
    return FileResponse(
        path=file_path,
        filename="NPO予算管理システム_仕様書.md",
        media_type="text/markdown"
    )

# Freee連携エンドポイント
freee_service = FreeeService()

@app.get("/api/freee/auth", response_model=FreeeAuthResponse)
def get_freee_auth_url():
    """freee OAuth認証URLを取得"""
    try:
        auth_data = freee_service.generate_auth_url()
        return FreeeAuthResponse(
            auth_url=auth_data["auth_url"],
            state=auth_data["state"]
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"認証URL生成エラー: {str(e)}")

from pydantic import BaseModel

class FreeeCallbackRequest(BaseModel):
    code: str
    state: Optional[str] = None

@app.post("/api/freee/callback", response_model=FreeeTokenResponse)
async def freee_callback(request: FreeeCallbackRequest, db: Session = Depends(get_db)):
    """freee OAuth認証コールバック"""
    try:
        result = await freee_service.exchange_code_for_token(request.code, request.state, db)
        return FreeeTokenResponse(
            message=result["message"],
            company_id=result.get("company_id"),
            expires_at=result["expires_at"]
        )
    except Exception as e:
        print(f"FREEE CALLBACK ERROR: {str(e)}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=400, detail=f"認証エラー: {str(e)}")

@app.get("/api/freee/status")
def get_freee_status(db: Session = Depends(get_db)):
    """freee連携状況を取得"""
    try:
        token = db.query(FreeeToken).filter(FreeeToken.is_active == True).first()
        
        if not token:
            return {
                "connected": False,
                "message": "freee連携が設定されていません"
            }
        
        # トークンの有効期限をチェック
        if datetime.utcnow() >= token.expires_at:
            return {
                "connected": False,
                "message": "認証の有効期限が切れています。再認証が必要です。"
            }
        
        return {
            "connected": True,
            "company_id": token.company_id,
            "expires_at": token.expires_at,
            "message": "freee連携が有効です"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"状況取得エラー: {str(e)}")

@app.post("/api/freee/sync")
async def sync_freee_journals(
    request: FreeeSyncRequest,
    db: Session = Depends(get_db)
):
    """freee仕訳データを同期またはプレビュー"""
    try:
        if request.preview:
            # プレビューモード
            result = await freee_service.preview_journals(db, request.start_date, request.end_date)
            return {
                "status": "preview",
                "message": "プレビューデータを取得しました",
                "imported_count": len(result.get("journal_entries", [])),
                "journal_entries": result.get("journal_entries", []),
                "journals_data": result.get("journals_data", []),
                "csv_data": result.get("csv_data"),  # 仕訳帳CSVデータを追加
                "csv_converted_transactions": result.get("csv_converted_transactions", []),  # CSV変換データを追加
                "converted_transactions": result.get("converted_transactions", []),
                "needs_reauth": result.get("needs_reauth", False)
            }
        else:
            # 実際の同期（CSVデータを使用）
            result = await freee_service.sync_journals_csv(db, request.start_date, request.end_date)
            return FreeeSyncResponse(
                message=result["message"],
                sync_id=result["sync_id"],
                status=result["status"]
            )
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"同期エラー: {str(e)}")

@app.get("/api/freee/syncs")
def get_freee_syncs(db: Session = Depends(get_db)):
    """freee同期履歴を取得"""
    try:
        syncs = db.query(FreeeSync).order_by(FreeeSync.created_at.desc()).limit(20).all()
        return [
            {
                "id": sync.id,
                "sync_type": sync.sync_type,
                "start_date": sync.start_date,
                "end_date": sync.end_date,
                "status": sync.status,
                "total_records": sync.total_records,
                "processed_records": sync.processed_records,
                "created_records": sync.created_records,
                "updated_records": sync.updated_records,
                "error_message": sync.error_message,
                "created_at": sync.created_at,
                "completed_at": sync.completed_at
            }
            for sync in syncs
        ]
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"同期履歴取得エラー: {str(e)}")

@app.get("/api/freee/receipts/{deal_id}")
async def get_freee_receipts(deal_id: str, db: Session = Depends(get_db)):
    """取引に紐づくファイルボックス情報を取得"""
    try:
        from freee_service_receipts import FreeeReceiptsService
        
        # トークン取得
        token = db.query(FreeeToken).filter(FreeeToken.is_active == True).first()
        if not token:
            raise HTTPException(status_code=401, detail="freee連携が設定されていません")
        
        receipts_service = FreeeReceiptsService()
        receipts_data = await receipts_service.get_receipts(
            access_token=token.access_token,
            company_id=token.company_id,
            deal_id=deal_id
        )
        
        return receipts_data
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"ファイルボックス取得エラー: {str(e)}")

@app.get("/api/freee/receipts/")
async def get_all_freee_receipts(db: Session = Depends(get_db)):  
    """全ファイルボックス情報を取得"""
    try:
        from freee_service_receipts import FreeeReceiptsService
        
        # トークン取得
        token = db.query(FreeeToken).filter(FreeeToken.is_active == True).first()
        if not token:
            raise HTTPException(status_code=401, detail="freee連携が設定されていません")
        
        receipts_service = FreeeReceiptsService()
        receipts_data = await receipts_service.get_receipts(
            access_token=token.access_token,
            company_id=token.company_id,
            deal_id=None
        )
        
        return receipts_data
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"ファイルボックス取得エラー: {str(e)}")

@app.get("/api/freee/receipt/{receipt_id}")
async def get_freee_receipt_detail(receipt_id: str, db: Session = Depends(get_db)):
    """個別ファイルボックス詳細情報を取得"""
    try:
        from freee_service_receipts import FreeeReceiptsService
        
        # トークン取得
        token = db.query(FreeeToken).filter(FreeeToken.is_active == True).first()
        if not token:
            raise HTTPException(status_code=401, detail="freee連携が設定されていません")
        
        receipts_service = FreeeReceiptsService()
        receipt_detail = await receipts_service.get_receipt_detail(
            access_token=token.access_token,
            company_id=token.company_id,
            receipt_id=receipt_id
        )
        
        return receipt_detail
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"ファイル詳細取得エラー: {str(e)}")

@app.get("/api/freee/deal/{deal_id}")
async def get_freee_deal_detail(deal_id: str, db: Session = Depends(get_db)):
    """取引詳細情報を取得（receipts配列を含む）"""
    try:
        # トークン取得
        token = db.query(FreeeToken).filter(FreeeToken.is_active == True).first()
        if not token:
            raise HTTPException(status_code=401, detail="freee連携が設定されていません")
        
        from freee_deal_service import FreeDealService
        
        deal_service = FreeDealService()
        deal_detail = await deal_service.get_deal_detail(
            access_token=token.access_token,
            company_id=token.company_id,
            deal_id=deal_id
        )
        
        return deal_detail
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"取引詳細取得エラー: {str(e)}")

@app.delete("/api/freee/disconnect")
def disconnect_freee(db: Session = Depends(get_db)):
    """freee連携を切断"""
    try:
        db.query(FreeeToken).update({"is_active": False})
        db.commit()
        return {"message": "freee連携を切断しました"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"切断エラー: {str(e)}")

@app.post("/api/import/allocations/replace")
async def import_allocations_replace(
    file: UploadFile = File(...), 
    preview_only: bool = Form(False),
    backup_before_import: bool = Form(True)
):
    """割当データをCSVから完全置換でインポート（差分更新方式）"""
    print("=== STARTING ALLOCATION REPLACE IMPORT ===")
    from database import engine
    from sqlalchemy.orm import sessionmaker
    
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    db = SessionLocal()
    
    try:
        print("=== READING FILE ===")
        # ファイル内容を読み取り
        contents = await file.read()
        
        # 文字エンコーディングを検出
        detected = chardet.detect(contents)
        encoding = detected['encoding'] or 'utf-8'
        
        # CSVデータを解析
        text_data = contents.decode(encoding)
        
        # BOMを削除
        if text_data.startswith('\ufeff'):
            text_data = text_data[1:]
        
        lines = text_data.strip().split('\n')
        reader = csv.reader(lines)
        
        # ヘッダー行をスキップ
        next(reader, None)
        
        # CSVから読み込む割当データ
        csv_allocations = []
        errors = []
        
        print(f"=== CSV行数: {len(lines)} ===")
        
        for row_num, row in enumerate(reader, 1):
            print(f"Processing row {row_num}: {row}")
            if len(row) < 3:
                print(f"Row {row_num} skipped: too few columns")
                continue
            try:
                if len(row) >= 4:
                    allocation_id, transaction_id, budget_item_id, amount = row[:4]
                else:
                    allocation_id = ""
                    transaction_id, budget_item_id, amount = row[:3]
                
                # データ検証
                if not transaction_id or str(transaction_id).strip() == '':
                    errors.append(f"行 {row_num}: 取引IDが空です")
                    continue
                
                if not budget_item_id or str(budget_item_id).strip() == '':
                    errors.append(f"行 {row_num}: 予算項目IDが空です")
                    continue
                
                if not amount or str(amount).strip() == '':
                    errors.append(f"行 {row_num}: 金額が空です")
                    continue
                
                # 数値変換チェック
                try:
                    budget_item_id_int = int(budget_item_id)
                except ValueError:
                    errors.append(f"行 {row_num}: 予算項目ID '{budget_item_id}' が無効です")
                    continue
                
                try:
                    amount_str = str(amount).strip().replace(',', '').replace('¥', '').replace('円', '')
                    amount_value = int(float(amount_str))
                except (ValueError, TypeError):
                    errors.append(f"行 {row_num}: 金額 '{amount}' が無効です")
                    continue
                
                # 取引と予算項目の存在確認
                transaction_check = db.execute(text("SELECT id FROM transactions WHERE id = :id"), {"id": transaction_id}).fetchone()
                budget_item_check = db.execute(text("SELECT id FROM budget_items WHERE id = :id"), {"id": budget_item_id_int}).fetchone()
                
                if not transaction_check:
                    errors.append(f"行 {row_num}: 取引ID {transaction_id} が見つかりません")
                    continue
                
                if not budget_item_check:
                    errors.append(f"行 {row_num}: 予算項目ID {budget_item_id_int} が見つかりません")
                    continue
                
                # 有効な割当データとして追加
                allocation_data = {
                    'id': int(allocation_id) if allocation_id and str(allocation_id).strip() else None,
                    'transaction_id': str(transaction_id).strip(),
                    'budget_item_id': budget_item_id_int,
                    'amount': amount_value
                }
                csv_allocations.append(allocation_data)
                print(f"Added valid allocation: {allocation_data}")
                
            except Exception as e:
                print(f"Exception in row {row_num}: {str(e)}")
                errors.append(f"行 {row_num}: 処理エラー - {str(e)}")
        
        print(f"=== CSV解析完了 ===")
        print(f"有効な割当データ数: {len(csv_allocations)}")
        print(f"エラー数: {len(errors)}")
        
        # 現在のDBの割当データを取得
        current_allocations = []
        result = db.execute(text("SELECT id, transaction_id, budget_item_id, amount FROM allocations")).fetchall()
        for row in result:
            current_allocations.append({
                'id': row[0],
                'transaction_id': row[1],
                'budget_item_id': row[2],
                'amount': row[3]
            })
        
        # 差分計算
        # CSVにある割当データのIDセット
        csv_ids = {alloc['id'] for alloc in csv_allocations if alloc['id'] is not None}
        current_ids = {alloc['id'] for alloc in current_allocations}
        
        # 完全置換: 現在のDBの全データを削除して、CSVデータで置換
        to_delete = current_allocations  # 全ての既存データを削除
        
        # 完全置換: 更新はなし（全削除 → 全新規作成）
        to_update = []
        
        # 新規作成対象: CSVの全データを新規作成
        to_create = csv_allocations
        
        print(f"=== 差分計算結果 ===")
        print(f"削除対象: {len(to_delete)}件")
        print(f"更新対象: {len(to_update)}件")
        print(f"新規作成対象: {len(to_create)}件")
        
        diff_summary = {
            'to_delete': len(to_delete),
            'to_update': len(to_update),
            'to_create': len(to_create),
            'errors': errors,
            'delete_details': to_delete if preview_only else [],
            'update_details': to_update if preview_only else [],
            'create_details': to_create if preview_only else []
        }
        
        # プレビューのみの場合は差分情報を返す
        if preview_only:
            return {
                'preview': True,
                'stats': diff_summary,
                'message': f'削除: {len(to_delete)}件, 更新: {len(to_update)}件, 作成: {len(to_create)}件'
            }
        
        # バックアップ作成
        backup_id = None
        if backup_before_import:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            backup_id = f"allocation_backup_{timestamp}"
            
            # バックアップテーブルを作成
            db.execute(text(f"""
                CREATE TABLE IF NOT EXISTS allocation_backups_{timestamp} AS 
                SELECT *, '{timestamp}' as backup_timestamp, 'replace_import' as backup_reason
                FROM allocations
            """))
            print(f"バックアップ作成完了: allocation_backups_{timestamp}")
        
        # 実際の更新処理を開始
        try:
            # 1. 削除処理
            if to_delete:
                delete_ids = [alloc['id'] for alloc in to_delete]
                for chunk_start in range(0, len(delete_ids), 100):  # 100件ずつ処理
                    chunk = delete_ids[chunk_start:chunk_start + 100]
                    placeholders = ','.join([':id' + str(i) for i in range(len(chunk))])
                    params = {f'id{i}': chunk[i] for i in range(len(chunk))}
                    db.execute(text(f"DELETE FROM allocations WHERE id IN ({placeholders})"), params)
            
            # 2. 更新処理
            for alloc in to_update:
                db.execute(text("""
                    UPDATE allocations 
                    SET transaction_id = :transaction_id, budget_item_id = :budget_item_id, amount = :amount 
                    WHERE id = :id
                """), alloc)
            
            # 3. 新規作成処理
            for alloc in to_create:
                db.execute(text("""
                    INSERT INTO allocations (transaction_id, budget_item_id, amount) 
                    VALUES (:transaction_id, :budget_item_id, :amount)
                """), {
                    'transaction_id': alloc['transaction_id'],
                    'budget_item_id': alloc['budget_item_id'],
                    'amount': alloc['amount']
                })
            
            # コミット
            db.commit()
            
            return {
                'preview': False,
                'stats': diff_summary,
                'backup_id': backup_id,
                'message': f'完全置換完了: 削除 {len(to_delete)}件, 更新 {len(to_update)}件, 作成 {len(to_create)}件'
            }
            
        except Exception as e:
            db.rollback()
            raise HTTPException(status_code=500, detail=f"インポート処理エラー: {str(e)}")
            
    except Exception as e:
        print(f"エラー: {str(e)}")
        raise HTTPException(status_code=400, detail=f"処理エラー: {str(e)}")
    finally:
        db.close()

@app.get("/api/allocations/backup/list")
def list_allocation_backups(db: Session = Depends(get_db)):
    """割当データのバックアップ一覧を取得"""
    try:
        # バックアップテーブル一覧を取得
        result = db.execute(text("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_name LIKE 'allocation_backups_%'
            ORDER BY table_name DESC
        """)).fetchall()
        
        backups = []
        for row in result:
            table_name = row[0]
            timestamp = table_name.replace('allocation_backups_', '')
            
            # バックアップの件数を取得
            count_result = db.execute(text(f"SELECT COUNT(*) FROM {table_name}")).fetchone()
            count = count_result[0] if count_result else 0
            
            backups.append({
                'table_name': table_name,
                'timestamp': timestamp,
                'record_count': count,
                'created_at': datetime.strptime(timestamp, "%Y%m%d_%H%M%S").isoformat()
            })
        
        return {'backups': backups}
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"バックアップ一覧取得エラー: {str(e)}")

@app.post("/api/allocations/backup/restore/{backup_id}")
def restore_allocation_backup(backup_id: str, db: Session = Depends(get_db)):
    """割当データのバックアップから復元"""
    try:
        backup_table = f"allocation_backups_{backup_id}"
        
        # バックアップテーブルの存在確認
        result = db.execute(text("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_name = :table_name
        """), {"table_name": backup_table}).fetchone()
        
        if not result:
            raise HTTPException(status_code=404, detail="指定されたバックアップが見つかりません")
        
        # 現在のデータをバックアップ
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        temp_backup = f"allocation_backups_restore_{timestamp}"
        
        db.execute(text(f"""
            CREATE TABLE {temp_backup} AS 
            SELECT *, '{timestamp}' as backup_timestamp, 'before_restore' as backup_reason
            FROM allocations
        """))
        
        # 現在のデータを削除
        db.execute(text("DELETE FROM allocations"))
        
        # バックアップから復元（バックアップ固有の列を除く）
        db.execute(text(f"""
            INSERT INTO allocations (id, transaction_id, budget_item_id, amount, created_at)
            SELECT id, transaction_id, budget_item_id, amount, created_at
            FROM {backup_table}
        """))
        
        db.commit()
        
        return {
            'message': f'バックアップ {backup_id} から復元完了',
            'restore_backup_id': f"restore_{timestamp}"
        }
        
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"復元エラー: {str(e)}")

# WAM報告書関連のエンドポイント
@app.get("/api/wam-report/data")
async def get_wam_report_data(
    db: Session = Depends(get_db),
    start_date: Optional[str] = Query(None),
    end_date: Optional[str] = Query(None),
    grant_id: Optional[int] = Query(None),
    force_remap: Optional[bool] = Query(False)
):
    """WAM報告書用データを取得"""
    if not WAM_SERVICE_AVAILABLE:
        raise HTTPException(status_code=503, detail="WAM Service is not available")
    
    try:
        wam_data = WamService.get_wam_data_from_db(db, start_date, end_date, grant_id, force_remap)
        return {
            "data": wam_data,
            "total_count": len(wam_data),
            "start_date": start_date,
            "end_date": end_date,
            "force_remap": force_remap
        }
    except Exception as e:
        print(f"❌ WAM Data Error: {str(e)}")
        raise HTTPException(status_code=500, detail=f"WAMデータ取得エラー: {str(e)}")

@app.get("/api/wam-report/categories")
async def get_wam_categories():
    """WAM科目リストを取得"""
    if not WAM_SERVICE_AVAILABLE:
        raise HTTPException(status_code=503, detail="WAM Service is not available")
    
    try:
        categories = WamService.get_wam_categories()
        return {"categories": categories}
    except Exception as e:
        print(f"❌ WAM Categories Error: {str(e)}")
        raise HTTPException(status_code=500, detail=f"WAM科目取得エラー: {str(e)}")

@app.post("/api/wam-report/export")
async def export_wam_report_csv(
    wam_data: List[dict],
    db: Session = Depends(get_db)
):
    """WAM報告書CSVをエクスポート"""
    try:
        import io
        import csv
        from datetime import datetime
        
        output = io.StringIO()
        # BOMを追加（Excel用）
        output.write('\ufeff')
        
        writer = csv.writer(output)
        
        # ヘッダー行
        headers = ['支出年月日', '科目', '支払いの相手方', '摘要', '金額']
        writer.writerow(headers)
        
        # データ行
        for item in wam_data:
            row = [
                item.get('支出年月日', ''),
                item.get('科目', ''),
                item.get('支払いの相手方', ''),
                item.get('摘要', ''),
                item.get('金額', 0)
            ]
            writer.writerow(row)
        
        csv_content = output.getvalue()
        output.close()
        
        # ファイル名を生成
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        filename = f"wam_report_{timestamp}.csv"
        
        return StreamingResponse(
            io.BytesIO(csv_content.encode('utf-8-sig')),
            media_type="text/csv",
            headers={"Content-Disposition": f"attachment; filename={filename}"}
        )
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"CSV出力エラー: {str(e)}")

# WAMマッピング設定関連のエンドポイント
@app.get("/api/wam-mappings")
async def get_wam_mappings(db: Session = Depends(get_db)):
    """WAMマッピングルール一覧を取得"""
    if not WAM_SERVICE_AVAILABLE:
        raise HTTPException(status_code=503, detail="WAM Service is not available")
    
    try:
        # 初期データが存在しない場合は初期化
        WamService.initialize_default_mappings(db)
        mappings = WamService.get_all_mappings(db)
        return {"mappings": mappings}
    except Exception as e:
        print(f"❌ WAM Mappings Error: {str(e)}")
        raise HTTPException(status_code=500, detail=f"マッピング取得エラー: {str(e)}")

@app.get("/api/account-patterns")
async def get_account_patterns(db: Session = Depends(get_db)):
    """既存の勘定科目一覧を取得（マッピング設定用）"""
    try:
        # 取引データから勘定科目の一覧を取得
        accounts = db.query(Transaction.account).distinct().filter(Transaction.account.isnot(None)).all()
        account_list = [account[0] for account in accounts if account[0]]
        
        # 【事】【管】を除去したクリーンなリストも生成
        from wam_service import WamService
        clean_accounts = []
        for account in account_list:
            clean_account = WamService.clean_account_name(account)
            if clean_account and clean_account not in clean_accounts:
                clean_accounts.append(clean_account)
        
        # 統計情報も追加
        account_stats = {}
        for account in account_list:
            count = db.query(Transaction).filter(Transaction.account == account).count()
            account_stats[account] = count
        
        return {
            "original_accounts": sorted(account_list),
            "clean_accounts": sorted(clean_accounts),
            "account_stats": account_stats,
            "total_accounts": len(account_list)
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"勘定科目取得エラー: {str(e)}")

@app.post("/api/wam-mappings")
async def create_wam_mapping(
    account_pattern: str = Form(...),
    wam_category: str = Form(...),
    priority: int = Form(100),
    db: Session = Depends(get_db)
):
    """新しいWAMマッピングルールを作成"""
    try:
        import sys
        import os
        sys.path.append(os.path.dirname(__file__))
        from wam_service import WamService
        mapping_id = WamService.create_mapping(db, account_pattern, wam_category, priority)
        return {"success": True, "mapping_id": mapping_id}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"マッピング作成エラー: {str(e)}")

@app.put("/api/wam-mappings/{mapping_id}")
async def update_wam_mapping(
    mapping_id: int,
    account_pattern: str = Form(...),
    wam_category: str = Form(...),
    priority: int = Form(100),
    db: Session = Depends(get_db)
):
    """WAMマッピングルールを更新"""
    try:
        import sys
        import os
        sys.path.append(os.path.dirname(__file__))
        from wam_service import WamService
        success = WamService.update_mapping(db, mapping_id, account_pattern, wam_category, priority)
        if not success:
            raise HTTPException(status_code=404, detail="マッピングが見つかりません")
        return {"success": True}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"マッピング更新エラー: {str(e)}")

@app.delete("/api/wam-mappings/{mapping_id}")
async def delete_wam_mapping(mapping_id: int, db: Session = Depends(get_db)):
    """WAMマッピングルールを削除"""
    try:
        import sys
        import os
        sys.path.append(os.path.dirname(__file__))
        from wam_service import WamService
        success = WamService.delete_mapping(db, mapping_id)
        if not success:
            raise HTTPException(status_code=404, detail="マッピングが見つかりません")
        return {"success": True}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"マッピング削除エラー: {str(e)}")

@app.get("/api/wam-mappings/export")
async def export_wam_mappings_csv(db: Session = Depends(get_db)):
    """WAMマッピングルールをCSVエクスポート"""
    try:
        import sys
        import os
        sys.path.append(os.path.dirname(__file__))
        from wam_service import WamService
        import io
        import csv
        from datetime import datetime
        
        mappings = WamService.get_all_mappings(db)
        
        output = io.StringIO()
        output.write('\ufeff')  # BOM
        
        writer = csv.writer(output)
        
        # ヘッダー行
        headers = ['勘定科目パターン', 'WAM科目', '優先順位', '有効']
        writer.writerow(headers)
        
        # データ行
        for mapping in mappings:
            row = [
                mapping['account_pattern'],
                mapping['wam_category'],
                mapping['priority'],
                'TRUE' if mapping['is_active'] else 'FALSE'
            ]
            writer.writerow(row)
        
        csv_content = output.getvalue()
        output.close()
        
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        filename = f"wam_mappings_{timestamp}.csv"
        
        return StreamingResponse(
            io.BytesIO(csv_content.encode('utf-8-sig')),
            media_type="text/csv",
            headers={"Content-Disposition": f"attachment; filename={filename}"}
        )
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"マッピングCSV出力エラー: {str(e)}")

@app.post("/api/wam-mappings/import")
async def import_wam_mappings_csv(file: UploadFile = File(...), db: Session = Depends(get_db)):
    """WAMマッピングルールをCSVインポート"""
    try:
        import sys
        import os
        sys.path.append(os.path.dirname(__file__))
        from wam_service import WamService
        import csv
        import io
        
        # ファイル内容を読み取り
        content = await file.read()
        
        # エンコーディング検出
        import chardet
        detected = chardet.detect(content)
        encoding = detected['encoding'] or 'utf-8'
        
        # CSV解析
        csv_content = content.decode(encoding)
        csv_reader = csv.DictReader(io.StringIO(csv_content))
        
        imported_count = 0
        errors = []
        
        for row_num, row in enumerate(csv_reader, start=2):
            try:
                account_pattern = row.get('勘定科目パターン', '').strip()
                wam_category = row.get('WAM科目', '').strip()
                priority = int(row.get('優先順位', 100))
                is_active = row.get('有効', 'TRUE').upper() == 'TRUE'
                
                if not account_pattern or not wam_category:
                    errors.append(f"行{row_num}: 勘定科目パターンとWAM科目は必須です")
                    continue
                
                # 既存のマッピングをチェック
                existing = db.query(WamMapping).filter(
                    WamMapping.account_pattern == account_pattern
                ).first()
                
                if existing:
                    # 更新
                    existing.wam_category = wam_category
                    existing.priority = priority
                    existing.is_active = is_active
                else:
                    # 新規作成
                    from database import WamMapping
                    mapping = WamMapping(
                        account_pattern=account_pattern,
                        wam_category=wam_category,
                        priority=priority,
                        is_active=is_active
                    )
                    db.add(mapping)
                
                imported_count += 1
                
            except Exception as e:
                errors.append(f"行{row_num}: {str(e)}")
        
        db.commit()
        
        return {
            "success": True,
            "imported_count": imported_count,
            "errors": errors
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"マッピングCSVインポートエラー: {str(e)}")

@app.get("/api/reports/monthly-summary")
async def get_monthly_summary(
    db: Session = Depends(get_db),
    start_date: Optional[str] = Query(None),
    end_date: Optional[str] = Query(None)
):
    """助成金ごとの月別集計レポートを取得"""
    try:
        from sqlalchemy import func, extract
        from datetime import datetime
        
        # 基本クエリ: 取引 -> 割当 -> 予算項目 -> 助成金
        query = db.query(
            Grant.id.label('grant_id'),
            Grant.name.label('grant_name'),
            extract('year', Transaction.date).label('year'),
            extract('month', Transaction.date).label('month'),
            func.sum(Allocation.amount).label('total_amount'),
            func.count(Transaction.id).label('transaction_count')
        ).select_from(Transaction)\
         .join(Allocation, Transaction.id == Allocation.transaction_id)\
         .join(BudgetItem, Allocation.budget_item_id == BudgetItem.id)\
         .join(Grant, BudgetItem.grant_id == Grant.id)
        
        # 期間フィルター
        if start_date:
            start_dt = datetime.strptime(start_date, '%Y-%m-%d').date()
            query = query.filter(Transaction.date >= start_dt)
        if end_date:
            end_dt = datetime.strptime(end_date, '%Y-%m-%d').date()
            query = query.filter(Transaction.date <= end_dt)
        
        # グループ化と並び順
        query = query.group_by(
            Grant.id, Grant.name, 
            extract('year', Transaction.date), 
            extract('month', Transaction.date)
        ).order_by(
            Grant.name,
            extract('year', Transaction.date), 
            extract('month', Transaction.date)
        )
        
        results = query.all()
        
        # 未割当の取引も月別で取得
        unallocated_query = db.query(
            extract('year', Transaction.date).label('year'),
            extract('month', Transaction.date).label('month'),
            func.sum(Transaction.amount).label('total_amount'),
            func.count(Transaction.id).label('transaction_count')
        ).select_from(Transaction)\
         .outerjoin(Allocation, Transaction.id == Allocation.transaction_id)\
         .filter(Allocation.id.is_(None))  # 割当がない取引のみ
        
        # 期間フィルター（未割当）
        if start_date:
            start_dt = datetime.strptime(start_date, '%Y-%m-%d').date()
            unallocated_query = unallocated_query.filter(Transaction.date >= start_dt)
        if end_date:
            end_dt = datetime.strptime(end_date, '%Y-%m-%d').date()
            unallocated_query = unallocated_query.filter(Transaction.date <= end_dt)
        
        unallocated_query = unallocated_query.group_by(
            extract('year', Transaction.date), 
            extract('month', Transaction.date)
        ).order_by(
            extract('year', Transaction.date), 
            extract('month', Transaction.date)
        )
        
        unallocated_results = unallocated_query.all()
        
        # データ整形
        monthly_summary = []
        
        # 割当済みデータを追加
        for row in results:
            monthly_summary.append({
                'grant_id': row.grant_id,
                'grant_name': row.grant_name,
                'year': int(row.year),
                'month': int(row.month),
                'year_month': f"{int(row.year)}-{int(row.month):02d}",
                'total_amount': int(row.total_amount) if row.total_amount else 0,
                'transaction_count': int(row.transaction_count)
            })
        
        # 未割当データを追加
        for row in unallocated_results:
            if row.total_amount and row.total_amount > 0:
                monthly_summary.append({
                    'grant_id': None,
                    'grant_name': '未割当',
                    'year': int(row.year),
                    'month': int(row.month),
                    'year_month': f"{int(row.year)}-{int(row.month):02d}",
                    'total_amount': int(row.total_amount),
                    'transaction_count': int(row.transaction_count)
                })
        
        return {
            "summary": monthly_summary,
            "total_records": len(monthly_summary),
            "start_date": start_date,
            "end_date": end_date
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"月別集計取得エラー: {str(e)}")

@app.get("/api/reports/budget-vs-actual")
async def get_budget_vs_actual(
    db: Session = Depends(get_db),
    start_date: Optional[str] = Query(None),
    end_date: Optional[str] = Query(None)
):
    """助成金ごとの予算vs実際の支出を取得"""
    try:
        from sqlalchemy import func
        from datetime import datetime
        
        # 助成金ごとの予算合計を取得
        budget_query = db.query(
            Grant.id.label('grant_id'),
            Grant.name.label('grant_name'),
            Grant.total_amount.label('grant_total_amount'),
            Grant.start_date.label('grant_start_date'),
            Grant.end_date.label('grant_end_date'),
            func.sum(BudgetItem.budgeted_amount).label('total_budget')
        ).select_from(Grant)\
         .join(BudgetItem)\
         .group_by(Grant.id, Grant.name, Grant.total_amount, Grant.start_date, Grant.end_date)\
         .order_by(Grant.name)
        
        # 助成金ごとの実際の支出を取得（割当済み + 未割当を含む）
        # 1. 割当済みの支出
        allocated_spent_query = db.query(
            Grant.id.label('grant_id'),
            func.sum(Allocation.amount).label('total_spent')
        ).select_from(Grant)\
         .join(BudgetItem)\
         .join(Allocation)\
         .join(Transaction, Allocation.transaction_id == Transaction.id)
        
        # 期間フィルター（割当済み）
        if start_date:
            start_dt = datetime.strptime(start_date, '%Y-%m-%d').date()
            allocated_spent_query = allocated_spent_query.filter(Transaction.date >= start_dt)
        if end_date:
            end_dt = datetime.strptime(end_date, '%Y-%m-%d').date()
            allocated_spent_query = allocated_spent_query.filter(Transaction.date <= end_dt)
        
        allocated_spent_query = allocated_spent_query.group_by(Grant.id)
        
        # 2. 未割当の取引の合計を取得
        unallocated_query = db.query(
            func.sum(Transaction.amount).label('total_unallocated')
        ).select_from(Transaction)\
         .outerjoin(Allocation, Transaction.id == Allocation.transaction_id)\
         .filter(Allocation.id.is_(None))  # 割当がない取引のみ
        
        # 期間フィルター（未割当）
        if start_date:
            start_dt = datetime.strptime(start_date, '%Y-%m-%d').date()
            unallocated_query = unallocated_query.filter(Transaction.date >= start_dt)
        if end_date:
            end_dt = datetime.strptime(end_date, '%Y-%m-%d').date()
            unallocated_query = unallocated_query.filter(Transaction.date <= end_dt)
        
        # 予算データを取得
        budget_results = budget_query.all()
        allocated_spent_results = {row.grant_id: row.total_spent for row in allocated_spent_query.all()}
        unallocated_total = unallocated_query.scalar() or 0
        
        # データを統合
        summary = []
        current_date = datetime.now().date()
        total_grants = len(budget_results)
        
        for row in budget_results:
            budget = int(row.total_budget) if row.total_budget else 0
            spent = int(allocated_spent_results.get(row.grant_id, 0)) if allocated_spent_results.get(row.grant_id) else 0
            
            remaining = budget - spent
            usage_rate = (spent / budget * 100) if budget > 0 else 0
            
            # 期間進捗率を計算
            period_progress = 0
            if row.grant_start_date and row.grant_end_date:
                total_days = (row.grant_end_date - row.grant_start_date).days
                if total_days > 0:
                    if current_date < row.grant_start_date:
                        period_progress = 0  # まだ開始前
                    elif current_date > row.grant_end_date:
                        period_progress = 100  # 既に終了
                    else:
                        elapsed_days = (current_date - row.grant_start_date).days
                        period_progress = (elapsed_days / total_days * 100)
            
            summary.append({
                'grant_id': row.grant_id,
                'grant_name': row.grant_name,
                'grant_total_amount': int(row.grant_total_amount) if row.grant_total_amount else 0,
                'grant_start_date': row.grant_start_date.strftime('%Y-%m-%d') if row.grant_start_date else None,
                'grant_end_date': row.grant_end_date.strftime('%Y-%m-%d') if row.grant_end_date else None,
                'budget_total': budget,
                'spent_total': spent,
                'remaining': remaining,
                'usage_rate': round(usage_rate, 1),
                'period_progress': round(period_progress, 1)
            })
        
        # 未割当の行を追加
        if unallocated_total > 0:
            summary.append({
                'grant_id': None,
                'grant_name': '未割当',
                'grant_total_amount': 0,
                'grant_start_date': None,
                'grant_end_date': None,
                'budget_total': 0,
                'spent_total': int(unallocated_total),
                'remaining': int(-unallocated_total),  # 予算がないので負の値
                'usage_rate': 0,
                'period_progress': 0
            })
        
        return {
            "summary": summary,
            "total_grants": len(budget_results),  # 助成金の数（未割当を除く）
            "total_unallocated": int(unallocated_total),
            "start_date": start_date,
            "end_date": end_date
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"予算vs実績データの取得に失敗しました: {str(e)}")

@app.get("/api/reports/monthly-allocation")
async def generate_monthly_allocation_report(db: Session = Depends(get_db)):
    """助成金の期間に基づいて予算を月ごとに配分するレポートを生成"""
    try:
        from datetime import datetime, timedelta
        from calendar import monthrange
        
        # 全ての助成金とその予算項目を取得
        grants_with_budget = db.query(Grant)\
            .filter(Grant.start_date.isnot(None))\
            .filter(Grant.end_date.isnot(None))\
            .all()
        
        monthly_allocations = []
        
        for grant in grants_with_budget:
            # 助成金の期間を計算
            start_date = grant.start_date
            end_date = grant.end_date
            
            if not start_date or not end_date:
                continue
                
            # 助成金の予算項目を取得
            budget_items = db.query(BudgetItem)\
                .filter(BudgetItem.grant_id == grant.id)\
                .all()
            
            # 各予算項目の月ごと配分を計算
            for budget_item in budget_items:
                if not budget_item.budgeted_amount or budget_item.budgeted_amount <= 0:
                    continue
                
                # 助成金期間の総日数を計算
                total_days = (end_date - start_date).days + 1
                daily_amount = budget_item.budgeted_amount / total_days
                
                # 月ごとの配分を計算
                current_date = start_date
                while current_date <= end_date:
                    year = current_date.year
                    month = current_date.month
                    
                    # 該当月の日数を計算（期間内のみ）
                    month_start = datetime(year, month, 1).date()
                    month_end = datetime(year, month, monthrange(year, month)[1]).date()
                    
                    # 実際の配分期間を計算
                    period_start = max(start_date, month_start)
                    period_end = min(end_date, month_end)
                    
                    if period_start <= period_end:
                        days_in_month = (period_end - period_start).days + 1
                        month_allocation = daily_amount * days_in_month
                        
                        monthly_allocations.append({
                            'grant_id': grant.id,
                            'grant_name': grant.name,
                            'grant_code': grant.grant_code,
                            'grant_start_date': start_date.isoformat(),
                            'grant_end_date': end_date.isoformat(),
                            'grant_total_days': total_days,
                            'budget_item_id': budget_item.id,
                            'budget_item_name': budget_item.name,
                            'budget_item_category': budget_item.category,
                            'budget_item_total': budget_item.budgeted_amount,
                            'year': year,
                            'month': month,
                            'year_month': f"{year}-{month:02d}",
                            'days_in_allocation': days_in_month,
                            'daily_amount': round(daily_amount, 2),
                            'monthly_allocation': round(month_allocation, 0),
                            'period_start': period_start.isoformat(),
                            'period_end': period_end.isoformat()
                        })
                    
                    # 次の月へ
                    if month == 12:
                        current_date = datetime(year + 1, 1, 1).date()
                    else:
                        current_date = datetime(year, month + 1, 1).date()
        
        # 年月でソート
        monthly_allocations.sort(key=lambda x: (x['year'], x['month'], x['grant_name'], x['budget_item_name']))
        
        # サマリー情報を計算
        total_grants = len(set(item['grant_id'] for item in monthly_allocations))
        total_budget_items = len(set(item['budget_item_id'] for item in monthly_allocations))
        total_allocated = sum(item['monthly_allocation'] for item in monthly_allocations)
        
        # 月別サマリーを作成
        monthly_summary = {}
        for item in monthly_allocations:
            key = item['year_month']
            if key not in monthly_summary:
                monthly_summary[key] = {
                    'year_month': key,
                    'year': item['year'],
                    'month': item['month'],
                    'total_amount': 0,
                    'grant_count': set(),
                    'budget_item_count': set()
                }
            monthly_summary[key]['total_amount'] += item['monthly_allocation']
            monthly_summary[key]['grant_count'].add(item['grant_id'])
            monthly_summary[key]['budget_item_count'].add(item['budget_item_id'])
        
        # setをcountに変換
        monthly_summary_list = []
        for key, data in monthly_summary.items():
            monthly_summary_list.append({
                'year_month': data['year_month'],
                'year': data['year'],
                'month': data['month'],
                'total_amount': round(data['total_amount'], 0),
                'grant_count': len(data['grant_count']),
                'budget_item_count': len(data['budget_item_count'])
            })
        
        monthly_summary_list.sort(key=lambda x: (x['year'], x['month']))
        
        return {
            'allocations': monthly_allocations,
            'monthly_summary': monthly_summary_list,
            'total_grants': total_grants,
            'total_budget_items': total_budget_items,
            'total_allocated': round(total_allocated, 0),
            'generated_at': datetime.now().isoformat()
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"月ごと配分レポートの生成に失敗しました: {str(e)}")

@app.get("/api/reports/monthly-allocation-cross-table")
async def generate_allocation_cross_table(db: Session = Depends(get_db)):
    """助成金期間配分による予算項目×月・カテゴリ×月のクロス集計表を生成（期間配分予算・実割当・差額含む）"""
    try:
        from datetime import datetime, timedelta
        from calendar import monthrange
        from collections import defaultdict
        from sqlalchemy import func, extract
        
        # 全ての助成金とその予算項目を取得
        grants_with_budget = db.query(Grant)\
            .filter(Grant.start_date.isnot(None))\
            .filter(Grant.end_date.isnot(None))\
            .all()
        
        # 予算項目×月のクロス集計データ（期間配分予算）
        budget_cross_table = defaultdict(lambda: defaultdict(float))
        # カテゴリ×月のクロス集計データ（期間配分予算）
        category_cross_table = defaultdict(lambda: defaultdict(float))
        
        # 予算項目IDとdisplay_nameのマッピングを作成
        budget_item_mapping = {}
        category_mapping = {}
        
        # 全ての月を収集（範囲決定のため）
        all_months = set()
        
        # 期間配分予算を計算
        for grant in grants_with_budget:
            # 助成金の予算項目を取得
            budget_items = db.query(BudgetItem)\
                .filter(BudgetItem.grant_id == grant.id)\
                .all()
            
            # 各予算項目の月ごと配分を計算
            for budget_item in budget_items:
                if not budget_item.budgeted_amount or budget_item.budgeted_amount <= 0:
                    continue
                
                # 予算項目ごとの予定使用期間を取得（なければ助成金期間を使用）
                start_date = budget_item.planned_start_date or grant.start_date
                end_date = budget_item.planned_end_date or grant.end_date
                
                if not start_date or not end_date:
                    continue
                
                budget_item_display_name = f"{grant.name}-{budget_item.name}"
                budget_item_mapping[budget_item.id] = budget_item_display_name
                category = budget_item.category or "その他"
                category_mapping[budget_item.id] = category
                
                # 予定使用期間の総日数を計算
                total_days = (end_date - start_date).days + 1
                daily_amount = budget_item.budgeted_amount / total_days
                
                # 月ごとの配分を計算
                current_date = start_date
                while current_date <= end_date:
                    year = current_date.year
                    month = current_date.month
                    year_month = f"{year}-{month:02d}"
                    all_months.add(year_month)
                    
                    # 該当月の日数を計算（期間内のみ）
                    month_start = datetime(year, month, 1).date()
                    month_end = datetime(year, month, monthrange(year, month)[1]).date()
                    
                    # 実際の配分期間を計算
                    period_start = max(start_date, month_start)
                    period_end = min(end_date, month_end)
                    
                    if period_start <= period_end:
                        days_in_month = (period_end - period_start).days + 1
                        month_allocation = daily_amount * days_in_month
                        
                        # 予算項目×月の集計
                        budget_cross_table[budget_item_display_name][year_month] += month_allocation
                        
                        # カテゴリ×月の集計
                        category_cross_table[category][year_month] += month_allocation
                    
                    # 次の月へ
                    if month == 12:
                        current_date = datetime(year + 1, 1, 1).date()
                    else:
                        current_date = datetime(year, month + 1, 1).date()
        
        # 実際の割当額を取得
        actual_budget_cross_table = defaultdict(lambda: defaultdict(float))
        actual_category_cross_table = defaultdict(lambda: defaultdict(float))
        
        # 取引 -> 割当 -> 予算項目 -> 助成金のクエリで実績を取得
        allocation_query = db.query(
            BudgetItem.id.label('budget_item_id'),
            extract('year', Transaction.date).label('year'),
            extract('month', Transaction.date).label('month'),
            func.sum(Allocation.amount).label('total_amount')
        ).select_from(Transaction)\
         .join(Allocation, Transaction.id == Allocation.transaction_id)\
         .join(BudgetItem, Allocation.budget_item_id == BudgetItem.id)\
         .join(Grant, BudgetItem.grant_id == Grant.id)\
         .filter(Grant.start_date.isnot(None))\
         .filter(Grant.end_date.isnot(None))\
         .group_by(
            BudgetItem.id,
            extract('year', Transaction.date), 
            extract('month', Transaction.date)
         ).all()
        
        for row in allocation_query:
            budget_item_id = row.budget_item_id
            year_month = f"{int(row.year)}-{int(row.month):02d}"
            amount = int(row.total_amount) if row.total_amount else 0
            
            if budget_item_id in budget_item_mapping:
                budget_item_display_name = budget_item_mapping[budget_item_id]
                actual_budget_cross_table[budget_item_display_name][year_month] += amount
                
                category = category_mapping[budget_item_id]
                actual_category_cross_table[category][year_month] += amount
        
        # 月をソート
        sorted_months = sorted(all_months)
        
        # データを整形（期間配分予算・実割当・差額を含む）
        budget_cross_result = {}
        for budget_item in budget_cross_table.keys():
            budget_cross_result[budget_item] = {}
            for month in sorted_months:
                planned_amount = round(budget_cross_table[budget_item].get(month, 0), 0)
                actual_amount = round(actual_budget_cross_table[budget_item].get(month, 0), 0)
                difference = planned_amount - actual_amount
                
                budget_cross_result[budget_item][month] = {
                    'planned': planned_amount,
                    'actual': actual_amount,
                    'difference': difference
                }
        
        category_cross_result = {}
        for category in category_cross_table.keys():
            category_cross_result[category] = {}
            for month in sorted_months:
                planned_amount = round(category_cross_table[category].get(month, 0), 0)
                actual_amount = round(actual_category_cross_table[category].get(month, 0), 0)
                difference = planned_amount - actual_amount
                
                category_cross_result[category][month] = {
                    'planned': planned_amount,
                    'actual': actual_amount,
                    'difference': difference
                }
        
        return {
            'budget_cross_table': budget_cross_result,
            'category_cross_table': category_cross_result,
            'months': sorted_months,
            'generated_at': datetime.now().isoformat()
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"期間配分クロス集計表の生成に失敗しました: {str(e)}")

@app.get("/api/system-info")
async def get_system_info():
    """統一環境のシステム情報を取得"""
    db_name = os.getenv("DATABASE_NAME", "nagaiku_budget")
    port = os.getenv("PORT", "8000")
    
    # データベース種別を判定
    db_type = "本番データベース" if db_name == "nagaiku_budget" else "開発データベース"
    
    return {
        "database_name": db_name,
        "database_type": db_type,
        "environment": "統一環境",
        "port": port,
        "mode": "本番DB" if db_name == "nagaiku_budget" else "開発DB"
    }

@app.get("/api/version")
async def get_version():
    """バージョン情報を取得"""
    try:
        import subprocess
        from datetime import datetime
        
        # Gitコミット情報を取得
        try:
            commit = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd='..').decode().strip()
            commit_short = commit[:7]
            commit_date = subprocess.check_output(['git', 'show', '-s', '--format=%ci', 'HEAD'], cwd='..').decode().strip()
            commit_message = subprocess.check_output(['git', 'show', '-s', '--format=%s', 'HEAD'], cwd='..').decode().strip()
            branch = subprocess.check_output(['git', 'rev-parse', '--abbrev-ref', 'HEAD'], cwd='..').decode().strip()
        except:
            commit = "unknown"
            commit_short = "unknown"
            commit_date = "unknown"
            commit_message = "unknown"
            branch = "unknown"
        
        return {
            "commit": commit,
            "commitShort": commit_short,
            "commitDate": commit_date,
            "commitMessage": commit_message,
            "branch": branch,
            "timestamp": datetime.now().isoformat(),
        }
    except Exception as e:
        return {
            "commit": "error",
            "commitShort": "error",
            "commitDate": "error",
            "commitMessage": f"Error: {str(e)}",
            "branch": "error",
            "timestamp": datetime.now().isoformat(),
        }

if __name__ == "__main__":
    import uvicorn
    import os
    
    port = int(os.getenv("PORT", 8000))
    print(f"🚀 {ENVIRONMENT}環境バックエンドを起動します (ポート: {port})")
    uvicorn.run("main:app", host="0.0.0.0", port=port, reload=(ENVIRONMENT == "development"))