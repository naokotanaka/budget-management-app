# 本番デプロイ チェックリスト

## Phase 1: 事前確認・準備 ✅

### 1.1 システム状況確認
```bash
# 現在のプロセス確認
ss -tlnp | grep -E "(3000|3001|8000|8001)"

# PostgreSQL稼働確認
systemctl status postgresql

# ディスク容量確認
df -h

# メモリ使用量確認
free -h
```

### 1.2 データベースバックアップ（必須）
```bash
# バックアップディレクトリ作成
mkdir -p /home/tanaka/nagaiku-budget/backups

# 現在の本番DBをバックアップ
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
PGPASSWORD=nagaiku_password2024 pg_dump \
  -U nagaiku_user \
  -h localhost \
  -d nagaiku_budget \
  > /home/tanaka/nagaiku-budget/backups/backup_prod_${TIMESTAMP}.sql

# バックアップファイル確認
ls -la /home/tanaka/nagaiku-budget/backups/
```

### 1.3 Git状況確認
```bash
# 現在のブランチ・コミット確認
git branch -v
git status
git log --oneline -5

# リモートとの同期確認
git fetch
git status
```

## Phase 2: テスト環境での確認 ✅

### 2.1 開発環境でのテスト
```bash
# 開発環境起動（tmux版推奨）
./start_dev_tmux.sh

# 動作確認項目：
# - フロントエンド表示 (http://160.251.170.97:3001)
# - API接続確認
# - 主要機能テスト：取引一覧、一括割当、レポート
# - 新機能：割当後の自動更新

# テスト完了後停止
./stop_dev.sh
```

### 2.2 本番環境向けビルドテスト
```bash
# フロントエンド本番ビルドテスト
cd frontend
NODE_ENV=production npm run build
cd ..

# バックエンド依存関係確認
cd backend
pip check
cd ..
```

## Phase 3: 段階的本番デプロイ ⏳

### 3.1 現在の本番環境停止
```bash
# systemdサービス停止（存在する場合）
sudo systemctl stop nagaiku-budget-frontend || echo "Service not running"
sudo systemctl stop nagaiku-budget-backend || echo "Service not running"

# PM2プロセス停止（存在する場合）
pm2 stop all || echo "PM2 not running"

# 手動プロセス確認・停止
pkill -f "uvicorn.*8000"
pkill -f "next.*3000"
```

### 3.2 自動デプロイ実行
```bash
# 既存の安全デプロイスクリプト使用
./safe_deploy.sh

# ログ監視
tail -f logs/backend_prod.log &
tail -f logs/frontend_prod.log &
```

### 3.3 サービス起動
```bash
# systemdサービス起動（推奨）
sudo systemctl start nagaiku-budget-backend
sudo systemctl start nagaiku-budget-frontend

# サービス状態確認
sudo systemctl status nagaiku-budget-backend
sudo systemctl status nagaiku-budget-frontend

# 自動起動設定
sudo systemctl enable nagaiku-budget-backend
sudo systemctl enable nagaiku-budget-frontend
```

## Phase 4: 動作確認 ⏳

### 4.1 基本接続確認
```bash
# ポート確認
ss -tlnp | grep -E "(3000|8000)"

# HTTP応答確認
curl -f http://localhost:8000/health || echo "Backend not responding"
curl -f http://localhost:3000/ || echo "Frontend not responding"
```

### 4.2 機能テスト
```bash
# ブラウザアクセス: http://160.251.170.97:3000

# 確認項目：
# ✅ ログイン・認証
# ✅ 取引一覧表示
# ✅ 一括割当機能
# ✅ 新機能：割当後自動更新
# ✅ レポート機能
# ✅ WAM報告書機能
# ✅ データベース接続
```

### 4.3 パフォーマンス確認
```bash
# リソース使用量監視
top -p $(pgrep -f "uvicorn\|node")
```

## Phase 5: 問題発生時のロールバック ⚠️

### 5.1 アプリケーションロールバック
```bash
# サービス停止
sudo systemctl stop nagaiku-budget-frontend
sudo systemctl stop nagaiku-budget-backend

# 前のバージョンに戻す（Gitベース）
git log --oneline -10
git reset --hard <前のコミットID>

# 再デプロイ
./safe_deploy.sh
```

### 5.2 データベースロールバック
```bash
# 最新バックアップから復元
LATEST_BACKUP=$(ls -t /home/tanaka/nagaiku-budget/backups/backup_prod_*.sql | head -1)
echo "Restoring from: $LATEST_BACKUP"

PGPASSWORD=nagaiku_password2024 psql \
  -U nagaiku_user \
  -h localhost \
  -d nagaiku_budget \
  < "$LATEST_BACKUP"
```

## メンテナンス用コマンド 🔧

### ログ確認
```bash
# リアルタイムログ監視
tail -f logs/backend_prod.log logs/frontend_prod.log

# エラーログ検索
grep -i error logs/backend_prod.log
grep -i error logs/frontend_prod.log
```

### システム監視
```bash
# プロセス状況
ps aux | grep -E "(uvicorn|node|postgres)"

# ネットワーク接続
ss -tlnp | grep -E "(3000|8000|5432)"

# システムリソース
free -h && df -h
```

## 緊急時連絡先
- システム管理者: [連絡先情報]
- データベース管理者: [連絡先情報]

---
**作成日**: $(date)
**最終更新**: 自動デプロイ後自動更新