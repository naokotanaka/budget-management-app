from sqlalchemy import create_engine, Column, Integer, String, Date, DateTime, ForeignKey, Text, Boolean
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session, relationship
from datetime import datetime
import os

# PostgreSQL database
DATABASE_USER = os.getenv("DATABASE_USER", "nagaiku_user")
DATABASE_PASSWORD = os.getenv("DATABASE_PASSWORD", "nagaiku_password2024")
DATABASE_HOST = os.getenv("DATABASE_HOST", "localhost")
DATABASE_PORT = os.getenv("DATABASE_PORT", "5432")
DATABASE_NAME = os.getenv("DATABASE_NAME", "nagaiku_budget")

SQLALCHEMY_DATABASE_URL = f"postgresql://{DATABASE_USER}:{DATABASE_PASSWORD}@{DATABASE_HOST}:{DATABASE_PORT}/{DATABASE_NAME}"

engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

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
    raw_data = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationship
    allocations = relationship("Allocation", back_populates="transaction")

class Grant(Base):
    __tablename__ = "grants"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
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

def create_tables():
    Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()