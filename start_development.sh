#!/bin/bash

# 開発環境起動スクリプト

echo "🚀 開発環境を起動します..."
echo "フロントエンド: ポート3001"
echo "バックエンド: ポート8001"

# ログディレクトリを作成
mkdir -p logs

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

# 開発環境用の設定
export PORT=8001
export NODE_ENV=development
export ENVIRONMENT=development

# バックエンドをバックグラウンドで起動
nohup python3 main.py > ../logs/backend_dev.log 2>&1 &
BACKEND_PID=$!
echo "✅ バックエンド起動完了 (PID: $BACKEND_PID, Port: 8001)"

# フロントエンドの起動（開発環境）
echo "🌐 フロントエンド（開発環境）を起動中..."
cd ../frontend

# フロントエンドをバックグラウンドで起動
nohup npm run dev > ../logs/frontend_dev.log 2>&1 &
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
echo "🛑 停止方法:"
echo "  ./stop_development.sh を実行してください" 