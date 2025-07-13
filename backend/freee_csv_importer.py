#!/usr/bin/env python3
"""
freee仕訳データCSVインポート機能
freee会計からエクスポートした仕訳帳CSVを読み込む
"""
import pandas as pd
import chardet
import io
from datetime import datetime
from typing import List, Dict, Any
from sqlalchemy.orm import Session
from database_dev import SessionLocal, Transaction

class FreeeCSVImporter:
    def __init__(self):
        self.supported_formats = [
            'freee_journal',  # freee仕訳帳
            'freee_transaction',  # freee取引データ
        ]
    
    def detect_encoding(self, file_content: bytes) -> str:
        """ファイルの文字エンコーディングを検出"""
        result = chardet.detect(file_content)
        return result['encoding'] or 'utf-8'
    
    def parse_freee_journal_csv(self, file_content: bytes) -> List[Dict[str, Any]]:
        """freee仕訳帳CSVをパース"""
        encoding = self.detect_encoding(file_content)
        
        try:
            # CSVを読み込み
            df = pd.read_csv(io.BytesIO(file_content), encoding=encoding)
            
            # freee仕訳帳の標準列名をマッピング
            column_mapping = {
                '決算整理仕訳': 'is_adjustment',
                '取引日': 'date',
                '借方勘定科目': 'debit_account',
                '借方補助科目': 'debit_sub_account',
                '借方金額': 'debit_amount',
                '貸方勘定科目': 'credit_account',
                '貸方補助科目': 'credit_sub_account',
                '貸方金額': 'credit_amount',
                '摘要': 'description',
                '仕訳番号': 'journal_number',
                '仕訳行番号': 'journal_line_number',
                '取引先': 'supplier',
                '品目': 'item',
                'メモ': 'memo',
                '備考': 'remark',
                '部門': 'department',
                '管理番号': 'management_number'
            }
            
            # 列名を変換
            df = df.rename(columns=column_mapping)
            
            transactions = []
            
            for _, row in df.iterrows():
                # 借方仕訳
                if pd.notna(row.get('debit_amount', 0)) and float(row.get('debit_amount', 0)) > 0:
                    transaction = {
                        'id': f"freee_{row.get('journal_number', 0)}_{row.get('journal_line_number', 0)}_debit",
                        'journal_number': int(row.get('journal_number', 0)),
                        'journal_line_number': int(row.get('journal_line_number', 0)),
                        'date': pd.to_datetime(row.get('date')).date() if pd.notna(row.get('date')) else None,
                        'description': str(row.get('description', '')),
                        'amount': int(float(row.get('debit_amount', 0))),
                        'account': str(row.get('debit_account', '')),
                        'supplier': str(row.get('supplier', '')),
                        'item': str(row.get('item', '')),
                        'memo': str(row.get('memo', '')),
                        'remark': str(row.get('remark', '')),
                        'department': str(row.get('department', '')),
                        'management_number': str(row.get('management_number', '')),
                        'raw_data': row.to_json()
                    }
                    transactions.append(transaction)
                
                # 貸方仕訳
                if pd.notna(row.get('credit_amount', 0)) and float(row.get('credit_amount', 0)) > 0:
                    transaction = {
                        'id': f"freee_{row.get('journal_number', 0)}_{row.get('journal_line_number', 0)}_credit",
                        'journal_number': int(row.get('journal_number', 0)),
                        'journal_line_number': int(row.get('journal_line_number', 0)),
                        'date': pd.to_datetime(row.get('date')).date() if pd.notna(row.get('date')) else None,
                        'description': str(row.get('description', '')),
                        'amount': -int(float(row.get('credit_amount', 0))),  # 貸方は負の値
                        'account': str(row.get('credit_account', '')),
                        'supplier': str(row.get('supplier', '')),
                        'item': str(row.get('item', '')),
                        'memo': str(row.get('memo', '')),
                        'remark': str(row.get('remark', '')),
                        'department': str(row.get('department', '')),
                        'management_number': str(row.get('management_number', '')),
                        'raw_data': row.to_json()
                    }
                    transactions.append(transaction)
            
            return transactions
            
        except Exception as e:
            raise Exception(f"freee仕訳帳CSVの解析に失敗: {str(e)}")
    
    def import_to_database(self, transactions: List[Dict[str, Any]]) -> Dict[str, Any]:
        """取引データをデータベースに保存"""
        db = SessionLocal()
        try:
            created_count = 0
            updated_count = 0
            error_count = 0
            
            for trans_data in transactions:
                try:
                    # 既存データをチェック
                    existing = db.query(Transaction).filter(
                        Transaction.id == trans_data['id']
                    ).first()
                    
                    if existing:
                        # 更新
                        for key, value in trans_data.items():
                            setattr(existing, key, value)
                        updated_count += 1
                    else:
                        # 新規作成
                        transaction = Transaction(**trans_data)
                        db.add(transaction)
                        created_count += 1
                        
                except Exception as e:
                    print(f"取引データ保存エラー: {e}")
                    error_count += 1
                    continue
            
            db.commit()
            
            return {
                'status': 'success',
                'message': f'freee仕訳データのインポートが完了しました',
                'created_count': created_count,
                'updated_count': updated_count,
                'error_count': error_count,
                'total_count': len(transactions)
            }
            
        except Exception as e:
            db.rollback()
            raise Exception(f"データベース保存エラー: {str(e)}")
        finally:
            db.close()
    
    def process_freee_csv(self, file_content: bytes, format_type: str = 'freee_journal') -> Dict[str, Any]:
        """freee CSVファイルを処理"""
        try:
            if format_type == 'freee_journal':
                transactions = self.parse_freee_journal_csv(file_content)
            else:
                raise ValueError(f"サポートされていないフォーマット: {format_type}")
            
            # データベースに保存
            result = self.import_to_database(transactions)
            
            return result
            
        except Exception as e:
            return {
                'status': 'error',
                'message': str(e),
                'created_count': 0,
                'updated_count': 0,
                'error_count': 0,
                'total_count': 0
            }

# 使用例
if __name__ == "__main__":
    importer = FreeeCSVImporter()
    
    # テスト用
    print("freee CSV インポーターが初期化されました")
    print(f"サポートされている形式: {importer.supported_formats}")