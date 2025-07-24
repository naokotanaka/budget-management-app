import httpx
from typing import Dict, Any

class FreeDealService:
    def __init__(self, base_url: str = "https://api.freee.co.jp"):
        self.base_url = base_url
    
    async def get_deal_detail(self, access_token: str, company_id: str, deal_id: str) -> Dict[str, Any]:
        """取引詳細を取得（receipts配列を含む）"""
        headers = {
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/json"
        }
        
        params = {
            "company_id": company_id
        }
        
        async with httpx.AsyncClient(timeout=30.0) as client:
            try:
                response = await client.get(f"{self.base_url}/api/1/deals/{deal_id}", headers=headers, params=params)
                
                print(f"Deal detail API response status: {response.status_code}")
                
                if response.status_code == 200:
                    data = response.json()
                    print(f"Deal detail data keys: {data.keys()}")
                    if 'receipts' in data:
                        print(f"Receipts found: {len(data['receipts'])}")
                    else:
                        print("No receipts key found in deal data")
                    return data
                else:
                    print(f"Deal detail API error: {response.status_code} - {response.text}")
                    return {}
                    
            except Exception as e:
                print(f"取引詳細取得エラー: {e}")
                return {}