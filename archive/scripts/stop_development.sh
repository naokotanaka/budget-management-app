#!/bin/bash

# 開発環境停止スクリプト

echo "🛑 開発環境を停止します..."

# PIDファイルからプロセスを停止
if [ -f "logs/backend_dev.pid" ]; then
    BACKEND_PID=$(cat logs/backend_dev.pid)
    if kill -0 "$BACKEND_PID" 2>/dev/null; then
        echo "📊 バックエンド (PID: $BACKEND_PID) を停止中..."
        kill "$BACKEND_PID"
    fi
    rm -f logs/backend_dev.pid
fi

if [ -f "logs/frontend_dev.pid" ]; then
    FRONTEND_PID=$(cat logs/frontend_dev.pid)
    if kill -0 "$FRONTEND_PID" 2>/dev/null; then
        echo "🌐 フロントエンド (PID: $FRONTEND_PID) を停止中..."
        kill "$FRONTEND_PID"
    fi
    rm -f logs/frontend_dev.pid
fi

# ポートベースでの停止確認
echo "🔧 ポートベースでの停止確認..."
if lsof -ti:8001 >/dev/null 2>&1; then
    echo "ポート8001のプロセスを停止中..."
    kill $(lsof -ti:8001) 2>/dev/null
fi

if lsof -ti:3001 >/dev/null 2>&1; then
    echo "ポート3001のプロセスを停止中..."
    kill $(lsof -ti:3001) 2>/dev/null
fi

# 停止確認
sleep 3
echo ""
echo "📊 停止確認:"
if ! ss -tlnp | grep -E "(3001|8001)" >/dev/null 2>&1; then
    echo "✅ 開発環境が完全に停止しました"
else
    echo "⚠️ 一部のプロセスが残っている可能性があります:"
    ss -tlnp | grep -E "(3001|8001)"
fi

echo ""
echo "🏁 開発環境停止完了" 