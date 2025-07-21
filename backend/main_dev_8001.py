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

# 起動部分
if __name__ == "__main__":
    import uvicorn
    print(f"🚀 開発環境バックエンドを起動します (ポート: {PORT})")
    uvicorn.run(app, host="0.0.0.0", port=PORT, reload=True) 