from pydantic import BaseModel
from datetime import date, datetime
from typing import Optional, List

class TransactionBase(BaseModel):
    journal_number: int
    journal_line_number: int
    date: date
    description: Optional[str] = None
    amount: int
    account: Optional[str] = None
    supplier: Optional[str] = None
    item: Optional[str] = None
    memo: Optional[str] = None
    remark: Optional[str] = None
    department: Optional[str] = None
    management_number: Optional[str] = None

class TransactionCreate(TransactionBase):
    id: str

class Transaction(TransactionBase):
    id: str
    created_at: datetime
    
    class Config:
        from_attributes = True

class GrantBase(BaseModel):
    name: str
    grant_code: Optional[str] = None
    total_amount: Optional[int] = None
    start_date: Optional[date] = None
    end_date: Optional[date] = None
    status: Optional[str] = 'active'

class GrantCreate(GrantBase):
    pass

class Grant(GrantBase):
    id: int
    
    class Config:
        from_attributes = True

class BudgetItemBase(BaseModel):
    name: str
    category: Optional[str] = None
    budgeted_amount: Optional[int] = None
    remarks: Optional[str] = None

class BudgetItemCreate(BudgetItemBase):
    grant_id: int

class BudgetItem(BudgetItemBase):
    id: int
    grant_id: int
    
    class Config:
        from_attributes = True

class BudgetItemWithGrant(BudgetItemBase):
    id: int
    grant_id: int
    grant_name: str
    display_name: str  # "助成金名-予算項目名" の形式
    
    class Config:
        from_attributes = True

class AllocationBase(BaseModel):
    transaction_id: str
    budget_item_id: int
    amount: int

class AllocationCreate(AllocationBase):
    pass

class Allocation(AllocationBase):
    id: int
    created_at: datetime
    
    class Config:
        from_attributes = True

class TransactionWithAllocation(Transaction):
    budget_item: Optional[BudgetItemWithGrant] = None
    allocated_amount: Optional[int] = None

class ImportResponse(BaseModel):
    message: str
    total_checked: int
    imported_count: int
    updated_count: int
    created_count: int

class PreviewResponse(BaseModel):
    total_rows: int
    filtered_rows: int
    preview: List[dict]

# Freee関連のスキーマ
class FreeeTokenBase(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "Bearer"
    expires_at: datetime
    scope: Optional[str] = None
    company_id: Optional[str] = None

class FreeeTokenCreate(FreeeTokenBase):
    pass

class FreeeToken(FreeeTokenBase):
    id: int
    created_at: datetime
    updated_at: datetime
    is_active: bool
    
    class Config:
        from_attributes = True

class FreeeSyncBase(BaseModel):
    sync_type: str
    start_date: Optional[date] = None
    end_date: Optional[date] = None
    status: str = 'pending'
    total_records: int = 0
    processed_records: int = 0
    created_records: int = 0
    updated_records: int = 0
    error_message: Optional[str] = None

class FreeeSyncCreate(FreeeSyncBase):
    pass

class FreeeSync(FreeeSyncBase):
    id: int
    created_at: datetime
    completed_at: Optional[datetime] = None
    
    class Config:
        from_attributes = True

class FreeeAuthResponse(BaseModel):
    auth_url: str
    state: str

class FreeeTokenResponse(BaseModel):
    message: str
    company_id: Optional[str] = None
    expires_at: datetime

class FreeeSyncResponse(BaseModel):
    message: str
    sync_id: int
    status: str

class CategoryBase(BaseModel):
    name: str
    description: Optional[str] = None

class CategoryCreate(CategoryBase):
    pass

class Category(CategoryBase):
    id: int
    created_at: datetime
    updated_at: datetime
    is_active: bool
    
    class Config:
        from_attributes = True