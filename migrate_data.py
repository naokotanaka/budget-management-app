#!/usr/bin/env python3
"""
SQLiteからPostgreSQLにデータを移行するスクリプト
"""

import sqlite3
import psycopg2
import os
from datetime import datetime

# データベース設定
SQLITE_DB = "/root/nagaiku-budget/data/budget.db"
POSTGRES_CONFIG = {
    'host': 'localhost',
    'port': '5432',
    'database': 'nagaiku_budget',
    'user': 'nagaiku_user',
    'password': 'nagaiku_password2024'
}

def migrate_data():
    # SQLite接続
    sqlite_conn = sqlite3.connect(SQLITE_DB)
    sqlite_cursor = sqlite_conn.cursor()
    
    # PostgreSQL接続
    postgres_conn = psycopg2.connect(**POSTGRES_CONFIG)
    postgres_cursor = postgres_conn.cursor()
    
    try:
        print("🔄 データ移行を開始します...")
        
        # 1. Grantsテーブルの移行
        print("📊 Grantsデータを移行中...")
        sqlite_cursor.execute("SELECT * FROM grants")
        grants = sqlite_cursor.fetchall()
        
        for grant in grants:
            postgres_cursor.execute("""
                INSERT INTO grants (id, name, total_amount, start_date, end_date)
                VALUES (%s, %s, %s, %s, %s)
                ON CONFLICT (id) DO NOTHING
            """, grant)
        
        postgres_conn.commit()
        print(f"✅ Grants: {len(grants)}件を移行しました")
        
        # 2. Budget Itemsテーブルの移行
        print("💰 Budget Itemsデータを移行中...")
        sqlite_cursor.execute("SELECT * FROM budget_items")
        budget_items = sqlite_cursor.fetchall()
        
        for item in budget_items:
            postgres_cursor.execute("""
                INSERT INTO budget_items (id, grant_id, name, category, budgeted_amount)
                VALUES (%s, %s, %s, %s, %s)
                ON CONFLICT (id) DO NOTHING
            """, item)
        
        postgres_conn.commit()
        print(f"✅ Budget Items: {len(budget_items)}件を移行しました")
        
        # 3. Transactionsテーブルの移行
        print("💳 Transactionsデータを移行中...")
        sqlite_cursor.execute("SELECT * FROM transactions")
        transactions = sqlite_cursor.fetchall()
        
        for transaction in transactions:
            postgres_cursor.execute("""
                INSERT INTO transactions 
                (id, journal_number, journal_line_number, date, description, amount, 
                 account, supplier, item, memo, remark, department, management_number, 
                 raw_data, created_at)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT (id) DO NOTHING
            """, transaction)
        
        postgres_conn.commit()
        print(f"✅ Transactions: {len(transactions)}件を移行しました")
        
        # 4. Allocationsテーブルの移行
        print("🔗 Allocationsデータを移行中...")
        sqlite_cursor.execute("SELECT * FROM allocations")
        allocations = sqlite_cursor.fetchall()
        
        for allocation in allocations:
            postgres_cursor.execute("""
                INSERT INTO allocations (id, transaction_id, budget_item_id, amount, created_at)
                VALUES (%s, %s, %s, %s, %s)
                ON CONFLICT (id) DO NOTHING
            """, allocation)
        
        postgres_conn.commit()
        print(f"✅ Allocations: {len(allocations)}件を移行しました")
        
        print("🎉 データ移行が完了しました！")
        
    except Exception as e:
        print(f"❌ エラーが発生しました: {e}")
        postgres_conn.rollback()
        raise
    
    finally:
        sqlite_conn.close()
        postgres_conn.close()

if __name__ == "__main__":
    migrate_data()