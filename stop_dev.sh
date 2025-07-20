#!/bin/bash
echo "🛑 開発環境を停止しています..."

# tmuxセッション停止
echo "📊 tmuxセッション停止中..."
tmux list-sessions 2>/dev/null
tmux kill-session -t dev-env 2>/dev/null
tmux kill-session -t dev 2>/dev/null

# 念のためポートベースでも停止
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
sleep 2
echo "📊 停止確認:"
if ! ss -tlnp | grep -E "(3001|8001)" >/dev/null 2>&1; then
    echo "✅ 開発環境が完全に停止しました"
else
    echo "⚠️ 一部のプロセスが残っている可能性があります:"
    ss -tlnp | grep -E "(3001|8001)"
fi
