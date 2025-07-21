#!/bin/bash

# Pre-Deployment Check Script
# 本番デプロイ前の事前チェックスクリプト

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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=== 本番デプロイ前事前チェック ==="
echo "実行日時: $(date)"
echo "実行ディレクトリ: $SCRIPT_DIR"
echo

# 1. Git状態確認
log_info "1. Git状態確認"
echo "現在のブランチ: $(git branch --show-current)"
echo "現在のコミット: $(git rev-parse --short HEAD)"
echo "最新コミット: $(git log --oneline -1)"

if [[ -n $(git status --porcelain) ]]; then
    log_warning "未コミットの変更があります:"
    git status --short
else
    log_success "作業ディレクトリはクリーンです"
fi

echo

# 2. システムリソース確認
log_info "2. システムリソース確認"
echo "ディスク使用量: $(df -h / | awk 'NR==2 {print $5}')"
echo "メモリ使用量: $(free -h | awk 'NR==2{printf "%s/%s (%.0f%%)\n", $3,$2,$3*100/$2}')"
echo "CPU負荷: $(uptime | awk -F'load average:' '{ print $2 }' | xargs)"

echo

# 3. データベース確認
log_info "3. データベース確認"
if systemctl is-active --quiet postgresql; then
    log_success "PostgreSQL: 実行中"
    
    # データベース接続テスト
    if PGPASSWORD=nagaiku_password2024 psql -U nagaiku_user -h localhost -d nagaiku_budget -c "SELECT version();" >/dev/null 2>&1; then
        log_success "データベース接続: OK"
        
        # テーブル数確認
        TABLE_COUNT=$(PGPASSWORD=nagaiku_password2024 psql -U nagaiku_user -h localhost -d nagaiku_budget -t -c "SELECT count(*) FROM information_schema.tables WHERE table_schema='public';" 2>/dev/null | xargs)
        echo "テーブル数: $TABLE_COUNT"
        
        # データベースサイズ
        DB_SIZE=$(PGPASSWORD=nagaiku_password2024 psql -U nagaiku_user -h localhost -d nagaiku_budget -t -c "SELECT pg_size_pretty(pg_database_size('nagaiku_budget'));" 2>/dev/null | xargs)
        echo "データベースサイズ: $DB_SIZE"
    else
        log_error "データベース接続: 失敗"
    fi
else
    log_error "PostgreSQL: 停止中"
fi

echo

# 4. 現在実行中のサービス確認
log_info "4. 実行中のサービス確認"
RUNNING_PROCESSES=$(ss -tlnp | grep -E "(3000|3001|8000|8001)" || echo "該当プロセスなし")
echo "実行中のプロセス:"
echo "$RUNNING_PROCESSES"

# systemdサービス確認
echo
echo "systemdサービス状態:"
for service in nagaiku-budget-backend nagaiku-budget-frontend; do
    if systemctl list-unit-files | grep -q "$service" 2>/dev/null; then
        STATUS=$(systemctl is-active "$service" 2>/dev/null || echo "inactive")
        ENABLED=$(systemctl is-enabled "$service" 2>/dev/null || echo "disabled")
        echo "  $service: $STATUS (自動起動: $ENABLED)"
    else
        echo "  $service: unit file not found"
    fi
done

echo

# 5. 依存関係チェック
log_info "5. 依存関係チェック"

# Python依存関係
echo "Python依存関係チェック:"
cd backend
if pip check >/dev/null 2>&1; then
    log_success "  Python依存関係: OK"
else
    log_warning "  Python依存関係に問題があります"
    pip check 2>/dev/null | head -5
fi
cd ..

# Node.js依存関係
echo "Node.js依存関係チェック:"
cd frontend
if npm audit --audit-level=high >/dev/null 2>&1; then
    log_success "  Node.js依存関係: OK"
else
    log_warning "  Node.js依存関係に高レベルの脆弱性があります"
fi

# package.jsonの重要な情報
NEXT_VERSION=$(node -p "require('./package.json').dependencies.next" 2>/dev/null || echo "not found")
REACT_VERSION=$(node -p "require('./package.json').dependencies.react" 2>/dev/null || echo "not found")
echo "  Next.js: $NEXT_VERSION"
echo "  React: $REACT_VERSION"
cd ..

echo

# 6. 環境設定ファイル確認
log_info "6. 環境設定ファイル確認"
ENV_FILES=(
    "backend/.env.development"
    "backend/.env.production"
    "frontend/.env.local"
    "frontend/.env.production"
)

for file in "${ENV_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        log_success "  $file: 存在"
    else
        log_error "  $file: 不存在"
    fi
done

echo

# 7. バックアップ履歴確認
log_info "7. バックアップ履歴確認"
if [[ -d "backups" ]]; then
    BACKUP_COUNT=$(ls -1 backups/backup_prod_*.sql 2>/dev/null | wc -l || echo 0)
    echo "過去のバックアップ数: $BACKUP_COUNT"
    
    if [[ $BACKUP_COUNT -gt 0 ]]; then
        echo "最新のバックアップ:"
        ls -lt backups/backup_prod_*.sql | head -3
    fi
else
    log_warning "backupsディレクトリが存在しません"
fi

echo

# 8. ログファイル確認
log_info "8. ログファイル確認"
if [[ -d "logs" ]]; then
    echo "ログディレクトリサイズ: $(du -sh logs | cut -f1)"
    echo "最近のログファイル:"
    ls -lt logs/ | head -5
else
    log_warning "logsディレクトリが存在しません"
fi

echo

# 9. デプロイスクリプト確認
log_info "9. デプロイスクリプト確認"
DEPLOY_SCRIPTS=(
    "safe_deploy.sh"
    "safe_deploy_enhanced.sh"
    "deploy.sh"
)

for script in "${DEPLOY_SCRIPTS[@]}"; do
    if [[ -f "$script" ]]; then
        if [[ -x "$script" ]]; then
            log_success "  $script: 存在・実行可能"
        else
            log_warning "  $script: 存在するが実行権限なし"
        fi
    else
        log_warning "  $script: 不存在"
    fi
done

echo

# 10. 推奨事項
log_info "10. デプロイ前推奨事項"
echo "✅ 1. 開発環境でテストを実行してください"
echo "✅ 2. データベースの自動バックアップを確認してください"
echo "✅ 3. メンテナンス通知をユーザーに送信してください"
echo "✅ 4. 本番デプロイは業務時間外に実行してください"
echo "✅ 5. デプロイ後の動作確認項目を準備してください"

echo
log_info "=== 事前チェック完了 ==="

# 重要な警告があるかチェック
WARNINGS=0
if [[ -n $(git status --porcelain) ]]; then
    ((WARNINGS++))
fi

if ! systemctl is-active --quiet postgresql; then
    ((WARNINGS++))
fi

if [[ $WARNINGS -gt 0 ]]; then
    log_warning "⚠️  $WARNINGS 個の警告があります。デプロイ前に解決することを推奨します。"
else
    log_success "🚀 事前チェックに問題ありません。デプロイを実行できます。"
fi

echo
echo "次のステップ:"
echo "1. 事前チェックの警告を解決"
echo "2. ./safe_deploy_enhanced.sh を実行"
echo "3. デプロイ後の動作確認を実施"