#!/bin/bash

# Backend development restart script - 環境変数完全分離対応
LOG_FILE="$HOME/nagaiku-budget/logs/backend_dev_restart.log"
BACKEND_DIR="$HOME/nagaiku-budget/backend"

# 開発環境用環境変数設定
export NODE_ENV=development
export ENVIRONMENT=development
export PORT=8001
export FRONTEND_URL=http://160.251.170.97:3001

echo "🚀 開発環境バックエンド自動再起動スクリプト開始" >> $LOG_FILE
echo "設定: PORT=$PORT, ENVIRONMENT=$ENVIRONMENT, FRONTEND_URL=$FRONTEND_URL" >> $LOG_FILE

while true; do
    echo "$(date): Starting backend development server..." >> $LOG_FILE
    
    cd $BACKEND_DIR
    
    # 仮想環境をアクティベート
    if [ -d "venv" ]; then
        source venv/bin/activate
    else
        echo "$(date): ERROR - 仮想環境が見つかりません" >> $LOG_FILE
        exit 1
    fi
    
    # Start with development-specific main file
    python3 main_dev_8001.py >> $LOG_FILE 2>&1
    
    echo "$(date): Backend development server stopped. Restarting in 5 seconds..." >> $LOG_FILE
    sleep 5
done
