#!/bin/bash

# Enhanced Safe Production Deployment Script
# NPO予算管理システム 本番環境デプロイスクリプト（安全強化版）

set -euo pipefail  # エラー時即座に終了

# カラー出力用
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ログ関数
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# タイムスタンプ
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# ログファイル
DEPLOY_LOG="logs/deploy_${TIMESTAMP}.log"
mkdir -p logs

exec 1> >(tee -a "$DEPLOY_LOG")
exec 2> >(tee -a "$DEPLOY_LOG" >&2)

log_info "=== Enhanced Safe Deployment Started at $(date) ==="

# Phase 1: 事前確認
log_info "Phase 1: 事前確認開始"

# Git状態確認
log_info "Git状態を確認中..."
if [[ -n $(git status --porcelain) ]]; then
    log_warning "未コミットの変更があります:"
    git status --short
    read -p "続行しますか？ (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_error "デプロイを中断しました"
        exit 1
    fi
fi

# 現在のブランチ・コミット記録
CURRENT_BRANCH=$(git branch --show-current)
CURRENT_COMMIT=$(git rev-parse HEAD)
log_info "現在のブランチ: $CURRENT_BRANCH"
log_info "現在のコミット: $CURRENT_COMMIT"

# システムリソース確認
log_info "システムリソースを確認中..."
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 90 ]; then
    log_error "ディスク使用量が90%を超えています ($DISK_USAGE%)"
    exit 1
fi

MEMORY_USAGE=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')
log_info "ディスク使用量: ${DISK_USAGE}%, メモリ使用量: ${MEMORY_USAGE}%"

# PostgreSQL確認
log_info "PostgreSQL状態を確認中..."
if ! systemctl is-active --quiet postgresql; then
    log_error "PostgreSQLが実行されていません"
    exit 1
fi

# Phase 2: バックアップ作成
log_info "Phase 2: バックアップ作成開始"

BACKUP_DIR="backups"
mkdir -p "$BACKUP_DIR"

# データベースバックアップ
log_info "データベースバックアップを作成中..."
BACKUP_FILE="$BACKUP_DIR/backup_prod_${TIMESTAMP}.sql"

if PGPASSWORD=nagaiku_password2024 pg_dump \
    -U nagaiku_user \
    -h localhost \
    -d nagaiku_budget \
    > "$BACKUP_FILE"; then
    log_success "データベースバックアップ完了: $BACKUP_FILE"
else
    log_error "データベースバックアップに失敗しました"
    exit 1
fi

# バックアップファイルサイズ確認
BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
log_info "バックアップサイズ: $BACKUP_SIZE"

# 古いバックアップの削除（30日以上前）
log_info "古いバックアップファイルをクリーンアップ中..."
find "$BACKUP_DIR" -name "backup_prod_*.sql" -mtime +30 -delete || true

# Phase 3: 現在のサービス停止
log_info "Phase 3: 現在のサービス停止開始"

# 現在実行中のプロセス確認
log_info "現在実行中のプロセスを確認中..."
RUNNING_PROCESSES=$(ss -tlnp | grep -E "(3000|8000)" || true)
if [[ -n "$RUNNING_PROCESSES" ]]; then
    log_info "実行中のプロセス:"
    echo "$RUNNING_PROCESSES"
fi

# systemdサービス停止
log_info "systemdサービスを停止中..."
for service in nagaiku-budget-frontend nagaiku-budget-backend; do
    if systemctl is-active --quiet "$service" 2>/dev/null; then
        log_info "Stopping $service..."
        sudo systemctl stop "$service"
        log_success "$service stopped"
    else
        log_info "$service is not running"
    fi
done

# PM2プロセス停止
if command -v pm2 >/dev/null 2>&1; then
    log_info "PM2プロセスを停止中..."
    pm2 stop all >/dev/null 2>&1 || true
fi

# 残存プロセス確認・停止
log_info "残存プロセスを確認・停止中..."
pkill -f "uvicorn.*8000" >/dev/null 2>&1 || true
pkill -f "next.*3000" >/dev/null 2>&1 || true

