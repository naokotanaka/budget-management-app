from typing import Optional, Dict, Any
import httpx

class FreeeReceiptsService:
    def __init__(self, base_url: str = "https://api.freee.co.jp"):
        self.base_url = base_url
    
    async def get_receipts(self, access_token: str, company_id: str, deal_id: Optional[str] = None) -> Dict[str, Any]:
        """ファイルボックス（証憑ファイル）を取得"""
        from datetime import datetime, timedelta
        
        headers = {
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/json"
        }
        
        # 日付範囲を設定（過去1年間）
        end_date = datetime.now()
        start_date = end_date - timedelta(days=365)
        
        params = {
            "company_id": company_id,
            "start_date": start_date.strftime("%Y-%m-%d"),
            "end_date": end_date.strftime("%Y-%m-%d"),
            "limit": 100  # 最大取得件数
        }
        
        async with httpx.AsyncClient(timeout=30.0) as client:
            try:
                response = await client.get(f"{self.base_url}/api/1/receipts", headers=headers, params=params)
                
                print(f"Receipts API response status: {response.status_code}")
                print(f"Request URL: {response.url}")
                print(f"Request params: {params}")
                
                if response.status_code == 200:
                    data = response.json()
                    all_receipts = data.get('receipts', [])
                    print(f"Response data keys: {data.keys()}")
                    print(f"取得した全ファイル数: {len(all_receipts)}")
                    
                    # 最初の数件のreceipt構造を確認
                    if all_receipts:
                        print(f"最初のファイル構造: {all_receipts[0]}")
                        if len(all_receipts) > 1:
                            print(f"2番目のファイル構造: {all_receipts[1]}")
                    
                    # 特定の取引に紐づくファイルをフィルタリング
                    if deal_id:
                        filtered_receipts = []
                        for receipt in all_receipts:
                            # receiptsにdeal_idが含まれているかチェック
                            receipt_deal_id = receipt.get('deal_id')
                            print(f"ファイルID {receipt.get('id')}: deal_id={receipt_deal_id}, 探している deal_id={deal_id}")
                            if receipt_deal_id == int(deal_id):
                                filtered_receipts.append(receipt)
                        
                        print(f"取引ID {deal_id} に紐づくファイル数: {len(filtered_receipts)}")
                        return {"receipts": filtered_receipts}
                    else:
                        return data
                else:
                    print(f"Receipts API error: {response.status_code} - {response.text}")
                    return {"receipts": []}
                    
            except Exception as e:
                print(f"ファイルボックス取得エラー: {e}")
                return {"receipts": []}
    
    async def get_receipt_detail(self, access_token: str, company_id: str, receipt_id: str) -> Dict[str, Any]:
        """ファイルボックス（証憑ファイル）の詳細を取得"""
        headers = {
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/json"
        }
        
        params = {
            "company_id": company_id
        }
        
        async with httpx.AsyncClient(timeout=30.0) as client:
            try:
                response = await client.get(f"{self.base_url}/api/1/receipts/{receipt_id}", headers=headers, params=params)
                
                print(f"Receipt detail API response status: {response.status_code}")
                
                if response.status_code == 200:
                    return response.json()
                else:
                    print(f"Receipt detail API error: {response.text}")
                    return {}
                    
            except Exception as e:
                print(f"ファイル詳細取得エラー: {e}")
                return {}