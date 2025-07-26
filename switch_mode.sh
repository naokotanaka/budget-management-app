#!/bin/bash

# モード切り替えスクリプト
# 使用法: ./switch_mode.sh [production|development]

MODE=$1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# カラー出力
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# 使用法を表示
if [ -z "$MODE" ] || ([ "$MODE" != "production" ] && [ "$MODE" != "development" ]); then
    echo -e "${RED}Usage: $0 [production|development]${NC}"
    echo ""
    echo "Modes:"
    echo "  production  - Use systemd services with production database"
    echo "  development - Use tmux session with development database"
    exit 1
fi

echo -e "${BLUE}=== Switching to $MODE mode ===${NC}"

# 現在の状態を確認
CURRENT_MODE="unknown"
if systemctl is-active --quiet nagaiku-budget-backend || systemctl is-active --quiet nagaiku-budget-frontend; then
    CURRENT_MODE="production"
elif tmux has-session -t nagaiku-dev 2>/dev/null; then
    CURRENT_MODE="development"
fi

if [ "$CURRENT_MODE" != "unknown" ]; then
    echo -e "${YELLOW}Current mode: $CURRENT_MODE${NC}"
fi

# モード切り替え前の確認
echo -e "${YELLOW}This will:${NC}"
if [ "$MODE" = "production" ]; then
    echo "  - Stop all services"
    echo "  - Use production database (nagaiku_budget)"
    echo "  - Start services with systemd"
    echo "  - Services will auto-start on boot"
else
    echo "  - Stop all services"
    echo "  - Backup production database"
    echo "  - Use development database (nagaiku_budget_dev)"
    echo "  - Start services with tmux"
    echo "  - You can view logs in real-time"
fi

echo ""
read -p "Continue? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}Cancelled${NC}"
    exit 1
fi

# データベースバックアップ（開発モードに切り替える場合）
if [ "$MODE" = "development" ]; then
    echo -e "${YELLOW}Creating database backup...${NC}"
    BACKUP_FILE="backups/backup_prod_$(date +%Y%m%d_%H%M%S).sql"
    mkdir -p backups
    sudo -u postgres pg_dump nagaiku_budget > "$BACKUP_FILE"
    echo -e "${GREEN}Production database backed up to: $BACKUP_FILE${NC}"
    
    # 開発用データベースの準備
    if ! sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw nagaiku_budget_dev; then
        echo -e "${YELLOW}Creating development database from backup...${NC}"
        sudo -u postgres createdb nagaiku_budget_dev
        sudo -u postgres psql nagaiku_budget_dev < "$BACKUP_FILE"
        sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE nagaiku_budget_dev TO nagaiku_user;"
    else
        echo -e "${YELLOW}Development database already exists${NC}"
        read -p "Refresh development database from production? (y/N) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo -u postgres dropdb nagaiku_budget_dev
            sudo -u postgres createdb nagaiku_budget_dev
            sudo -u postgres psql nagaiku_budget_dev < "$BACKUP_FILE"
            sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE nagaiku_budget_dev TO nagaiku_user;"
            echo -e "${GREEN}Development database refreshed${NC}"
        fi
    fi
fi

# サービスを停止
echo -e "${YELLOW}Stopping all services...${NC}"
./stop.sh

# 新しいモードで起動
echo -e "${GREEN}Starting services in $MODE mode...${NC}"
./start.sh $MODE

# systemdサービスの自動起動設定
if [ "$MODE" = "production" ]; then
    echo -e "${YELLOW}Enabling auto-start on boot...${NC}"
    sudo systemctl enable nagaiku-budget-backend
    sudo systemctl enable nagaiku-budget-frontend
else
    echo -e "${YELLOW}Disabling auto-start on boot...${NC}"
    sudo systemctl disable nagaiku-budget-backend 2>/dev/null || true
    sudo systemctl disable nagaiku-budget-frontend 2>/dev/null || true
fi

echo -e "${GREEN}=== Mode switched to $MODE ===${NC}"

# 接続情報を表示
if [ "$MODE" = "development" ]; then
    echo ""
    echo "Development tips:"
    echo "  - View logs: tmux attach -t nagaiku-dev"
    echo "  - Switch windows in tmux: Ctrl-b + window number"
    echo "  - Detach from tmux: Ctrl-b + d"
    echo "  - Database: nagaiku_budget_dev (isolated from production)"
else
    echo ""
    echo "Production tips:"
    echo "  - View logs: sudo journalctl -u nagaiku-budget-backend -f"
    echo "  - Check status: sudo systemctl status nagaiku-budget-backend"
    echo "  - Database: nagaiku_budget (production data)"
fi