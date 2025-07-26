#!/bin/bash

# 統一起動スクリプト
# 使用法: ./start.sh [production|development]
# デフォルトは development モード

MODE=${1:-development}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# カラー出力
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Starting nagaiku-budget in ${MODE} mode...${NC}"

# モードに応じた環境設定
if [ "$MODE" = "production" ]; then
    ENV_FILE=".env"
    USE_SYSTEMD=true
    echo -e "${YELLOW}Using production configuration${NC}"
else
    ENV_FILE=".env.development"
    USE_SYSTEMD=false
    echo -e "${YELLOW}Using development configuration${NC}"
    
    # 開発環境用のデータベースバックアップ（オプション）
    if [ ! -f ".env.development" ]; then
        echo -e "${YELLOW}Creating development environment file...${NC}"
        cp backend/.env backend/.env.development
        # データベース名を開発用に変更
        sed -i 's/DATABASE_NAME=nagaiku_budget/DATABASE_NAME=nagaiku_budget_dev/' backend/.env.development
    fi
    
    # 開発用データベースの存在確認
    if ! sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw nagaiku_budget_dev; then
        echo -e "${RED}Error: Development database 'nagaiku_budget_dev' does not exist!${NC}"
        echo -e "${YELLOW}Please create it manually with:${NC}"
        echo "  1. Create backup: sudo -u postgres pg_dump nagaiku_budget > backups/backup_\$(date +%Y%m%d_%H%M%S).sql"
        echo "  2. Create dev DB: sudo -u postgres createdb nagaiku_budget_dev"
        echo "  3. Import data: sudo -u postgres psql nagaiku_budget_dev < backups/backup_filename.sql"
        echo "  4. Grant permissions: sudo -u postgres psql -c \"GRANT ALL PRIVILEGES ON DATABASE nagaiku_budget_dev TO nagaiku_user;\""
        echo ""
        echo -e "${YELLOW}Or use the switch_mode.sh script with backup option${NC}"
        exit 1
    fi
fi

# 既存のプロセスを停止
echo -e "${YELLOW}Stopping existing processes...${NC}"
./stop.sh

# ポート設定（常に3000/8000を使用）
FRONTEND_PORT=3000
BACKEND_PORT=8000

if [ "$USE_SYSTEMD" = true ]; then
    # 本番モード: systemdを使用
    echo -e "${GREEN}Starting services with systemd...${NC}"
    
    # systemdサービスを開始
    sudo systemctl start nagaiku-budget-backend
    sudo systemctl start nagaiku-budget-frontend
    
    echo -e "${GREEN}Services started with systemd${NC}"
    echo "Check status with: sudo systemctl status nagaiku-budget-backend nagaiku-budget-frontend"
    
else
    # 開発モード: tmuxを使用
    echo -e "${GREEN}Starting services with tmux...${NC}"
    
    # tmuxセッションを作成
    tmux new-session -d -s nagaiku-dev
    
    # バックエンドを起動
    tmux send-keys -t nagaiku-dev "cd $SCRIPT_DIR/backend" C-m
    tmux send-keys -t nagaiku-dev "bash" C-m
    tmux send-keys -t nagaiku-dev "source dev_venv/bin/activate" C-m
    tmux send-keys -t nagaiku-dev "ENV_FILE=$ENV_FILE PORT=$BACKEND_PORT uvicorn main:app --host 0.0.0.0 --port $BACKEND_PORT --reload" C-m
    
    # フロントエンドウィンドウを作成
    tmux new-window -t nagaiku-dev -n frontend
    tmux send-keys -t nagaiku-dev:frontend "cd $SCRIPT_DIR/frontend" C-m
    tmux send-keys -t nagaiku-dev:frontend "bash" C-m
    tmux send-keys -t nagaiku-dev:frontend "NEXT_PUBLIC_API_URL=http://160.251.170.97:$BACKEND_PORT NODE_ENV=development PORT=$FRONTEND_PORT npm run dev" C-m
    
    echo -e "${GREEN}Services started in tmux session 'nagaiku-dev'${NC}"
    echo "Attach to session with: tmux attach -t nagaiku-dev"
fi

echo -e "${GREEN}Application is running:${NC}"
echo "  Frontend: http://160.251.170.97:${FRONTEND_PORT}"
echo "  Backend API: http://160.251.170.97:${BACKEND_PORT}"
echo "  Production URL: https://nagaiku.top/budget/"