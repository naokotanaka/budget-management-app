import httpx
import os
import secrets
import asyncio
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
        
        print(f"Token exchange data: {data}")
        
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.post(self.token_url, data=data)
            print(f"Token response status: {response.status_code}")
            print(f"Token response content: {response.text}")
            
            if response.status_code != 200:
                error_detail = response.text
                try:
                    error_json = response.json()
                    error_detail = error_json.get("error_description", error_json)
                except:
                    pass
                raise Exception(f"Freee API token exchange failed: {error_detail}")
            
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
        
        async with httpx.AsyncClient(timeout=30.0) as client:
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
    
    async def get_deals(self, access_token: str, company_id: str, start_date: str, end_date: str, limit: int = 100, offset: int = 0) -> Dict[str, Any]:
        """取引データを取得（dealsエンドポイント使用）"""
        headers = {
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/json"
        }
        
        params = {
            "company_id": company_id,
            "start_issue_date": start_date,
            "end_issue_date": end_date,
            "limit": limit,
            "offset": offset
        }
        
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.get(f"{self.base_url}/api/1/deals", headers=headers, params=params)
            
            print(f"Deals API response status: {response.status_code}")
            print(f"Deals API response content: {response.text[:500]}...")
            
            response.raise_for_status()
            
            return response.json()
    
    async def get_journals(self, access_token: str, company_id: str, start_date: str, end_date: str, limit: int = 100, offset: int = 0) -> Dict[str, Any]:
        """仕訳データを取得（journalsエンドポイント使用）"""
        headers = {
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/json"
        }
        
        params = {
            "company_id": company_id,
            "start_date": start_date,
            "end_date": end_date,
            "download_type": "generic_v2",
            "limit": limit,
            "offset": offset
        }
        
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.get(f"{self.base_url}/api/1/journals", headers=headers, params=params)
            
            print(f"Journals API response status: {response.status_code}")
            print(f"Journals API response content: {response.text[:500]}...")
            
            if response.status_code == 202:
                # 非同期処理の場合、ステータス確認を試行
                response_data = response.json()
                status_url = response_data.get('journals', {}).get('status_url', '')
                print(f"仕訳データは非同期処理中です。ステータスURL: {status_url}")
                
                if status_url:
                    # 複数回ステータス確認を試行
                    import asyncio
                    max_attempts = 5
                    for attempt in range(max_attempts):
                        wait_time = 3 + (attempt * 2)  # 3, 5, 7, 9, 11秒待機
                        print(f"仕訳ステータス確認試行 {attempt + 1}/{max_attempts}、{wait_time}秒待機中...")
                        await asyncio.sleep(wait_time)
                        
                        try:
                            # company_idパラメータを追加
                            status_params = {"company_id": company_id}
                            status_response = await client.get(status_url, headers=headers, params=status_params)
                            status_data = status_response.json()
                            print(f"仕訳ステータス確認 {attempt + 1}: {status_data}")
                            
                            # 処理完了している場合はダウンロードURLを取得
                            journal_status = status_data.get('journals', {}).get('status')
                            download_url = status_data.get('journals', {}).get('download_url')
                            
                            if (journal_status == 'completed' or journal_status == 'uploaded') and download_url:
                                # ダウンロードリクエストにもcompany_idパラメータを追加
                                download_params = {"company_id": company_id}
                                download_response = await client.get(download_url, headers=headers, params=download_params)
                                print(f"仕訳ダウンロード成功: {len(download_response.content)} bytes")
                                print(f"ダウンロード内容サンプル: {download_response.text[:200]}")
                                # CSV形式のデータを処理する必要があります
                                return {"journals": [], "csv_data": download_response.text, "async_processing": True}
                            elif journal_status == 'working':
                                print(f"まだ処理中です。再試行します...")
                                continue
                            else:
                                print(f"予期しないステータス: {journal_status}, download_url: {download_url}")
                                break
                        except Exception as e:
                            print(f"仕訳ステータス確認エラー (試行 {attempt + 1}): {e}")
                            continue
                
                return {"journals": [], "async_processing": True, "status_info": response_data}
            
            response.raise_for_status()
            
            return response.json()
    
    async def get_sections(self, access_token: str, company_id: str) -> Dict[str, Any]:
        """部門マスタを取得"""
        headers = {
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/json"
        }
        
        params = {
            "company_id": company_id
        }
        
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.get(f"{self.base_url}/api/1/sections", headers=headers, params=params)
            
            print(f"Sections API response status: {response.status_code}")
            print(f"Sections API response content: {response.text[:500]}...")
            
            response.raise_for_status()
            
            return response.json()
    
    async def get_items(self, access_token: str, company_id: str) -> Dict[str, Any]:
        """品目マスタを取得"""
        headers = {
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/json"
        }
        
        params = {
            "company_id": company_id
        }
        
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.get(f"{self.base_url}/api/1/items", headers=headers, params=params)
            
            print(f"Items API response status: {response.status_code}")
            print(f"Items API response content: {response.text[:500]}...")
            
            response.raise_for_status()
            
            return response.json()
    
    async def get_account_items(self, access_token: str, company_id: str) -> Dict[str, Any]:
        """勘定科目マスタを取得"""
        headers = {
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/json"
        }
        
        params = {
            "company_id": company_id
        }
        
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.get(f"{self.base_url}/api/1/account_items", headers=headers, params=params)
            
            print(f"Account Items API response status: {response.status_code}")
            print(f"Account Items API response content: {response.text[:500]}...")
            
            response.raise_for_status()
            
            return response.json()
    
    def convert_deals_to_transaction(self, deals_data: Dict[str, Any]) -> List[Dict[str, Any]]:
        """freeeの取引データを既存のtransactionフォーマットに変換"""
        transactions = []
        
        for deal in deals_data.get("deals", []):
            for i, detail in enumerate(deal.get("details", [])):
                # より詳細な情報を抽出
                partner_info = ""
                if deal.get("partner_name"):
                    partner_info = deal["partner_name"]
                elif deal.get("partner"):
                    partner_info = deal["partner"].get("name", "")
                
                # 品名情報（品目のみ）
                item_info = ""
                if detail.get("item_name"):  # マスタから取得した品目名
                    item_info = detail["item_name"]
                elif detail.get("item") and detail["item"].get("name"):
                    item_info = detail["item"]["name"]
                elif detail.get("item_id") and detail.get("item_id") != "null":
                    item_info = f"品目ID:{detail['item_id']}"
                
                # 部門情報（部門のみ）
                department_info = ""
                if detail.get("section_name"):  # マスタから取得した部門名
                    department_info = detail["section_name"]
                elif detail.get("section") and detail["section"].get("name"):
                    department_info = detail["section"]["name"]
                
                # 備考情報
                memo_combined = deal.get("description", "")
                
                # 管理番号関連
                management_info = ""
                if deal.get("ref_number"):
                    management_info = deal["ref_number"]
                elif deal.get("receipt_id"):
                    management_info = f"Receipt:{deal['receipt_id']}"
                
                # 取引データを変換
                transaction = {
                    "id": f"freee_{deal['id']}_{i+1}",
                    "journal_number": deal["id"],
                    "journal_line_number": i + 1,
                    "date": deal.get("due_date") or deal["issue_date"],
                    "description": deal.get("description", "") or detail.get("description", ""),
                    "amount": abs(detail.get("amount", 0)),
                    "account": detail.get("account_item_name", f"科目ID:{detail.get('account_item_id', '')}"),
                    "supplier": partner_info,
                    "item": item_info,
                    "memo": memo_combined,
                    "remark": deal.get("ref_number", ""),
                    "department": department_info,
                    "management_number": management_info,
                    "raw_data": json.dumps(deal, ensure_ascii=False)
                }
                
                transactions.append(transaction)
        
        return transactions
    
    async def preview_journals(self, db: Session, start_date: str, end_date: str) -> Dict[str, Any]:
        """取引データをプレビュー（保存しない）"""
        # 有効なトークンを取得
        access_token = await self.get_valid_token(db)
        if not access_token:
            raise Exception("有効なアクセストークンがありません。再認証が必要です。")
        
        # 会社IDを取得
        token = db.query(FreeeToken).filter(FreeeToken.is_active == True).first()
        if not token or not token.company_id:
            raise Exception("会社情報が見つかりません。")
        
        # テスト用：取引データを取得
        try:
            # 仕訳データと取引データを両方取得
            journals_data, deals_data = await asyncio.gather(
                self.get_journals(
                    access_token, 
                    token.company_id, 
                    start_date, 
                    end_date, 
                    limit=10, 
                    offset=0
                ),
                self.get_deals(
                    access_token, 
                    token.company_id, 
                    start_date, 
                    end_date, 
                    limit=100, 
                    offset=0
                ),
                return_exceptions=True
            )
            
            # エラーチェック
            needs_reauth = False
            if isinstance(journals_data, Exception):
                print(f"仕訳データ取得エラー: {journals_data}")
                if "403" in str(journals_data) or "400" in str(journals_data):
                    needs_reauth = True
                journals_data = {"journals": []}
            if isinstance(deals_data, Exception):
                print(f"取引データ取得エラー: {deals_data}")
                if "403" in str(deals_data) or "401" in str(deals_data):
                    needs_reauth = True
                deals_data = {"deals": []}
            
            # 勘定科目、品目、部門マスタの取得を試行
            account_items_map = {}
            items_map = {}
            sections_map = {}
            
            try:
                account_items_data = await self.get_account_items(access_token, token.company_id)
                for item in account_items_data.get("account_items", []):
                    account_items_map[item["id"]] = item["name"]
                print("勘定科目マスタを正常に取得しました")
            except Exception as e:
                print(f"勘定科目マスタの取得に失敗しました（権限不足の可能性）: {str(e)}")
                if "403" in str(e) or "401" in str(e):
                    needs_reauth = True
            
            try:
                items_data = await self.get_items(access_token, token.company_id)
                for item in items_data.get("items", []):
                    items_map[item["id"]] = item["name"]
                print("品目マスタを正常に取得しました")
            except Exception as e:
                print(f"品目マスタの取得に失敗しました（権限不足の可能性）: {str(e)}")
                if "403" in str(e) or "401" in str(e):
                    needs_reauth = True
            
            try:
                sections_data = await self.get_sections(access_token, token.company_id)
                for section in sections_data.get("sections", []):
                    sections_map[section["id"]] = section["name"]
                print("部門マスタを正常に取得しました")
            except Exception as e:
                print(f"部門マスタの取得に失敗しました（権限不足の可能性）: {str(e)}")
                if "403" in str(e) or "401" in str(e):
                    needs_reauth = True
            
            # 取引データに勘定科目名、品目名、部門名を追加
            deals = deals_data.get("deals", [])
            if account_items_map or items_map or sections_map:
                for deal in deals:
                    if "details" in deal and isinstance(deal["details"], list):
                        for detail in deal["details"]:
                            if "account_item_id" in detail and account_items_map:
                                detail["account_item_name"] = account_items_map.get(detail["account_item_id"], "不明")
                            if "item_id" in detail and detail["item_id"] and items_map:
                                detail["item_name"] = items_map.get(detail["item_id"], "不明")
                            if "section_id" in detail and detail["section_id"] and sections_map:
                                detail["section_name"] = sections_map.get(detail["section_id"], "不明")
            
            # 取引データを既存システム形式に変換
            converted_transactions = self.convert_deals_to_transaction({"deals": deals})
            print(f"変換された取引データ数: {len(converted_transactions)}")
            if converted_transactions:
                print(f"最初の変換データ: {converted_transactions[0]}")
            
            # デバッグ用：全取引の詳細構造を確認
            if deals:
                for i, deal in enumerate(deals[:3]):  # 最初の3件
                    print(f"=== 取引 {i+1} ===")
                    print(f"取引全体: {deal}")
                    print(f"deal.description: {deal.get('description')}")
                    print(f"deal.memo: {deal.get('memo')}")
                    print(f"deal.ref_number: {deal.get('ref_number')}")
                    
                    if deal.get("details"):
                        for j, detail in enumerate(deal["details"]):
                            print(f"  明細 {j+1}: {detail}")
                            print(f"  detail.description: {detail.get('description')}")
                    
                    if deal.get("receipts"):
                        print(f"  レシート情報: {deal['receipts']}")
                    
                    if deal.get("payments"):
                        print(f"  支払い情報: {deal['payments']}")
                    print("---")
            
            # 仕訳データのデバッグログ
            print(f"仕訳データの内容: {journals_data}")
            print(f"仕訳データのCSV: {journals_data.get('csv_data')}")
            
            return {
                "journal_entries": deals,  # 元のFreee取引データ
                "journals_data": journals_data.get("journals", []),  # 仕訳データ
                "csv_data": journals_data.get("csv_data"),  # 仕訳帳CSV データ
                "converted_transactions": converted_transactions,  # 変換後のデータ
                "account_items": account_items_map,
                "needs_reauth": needs_reauth,  # 再認証が必要かどうか
                "raw_response": {
                    "deals": deals_data,
                    "journals": journals_data
                }
            }
            
        except Exception as e:
            print(f"Preview error: {str(e)}")
            raise e

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