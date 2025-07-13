#!/bin/bash
echo "🛑 開発環境を停止しています..."
echo "現在のセッション:"
tmux list-sessions 2>/dev/null
tmux kill-session -t dev-env 2>/dev/null
tmux kill-session -t dev 2>/dev/null
echo "✅ 開発環境停止完了!"
