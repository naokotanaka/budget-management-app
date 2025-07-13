#!/usr/bin/env python3
"""
freee機能テスト用のサンプルデータを作成
"""
import os
from datetime import datetime, date, timedelta
from sqlalchemy.orm import Session
from database_dev import SessionLocal, Transaction, FreeeToken

def create_test_freee_token():
    """テスト用のfreeeトークンを作成"""
    db = SessionLocal()
    try:
        # 既存のトークンを無効化
        db.query(FreeeToken).update({"is_active": False})
        
        # テスト用トークンを作成
        test_token = FreeeToken(
            access_token="test_access_token_12345",
            refresh_token="test_refresh_token_67890",
            token_type="Bearer",
            expires_at=datetime.utcnow() + timedelta(hours=6),
            scope="read write",
            company_id="test_company_12345",
            is_active=True
        )
        
        db.add(test_token)
        db.commit()
        
        print("✓ テスト用freeeトークンを作成しました")
        
    except Exception as e:
        db.rollback()
        print(f"エラー: {e}")
    finally:
        db.close()

def create_test_transactions():
    """テスト用の取引データを作成"""
    db = SessionLocal()
    try:
        # テスト用取引データ
        test_transactions = [
            {
                'id': 'freee_test_001',
                'journal_number': 1001,
                'journal_line_number': 1,
                'date': date.today() - timedelta(days=30),
                'description': 'freee連携テスト - 人件費',
                'amount': 500000,
                'account': '給料手当',
                'supplier': 'テスト会社',
                'item': '人件費',
                'memo': 'freee API連携テスト',
                'remark': 'テストデータ',
                'department': '事業部',
                'management_number': 'TEST001',
                'raw_data': '{"source": "freee_test"}'
            },
            {
                'id': 'freee_test_002',
                'journal_number': 1002,
                'journal_line_number': 1,
                'date': date.today() - timedelta(days=25),
                'description': 'freee連携テスト - 事業費',
                'amount': 300000,
                'account': '事業費',
                'supplier': 'テスト取引先',
                'item': '事業費',
                'memo': 'freee API連携テスト',
                'remark': 'テストデータ',
                'department': '事業部',
                'management_number': 'TEST002',
                'raw_data': '{"source": "freee_test"}'
            },
            {
                'id': 'freee_test_003',
                'journal_number': 1003,
                'journal_line_number': 1,
                'date': date.today() - timedelta(days=20),
                'description': 'freee連携テスト - 管理費',
                'amount': 150000,
                'account': '管理費',
                'supplier': 'テスト業者',
                'item': '管理費',
                'memo': 'freee API連携テスト',
                'remark': 'テストデータ',
                'department': '管理部',
                'management_number': 'TEST003',
                'raw_data': '{"source": "freee_test"}'
            }
        ]
        
        created_count = 0
        for trans_data in test_transactions:
            existing = db.query(Transaction).filter(Transaction.id == trans_data['id']).first()
            if not existing:
                transaction = Transaction(**trans_data)
                db.add(transaction)
                created_count += 1
        
        db.commit()
        print(f"✓ テスト用取引データを{created_count}件作成しました")
        
    except Exception as e:
        db.rollback()
        print(f"エラー: {e}")
    finally:
        db.close()

def main():
    """テストデータ作成のメイン関数"""
    print("freee機能テスト用データを作成中...")
    
    # テスト用freeeトークンを作成
    create_test_freee_token()
    
    # テスト用取引データを作成
    create_test_transactions()
    
    print("\n✅ freee機能テスト用データの作成が完了しました！")
    print("これで以下の機能をテストできます：")
    print("- freee連携状況の確認")
    print("- 取引データの表示")
    print("- 自動同期機能のテスト")

if __name__ == "__main__":
    main()