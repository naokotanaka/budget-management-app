#!/bin/bash

# 週次Git整理スクリプト
# 毎週日曜日に実行される予定

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_FILE="$PROJECT_DIR/logs/git_cleanup.log"

# カラー出力（ログファイル用は無効化）
if [ -t 1 ]; then
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    RED='\033[0;31m'
    BLUE='\033[0;34m'
    NC='\033[0m'
else
    GREEN=''
    YELLOW=''
    RED=''
    BLUE=''
    NC=''
fi

# ログ関数
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

cd "$PROJECT_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

log_message "=== 週次Git整理開始 ==="

# 現在のブランチとGitの状態を確認
CURRENT_BRANCH=$(git branch --show-current)
log_message "現在のブランチ: $CURRENT_BRANCH"

# ステージングされていない変更があるかチェック
if ! git diff --quiet || ! git diff --cached --quiet; then
    log_message "警告: ステージングされていない変更があります"
    log_message "$(git status --porcelain | wc -l)個のファイルに変更があります"
fi

# リモートから最新情報を取得
log_message "リモートから最新情報を取得中..."
if git fetch origin &>/dev/null; then
    log_message "リモート情報の取得完了"
else
    log_message "警告: リモート情報の取得に失敗"
fi

# 不要なファイルのクリーンアップ
log_message "不要なファイルをクリーンアップ中..."

# 一時ファイルを削除
TEMP_FILES=$(find . -name "*.tmp" -o -name "*.bak" -o -name "*~" -o -name ".DS_Store" 2>/dev/null | wc -l)
if [ "$TEMP_FILES" -gt 0 ]; then
    find . -name "*.tmp" -o -name "*.bak" -o -name "*~" -o -name ".DS_Store" -delete 2>/dev/null
    log_message "一時ファイル ${TEMP_FILES}個 を削除しました"
fi

# ログファイルのローテーション（30日より古いものを削除）
LOG_DIR="$PROJECT_DIR/logs"
if [ -d "$LOG_DIR" ]; then
    OLD_LOGS=$(find "$LOG_DIR" -name "*.log" -mtime +30 | wc -l)
    if [ "$OLD_LOGS" -gt 0 ]; then
        find "$LOG_DIR" -name "*.log" -mtime +30 -delete
        log_message "古いログファイル ${OLD_LOGS}個 を削除しました"
    fi
fi

# Pythonキャッシュファイルを削除
PYTHON_CACHE=$(find . -name "__pycache__" -type d 2>/dev/null | wc -l)
if [ "$PYTHON_CACHE" -gt 0 ]; then
    find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
    log_message "Pythonキャッシュディレクトリ ${PYTHON_CACHE}個 を削除しました"
fi

# Node.jsキャッシュファイルを削除（node_modules以外）
NODE_CACHE=$(find . -name ".next" -type d -not -path "./node_modules/*" 2>/dev/null | wc -l)
if [ "$NODE_CACHE" -gt 0 ]; then
    find . -name ".next" -type d -not -path "./node_modules/*" -exec rm -rf {} + 2>/dev/null || true
    log_message "Next.jsキャッシュディレクトリ ${NODE_CACHE}個 を削除しました"
fi

# Git統計情報を記録
TOTAL_COMMITS=$(git rev-list --count HEAD 2>/dev/null || echo "0")
RECENT_COMMITS=$(git rev-list --count --since="7 days ago" HEAD 2>/dev/null || echo "0")
log_message "Git統計: 総コミット数 ${TOTAL_COMMITS}, 過去7日間のコミット数 ${RECENT_COMMITS}"

# ディスク使用量をチェック
PROJECT_SIZE=$(du -sh "$PROJECT_DIR" 2>/dev/null | cut -f1)
DISK_USAGE=$(df "$PROJECT_DIR" | awk 'NR==2 {print $5}' | sed 's/%//')
log_message "プロジェクトサイズ: $PROJECT_SIZE"
log_message "ディスク使用率: ${DISK_USAGE}%"

if [ "$DISK_USAGE" -gt 85 ]; then
    log_message "警告: ディスク使用率が85%を超えています"
fi

# 最新のコミット情報を記録
LATEST_COMMIT=$(git log -1 --pretty=format:"%h %s" 2>/dev/null || echo "コミットなし")
log_message "最新のコミット: $LATEST_COMMIT"

log_message "=== 週次Git整理完了 ==="
echo ""