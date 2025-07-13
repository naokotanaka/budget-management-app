#!/bin/bash
# 開発環境起動スクリプト

set -e

PROJECT_ROOT="/home/tanaka/nagaiku-budget"
BACKEND_DIR="$PROJECT_ROOT/backend"
FRONTEND_DIR="$PROJECT_ROOT/frontend"

echo "======================================================"
echo "NPO予算管理システム - 開発環境起動スクリプト"
echo "======================================================"

# 環境変数を設定
export DATABASE_NAME_DEV="nagaiku_budget_dev"
export NODE_ENV="development"

# 既存のプロセスを確認・停止
echo "既存のプロセスを確認中..."
if pgrep -f "python main_dev.py" > /dev/null; then
    echo "既存のバックエンドプロセスを停止中..."
    pkill -f "python main_dev.py"
    sleep 2
fi

if pgrep -f "next dev.*3001" > /dev/null; then
    echo "既存のフロントエンドプロセス（ポート3001）を停止中..."
    pkill -f "next dev.*3001"
    sleep 2
fi

# バックエンドを起動
echo "バックエンドを起動中..."
cd "$BACKEND_DIR"
source dev_venv/bin/activate
nohup python main_dev.py > dev_backend.log 2>&1 &
BACKEND_PID=$!

echo "バックエンドPID: $BACKEND_PID"
echo "バックエンドログ: $BACKEND_DIR/dev_backend.log"

# フロントエンドを起動
echo "フロントエンドを起動中..."
cd "$FRONTEND_DIR"
nohup npm run dev -- -H 0.0.0.0 -p 3001 > dev_frontend.log 2>&1 &
FRONTEND_PID=$!

echo "フロントエンドPID: $FRONTEND_PID"
echo "フロントエンドログ: $FRONTEND_DIR/dev_frontend.log"

# 起動確認
echo "起動確認中..."
sleep 5

# バックエンドの起動確認
if curl -s http://localhost:8001/health > /dev/null; then
    echo "✓ バックエンドが正常に起動しました (ポート8001)"
else
    echo "⚠ バックエンドの起動に問題があります"
fi

# フロントエンドの起動確認
if curl -s http://localhost:3001 > /dev/null; then
    echo "✓ フロントエンドが正常に起動しました (ポート3001)"
else
    echo "⚠ フロントエンドの起動に問題があります"
fi

echo ""
echo "======================================================"
echo "開発環境が起動しました！"
echo "======================================================"
echo "フロントエンド: http://160.251.170.97:3001"
echo "バックエンドAPI: http://160.251.170.97:8001"
echo "データベース: nagaiku_budget_dev"
echo ""
echo "停止するには: ./stop_dev.sh"
echo "ログを確認するには:"
echo "  tail -f $BACKEND_DIR/dev_backend.log"
echo "  tail -f $FRONTEND_DIR/dev_frontend.log"
echo "======================================================"