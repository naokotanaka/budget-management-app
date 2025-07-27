#!/bin/bash

# 統一起動スクリプト（統一環境版）
# 使用法: 
#   ./start.sh          → 開発DB + tmux
#   ./start.sh prod     → 本番DB + tmux  
#   ./start.sh systemd  → 本番DB + systemd（本番運用）

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# カラー出力
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# コード変更の自動バックアップ（週次バックアップに変更）
echo -e "${YELLOW}コード変更を確認中...${NC}"
if [ -f "$SCRIPT_DIR/scripts/weekly_code_backup.sh" ]; then
    bash "$SCRIPT_DIR/scripts/weekly_code_backup.sh" > /dev/null 2>&1
    echo -e "${GREEN}コード自動バックアップ完了${NC}"
fi

# 起動方式とデータベース選択
MODE=${1:-dev}
case "$MODE" in
    "systemd")
        USE_SYSTEMD=true
        DB_NAME="nagaiku_budget"
        echo -e "${GREEN}統一環境起動: systemd + 本番データベース（本番運用）${NC}"
        ;;
    "prod"|"production")
        USE_SYSTEMD=false
        DB_NAME="nagaiku_budget"
        echo -e "${GREEN}統一環境起動: tmux + 本番データベース${NC}"
        ;;
    *)
        USE_SYSTEMD=false
        DB_NAME="nagaiku_budget_dev"
        echo -e "${GREEN}統一環境起動: tmux + 開発データベース${NC}"
        
        # 開発用データベースの存在確認
        if ! psql -U nagaiku_user -h localhost -lqt 2>/dev/null | cut -d \| -f 1 | grep -qw nagaiku_budget_dev; then
            echo -e "${RED}エラー: 開発用データベース 'nagaiku_budget_dev' が存在しません${NC}"
            echo -e "${YELLOW}switch_mode.sh development で作成してください${NC}"
            exit 1
        fi
        ;;
esac

# 既存のプロセスを停止
echo -e "${YELLOW}Stopping existing processes...${NC}"
./stop.sh

# ポートが本当に空いているか確認
sleep 1
if lsof -i:3000 >/dev/null 2>&1 || lsof -i:8000 >/dev/null 2>&1; then
    echo -e "${RED}エラー: ポート3000または8000がまだ使用中です${NC}"
    echo -e "${YELLOW}権限が必要なプロセスが残っている可能性があります${NC}"
    echo -e "${YELLOW}sudo権限でプロセスを終了しますか？ [y/N]: ${NC}"
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}sudo権限でポートクリーンアップ中...${NC}"
        sudo lsof -ti:3000 | xargs -r sudo kill -9 2>/dev/null || true
        sudo lsof -ti:8000 | xargs -r sudo kill -9 2>/dev/null || true
        sleep 1
        if lsof -i:3000 >/dev/null 2>&1 || lsof -i:8000 >/dev/null 2>&1; then
            echo -e "${RED}エラー: ポートクリーンアップに失敗しました${NC}"
            exit 1
        fi
        echo -e "${GREEN}ポートクリーンアップ完了${NC}"
    else
        echo -e "${RED}エラー: ポートが使用中のため起動できません${NC}"
        echo -e "${YELLOW}手動でプロセスを終了してください: sudo lsof -i:3000 -i:8000${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}Ports 3000 and 8000 are free${NC}"
fi

# 統一環境でサービス起動（ポート3000/8000固定）
FRONTEND_PORT=3000
BACKEND_PORT=8000

if [ "$USE_SYSTEMD" = true ]; then
    # systemd起動（本番運用）
    echo -e "${GREEN}systemdでサービス起動中...${NC}"
    
    # systemdサービスファイルにDATABASE_NAME環境変数を設定
    echo "DATABASE_NAME=$DB_NAME" | sudo tee /etc/systemd/system/nagaiku-budget-backend.service.d/override.conf > /dev/null 2>&1 || true
    
    # systemdサービスを開始
    sudo systemctl daemon-reload
    sudo systemctl start nagaiku-budget-backend
    sudo systemctl start nagaiku-budget-frontend
    
    echo -e "${GREEN}systemdサービス起動完了${NC}"
    echo "状態確認: sudo systemctl status nagaiku-budget-backend nagaiku-budget-frontend"
    
else
    # tmux起動（開発・テスト用）
    echo -e "${GREEN}tmuxでサービス起動中...${NC}"
    
    # tmuxセッションを作成
    tmux new-session -d -s nagaiku-budget
    
    # バックエンドを起動
    tmux send-keys -t nagaiku-budget "cd $SCRIPT_DIR/backend" C-m
    tmux send-keys -t nagaiku-budget "bash" C-m
    tmux send-keys -t nagaiku-budget "source ../venv/bin/activate" C-m
    tmux send-keys -t nagaiku-budget "DATABASE_NAME=$DB_NAME PORT=$BACKEND_PORT uvicorn main:app --host 0.0.0.0 --port $BACKEND_PORT --reload" C-m
    
    # フロントエンドウィンドウを作成
    tmux new-window -t nagaiku-budget -n frontend
    tmux send-keys -t nagaiku-budget:frontend "cd $SCRIPT_DIR/frontend" C-m
    tmux send-keys -t nagaiku-budget:frontend "bash" C-m
    tmux send-keys -t nagaiku-budget:frontend "PORT=$FRONTEND_PORT npm run dev" C-m
    
    echo -e "${GREEN}tmuxサービス起動完了${NC}"
    echo "セッション確認: tmux attach -t nagaiku-budget"
fi

echo ""
echo -e "${GREEN}アクセス先:${NC}"
echo "  開発アクセス: http://160.251.170.97:${FRONTEND_PORT}/budget/"
echo "  本番URL: https://nagaiku.top/budget/"
echo "  API: http://160.251.170.97:${BACKEND_PORT}"