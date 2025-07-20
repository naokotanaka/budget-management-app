#!/bin/bash

# NPO予算管理システム - 停止スクリプト

echo "🛑 NPO予算管理システムを停止します..."

# ログディレクトリの確認
if [ ! -d "logs" ]; then
    echo "❌ ログディレクトリが見つかりません。システムが起動していない可能性があります。"
    exit 1
fi

# バックエンドの停止
if [ -f "logs/backend.pid" ]; then
    BACKEND_PID=$(cat logs/backend.pid)
    if ps -p $BACKEND_PID > /dev/null; then
        echo "📊 バックエンド（PID: $BACKEND_PID）を停止中..."
        kill $BACKEND_PID
        sleep 2
        
        # 強制終了が必要な場合
        if ps -p $BACKEND_PID > /dev/null; then
            echo "🔨 バックエンドを強制停止中..."
            kill -9 $BACKEND_PID
        fi
        echo "✅ バックエンド停止完了"
    else
        echo "⚠️  バックエンドは既に停止しています"
    fi
    rm -f logs/backend.pid
else
    echo "⚠️  バックエンドのPIDファイルが見つかりません"
fi

# フロントエンドの停止
if [ -f "logs/frontend.pid" ]; then
    FRONTEND_PID=$(cat logs/frontend.pid)
    if ps -p $FRONTEND_PID > /dev/null; then
        echo "🌐 フロントエンド（PID: $FRONTEND_PID）を停止中..."
        kill $FRONTEND_PID
        sleep 2
        
        # 強制終了が必要な場合
        if ps -p $FRONTEND_PID > /dev/null; then
            echo "🔨 フロントエンドを強制停止中..."
            kill -9 $FRONTEND_PID
        fi
        echo "✅ フロントエンド停止完了"
    else
        echo "⚠️  フロントエンドは既に停止しています"
    fi
    rm -f logs/frontend.pid
else
    echo "⚠️  フロントエンドのPIDファイルが見つかりません"
fi

# 追加でポートを使用しているプロセスを確認・停止
echo "🔍 ポート使用状況を確認中..."

# ポート8000を使用しているプロセスを停止
BACKEND_PORT_PID=$(lsof -ti:8000 2>/dev/null)
if [ ! -z "$BACKEND_PORT_PID" ]; then
    echo "🔧 ポート8000を使用しているプロセス（PID: $BACKEND_PORT_PID）を停止中..."
    kill $BACKEND_PORT_PID 2>/dev/null
fi

# ポート3000を使用しているプロセスを停止
FRONTEND_PORT_PID=$(lsof -ti:3000 2>/dev/null)
if [ ! -z "$FRONTEND_PORT_PID" ]; then
    echo "🔧 ポート3000を使用しているプロセス（PID: $FRONTEND_PORT_PID）を停止中..."
    kill $FRONTEND_PORT_PID 2>/dev/null
fi

echo ""
echo "✅ NPO予算管理システムが完全に停止しました"
echo ""
echo "📝 再起動方法:"
echo "  ./start.sh を実行してください"
echo ""