#!/bin/bash

# tmux使用の開発環境起動スクリプト - 環境変数完全分離対応

echo "🔧 開発環境起動（tmux版）"
echo "================================"

# 既存セッション停止
tmux kill-session -t dev-env 2>/dev/null || true

# tmux新セッション作成
tmux new-session -d -s dev-env

# バックエンドペイン（環境変数を明示的に設定）
tmux send-keys -t dev-env 'cd /home/tanaka/nagaiku-budget/backend' Enter
tmux send-keys -t dev-env 'if [ -d "dev_venv" ]; then . dev_venv/bin/activate; elif [ -d "venv" ]; then . venv/bin/activate; fi' Enter
tmux send-keys -t dev-env 'export ENVIRONMENT=development' Enter
tmux send-keys -t dev-env 'export PORT=8001' Enter
tmux send-keys -t dev-env 'export NODE_ENV=development' Enter
tmux send-keys -t dev-env 'export FRONTEND_URL=http://160.251.170.97:3001' Enter
tmux send-keys -t dev-env 'echo "🚀 バックエンド起動中（ポート8001）..."' Enter
tmux send-keys -t dev-env 'python main_dev_8001.py' Enter

# フロントエンドペイン作成
tmux split-window -t dev-env
tmux send-keys -t dev-env 'cd /home/tanaka/nagaiku-budget/frontend' Enter
tmux send-keys -t dev-env 'export NODE_ENV=development' Enter
tmux send-keys -t dev-env 'export NEXT_PUBLIC_API_URL=http://160.251.170.97:8001' Enter
tmux send-keys -t dev-env 'echo "🌐 フロントエンド起動中（ポート3001）..."' Enter
tmux send-keys -t dev-env 'npm run dev -- -H 0.0.0.0 -p 3001' Enter

echo ""
echo "📱 アクセスURL:"
echo "  フロントエンド: http://160.251.170.97:3001"
echo "  バックエンドAPI: http://160.251.170.97:8001/docs"
echo ""
echo "🔗 tmux操作:"
echo "  セッション確認: tmux list-sessions"
echo "  アタッチ: tmux attach -t dev-env"
echo "  デタッチ: Ctrl+B → D"
echo "  停止: ./stop_development.sh"
echo ""
echo "🔧 環境変数設定:"
echo "  NODE_ENV=development"
echo "  ENVIRONMENT=development"
echo "  PORT=8001"
echo "  FRONTEND_URL=http://160.251.170.97:3001"
echo "  NEXT_PUBLIC_API_URL=http://160.251.170.97:8001"
echo ""

# アタッチするか選択
read -p "tmuxセッションにアタッチしますか？ (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    tmux attach -t dev-env
else
    echo "バックグラウンドで実行中です"
    echo "アタッチするには: tmux attach -t dev-env"
fi 