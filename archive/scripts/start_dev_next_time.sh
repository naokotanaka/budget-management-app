#!/bin/bash
echo "🔧 開発環境起動（環境変数直接設定版）"

# tmux新セッション作成
tmux new-session -d -s dev-env

# バックエンド起動（環境変数を明示的に設定）
tmux send-keys -t dev-env 'cd /home/tanaka/nagaiku-budget/backend' Enter
tmux send-keys -t dev-env '. dev_venv/bin/activate' Enter
tmux send-keys -t dev-env 'export PORT=8001' Enter
tmux send-keys -t dev-env 'export FRONTEND_URL=http://160.251.170.97:3001' Enter
tmux send-keys -t dev-env 'export NODE_ENV=development' Enter
tmux send-keys -t dev-env 'export ENVIRONMENT=development' Enter
tmux send-keys -t dev-env 'python main_dev_8001.py' Enter

# フロントエンド用ペイン作成
tmux split-window -t dev-env
tmux send-keys -t dev-env 'cd /home/tanaka/nagaiku-budget/frontend' Enter
tmux send-keys -t dev-env 'export NODE_ENV=development' Enter
tmux send-keys -t dev-env 'export NEXT_PUBLIC_API_URL=http://160.251.170.97:8001' Enter
tmux send-keys -t dev-env 'npm run dev -- -H 0.0.0.0 -p 3001' Enter

echo ""
echo "🎉 開発環境をtmuxで起動しました！"
echo "📱 アクセス方法:"
echo "  フロントエンド: http://160.251.170.97:3001"
echo "  バックエンドAPI: http://160.251.170.97:8001"
echo ""
echo "🔧 tmux操作:"
echo "  ペイン切り替え: Ctrl+b → o"
echo "  セッション終了: Ctrl+b → d (デタッチ)"
echo "  再アタッチ: tmux attach -t dev-env"
echo ""

# アタッチ
tmux attach -t dev-env
