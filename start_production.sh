#!/bin/bash

echo "======================================================"
echo "NPO予算管理システム - 本番環境起動スクリプト"
echo "======================================================"

# 環境変数読み込み
source .env.production

echo "既存のプロセスを確認中..."
# 既存のプロセスを停止
echo "既存のバックエンドプロセスを停止中..."
pkill -f "uvicorn.*main_dev:app.*--port 8000" || true
pkill -f "uvicorn.*main_dev:app.*--port 8001" || true
pkill -f "python.*main_dev.py" || true

echo "既存のフロントエンドプロセスを停止中..."
pkill -f "next.*3000" || true

sleep 2

echo "本番環境バックエンドを起動中 (ポート8000)..."
cd backend
export API_PORT=8000
nohup python3 main_dev.py > ../logs/backend_prod.log 2>&1 &
BACKEND_PID=$!
cd ..

echo "本番環境フロントエンドを起動中 (ポート3000)..."
cd frontend
nohup npm run dev -- -H 0.0.0.0 -p 3000 > ../logs/frontend_prod.log 2>&1 &
FRONTEND_PID=$!
cd ..

sleep 5

echo "======================================================"
echo "本番環境起動完了"
echo "バックエンド: http://160.251.170.97:8000 (PID: $BACKEND_PID)"
echo "フロントエンド: http://160.251.170.97:3000 (PID: $FRONTEND_PID)"
echo "======================================================"

# プロセス確認
echo "起動中のプロセス:"
pgrep -fl "python.*main_dev\|next.*3000"