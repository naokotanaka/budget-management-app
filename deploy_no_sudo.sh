#!/bin/bash

# Production Deployment Script (No Sudo Required)
# 本番環境デプロイスクリプト（sudo権限不要版）

set -euo pipefail

# カラー出力用
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

log_info "=== Production Deployment (No Sudo) Started at $(date) ==="

# Phase 1: Manual Process Kill
log_info "Phase 1: プロセス停止（手動）"

# 現在のプロセス確認
log_info "現在実行中のプロセス:"
ss -tlnp | grep -E "(3000|8000)" || log_info "該当プロセスなし"

# PM2があれば停止
if command -v pm2 >/dev/null 2>&1; then
    log_info "PM2プロセスを停止中..."
    pm2 stop all >/dev/null 2>&1 || true
    pm2 delete all >/dev/null 2>&1 || true
fi

# プロセス停止
log_info "アプリケーションプロセスを停止中..."
pkill -f "uvicorn.*8000" >/dev/null 2>&1 || true
pkill -f "next.*3000" >/dev/null 2>&1 || true

sleep 5

# 停止確認
REMAINING=$(ss -tlnp | grep -E "(3000|8000)" || true)
if [[ -n "$REMAINING" ]]; then
    log_warning "まだ実行中のプロセスがあります:"
    echo "$REMAINING"
    log_warning "手動で以下を実行してください:"
    echo "  sudo systemctl stop nagaiku-budget-frontend"
    echo "  sudo systemctl stop nagaiku-budget-backend"
    read -p "プロセス停止完了後、Enterを押してください..."
fi

# Phase 2: Application Update
log_info "Phase 2: アプリケーション更新"

# バックエンド依存関係更新
log_info "バックエンド依存関係を更新中..."
cd backend
if pip install -r requirements.txt; then
    log_success "バックエンド依存関係更新完了"
else
    log_error "バックエンド依存関係更新に失敗"
    exit 1
fi
cd ..

# フロントエンド依存関係更新・ビルド
log_info "フロントエンド依存関係を更新中..."
cd frontend
if npm ci; then
    log_success "フロントエンド依存関係更新完了"
else
    log_error "フロントエンド依存関係更新に失敗"
    exit 1
fi

# 本番環境ビルド
log_info "フロントエンド本番ビルドを実行中..."
if NODE_ENV=production npm run build; then
    log_success "フロントエンド本番ビルド完了"
else
    log_error "フロントエンド本番ビルドに失敗"
    exit 1
fi
cd ..

# Phase 3: Manual Service Start
log_info "Phase 3: サービス起動（手動指示）"

log_warning "以下のコマンドを手動で実行してください:"
echo "  sudo systemctl start nagaiku-budget-backend"
echo "  sudo systemctl start nagaiku-budget-frontend"
echo
echo "または、以下のPM2コマンドでも起動可能："
echo "  cd backend && ENV=production uvicorn main:app --host 0.0.0.0 --port 8000 &"
echo "  cd frontend && NODE_ENV=production npm start &"

read -p "サービス起動完了後、Enterを押してください..."

# Phase 4: Health Check
log_info "Phase 4: ヘルスチェック"

# サービス応答確認
log_info "サービス応答を確認中..."
for i in {1..10}; do
    if curl -sf http://localhost:8000/health >/dev/null 2>&1; then
        log_success "バックエンド応答確認 OK"
        break
    elif [ $i -eq 10 ]; then
        log_error "バックエンドが応答しません"
    else
        log_info "バックエンド起動待機中... ($i/10)"
        sleep 2
    fi
done

for i in {1..10}; do
    if curl -sf http://localhost:3000/ >/dev/null 2>&1; then
        log_success "フロントエンド応答確認 OK"
        break
    elif [ $i -eq 10 ]; then
        log_error "フロントエンドが応答しません"
    else
        log_info "フロントエンド起動待機中... ($i/10)"
        sleep 2
    fi
done

# 最終確認
log_info "Phase 5: 最終確認"

# プロセス状態確認
log_info "プロセス状態:"
ss -tlnp | grep -E "(3000|8000)" || log_warning "プロセスが見つかりません"

# システムリソース確認
log_info "デプロイ後のシステムリソース:"
echo "Memory: $(free -h | awk 'NR==2{printf "used: %s, free: %s", $3, $4}')"
echo "Disk: $(df -h / | awk 'NR==2{printf "used: %s, available: %s", $3, $4}')"

log_success "=== Production Deployment Completed ==="
log_info "Access your application at: http://160.251.170.97:3000"
log_info "API documentation: http://160.251.170.97:8000/docs"

echo
log_info "手動で以下も実行することを推奨します:"
echo "  sudo systemctl enable nagaiku-budget-backend"
echo "  sudo systemctl enable nagaiku-budget-frontend"