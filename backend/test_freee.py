#!/usr/bin/env python3
"""
freee連携機能のテスト・検証スクリプト

使用方法:
python test_freee.py [テスト種別]

テスト種別:
- config: 環境変数設定のテスト
- db: データベース接続のテスト
- auth: freee認証URLの生成テスト
- all: 全テストを実行
"""

import os
import sys
from datetime import datetime
from sqlalchemy.exc import SQLAlchemyError

def test_config():
    """環境変数設定のテスト"""
    print("🔧 環境変数設定をテストしています...")
    
    required_vars = [
        "FREEE_CLIENT_ID",
        "FREEE_CLIENT_SECRET", 
        "FREEE_REDIRECT_URI",
        "DATABASE_USER",
        "DATABASE_PASSWORD",
        "DATABASE_HOST",
        "DATABASE_NAME"
    ]
    
    missing_vars = []
    for var in required_vars:
        value = os.getenv(var)
        if not value:
            missing_vars.append(var)
        else:
            # 重要な情報は一部のみ表示
            if "SECRET" in var or "PASSWORD" in var:
                display_value = value[:4] + "***" if len(value) > 4 else "***"
            else:
                display_value = value
            print(f"  ✅ {var}: {display_value}")
    
    if missing_vars:
        print(f"  ❌ 不足している環境変数: {', '.join(missing_vars)}")
        return False
    
    print("  ✅ 全ての環境変数が設定されています")
    return True

def test_database():
    """データベース接続のテスト"""
    print("\n🗄️ データベース接続をテストしています...")
    
    try:
        from database import engine, get_db, FreeeToken, FreeeSync, Transaction
        from sqlalchemy.orm import sessionmaker
        
        # 接続テスト
        with engine.connect() as conn:
            print("  ✅ データベースに接続できました")
        
        # テーブル存在確認
        SessionLocal = sessionmaker(bind=engine)
        db = SessionLocal()
        
        try:
            # 各テーブルへのクエリテスト
            token_count = db.query(FreeeToken).count()
            sync_count = db.query(FreeeSync).count()
            transaction_count = db.query(Transaction).count()
            
            print(f"  ✅ FreeeToken テーブル: {token_count}件")
            print(f"  ✅ FreeeSync テーブル: {sync_count}件")
            print(f"  ✅ Transaction テーブル: {transaction_count}件")
            
        finally:
            db.close()
        
        return True
        
    except ImportError as e:
        print(f"  ❌ モジュールのインポートエラー: {e}")
        return False
    except SQLAlchemyError as e:
        print(f"  ❌ データベースエラー: {e}")
        return False
    except Exception as e:
        print(f"  ❌ 予期しないエラー: {e}")
        return False

def test_freee_auth():
    """freee認証URLの生成テスト"""
    print("\n🔐 freee認証URLの生成をテストしています...")
    
    try:
        from freee_service import FreeeService
        
        service = FreeeService()
        
        # 認証URL生成
        auth_data = service.generate_auth_url()
        
        print(f"  ✅ 認証URLを生成しました")
        print(f"  ✅ State: {auth_data['state'][:10]}...")
        print(f"  ✅ URL: {auth_data['auth_url'][:60]}...")
        
        # URL形式の基本チェック
        url = auth_data['auth_url']
        if "accounts.secure.freee.co.jp" in url and "authorize" in url:
            print("  ✅ 認証URLの形式が正しいようです")
            return True
        else:
            print("  ❌ 認証URLの形式が正しくありません")
            return False
        
    except ValueError as e:
        print(f"  ❌ 設定エラー: {e}")
        return False
    except Exception as e:
        print(f"  ❌ 予期しないエラー: {e}")
        return False

def run_all_tests():
    """全テストの実行"""
    print("🧪 freee連携機能のテストを開始します...\n")
    
    tests = [
        ("設定テスト", test_config),
        ("データベーステスト", test_database),
        ("freee認証テスト", test_freee_auth)
    ]
    
    results = []
    for test_name, test_func in tests:
        try:
            result = test_func()
            results.append((test_name, result))
        except Exception as e:
            print(f"  ❌ {test_name}で予期しないエラー: {e}")
            results.append((test_name, False))
    
    # 結果サマリー
    print("\n📊 テスト結果サマリー:")
    print("=" * 50)
    
    passed = 0
    for test_name, result in results:
        status = "✅ PASS" if result else "❌ FAIL"
        print(f"  {status}: {test_name}")
        if result:
            passed += 1
    
    print("=" * 50)
    print(f"  合計: {passed}/{len(results)} テストが成功")
    
    if passed == len(results):
        print("  🎉 全てのテストが成功しました！")
        return True
    else:
        print("  ⚠️  一部のテストが失敗しました。設定を確認してください。")
        return False

def main():
    if len(sys.argv) < 2:
        test_type = "all"
    else:
        test_type = sys.argv[1].lower()
    
    if test_type == "config":
        test_config()
    elif test_type == "db":
        test_database()
    elif test_type == "auth":
        test_freee_auth()
    elif test_type == "all":
        run_all_tests()
    else:
        print("無効なテスト種別です。config, db, auth, all のいずれかを指定してください。")
        sys.exit(1)

if __name__ == "__main__":
    main()