# プロセス停止確認
sleep 3
REMAINING=$(ss -tlnp | grep -E "(3000|8000)" || true)
if [[ -n "$REMAINING" ]]; then
    log_warning "まだ実行中のプロセスがあります:"
    echo "$REMAINING"
fi

# Phase 4: アプリケーション更新
log_info "Phase 4: アプリケーション更新開始"

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

# Phase 5: サービス起動
log_info "Phase 5: サービス起動開始"

# systemdサービス起動
log_info "systemdサービスを起動中..."
for service in nagaiku-budget-backend nagaiku-budget-frontend; do
    if systemctl list-unit-files | grep -q "$service"; then
        log_info "Starting $service..."
        sudo systemctl start "$service"
        sleep 5
        if systemctl is-active --quiet "$service"; then
            log_success "$service started successfully"
        else
            log_error "$service failed to start"
            sudo systemctl status "$service"
            exit 1
        fi
    else
        log_warning "$service unit file not found, skipping"
    fi
done

# Phase 6: ヘルスチェック
log_info "Phase 6: ヘルスチェック開始"

# サービス応答確認（最大30秒待機）
log_info "サービス応答を確認中..."
for i in {1..30}; do
    if curl -sf http://localhost:8000/health >/dev/null 2>&1; then
        log_success "バックエンド応答確認 OK"
        break
    elif [ $i -eq 30 ]; then
        log_error "バックエンドが応答しません"
        exit 1
    else
        log_info "バックエンド起動待機中... ($i/30)"
        sleep 1
    fi
done

for i in {1..30}; do
    if curl -sf http://localhost:3000/ >/dev/null 2>&1; then
        log_success "フロントエンド応答確認 OK"
        break
    elif [ $i -eq 30 ]; then
        log_error "フロントエンドが応答しません"
        exit 1
    else
        log_info "フロントエンド起動待機中... ($i/30)"
        sleep 1
    fi
done

# Phase 7: 最終確認
log_info "Phase 7: 最終確認"

# プロセス状態確認
log_info "プロセス状態:"
ss -tlnp | grep -E "(3000|8000)" || log_warning "プロセスが見つかりません"

# システムリソース確認
log_info "デプロイ後のシステムリソース:"
echo "Memory: $(free -h | awk 'NR==2{printf "used: %s, free: %s", $3, $4}')"
echo "Disk: $(df -h / | awk 'NR==2{printf "used: %s, available: %s", $3, $4}')"

# デプロイ情報記録
DEPLOY_INFO="deployment_info_${TIMESTAMP}.txt"
cat > "$DEPLOY_INFO" << EOF
Deployment Information
======================
Date: $(date)
Branch: $CURRENT_BRANCH
Commit: $CURRENT_COMMIT
Backup: $BACKUP_FILE
Deploy Log: $DEPLOY_LOG

Services Status:
$(systemctl is-active nagaiku-budget-backend nagaiku-budget-frontend 2>/dev/null || echo "systemd services not found")

Access URLs:
- Production: http://160.251.170.97:3000
- API: http://160.251.170.97:8000

EOF

log_success "=== Enhanced Safe Deployment Completed Successfully ==="
log_info "Deployment info saved to: $DEPLOY_INFO"
log_info "Access your application at: http://160.251.170.97:3000"
log_info "API documentation: http://160.251.170.97:8000/docs"

# 自動起動設定確認
log_info "自動起動設定を確認中..."
for service in nagaiku-budget-backend nagaiku-budget-frontend; do
    if systemctl list-unit-files | grep -q "$service"; then
        if systemctl is-enabled --quiet "$service"; then
            log_success "$service は自動起動が有効です"
        else
            log_warning "$service の自動起動が無効です"
            read -p "$service の自動起動を有効にしますか？ (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                sudo systemctl enable "$service"
                log_success "$service の自動起動を有効にしました"
            fi
        fi
    fi
done

log_info "デプロイ完了 - ログ確認: tail -f $DEPLOY_LOG"