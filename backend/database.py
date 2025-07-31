from sqlalchemy import create_engine, Column, Integer, String, Date, DateTime, ForeignKey, Text, Boolean, BigInteger
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session, relationship
from datetime import datetime
import os

# PostgreSQL database
# グローバル変数を定義
engine = None
SessionLocal = None
Base = declarative_base()

def get_database_url():
    """データベースURLを取得する関数"""
    # 環境変数DATABASE_URLが設定されている場合はそれを優先、そうでなければ個別の環境変数から構築
    DATABASE_URL = os.getenv("DATABASE_URL")

    if DATABASE_URL:
        SQLALCHEMY_DATABASE_URL = DATABASE_URL
    else:
        # フォールバック: 個別の環境変数から構築
        DATABASE_USER = os.getenv("DATABASE_USER", "nagaiku_user")
        DATABASE_PASSWORD = os.getenv("DATABASE_PASSWORD", "nagaiku_password2024")
        DATABASE_HOST = os.getenv("DATABASE_HOST", "localhost")
        DATABASE_PORT = os.getenv("DATABASE_PORT", "5432")

        # 統一環境（データベース名のみ環境変数で制御）
        DATABASE_NAME = os.getenv("DATABASE_NAME", "nagaiku_budget")
        print(f"🏭 データベース: {DATABASE_NAME} を使用")
        SQLALCHEMY_DATABASE_URL = f"postgresql://{DATABASE_USER}:{DATABASE_PASSWORD}@{DATABASE_HOST}:{DATABASE_PORT}/{DATABASE_NAME}"

    # デバッグ情報を表示
    env = os.getenv("ENVIRONMENT", "development")
    port = os.getenv("PORT", "8001")
    print(f"🔧 環境設定: ENVIRONMENT={env}, PORT={port}")
    print(f"🔗 データベース接続先: {SQLALCHEMY_DATABASE_URL}")
    if "budget_dev" in SQLALCHEMY_DATABASE_URL:
        print("📝 開発環境データベース (nagaiku_budget_dev) を使用")
    else:
        print("🏭 本番環境データベース (nagaiku_budget) を使用")
    
    return SQLALCHEMY_DATABASE_URL

def init_database():
    """データベースエンジンとセッションを初期化する関数"""
    global engine, SessionLocal
    
    if engine is None:
        database_url = get_database_url()
        engine = create_engine(database_url)
        SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    
    return engine, SessionLocal

def get_engine():
    """エンジンを取得（必要に応じて初期化）"""
    engine, _ = init_database()
    return engine

def get_session_local():
    """SessionLocalを取得（必要に応じて初期化）"""
    _, session_local = init_database()
    return session_local

class Transaction(Base):
    __tablename__ = "transactions"
    
    id = Column(String, primary_key=True, index=True)
    journal_number = Column(Integer, index=True)
    journal_line_number = Column(Integer)
    date = Column(Date, nullable=False, index=True)
    description = Column(Text)
    amount = Column(Integer, nullable=False)
    account = Column(String, index=True)
    supplier = Column(String)
    item = Column(String)
    memo = Column(String)
    remark = Column(String)
    department = Column(String)
    management_number = Column(String)
    freee_deal_id = Column(BigInteger)  # Freee取引ID
    raw_data = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationship
    allocations = relationship("Allocation", back_populates="transaction")

class Grant(Base):
    __tablename__ = "grants"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    grant_code = Column(String, nullable=True)  # 助成金コード
    total_amount = Column(Integer)
    start_date = Column(Date)
    end_date = Column(Date)
    status = Column(String, default='active')  # active, completed, applied
    
    # Relationship
    budget_items = relationship("BudgetItem", back_populates="grant")

class BudgetItem(Base):
    __tablename__ = "budget_items"
    
    id = Column(Integer, primary_key=True, index=True)
    grant_id = Column(Integer, ForeignKey("grants.id"))
    name = Column(String, nullable=False)
    category = Column(String)
    budgeted_amount = Column(Integer)
    remarks = Column(String, nullable=True)  # 備考
    planned_start_date = Column(Date, nullable=True)  # 予定使用開始日
    planned_end_date = Column(Date, nullable=True)    # 予定使用終了日
    
    # Relationships
    grant = relationship("Grant", back_populates="budget_items")
    allocations = relationship("Allocation", back_populates="budget_item")

class Allocation(Base):
    __tablename__ = "allocations"
    
    id = Column(Integer, primary_key=True, index=True)
    transaction_id = Column(String, ForeignKey("transactions.id"))
    budget_item_id = Column(Integer, ForeignKey("budget_items.id"))
    amount = Column(Integer, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationships
    transaction = relationship("Transaction", back_populates="allocations")
    budget_item = relationship("BudgetItem", back_populates="allocations")

class FreeeToken(Base):
    __tablename__ = "freee_tokens"
    
    id = Column(Integer, primary_key=True, index=True)
    access_token = Column(Text, nullable=False)
    refresh_token = Column(Text, nullable=False)
    token_type = Column(String, default="Bearer")
    expires_at = Column(DateTime, nullable=False)
    scope = Column(String)
    company_id = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    is_active = Column(Boolean, default=True)

class Category(Base):
    __tablename__ = "categories"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False, unique=True)
    description = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    is_active = Column(Boolean, default=True)

class FreeeSync(Base):
    __tablename__ = "freee_syncs"
    
    id = Column(Integer, primary_key=True, index=True)
    sync_type = Column(String, nullable=False)  # 'journals', 'accounts', etc.
    start_date = Column(Date)
    end_date = Column(Date)
    status = Column(String, default='pending')  # pending, running, completed, failed
    total_records = Column(Integer, default=0)
    processed_records = Column(Integer, default=0)
    created_records = Column(Integer, default=0)
    updated_records = Column(Integer, default=0)
    error_message = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)
    completed_at = Column(DateTime)

class WamMapping(Base):
    __tablename__ = "wam_mappings"
    
    id = Column(Integer, primary_key=True, index=True)
    account_pattern = Column(String, nullable=False)  # 勘定科目のパターン（部分一致用）
    wam_category = Column(String, nullable=False)  # WAM科目
    priority = Column(Integer, default=100)  # 優先順位（小さいほど高優先）
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

def create_tables():
    Base.metadata.create_all(bind=get_engine())

def get_db():
    SessionLocal = get_session_local()
    db = SessionLocal()  # ここで実際のセッションを作成
    try:
        yield db
    finally:
        db.close()