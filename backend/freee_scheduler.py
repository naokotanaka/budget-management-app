#!/usr/bin/env python3
"""
freee自動読み込みスケジューラー
定期的にfreee APIから仕訳データを取得して同期する
"""
import asyncio
import os
import schedule
import time
from datetime import datetime, timedelta
from sqlalchemy.orm import Session
from database_dev import SessionLocal, FreeeToken
from freee_service import FreeeService
import logging

# ログ設定
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('freee_scheduler.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

class FreeeScheduler:
    def __init__(self):
        self.freee_service = FreeeService()
        self.is_running = False
        
    def check_freee_connection(self) -> bool:
        """freee接続状況を確認"""
        db = SessionLocal()
        try:
            token = db.query(FreeeToken).filter(FreeeToken.is_active == True).first()
            if not token:
                logger.warning("freee認証トークンが見つかりません")
                return False
            
            # トークンの有効期限をチェック
            if token.expires_at <= datetime.utcnow():
                logger.warning("freee認証トークンの有効期限が切れています")
                return False
            
            return True
        except Exception as e:
            logger.error(f"freee接続確認中にエラー: {e}")
            return False
        finally:
            db.close()
    
    async def sync_journals_task(self):
        """仕訳データ同期タスク"""
        if self.is_running:
            logger.info("既に同期処理が実行中です。スキップします。")
            return
        
        self.is_running = True
        try:
            logger.info("freee仕訳データの自動同期を開始します")
            
            # 接続チェック
            if not self.check_freee_connection():
                logger.error("freee接続が無効です。同期をスキップします。")
                return
            
            # 同期期間を設定（過去1週間）
            end_date = datetime.now().date()
            start_date = end_date - timedelta(days=7)
            
            # 同期実行
            db = SessionLocal()
            try:
                result = await self.freee_service.sync_journals(
                    db, 
                    start_date.strftime("%Y-%m-%d"),
                    end_date.strftime("%Y-%m-%d")
                )
                
                logger.info(f"同期完了: {result}")
                
            except Exception as e:
                logger.error(f"同期処理中にエラー: {e}")
            finally:
                db.close()
                
        except Exception as e:
            logger.error(f"同期タスク実行中にエラー: {e}")
        finally:
            self.is_running = False
    
    def run_sync_job(self):
        """同期ジョブを実行（同期関数用ラッパー）"""
        asyncio.run(self.sync_journals_task())
    
    def setup_schedule(self):
        """スケジュールを設定"""
        # 毎日朝9時に実行
        schedule.every().day.at("09:00").do(self.run_sync_job)
        
        # 毎日夕方5時に実行
        schedule.every().day.at("17:00").do(self.run_sync_job)
        
        # 開発環境では10分ごとに実行（テスト用）
        if os.getenv('NODE_ENV') == 'development':
            schedule.every(10).minutes.do(self.run_sync_job)
        
        logger.info("freee自動同期スケジュールを設定しました")
        logger.info("- 毎日 9:00")
        logger.info("- 毎日 17:00")
        if os.getenv('NODE_ENV') == 'development':
            logger.info("- 開発環境: 10分ごと")
    
    def start(self):
        """スケジューラーを開始"""
        self.setup_schedule()
        logger.info("freee自動同期スケジューラーを開始しました")
        
        while True:
            try:
                schedule.run_pending()
                time.sleep(60)  # 1分ごとにスケジュールをチェック
            except KeyboardInterrupt:
                logger.info("スケジューラーを停止します")
                break
            except Exception as e:
                logger.error(f"スケジューラー実行中にエラー: {e}")
                time.sleep(60)

def main():
    """メイン関数"""
    scheduler = FreeeScheduler()
    
    # 開発環境の場合は即座に1回実行
    if os.getenv('NODE_ENV') == 'development':
        logger.info("開発環境: 初回同期を実行します")
        scheduler.run_sync_job()
    
    # スケジューラーを開始
    scheduler.start()

if __name__ == "__main__":
    main()