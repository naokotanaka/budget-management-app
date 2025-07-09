#!/usr/bin/env python3
"""
デフォルトカテゴリを作成するスクリプト
"""
from database import SessionLocal, Category, create_tables

def init_categories():
    """デフォルトカテゴリを作成"""
    db = SessionLocal()
    
    # テーブルを作成
    create_tables()
    
    # デフォルトカテゴリリスト
    default_categories = [
        {'name': '固定', 'description': '固定費用'},
        {'name': '家賃', 'description': '賃貸料'},
        {'name': '光熱', 'description': '光熱費'},
        {'name': 'ほか', 'description': 'その他'},
        {'name': '謝金', 'description': '謝礼金'},
        {'name': '消耗', 'description': '消耗品費'},
        {'name': '賃金', 'description': '給与・賃金'},
        {'name': '通信', 'description': '通信費'},
        {'name': '保険', 'description': '保険料'},
        {'name': '食材', 'description': '食材費'}
    ]
    
    try:
        for cat_data in default_categories:
            # 既存チェック
            existing = db.query(Category).filter(Category.name == cat_data['name']).first()
            if not existing:
                category = Category(**cat_data)
                db.add(category)
                print(f"Created category: {cat_data['name']}")
            else:
                print(f"Category already exists: {cat_data['name']}")
        
        db.commit()
        print("Default categories initialization completed!")
        
    except Exception as e:
        print(f"Error: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    init_categories()