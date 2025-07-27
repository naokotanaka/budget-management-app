#!/bin/bash

# 週次コード自動バックアップスクリプト
# cronで毎週実行される

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_FILE="$PROJECT_DIR/logs/backup.log"

# ログ関数
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

cd "$PROJECT_DIR"

log_message "=== 日次コード自動バックアップ開始 ==="

# Gitの状態を確認
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    log_message "エラー: Gitリポジトリではありません"
    exit 1
fi

# 変更があるかチェック
if git diff-index --quiet HEAD -- && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    log_message "変更なし - バックアップ不要"
else
    # 変更内容を確認
    CHANGES=$(git status --porcelain | wc -l)
    log_message "変更ファイル数: $CHANGES"
    
    # 全ての変更をステージング
    git add -A
    
    # 自動コミット
    COMMIT_MSG="自動バックアップ: $(date '+%Y-%m-%d %H:%M:%S')

変更ファイル数: $CHANGES
ホスト: $(hostname)
ユーザー: $(whoami)"
    
    if git commit -m "$COMMIT_MSG" > /dev/null 2>&1; then
        COMMIT_HASH=$(git rev-parse HEAD)
        log_message "コミット成功: $COMMIT_HASH"
        
        # 変更内容をログに記録
        git show --stat --oneline HEAD | while read line; do
            log_message "  $line"
        done
    else
        log_message "エラー: コミットに失敗しました"
    fi
fi

# リモートにプッシュ（設定されている場合）
if git remote | grep -q origin; then
    log_message "リモートへのプッシュを試行中..."
    if git push origin 2>&1 | grep -q "Everything up-to-date\|successfully"; then
        log_message "プッシュ成功またはすでに最新"
    else
        log_message "警告: プッシュに失敗しました（手動でプッシュしてください）"
    fi
fi

log_message "=== 日次コード自動バックアップ完了 ==="
echo ""