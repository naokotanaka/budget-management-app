#!/usr/bin/env python3
"""
開発環境用データベース初期化スクリプト
"""
import sys
import os
from datetime import datetime
from sqlalchemy import text

# 環境変数を開発用に設定
os.environ['DATABASE_NAME_DEV'] = 'nagaiku_budget_dev'

# database_devモジュールをインポート
from database_dev import engine, Base, SessionLocal
from database_dev import Transaction, Grant, BudgetItem, Allocation, FreeeToken, Category, FreeeSync

def init_database():
    """データベースのテーブルを作成"""
    print("開発環境データベースの初期化を開始...")
    
    try:
        # すべてのテーブルを作成
        Base.metadata.create_all(bind=engine)
        print("✓ テーブルの作成が完了しました")
        
        # 接続テスト
        db = SessionLocal()
        try:
            # 各テーブルの存在を確認
            tables = ['transactions', 'grants', 'budget_items', 'allocations', 'freee_tokens', 'categories', 'freee_syncs']
            for table in tables:
                result = db.execute(text(f"SELECT COUNT(*) FROM {table}"))
                count = result.scalar()
                print(f"✓ {table}: {count} 件")
        except Exception as e:
            print(f"エラー: {e}")
        finally:
            db.close()
            
        print("\n開発環境データベースの初期化が完了しました！")
        print(f"データベース名: nagaiku_budget_dev")
        print(f"ユーザー: nagaiku_user")
        
    except Exception as e:
        print(f"エラーが発生しました: {e}")
        sys.exit(1)

def create_sample_data():
    """開発用のサンプルデータを作成"""
    db = SessionLocal()
    try:
        # 助成金のサンプル
        sample_grant = Grant(
            name="開発テスト助成金",
            grant_code="TEST2024",
            total_amount=1800000,
            status="active"
        )
        db.add(sample_grant)
        db.flush()  # IDを取得するため
        
        # 予算項目のサンプル
        budget_items = [
            BudgetItem(grant_id=sample_grant.id, name="人件費", category="人件費", budgeted_amount=1000000),
            BudgetItem(grant_id=sample_grant.id, name="事業費", category="事業費", budgeted_amount=500000),
            BudgetItem(grant_id=sample_grant.id, name="管理費", category="管理費", budgeted_amount=300000),
        ]
        for item in budget_items:
            db.add(item)
        
        db.commit()
        print("✓ サンプルデータの作成が完了しました")
        
    except Exception as e:
        db.rollback()
        print(f"サンプルデータ作成中にエラー: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description='開発環境データベースの初期化')
    parser.add_argument('--sample-data', action='store_true', help='サンプルデータを作成')
    args = parser.parse_args()
    
    init_database()
    
    if args.sample_data:
        create_sample_data()