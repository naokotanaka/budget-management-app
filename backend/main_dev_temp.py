from fastapi import FastAPI, Depends, HTTPException, UploadFile, File, Query
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
import csv
import os
from dotenv import load_dotenv

# 環境変数を読み込み
load_dotenv()

from database import get_db, create_tables, Transaction, Grant, BudgetItem, Allocation, FreeeToken, FreeeSync, Category
from schemas import (
    TransactionCreate, Transaction as TransactionSchema, TransactionWithAllocation,
    GrantCreate, Grant as GrantSchema,
    BudgetItemCreate, BudgetItem as BudgetItemSchema, BudgetItemWithGrant,
    AllocationCreate, Allocation as AllocationSchema,
    ImportResponse, PreviewResponse,
    FreeeAuthResponse, FreeeTokenResponse, FreeeSyncResponse,
    CategoryCreate, Category as CategorySchema
)
from freee_service import FreeeService

app = FastAPI(title="NPO Budget Management System")

# CORS middleware - explicit configuration for external access
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",
        "http://localhost:3001", 
        "http://160.251.170.97:3000",
        "http://160.251.170.97:3001",
        "http://160.251.170.97:3005",
        "*"
    ],
    allow_credentials=False,  # Set to False when using wildcard origins
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allow_headers=["*"],
)

# Create tables on startup
@app.on_event("startup")
def startup_event():
    create_tables()

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
                # Determine account and amount
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
    budget_items = db.query(BudgetItem).join(Grant).all()
    
    result = []
    for budget_item in budget_items:
        result.append({
            "id": budget_item.id,
            "name": budget_item.name,
            "category": budget_item.category,
            "budgeted_amount": budget_item.budgeted_amount,
            "grant_id": budget_item.grant_id,
            "grant_name": budget_item.grant.name,
            "display_name": f"{budget_item.grant.name}-{budget_item.name}"
        })
    
    return result

@app.post("/api/budget-items", response_model=BudgetItemSchema)
def create_budget_item(budget_item: BudgetItemCreate, db: Session = Depends(get_db)):
    db_item = BudgetItem(**budget_item.dict())
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    return db_item

@app.put("/api/budget-items/{budget_item_id}", response_model=BudgetItemSchema)
def update_budget_item(budget_item_id: int, budget_item_update: dict, db: Session = Depends(get_db)):
    db_item = db.query(BudgetItem).filter(BudgetItem.id == budget_item_id).first()
    if not db_item:
        raise HTTPException(status_code=404, detail="Budget item not found")
    
    for field, value in budget_item_update.items():
        if hasattr(db_item, field):
            setattr(db_item, field, value)
    
    db.commit()
    db.refresh(db_item)
    return db_item

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
        # PostgreSQL-compatible query for cross-tabulation with grant names
        query = """
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
        ORDER BY g.name, bi.name, month
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
async def import_allocations(file: UploadFile = File(...), db: Session = Depends(get_db)):
    """割当データをCSVからインポート"""
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
        
        # ヘッダー行をスキップ
        next(reader, None)
        
        import_stats = {
            'allocations_created': 0,
            'allocations_updated': 0,
            'errors': []
        }
        
        # 割当データのインポート
        for row in reader:
            if len(row) < 4:
                continue
            try:
                allocation_id, transaction_id, budget_item_id, amount = row[:4]
                
                # 既存の割当を確認
                existing_allocation = db.query(Allocation).filter(Allocation.id == int(allocation_id)).first()
                
                # 取引と予算項目の存在確認
                transaction = db.query(Transaction).filter(Transaction.id == transaction_id).first()
                budget_item = db.query(BudgetItem).filter(BudgetItem.id == int(budget_item_id)).first()
                
                if not transaction:
                    import_stats['errors'].append(f"取引ID {transaction_id} が見つかりません")
                    continue
                
                if not budget_item:
                    import_stats['errors'].append(f"予算項目ID {budget_item_id} が見つかりません")
                    continue
                
                allocation_data = {
                    'transaction_id': transaction_id,
                    'budget_item_id': int(budget_item_id),
                    'amount': float(amount)
                }
                
                if existing_allocation:
                    # 更新
                    for key, value in allocation_data.items():
                        setattr(existing_allocation, key, value)
                    import_stats['allocations_updated'] += 1
                else:
                    # 新規作成
                    new_allocation = Allocation(id=int(allocation_id), **allocation_data)
                    db.add(new_allocation)
                    import_stats['allocations_created'] += 1
                    
            except Exception as e:
                import_stats['errors'].append(f"割当データエラー: {str(e)}")
        
        # データベースにコミット
        db.commit()
        
        return {
            "message": "割当データのインポートが完了しました",
            "stats": import_stats
        }
        
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"割当データインポートエラー: {str(e)}")

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
                
                # 既存の助成金を確認
                existing_grant = db.query(Grant).filter(Grant.id == int(grant_id)).first()
                
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
                    new_grant = Grant(id=int(grant_id), **grant_data)
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
                
                # 既存の助成金を確認
                existing_grant = db.query(Grant).filter(Grant.id == int(grant_id)).first()
                
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
                    new_grant = Grant(id=int(grant_id), **grant_data)
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
                
                # 既存の予算項目を確認
                existing_item = db.query(BudgetItem).filter(BudgetItem.id == int(item_id)).first()
                
                item_data = {
                    'grant_id': int(grant_id),
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
                    new_item = BudgetItem(id=int(item_id), **item_data)
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
                
                # 既存の割当を確認
                existing_allocation = db.query(Allocation).filter(Allocation.id == int(allocation_id)).first()
                
                allocation_data = {
                    'transaction_id': transaction_id,
                    'budget_item_id': int(budget_item_id),
                    'amount': float(amount) if amount else 0
                }
                
                if existing_allocation:
                    # 更新
                    for key, value in allocation_data.items():
                        setattr(existing_allocation, key, value)
                    import_stats['allocations_updated'] += 1
                else:
                    # 新規作成
                    new_allocation = Allocation(id=int(allocation_id), **allocation_data)
                    db.add(new_allocation)
                    import_stats['allocations_created'] += 1
                    
            except Exception as e:
                import_stats['errors'].append(f"割当データエラー: {str(e)}")
        
        # データベースにコミット
        db.commit()
        
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

@app.post("/api/freee/callback", response_model=FreeeTokenResponse)
async def freee_callback(code: str, state: str, db: Session = Depends(get_db)):
    """freee OAuth認証コールバック"""
    try:
        result = await freee_service.exchange_code_for_token(code, state, db)
        return FreeeTokenResponse(
            message=result["message"],
            company_id=result.get("company_id"),
            expires_at=result["expires_at"]
        )
    except Exception as e:
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

@app.post("/api/freee/sync", response_model=FreeeSyncResponse)
async def sync_freee_journals(
    start_date: str, 
    end_date: str, 
    db: Session = Depends(get_db)
):
    """freee仕訳データを同期"""
    try:
        result = await freee_service.sync_journals(db, start_date, end_date)
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

@app.delete("/api/freee/disconnect")
def disconnect_freee(db: Session = Depends(get_db)):
    """freee連携を切断"""
    try:
        db.query(FreeeToken).update({"is_active": False})
        db.commit()
        return {"message": "freee連携を切断しました"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"切断エラー: {str(e)}")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8001)