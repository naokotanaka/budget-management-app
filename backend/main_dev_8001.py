import os
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

# 環境変数から直接取得（.envファイルは使用しない）
PORT = int(os.getenv("PORT", "8001"))
FRONTEND_URL = os.getenv("FRONTEND_URL", "http://160.251.170.97:3001")
ENVIRONMENT = os.getenv("ENVIRONMENT", "development")
NODE_ENV = os.getenv("NODE_ENV", "development")

print(f"🚀 開発環境バックエンド起動設定:")
print(f"   PORT: {PORT}")
print(f"   FRONTEND_URL: {FRONTEND_URL}")
print(f"   ENVIRONMENT: {ENVIRONMENT}")
print(f"   NODE_ENV: {NODE_ENV}")

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

app = FastAPI(title="NPO Budget Management System - Development")

# CORS設定 - 開発環境特化
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        FRONTEND_URL,  # 環境変数から取得
        "http://localhost:3001",  # 開発環境フロントエンド
        "http://160.251.170.97:3001",  # 開発環境外部アクセス
    ],
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
    from database import SQLALCHEMY_DATABASE_URL
    
    return {
        "environment": ENVIRONMENT,
        "node_env": NODE_ENV,
        "port": PORT,
        "frontend_url": FRONTEND_URL,
        "database_url": SQLALCHEMY_DATABASE_URL,
        "is_dev_db": "budget_dev" in SQLALCHEMY_DATABASE_URL,
        "is_prod_db": "budget_dev" not in SQLALCHEMY_DATABASE_URL and "nagaiku_budget" in SQLALCHEMY_DATABASE_URL
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

# 基本的なAPIエンドポイントをmain.pyから継承
# （簡略化のため、主要なエンドポイントのみ実装）

@app.get("/api/transactions")
def get_transactions(db: Session = Depends(get_db)):
    """取引データを取得"""
    transactions = db.query(Transaction).all()
    return transactions

@app.get("/api/grants")
def get_grants(db: Session = Depends(get_db)):
    """助成金データを取得"""
    grants = db.query(Grant).all()
    return grants

@app.get("/api/budget-items")
def get_budget_items(db: Session = Depends(get_db)):
    """予算項目データを取得"""
    budget_items = db.query(BudgetItem).all()
    return budget_items

@app.get("/api/allocations")
def get_allocations(db: Session = Depends(get_db)):
    """割当データを取得"""
    allocations = db.query(Allocation).all()
    return allocations

# Reports endpoints
@app.get("/api/reports/cross-table")
def get_cross_table(start_date: str, end_date: str, db: Session = Depends(get_db)):
    """クロス集計レポートを取得"""
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
        WHERE t.date >= :start_date AND t.date <= :end_date
        GROUP BY CONCAT(g.name, '-', bi.name), TO_CHAR(t.date, 'YYYY-MM')
        ORDER BY CONCAT(g.name, '-', bi.name), TO_CHAR(t.date, 'YYYY-MM')
        """
        
        result = db.execute(text(query), {"start_date": start_date, "end_date": end_date})
        rows = result.fetchall()
        
        # Convert to pivot format (same as main.py)
        pivot_data = {}
        for row in rows:
            budget_item = row[0]  # budget_item
            month = row[1]        # month
            total = row[2]        # total
            
            if budget_item not in pivot_data:
                pivot_data[budget_item] = {}
            pivot_data[budget_item][month] = total
            
        return pivot_data
        
    except Exception as e:
        print(f"Cross table error: {e}")
        return {"data": [], "error": str(e)}

@app.get("/api/reports/monthly-summary")
def get_monthly_summary(
    db: Session = Depends(get_db),
    start_date: Optional[str] = Query(None),
    end_date: Optional[str] = Query(None)
):
    """助成金ごとの月別集計レポートを取得"""
    try:
        # 簡単な実装
        query = """
        SELECT 
            g.name as grant_name,
            TO_CHAR(t.date, 'YYYY-MM') as month,
            SUM(a.amount) as total_amount
        FROM allocations a
        JOIN transactions t ON a.transaction_id = t.id
        JOIN budget_items bi ON a.budget_item_id = bi.id
        JOIN grants g ON bi.grant_id = g.id
        """
        
        if start_date and end_date:
            query += " WHERE t.date >= :start_date AND t.date <= :end_date"
            result = db.execute(text(query + " GROUP BY g.name, TO_CHAR(t.date, 'YYYY-MM') ORDER BY g.name, month"), 
                              {"start_date": start_date, "end_date": end_date})
        else:
            result = db.execute(text(query + " GROUP BY g.name, TO_CHAR(t.date, 'YYYY-MM') ORDER BY g.name, month"))
        
        rows = result.fetchall()
        monthly_summary = []
        for row in rows:
            monthly_summary.append({
                "grant_name": row[0],
                "month": row[1], 
                "total_amount": float(row[2]) if row[2] else 0,
                "year": int(row[1].split('-')[0]) if row[1] else 0,
                "month_num": int(row[1].split('-')[1]) if row[1] else 0,
                "transaction_count": 1  # 簡易実装
            })
            
        return {
            "summary": monthly_summary,
            "total_records": len(monthly_summary),
            "start_date": start_date,
            "end_date": end_date
        }
        
    except Exception as e:
        print(f"Monthly summary error: {e}")
        return {"data": [], "error": str(e)}

@app.get("/api/reports/budget-vs-actual")
def get_budget_vs_actual(
    db: Session = Depends(get_db),
    start_date: Optional[str] = Query(None),
    end_date: Optional[str] = Query(None)
):
    """助成金ごとの予算vs実際の支出を取得"""
    try:
        # 簡単な実装
        query = """
        SELECT 
            g.name as grant_name,
            SUM(bi.budgeted_amount) as budgeted,
            COALESCE(SUM(a.amount), 0) as actual
        FROM grants g
        LEFT JOIN budget_items bi ON g.id = bi.grant_id
        LEFT JOIN allocations a ON bi.id = a.budget_item_id
        """
        
        if start_date and end_date:
            query += """
            LEFT JOIN transactions t ON a.transaction_id = t.id
            WHERE t.date IS NULL OR (t.date >= :start_date AND t.date <= :end_date)
            """
            result = db.execute(text(query + " GROUP BY g.name ORDER BY g.name"), 
                              {"start_date": start_date, "end_date": end_date})
        else:
            result = db.execute(text(query + " GROUP BY g.name ORDER BY g.name"))
        
        rows = result.fetchall()
        summary = []
        for row in rows:
            budgeted = float(row[1]) if row[1] else 0
            actual = float(row[2]) if row[2] else 0
            remaining = budgeted - actual
            usage_rate = (actual / budgeted * 100) if budgeted > 0 else 0
            
            summary.append({
                "grant_id": 1,  # 簡易実装
                "grant_name": row[0],
                "grant_total_amount": int(budgeted),
                "grant_start_date": start_date,
                "grant_end_date": end_date,
                "budget_total": int(budgeted),
                "spent_total": int(actual),
                "remaining": int(remaining),
                "usage_rate": round(usage_rate, 1),
                "period_progress": 50.0  # 簡易実装
            })
            
        return {
            "summary": summary,
            "total_grants": len(summary),
            "start_date": start_date,
            "end_date": end_date
        }
        
    except Exception as e:
        print(f"Budget vs actual error: {e}")
        return {"data": [], "error": str(e)}

# WAM Report endpoints
@app.get("/api/wam-report/data")
def get_wam_report_data(
    db: Session = Depends(get_db),
    start_date: Optional[str] = Query(None),
    end_date: Optional[str] = Query(None),
    grant_id: Optional[int] = Query(None),
    force_remap: Optional[bool] = Query(False)
):
    """WAM報告書用データを取得（簡易版）"""
    try:
        from wam_service import WamService
        wam_data = WamService.get_wam_data_from_db(db, start_date, end_date, grant_id, force_remap)
        return {
            "data": wam_data,
            "total_count": len(wam_data),
            "start_date": start_date,
            "end_date": end_date,
            "force_remap": force_remap
        }
    except Exception as e:
        print(f"WAM Report error: {e}")
        return {
            "data": [],
            "total_count": 0,
            "start_date": start_date,
            "end_date": end_date,
            "error": str(e)
        }

@app.get("/api/wam-report/categories")
def get_wam_categories():
    """WAM科目リストを取得"""
    try:
        from wam_service import WamService
        categories = WamService.get_wam_categories()
        return {"categories": categories}
    except Exception as e:
        print(f"WAM Categories error: {e}")
        # 基本的なWAM科目をハードコード
        basic_categories = [
            "謝金", "旅費", "賃金", "家賃", "光熱水費", 
            "備品購入費", "消耗品費", "通信運搬費", "印刷製本費",
            "会議費", "雑役務費", "対象外経費"
        ]
        return {"categories": basic_categories}

@app.get("/api/wam-mappings")
def get_wam_mappings(db: Session = Depends(get_db)):
    """WAMマッピングルール一覧を取得"""
    try:
        from wam_service import WamService
        WamService.initialize_default_mappings(db)
        mappings = WamService.get_all_mappings(db)
        return {"mappings": mappings}
    except Exception as e:
        print(f"WAM Mappings error: {e}")
        return {"mappings": [], "error": str(e)}

@app.get("/api/account-patterns")
def get_account_patterns(db: Session = Depends(get_db)):
    """既存の勘定科目一覧を取得（マッピング設定用）"""
    try:
        accounts = db.query(Transaction.account).distinct().filter(Transaction.account.isnot(None)).all()
        account_list = [acc[0] for acc in accounts if acc[0]]
        return {"accounts": sorted(account_list)}
    except Exception as e:
        print(f"Account patterns error: {e}")
        return {"accounts": [], "error": str(e)}

# 起動部分
if __name__ == "__main__":
    import uvicorn
    print(f"🚀 開発環境バックエンドを起動します (ポート: {PORT})")
    uvicorn.run(app, host="0.0.0.0", port=PORT, reload=True) 