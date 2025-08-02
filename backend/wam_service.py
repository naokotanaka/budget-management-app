from typing import List, Dict, Optional
from sqlalchemy.orm import Session
from database import Transaction, WamMapping, Allocation, BudgetItem
import re

class WamService:
    """WAM報告書データ変換サービス"""
    
    # WAM科目の正式リスト
    WAM_CATEGORIES = [
        '謝金（内部）',
        '謝金（外部）',
        '旅費',
        '賃金（職員）',
        '賃金（アルバイト）',
        '家賃',
        '光熱水費',
        '備品購入費',
        '消耗品費',
        '借料損料',
        '印刷製本費',
        '通信運搬費',
        '委託費',
        '雑役務費',
        '保険料',
        '修繕費',
        '対象外経費'
    ]
    
    # 勘定科目からWAM科目への自動マッピングルール（実際にデータにある勘定科目）
    WAM_ACCOUNT_MAPPING = {
        # 人件費関連
        '賃金（職員）': ['給与手当', '役員報酬'],
        '賃金（アルバイト）': ['臨時給与'],
        '謝金（内部）': ['謝金'],
        '謝金（外部）': ['謝金'],
        
        # 事業費関連
        '旅費': ['旅費交通費'],
        '印刷製本費': ['印刷製本費'],
        '通信運搬費': ['通信費'],
        '委託費': ['支払手数料', '外注工賃'],
        '雑役務費': ['会議費', '接待交際費'],
        
        # 管理費関連
        '家賃': ['地代家賃'],
        '光熱水費': ['水道光熱費'],
        '備品購入費': ['工具器具備品'],
        '消耗品費': ['消耗品費'],
        '借料損料': ['リース料'],
        '保険料': ['保険料'],
        '修繕費': ['修繕費'],
        
        # その他
        '対象外経費': ['雑費', '租税公課']
    }
    
    @classmethod
    def get_wam_categories(cls) -> List[str]:
        """WAM科目リストを取得"""
        return cls.WAM_CATEGORIES
    
    @classmethod
    def clean_account_name(cls, account: str) -> str:
        """勘定科目から【事】【管】を除去"""
        if not account:
            return ""
        # 【事】【管】を除去
        cleaned = re.sub(r'^【[事管]】', '', account)
        return cleaned.strip()
    
    @classmethod
    def map_to_wam_category(cls, account: str, db: Session = None) -> str:
        """勘定科目をWAM科目に自動変換"""
        if not account:
            return ""
        
        # 勘定科目をクリーン化
        cleaned_account = cls.clean_account_name(account)
        
        # データベースからマッピングルールを取得（優先順位順）
        if db:
            db_mappings = db.query(WamMapping).filter(WamMapping.is_active == True).order_by(WamMapping.priority).all()
            for mapping in db_mappings:
                if mapping.account_pattern in cleaned_account:
                    return mapping.wam_category
        
        # フォールバック: デフォルトマッピングルールで検索
        for wam_category, account_patterns in cls.WAM_ACCOUNT_MAPPING.items():
            for pattern in account_patterns:
                if pattern in cleaned_account:
                    return wam_category
        
        # マッチしない場合は対象外経費として分類
        return "対象外経費"
    
    @classmethod
    def generate_summary(cls, transaction: Dict) -> str:
        """摘要を自動生成"""
        parts = []
        
        # 取引内容
        if transaction.get('description'):
            parts.append(transaction['description'])
        
        # メモ
        if transaction.get('memo'):
            parts.append(transaction['memo'])
        
        # 備考
        if transaction.get('remark'):
            parts.append(transaction['remark'])
        
        return " ".join(filter(None, parts))
    
    @classmethod
    def convert_transactions_to_wam_format(cls, transactions: List[Dict], db: Session = None, force_remap: bool = False) -> List[Dict]:
        """取引データをWAM報告書形式に変換"""
        wam_data = []
        
        for transaction in transactions:
            # 自動マッピングを実行
            mapped_category = cls.map_to_wam_category(transaction.get('account', ''), db)
            
            wam_item = {
                '支出年月日': transaction.get('date', ''),
                '科目': mapped_category,
                '支払いの相手方': transaction.get('supplier', ''),
                '摘要': cls.generate_summary(transaction),
                '金額': transaction.get('amount', 0),
                '管理番号': transaction.get('management_number', ''),
                # 元データも保持（編集用）
                '_original_transaction_id': transaction.get('id'),
                '_original_account': transaction.get('account', ''),
                '_auto_mapped': True,
                '_force_remap': force_remap,  # 強制再マッピングフラグ
                '_mapped_by': 'database_mapping' if db else 'default_mapping'
            }
            wam_data.append(wam_item)
        
        return wam_data
    
    @classmethod
    def get_wam_data_from_db(cls, db: Session, start_date: str = None, end_date: str = None, grant_id: int = None, force_remap: bool = False) -> List[Dict]:
        """データベースからWAM報告書用データを取得・変換"""
        query = db.query(Transaction)
        
        # 期間フィルター
        if start_date:
            query = query.filter(Transaction.date >= start_date)
        if end_date:
            query = query.filter(Transaction.date <= end_date)
        
        # 助成金フィルター
        if grant_id:
            query = query.join(Allocation).join(BudgetItem).filter(BudgetItem.grant_id == grant_id)
        
        transactions = query.all()
        
        # 辞書形式に変換
        transaction_dicts = []
        for t in transactions:
            transaction_dicts.append({
                'id': t.id,
                'date': t.date.strftime('%Y/%m/%d') if t.date else '',
                'description': t.description or '',
                'amount': t.amount or 0,
                'account': t.account or '',
                'supplier': t.supplier or '',
                'item': t.item or '',
                'memo': t.memo or '',
                'remark': t.remark or '',
                'management_number': t.management_number or ''
            })
        
        # WAM形式に変換（force_remapフラグを渡す）
        return cls.convert_transactions_to_wam_format(transaction_dicts, db, force_remap)
    
    @classmethod
    def initialize_default_mappings(cls, db: Session):
        """デフォルトマッピングルールをデータベースに挿入（実際の勘定科目ベース）"""
        # 既存のルールをチェック
        existing_count = db.query(WamMapping).count()
        if existing_count > 0:
            return  # 既にデータが存在する場合は何もしない
        
        # 実際の勘定科目を取得
        accounts = db.query(Transaction.account).distinct().filter(Transaction.account.isnot(None)).all()
        account_list = [cls.clean_account_name(account[0]) for account in accounts if account[0]]
        account_set = set(filter(None, account_list))  # 重複除去とNone除去
        
        # 実際にあるデータに基づいてマッピングを作成
        default_mappings = []
        priority = 10
        
        # 実際の勘定科目に基づくマッピングルール
        mapping_rules = [
            # 人件費関連
            ('給与手当', '賃金（職員）'),
            ('臨時雇用費', '賃金（アルバイト）'),
            ('謝金', '謝金（外部）'),
            
            # 事業費関連
            ('旅費交通費', '旅費'),
            ('印刷製本費', '印刷製本費'),
            ('通信運搬費', '通信運搬費'),
            ('支払手数料', '委託費'),
            ('会議費', '雑役務費'),
            ('食材費', '雑役務費'),
            ('教養娯楽費', '雑役務費'),
            
            # 管理費関連
            ('地代家賃', '家賃'),
            ('賃借料', '借料損料'),
            ('水道光熱費', '光熱水費'),
            ('消耗品費', '消耗品費'),
            ('保険料', '保険料'),
            ('修繕費', '修繕費'),
            
            # その他
            ('雑費', '対象外経費'),
            ('租税公課', '対象外経費'),
            ('交際費', '対象外経費'),
            ('諸会費', '対象外経費'),
            ('支払寄付金', '対象外経費'),
        ]
        
        # 実際にある勘定科目に対してマッピングを作成
        for pattern, wam_category in mapping_rules:
            matching_accounts = [acc for acc in account_set if pattern in acc]
            for account in matching_accounts:
                mapping = WamMapping(
                    account_pattern=account,
                    wam_category=wam_category,
                    priority=priority,
                    is_active=True
                )
                default_mappings.append(mapping)
                priority += 1
        
        if default_mappings:
            db.add_all(default_mappings)
            db.commit()
    
    @classmethod
    def get_all_mappings(cls, db: Session) -> List[Dict]:
        """全てのマッピングルールを取得"""
        mappings = db.query(WamMapping).order_by(WamMapping.priority).all()
        return [
            {
                'id': mapping.id,
                'account_pattern': mapping.account_pattern,
                'wam_category': mapping.wam_category,
                'priority': mapping.priority,
                'is_active': mapping.is_active
            }
            for mapping in mappings
        ]
    
    @classmethod
    def update_mapping(cls, db: Session, mapping_id: int, account_pattern: str, wam_category: str, priority: int = 100) -> bool:
        """マッピングルールを更新"""
        mapping = db.query(WamMapping).filter(WamMapping.id == mapping_id).first()
        if not mapping:
            return False
        
        mapping.account_pattern = account_pattern
        mapping.wam_category = wam_category
        mapping.priority = priority
        db.commit()
        return True
    
    @classmethod
    def create_mapping(cls, db: Session, account_pattern: str, wam_category: str, priority: int = 100) -> int:
        """新しいマッピングルールを作成"""
        mapping = WamMapping(
            account_pattern=account_pattern,
            wam_category=wam_category,
            priority=priority,
            is_active=True
        )
        db.add(mapping)
        db.commit()
        return mapping.id
    
    @classmethod
    def delete_mapping(cls, db: Session, mapping_id: int) -> bool:
        """マッピングルールを削除"""
        mapping = db.query(WamMapping).filter(WamMapping.id == mapping_id).first()
        if not mapping:
            return False
        
        db.delete(mapping)
        db.commit()
        return True 