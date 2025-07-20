#!/bin/bash
echo "🔧 次回用：開発環境起動スクリプト"

# tmux新セッション作成
tmux new-session -d -s dev-env

# バックエンド
tmux send-keys -t dev-env 'cd /home/tanaka/nagaiku-budget/backend' Enter
tmux send-keys -t dev-env '. venv/bin/activate' Enter
tmux send-keys -t dev-env 'export ENVIRONMENT=development' Enter
tmux send-keys -t dev-env 'export PORT=8001' Enter  
tmux send-keys -t dev-env 'python3 main.py' Enter

# フロントエンド用ペイン作成
tmux split-window -t dev-env
tmux send-keys -t dev-env 'cd /home/tanaka/nagaiku-budget/frontend' Enter
tmux send-keys -t dev-env 'export NODE_ENV=development' Enter
tmux send-keys -t dev-env 'npm run dev -- -p 3001' Enter

# アタッチ
tmux attach -t dev-env
