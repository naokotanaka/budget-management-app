#!/bin/bash

# 開発環境起動スクリプト - 環境変数完全分離対応

echo "🚀 開発環境を起動します..."
echo "フロントエンド: ポート3001"
echo "バックエンド: ポート8001"

# ログディレクトリを作成
mkdir -p logs

# 開発環境用環境変数設定
export NODE_ENV=development
export ENVIRONMENT=development
export NEXT_PUBLIC_API_URL=http://160.251.170.97:8001
export FRONTEND_URL=http://160.251.170.97:3001

# バックエンドの起動（開発環境）
echo "📊 バックエンド（開発環境）を起動中..."
cd backend

# 仮想環境をアクティベート
if [ -d "venv" ]; then
    source venv/bin/activate
else
    echo "❌ 仮想環境が見つかりません。setup.shを実行してください。"
    exit 1
fi

# バックエンド用環境変数設定
export PORT=8001

# 開発環境専用ファイルでバックエンドをバックグラウンドで起動
nohup python3 main_dev_8001.py > ../logs/backend_dev.log 2>&1 &
BACKEND_PID=$!
echo "✅ バックエンド起動完了 (PID: $BACKEND_PID, Port: 8001)"

# フロントエンドの起動（開発環境）
echo "🌐 フロントエンド（開発環境）を起動中..."
cd ../frontend

# フロントエンド用環境変数設定
export PORT=3001

# フロントエンドをバックグラウンドで起動（外部アクセス対応）
nohup npm run dev -- -H 0.0.0.0 -p 3001 > ../logs/frontend_dev.log 2>&1 &
FRONTEND_PID=$!
echo "✅ フロントエンド起動完了 (PID: $FRONTEND_PID, Port: 3001)"

# PIDをファイルに保存
cd ..
echo $BACKEND_PID > logs/backend_dev.pid
echo $FRONTEND_PID > logs/frontend_dev.pid

echo ""
echo "🎉 開発環境が起動しました！"
echo ""
echo "📱 アクセス方法:"
echo "  フロントエンド: http://160.251.170.97:3001"
echo "  バックエンドAPI: http://160.251.170.97:8001"
echo "  API仕様書: http://160.251.170.97:8001/docs"
echo ""
echo "📝 ログファイル:"
echo "  バックエンド: logs/backend_dev.log"
echo "  フロントエンド: logs/frontend_dev.log"
echo ""
echo "🔧 環境変数設定:"
echo "  NODE_ENV: $NODE_ENV"
echo "  ENVIRONMENT: $ENVIRONMENT"
echo "  NEXT_PUBLIC_API_URL: $NEXT_PUBLIC_API_URL"
echo "  FRONTEND_URL: $FRONTEND_URL"
echo "  BACKEND_PORT: 8001"
echo "  FRONTEND_PORT: 3001"
echo ""
echo "🛑 停止方法:"
echo "  ./stop_development.sh を実行してください" 