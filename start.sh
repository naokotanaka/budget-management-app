#!/bin/bash

# NPO予算管理システム - 起動スクリプト

echo "🚀 NPO予算管理システムを起動します..."

# バックエンドの起動
echo "📊 バックエンド（FastAPI）を起動中..."
cd backend

# 仮想環境があるかチェック
if [ ! -d "venv" ]; then
    echo "📦 Python仮想環境を作成中..."
    python3 -m venv venv
fi

# 仮想環境をアクティベート
source venv/bin/activate

# 依存関係をインストール
echo "📦 Python依存関係をインストール中..."
pip install -r requirements.txt

# データベースディレクトリを作成
mkdir -p ../data

# バックエンドをバックグラウンドで起動
echo "🔧 FastAPIサーバーを起動中..."
nohup uvicorn main:app --reload --host 0.0.0.0 --port 8000 > ../logs/backend.log 2>&1 &
BACKEND_PID=$!
echo "✅ バックエンド起動完了 (PID: $BACKEND_PID)"

# フロントエンドの起動
echo "🌐 フロントエンド（Next.js）を起動中..."
cd ../frontend

# 依存関係をインストール
echo "📦 Node.js依存関係をインストール中..."
npm install

# フロントエンドをバックグラウンドで起動
echo "🔧 Next.jsサーバーを起動中..."
mkdir -p ../logs
nohup npm run dev > ../logs/frontend.log 2>&1 &
FRONTEND_PID=$!
echo "✅ フロントエンド起動完了 (PID: $FRONTEND_PID)"

# PIDをファイルに保存
cd ..
echo $BACKEND_PID > logs/backend.pid
echo $FRONTEND_PID > logs/frontend.pid

echo ""
echo "🎉 NPO予算管理システムが起動しました！"
echo ""
echo "📱 アクセス方法:"
echo "  フロントエンド: http://localhost:3000"
echo "  バックエンドAPI: http://localhost:8000"
echo "  API仕様書: http://localhost:8000/docs"
echo ""
echo "📝 ログファイル:"
echo "  バックエンド: logs/backend.log"
echo "  フロントエンド: logs/frontend.log"
echo ""
echo "🛑 停止方法:"
echo "  ./stop.sh を実行してください"
echo ""