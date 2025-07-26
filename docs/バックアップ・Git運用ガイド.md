# バックアップ・Git運用ガイド

## 概要

このガイドでは、nagaiku-budgetプロジェクトのデータベースバックアップとGit管理の自動化について説明します。

## 自動バックアップシステム

### 日次データベースバックアップ

#### 実行スケジュール
- **実行時間**: 毎日 2:00 AM
- **対象データベース**: nagaiku_budget（本番環境）
- **保存場所**: `/home/tanaka/nagaiku-budget/backups/daily/`
- **ファイル形式**: `nagaiku_budget_daily_YYYYMMDD_HHMMSS.sql`

#### 自動機能
- ✅ 30日より古いバックアップファイルの自動削除
- ✅ バックアップサイズとディスク使用量の監視
- ✅ 実行ログの記録（`/home/tanaka/nagaiku-budget/logs/backup.log`）
- ✅ ディスク使用量90%超過時の警告

#### スクリプト位置
```bash
/home/tanaka/nagaiku-budget/scripts/daily_backup.sh
```

### 週次Git整理

#### 実行スケジュール
- **実行時間**: 毎週日曜日 3:00 AM
- **実行内容**: プロジェクトファイルのクリーンアップとGit統計記録

#### 自動機能
- ✅ 一時ファイル（*.tmp, *.bak, *~, .DS_Store）の削除
- ✅ Pythonキャッシュ（__pycache__）の削除
- ✅ Next.jsキャッシュ（.next）の削除
- ✅ 古いログファイル（30日以上）の削除
- ✅ Git統計情報の記録
- ✅ ディスク使用量の監視

#### スクリプト位置
```bash
/home/tanaka/nagaiku-budget/scripts/weekly_git_cleanup.sh
```

## cron設定

現在のcron設定を確認：
```bash
crontab -l
```

設定内容：
```
0 2 * * * /home/tanaka/nagaiku-budget/scripts/daily_backup.sh
0 3 * * 0 /home/tanaka/nagaiku-budget/scripts/weekly_git_cleanup.sh
```

## 手動操作

### 緊急時のバックアップ

#### 本番データベースの手動バックアップ
```bash
cd /home/tanaka/nagaiku-budget
sudo -u postgres pg_dump nagaiku_budget > backups/manual_backup_$(date +%Y%m%d_%H%M%S).sql
```

#### 開発データベースの手動バックアップ
```bash
sudo -u postgres pg_dump nagaiku_budget_dev > backups/dev_backup_$(date +%Y%m%d_%H%M%S).sql
```

### データベースの復元

#### 本番データベースの復元
```bash
# 注意: 本番環境を停止してから実行
./stop.sh
sudo -u postgres dropdb nagaiku_budget
sudo -u postgres createdb nagaiku_budget
sudo -u postgres psql nagaiku_budget < backups/backup_filename.sql
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE nagaiku_budget TO nagaiku_user;"
```

#### 開発データベースの復元
```bash
sudo -u postgres dropdb nagaiku_budget_dev
sudo -u postgres createdb nagaiku_budget_dev
sudo -u postgres psql nagaiku_budget_dev < backups/backup_filename.sql
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE nagaiku_budget_dev TO nagaiku_user;"
```

## ログの確認

### バックアップログ
```bash
tail -f /home/tanaka/nagaiku-budget/logs/backup.log
```

### Git整理ログ
```bash
tail -f /home/tanaka/nagaiku-budget/logs/git_cleanup.log
```

### 最新のバックアップ状況確認
```bash
ls -la /home/tanaka/nagaiku-budget/backups/daily/ | head -10
```

## Git運用フロー

### 推奨コミットタイミング

#### 必須タイミング
1. **機能追加・修正完了時**
   ```bash
   git add .
   git commit -m "feat: 新機能の追加"
   git push origin main
   ```

2. **本番デプロイ前**
   ```bash
   git add .
   git commit -m "deploy: v1.2.3 本番リリース"
   git push origin main
   git tag v1.2.3
   git push origin v1.2.3
   ```

3. **データベーススキーマ変更時**
   ```bash
   git add .
   git commit -m "db: テーブル構造の変更とマイグレーション"
   git push origin main
   ```

#### 推奨タイミング
1. **日次作業終了時**
   ```bash
   git add .
   git commit -m "chore: 日次作業完了 - 設定更新とバグ修正"
   git push origin main
   ```

2. **設定変更時**
   ```bash
   git add CLAUDE.md backend/.env*
   git commit -m "config: 環境設定の更新"
   git push origin main
   ```

### ブランチ戦略

#### 現在の運用
- **main**: 本番環境と開発環境の統一ブランチ
- **feature/***: 大きな機能追加時の作業ブランチ（オプション）

#### 大きな変更時の推奨フロー
```bash
# 新機能ブランチを作成
git checkout -b feature/new-report-system
# 作業を実施
git add .
git commit -m "progress: レポート機能の基本実装"
# 完了後にmainにマージ
git checkout main
git merge feature/new-report-system
git push origin main
git branch -d feature/new-report-system
```

## 監視とアラート

### ディスク容量の監視
- バックアップ時に自動チェック
- 使用率90%超過時にログに警告記録
- 手動確認: `df -h /home/tanaka`

### バックアップの健全性チェック
```bash
# 最新のバックアップファイルサイズ確認
ls -lh /home/tanaka/nagaiku-budget/backups/daily/ | head -2

# バックアップファイルの整合性確認（サンプル）
sudo -u postgres psql -d template1 -c "\\q" < backups/daily/latest_backup.sql
```

## トラブルシューティング

### バックアップが失敗する場合

#### 権限エラー
```bash
# postgresユーザーの権限確認
sudo -u postgres psql -c "\\l"
# nagaiku_userの権限確認
sudo -u postgres psql -c "\\du"
```

#### ディスク容量不足
```bash
# 古いバックアップを手動削除
find /home/tanaka/nagaiku-budget/backups -name "*.sql" -mtime +15 -delete
# 一時ファイルを削除
./scripts/weekly_git_cleanup.sh
```

### cronが実行されない場合

#### cron状態の確認
```bash
systemctl status cron
```

#### cronログの確認
```bash
sudo tail -f /var/log/syslog | grep CRON
```

#### 手動実行テスト
```bash
/home/tanaka/nagaiku-budget/scripts/daily_backup.sh
/home/tanaka/nagaiku-budget/scripts/weekly_git_cleanup.sh
```

## メンテナンス

### 月次メンテナンス作業
1. バックアップログの確認
2. ディスク使用量の確認
3. 古いログファイルの整理
4. Git統計の確認

### 四半期メンテナンス作業
1. バックアップファイルのアーカイブ
2. システム全体の健全性チェック
3. ドキュメントの更新

## 関連ドキュメント
- [開発環境起動ガイド](./開発環境起動ガイド.md)
- [CLAUDE.md](../CLAUDE.md) - プロジェクト全体の設定情報