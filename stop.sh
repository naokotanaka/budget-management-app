#!/bin/bash

# 統一停止スクリプト
# 全ての実行中のnagaiku-budgetプロセスを停止

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# カラー出力
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Stopping nagaiku-budget services...${NC}"

# systemdサービスの停止を試みる
if systemctl is-active --quiet nagaiku-budget-backend || systemctl is-active --quiet nagaiku-budget-frontend; then
    echo -e "${YELLOW}Stopping systemd services...${NC}"
    sudo systemctl stop nagaiku-budget-backend 2>/dev/null || true
    sudo systemctl stop nagaiku-budget-frontend 2>/dev/null || true
fi

# tmuxセッションの停止（統一環境）
if tmux has-session -t nagaiku-budget 2>/dev/null; then
    echo -e "${YELLOW}Stopping tmux session...${NC}"
    tmux kill-session -t nagaiku-budget
fi
# 旧セッション名も念のため停止
if tmux has-session -t nagaiku-dev 2>/dev/null; then
    tmux kill-session -t nagaiku-dev
fi

# ポート3000/8000を使用しているプロセスを停止
echo -e "${YELLOW}Checking for processes on ports 3000 and 8000...${NC}"

# ポート3000のプロセスを確認・停止
PORT_3000_PID=$(lsof -ti:3000 2>/dev/null)
if [ ! -z "$PORT_3000_PID" ]; then
    echo -e "${YELLOW}Killing process on port 3000 (PID: $PORT_3000_PID)${NC}"
    kill -9 $PORT_3000_PID 2>/dev/null || true
fi

# ポート8000のプロセスを確認・停止
PORT_8000_PID=$(lsof -ti:8000 2>/dev/null)
if [ ! -z "$PORT_8000_PID" ]; then
    echo -e "${YELLOW}Killing process on port 8000 (PID: $PORT_8000_PID)${NC}"
    kill -9 $PORT_8000_PID 2>/dev/null || true
fi

# uvicornプロセスの確認・停止
UVICORN_PIDS=$(pgrep -f "uvicorn main:app" 2>/dev/null)
if [ ! -z "$UVICORN_PIDS" ]; then
    echo -e "${YELLOW}Killing uvicorn processes...${NC}"
    echo "$UVICORN_PIDS" | xargs kill -9 2>/dev/null || true
fi

# Next.jsプロセスの確認・停止
NEXT_PIDS=$(pgrep -f "next dev" 2>/dev/null)
if [ ! -z "$NEXT_PIDS" ]; then
    echo -e "${YELLOW}Killing Next.js processes...${NC}"
    echo "$NEXT_PIDS" | xargs kill -9 2>/dev/null || true
fi

# npmプロセスの確認・停止（nagaiku-budget関連）
NPM_PIDS=$(pgrep -f "npm.*start\|npm.*dev" 2>/dev/null)
if [ ! -z "$NPM_PIDS" ]; then
    # プロセスの詳細を確認して、nagaiku-budget関連かチェック
    for pid in $NPM_PIDS; do
        if ps -p $pid -o args= | grep -q "nagaiku-budget\|budget"; then
            echo -e "${YELLOW}Killing npm process (PID: $pid)${NC}"
            kill -9 $pid 2>/dev/null || true
        fi
    done
fi

# Python main.pyプロセスの確認・停止
PYTHON_PIDS=$(pgrep -f "python.*main.py" 2>/dev/null)
if [ ! -z "$PYTHON_PIDS" ]; then
    echo -e "${YELLOW}Killing Python main.py processes...${NC}"
    echo "$PYTHON_PIDS" | xargs kill -9 2>/dev/null || true
fi

# PIDファイルのクリーンアップ
if [ -f logs/backend_dev.pid ]; then
    rm logs/backend_dev.pid
fi
if [ -f logs/frontend_dev.pid ]; then
    rm logs/frontend_dev.pid
fi

echo -e "${GREEN}All nagaiku-budget services stopped${NC}"

# 最終的なポートクリーンアップ（強制）
sleep 1
FINAL_3000_PID=$(lsof -ti:3000 2>/dev/null)
if [ ! -z "$FINAL_3000_PID" ]; then
    echo -e "${YELLOW}Force killing remaining process on port 3000 (PID: $FINAL_3000_PID)${NC}"
    kill -9 $FINAL_3000_PID 2>/dev/null || true
fi

FINAL_8000_PID=$(lsof -ti:8000 2>/dev/null)
if [ ! -z "$FINAL_8000_PID" ]; then
    echo -e "${YELLOW}Force killing remaining process on port 8000 (PID: $FINAL_8000_PID)${NC}"
    kill -9 $FINAL_8000_PID 2>/dev/null || true
fi

# 最終確認
sleep 1
if lsof -i:3000 >/dev/null 2>&1 || lsof -i:8000 >/dev/null 2>&1; then
    echo -e "${RED}Warning: Some processes may still be running on ports 3000 or 8000${NC}"
    echo "Check with: lsof -i:3000 -i:8000"
else
    echo -e "${GREEN}Ports 3000 and 8000 are free${NC}"
fi