#!/bin/bash

# 日次データベース自動バックアップスクリプト
# cronで毎日2:00に実行される予定

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="$PROJECT_DIR/backups/daily"
LOG_FILE="$PROJECT_DIR/logs/backup.log"

# カラー出力（ログファイル用は無効化）
if [ -t 1 ]; then
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    RED='\033[0;31m'
    NC='\033[0m'
else
    GREEN=''
    YELLOW=''
    RED=''
    NC=''
fi

# ログ関数
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# バックアップディレクトリを作成
mkdir -p "$BACKUP_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

log_message "=== 日次バックアップ開始 ==="

# 現在の日付でファイル名を生成
DATE_STR=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/nagaiku_budget_daily_$DATE_STR.sql"

# 本番データベースをバックアップ
log_message "本番データベースをバックアップ中..."
if pg_dump -U nagaiku_user -h localhost nagaiku_budget > "$BACKUP_FILE" 2>/dev/null; then
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    log_message "バックアップ完了: $BACKUP_FILE (サイズ: $BACKUP_SIZE)"
else
    log_message "エラー: バックアップに失敗しました"
    exit 1
fi

# 30日より古いバックアップファイルを削除
log_message "古いバックアップファイルを削除中..."
DELETED_COUNT=$(find "$BACKUP_DIR" -name "nagaiku_budget_daily_*.sql" -mtime +30 -print | wc -l)
find "$BACKUP_DIR" -name "nagaiku_budget_daily_*.sql" -mtime +30 -delete

if [ "$DELETED_COUNT" -gt 0 ]; then
    log_message "古いバックアップファイル ${DELETED_COUNT}個 を削除しました"
else
    log_message "削除対象の古いファイルはありませんでした"
fi

# バックアップディスクサイズをチェック
BACKUP_DIR_SIZE=$(du -sh "$BACKUP_DIR" | cut -f1)
log_message "現在のバックアップディレクトリサイズ: $BACKUP_DIR_SIZE"

# ディスク使用量が90%を超えていたら警告
DISK_USAGE=$(df "$PROJECT_DIR" | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 90 ]; then
    log_message "警告: ディスク使用量が ${DISK_USAGE}% に達しています"
fi

log_message "=== 日次バックアップ完了 ==="
echo ""