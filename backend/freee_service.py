import httpx
import os
import secrets
from datetime import datetime, timedelta
from typing import Optional, Dict, Any, List
from urllib.parse import urlencode
from sqlalchemy.orm import Session
from database import FreeeToken, FreeeSync, Transaction, get_db
from schemas import FreeeTokenCreate, FreeeSyncCreate
import json

class FreeeService:
    def __init__(self):
        self.client_id = os.getenv("FREEE_CLIENT_ID")
        self.client_secret = os.getenv("FREEE_CLIENT_SECRET")
        self.redirect_uri = os.getenv("FREEE_REDIRECT_URI", "http://160.251.170.97:3001/freee/callback")
        self.base_url = "https://api.freee.co.jp"
        self.auth_url = "https://accounts.secure.freee.co.jp/public_api/authorize"
        self.token_url = "https://accounts.secure.freee.co.jp/public_api/token"
        
        if not self.client_id or not self.client_secret:
            print("Warning: FREEE_CLIENT_ID and FREEE_CLIENT_SECRET environment variables are not set")
    
    def generate_auth_url(self) -> Dict[str, str]:
        """OAuth認証URLを生成"""
        if not self.client_id or not self.client_secret:
            raise ValueError("freee API credentials are not configured")
            
        state = secrets.token_urlsafe(32)
        
        params = {
            "client_id": self.client_id,
            "redirect_uri": self.redirect_uri,
            "response_type": "code",
            "scope": "read write",
            "state": state
        }
        
        auth_url = f"{self.auth_url}?{urlencode(params)}"
        
        return {
            "auth_url": auth_url,
            "state": state
        }
    
    async def exchange_code_for_token(self, code: str, state: str, db: Session) -> Dict[str, Any]:
        """認証コードをアクセストークンに交換"""
        data = {
            "grant_type": "authorization_code",
            "client_id": self.client_id,
            "client_secret": self.client_secret,
            "code": code,
            "redirect_uri": self.redirect_uri
        }
        
        async with httpx.AsyncClient() as client:
            response = await client.post(self.token_url, data=data)
            response.raise_for_status()
            
            token_data = response.json()
            
            # トークンの有効期限を計算
            expires_at = datetime.utcnow() + timedelta(seconds=token_data["expires_in"])
            
            # 既存のトークンを無効化
            db.query(FreeeToken).update({"is_active": False})
            
            # 新しいトークンを保存
            new_token = FreeeToken(
                access_token=token_data["access_token"],
                refresh_token=token_data["refresh_token"],
                token_type=token_data.get("token_type", "Bearer"),
                expires_at=expires_at,
                scope=token_data.get("scope"),
                is_active=True
            )
            
            db.add(new_token)
            
            # 会社情報を取得
            company_info = await self.get_companies(token_data["access_token"])
            if company_info and len(company_info) > 0:
                new_token.company_id = str(company_info[0]["id"])
            
            db.commit()
            db.refresh(new_token)
            
            return {
                "message": "認証が完了しました",
                "company_id": new_token.company_id,
                "expires_at": new_token.expires_at
            }
    
    async def refresh_token(self, refresh_token: str, db: Session) -> Optional[FreeeToken]:
        """リフレッシュトークンを使用してアクセストークンを更新"""
        data = {
            "grant_type": "refresh_token",
            "client_id": self.client_id,
            "client_secret": self.client_secret,
            "refresh_token": refresh_token
        }
        
        async with httpx.AsyncClient() as client:
            response = await client.post(self.token_url, data=data)
            response.raise_for_status()
            
            token_data = response.json()
            
            # トークンの有効期限を計算
            expires_at = datetime.utcnow() + timedelta(seconds=token_data["expires_in"])
            
            # 既存のトークンを無効化
            db.query(FreeeToken).update({"is_active": False})
            
            # 新しいトークンを保存
            new_token = FreeeToken(
                access_token=token_data["access_token"],
                refresh_token=token_data["refresh_token"],
                token_type=token_data.get("token_type", "Bearer"),
                expires_at=expires_at,
                scope=token_data.get("scope"),
                is_active=True
            )
            
            db.add(new_token)
            db.commit()
            db.refresh(new_token)
            
            return new_token
    
    async def get_valid_token(self, db: Session) -> Optional[str]:
        """有効なアクセストークンを取得（必要に応じて更新）"""
        token = db.query(FreeeToken).filter(FreeeToken.is_active == True).first()
        
        if not token:
            return None
        
        # トークンの有効期限をチェック
        if datetime.utcnow() >= token.expires_at:
            # リフレッシュトークンを使用して更新
            try:
                new_token = await self.refresh_token(token.refresh_token, db)
                return new_token.access_token if new_token else None
            except:
                return None
        
        return token.access_token
    
    async def get_companies(self, access_token: str) -> List[Dict[str, Any]]:
        """会社情報を取得"""
        headers = {
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/json"
        }
        
        async with httpx.AsyncClient() as client:
            response = await client.get(f"{self.base_url}/api/1/companies", headers=headers)
            response.raise_for_status()
            
            data = response.json()
            return data.get("companies", [])
    
    async def get_journals(self, access_token: str, company_id: str, start_date: str, end_date: str, limit: int = 100, offset: int = 0) -> Dict[str, Any]:
        """仕訳データを取得"""
        headers = {
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/json"
        }
        
        params = {
            "company_id": company_id,
            "start_date": start_date,
            "end_date": end_date,
            "limit": limit,
            "offset": offset
        }
        
        async with httpx.AsyncClient() as client:
            response = await client.get(f"{self.base_url}/api/1/journals", headers=headers, params=params)
            response.raise_for_status()
            
            return response.json()
    
    def convert_journal_to_transaction(self, journal_data: Dict[str, Any]) -> List[Dict[str, Any]]:
        """freeeの仕訳データを既存のtransactionフォーマットに変換"""
        transactions = []
        
        for journal in journal_data.get("journals", []):
            for i, detail in enumerate(journal.get("details", [])):
                # 【事】【管】勘定科目のフィルタリング
                account_item = detail.get("account_item", {})
                account_name = account_item.get("name", "")
                
                if not account_name.startswith(("【事】", "【管】")):
                    continue
                
                # 取引データを変換
                transaction = {
                    "id": f"{journal['id']}_{i+1}",
                    "journal_number": journal["id"],
                    "journal_line_number": i + 1,
                    "date": journal["issue_date"],
                    "description": journal.get("description", ""),
                    "amount": abs(detail.get("amount", 0)),
                    "account": account_name,
                    "supplier": "",  # freeeから取得できない場合は空
                    "item": "",      # freeeから取得できない場合は空
                    "memo": detail.get("description", ""),
                    "remark": "",
                    "department": "",
                    "management_number": "",
                    "raw_data": json.dumps(journal, ensure_ascii=False)
                }
                
                transactions.append(transaction)
        
        return transactions
    
    async def sync_journals(self, db: Session, start_date: str, end_date: str) -> Dict[str, Any]:
        """仕訳データを同期"""
        # 有効なトークンを取得
        access_token = await self.get_valid_token(db)
        if not access_token:
            raise Exception("有効なアクセストークンがありません。再認証が必要です。")
        
        # 会社IDを取得
        token = db.query(FreeeToken).filter(FreeeToken.is_active == True).first()
        if not token or not token.company_id:
            raise Exception("会社情報が見つかりません。")
        
        # 同期記録を作成
        sync_record = FreeeSync(
            sync_type="journals",
            start_date=datetime.strptime(start_date, "%Y-%m-%d").date(),
            end_date=datetime.strptime(end_date, "%Y-%m-%d").date(),
            status="running"
        )
        db.add(sync_record)
        db.commit()
        db.refresh(sync_record)
        
        try:
            # 仕訳データを取得
            all_transactions = []
            offset = 0
            limit = 100
            
            while True:
                journal_data = await self.get_journals(
                    access_token, 
                    token.company_id, 
                    start_date, 
                    end_date, 
                    limit, 
                    offset
                )
                
                if not journal_data.get("journals"):
                    break
                
                transactions = self.convert_journal_to_transaction(journal_data)
                all_transactions.extend(transactions)
                
                # 次のページがあるかチェック
                if len(journal_data.get("journals", [])) < limit:
                    break
                
                offset += limit
            
            # データベースに保存
            created_count = 0
            updated_count = 0
            
            for trans_data in all_transactions:
                existing = db.query(Transaction).filter(
                    Transaction.journal_number == trans_data["journal_number"],
                    Transaction.journal_line_number == trans_data["journal_line_number"]
                ).first()
                
                if existing:
                    # 更新
                    for key, value in trans_data.items():
                        if key != "id":
                            setattr(existing, key, value)
                    updated_count += 1
                else:
                    # 新規作成
                    transaction = Transaction(**trans_data)
                    db.add(transaction)
                    created_count += 1
            
            # 同期記録を更新
            sync_record.status = "completed"
            sync_record.total_records = len(all_transactions)
            sync_record.processed_records = len(all_transactions)
            sync_record.created_records = created_count
            sync_record.updated_records = updated_count
            sync_record.completed_at = datetime.utcnow()
            
            db.commit()
            
            return {
                "message": f"同期が完了しました。新規作成: {created_count}件、更新: {updated_count}件",
                "sync_id": sync_record.id,
                "status": "completed",
                "total_records": len(all_transactions),
                "created_records": created_count,
                "updated_records": updated_count
            }
            
        except Exception as e:
            # エラーの場合は同期記録を更新
            sync_record.status = "failed"
            sync_record.error_message = str(e)
            sync_record.completed_at = datetime.utcnow()
            db.commit()
            
            raise Exception(f"同期中にエラーが発生しました: {str(e)}")