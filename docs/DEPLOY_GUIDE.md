# NPO予算管理システム - デプロイガイド

## 🎯 デプロイ概要

本システムは開発環境（ポート3001/8001）と本番環境（ポート3000/8000）が明確に分離されています。
開発環境にはtmuxベースとシンプルベースの2つの起動方法があります。

## 📋 環境設定の前提条件

### 1. 環境変数ファイルの準備
```bash
# 開発環境用環境変数ファイル作成
cat > backend/.env.development << 'EOF'
ENVIRONMENT=development
PORT=8001
DATABASE_USER=nagaiku_user
DATABASE_PASSWORD=nagaiku_password2024
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=nagaiku_budget_dev
FREEE_CLIENT_ID=
FREEE_CLIENT_SECRET=
FREEE_REDIRECT_URI=http://160.251.170.97:3001/freee/callback
EOF

# 本番環境用環境変数ファイル確認
cat backend/.env.production
```

### 2. データベースユーザーとデータベースの確認
```bash
# PostgreSQLユーザーとデータベースが存在することを確認
sudo -u postgres psql -c "\du" | grep nagaiku_user
sudo -u postgres psql -c "\l" | grep nagaiku_budget
```

### 3. Python仮想環境とPython依存関係
```bash
# 仮想環境作成（初回のみ）
python3 -m venv venv

# 仮想環境有効化（/bin/sh互換）
. venv/bin/activate

# Python依存関係インストール
cd backend
pip install -r requirements.txt
cd ..
```

### 4. 実行権限設定
```bash
# スクリプトファイルに実行権限付与
chmod +x *.sh
```

## 📋 デプロイ前の必須確認

### 1. 現在の状況確認
```bash
# プロセス確認
ss -tlnp | grep -E "(3000|3001|8000|8001)"
ps aux | grep -E "(uvicorn|next)" | grep -v grep

# PostgreSQL確認
systemctl status postgresql
```

### 2. データベースバックアップ（最重要）
```bash
# バックアップディレクトリ作成
mkdir -p backups

# 本番データベースバックアップ（正しいユーザー名で）
PGPASSWORD=nagaiku_password2024 pg_dump -U nagaiku_user -h localhost -d nagaiku_budget > backups/backup_prod_$(date +%Y%m%d_%H%M%S).sql

# 開発データベースバックアップ（念のため）
PGPASSWORD=nagaiku_password2024 pg_dump -U nagaiku_user -h localhost -d nagaiku_budget_dev > backups/backup_dev_$(date +%Y%m%d_%H%M%S).sql
```

> ⚠️ **重要**: PostgreSQL認証情報は環境変数ファイルで管理されています

### 3. 環境設定確認
```bash
# 本番環境設定の確認
cat backend/.env.production

# 期待される内容:
# ENVIRONMENT=production
# PORT=8000
# DATABASE_USER=nagaiku_user
# DATABASE_PASSWORD=nagaiku_password2024
# DATABASE_HOST=localhost
# DATABASE_PORT=5432
# DATABASE_NAME=nagaiku_budget
```

## 🚀 開発環境起動（デプロイ前テスト）

開発環境で動作確認してから本番デプロイを行います。

### Method A: tmux開発環境（推奨）
```bash
# 仮想環境有効化
. venv/bin/activate

# tmux開発環境起動（画面分割でリアルタイム監視）
./start_dev_tmux.sh

# 停止
./stop_dev.sh
```

### Method B: シンプル開発環境
```bash
# シンプル開発環境起動（バックグラウンド実行）
./start_development.sh

# 停止
./stop_development.sh
```

### 開発環境動作確認
- フロントエンド: http://160.251.170.97:3001
- バックエンドAPI: http://160.251.170.97:8001/docs

## 🚀 本番デプロイ手順

### Method 1: 自動デプロイスクリプト使用（推奨）

```bash
# 安全デプロイスクリプトを実行
./safe_deploy.sh
```

このスクリプトは以下を自動実行します：
- 事前確認
- バックアップ確認
- プロセス停止
- フロントエンド強制リビルド（環境変数埋め込み対策）
- 本番環境起動
- 動作確認

### Method 2: systemdサービス使用（安定運用向け）

```bash
# systemdサービスインストール（初回のみ）
sudo ./install_systemd_services.sh

# 本番環境起動
sudo systemctl start nagaiku-budget-backend
sudo systemctl start nagaiku-budget-frontend

# 状態確認
sudo systemctl status nagaiku-budget-backend
sudo systemctl status nagaiku-budget-frontend

# 停止
sudo systemctl stop nagaiku-budget-backend
sudo systemctl stop nagaiku-budget-frontend
```

## 🚨 トラブルシューティング

### 問題1: ポートが使用中
```bash
# プロセス確認
lsof -i:3000
lsof -i:8000

# 強制停止
sudo kill -9 $(lsof -ti:3000)
sudo kill -9 $(lsof -ti:8000)
```

### 問題2: データベース接続エラー
```bash
# PostgreSQL状態確認
systemctl status postgresql

# 再起動
sudo systemctl restart postgresql

# 接続テスト
psql -U postgres -h localhost -l
```

## 📞 サポート情報

### アクセスURL
- **開発環境**: 
  - フロントエンド: http://160.251.170.97:3001
  - バックエンドAPI: http://160.251.170.97:8001/docs
- **本番環境**:
  - フロントエンド: http://160.251.170.97:3000
  - バックエンドAPI: http://160.251.170.97:8000/docs

### systemd管理コマンド（本番環境）
```bash
# サービス状態確認
sudo systemctl status nagaiku-budget-backend
sudo systemctl status nagaiku-budget-frontend

# ログ確認
sudo journalctl -u nagaiku-budget-backend -f
sudo journalctl -u nagaiku-budget-frontend -f

# サービス再起動
sudo systemctl restart nagaiku-budget-backend
sudo systemctl restart nagaiku-budget-frontend
```

## 💾 バックアップ手順

### データベースバックアップ

**開発環境：**
```bash
mkdir -p ~/backups
pg_dump -h localhost -U nagaiku_user nagaiku_budget_dev > ~/backups/nagaiku_budget_dev_$(date +%Y%m%d_%H%M%S).sql
```

**本番環境：**
```bash
sudo mkdir -p /root/backups
sudo pg_dump -h localhost -U nagaiku_user nagaiku_budget > /root/backups/nagaiku_budget_$(date +%Y%m%d_%H%M%S).sql
```

### コードバックアップ（Git推奨）

```bash
# 変更をコミット・プッシュ
git add .
git commit -m "変更内容の説明"
git push origin main
```

### 完全バックアップ（必要に応じて）

**開発環境：**
```bash
tar -czf ~/backups/nagaiku_budget_dev_full_$(date +%Y%m%d_%H%M%S).tar.gz ~/nagaiku-budget/
```

**本番環境：**
```bash
sudo tar -czf /root/backups/nagaiku_budget_prod_full_$(date +%Y%m%d_%H%M%S).tar.gz /root/nagaiku-budget-prod/
```

---

> 💡 **Tips**: 
> - 開発環境で十分にテストしてから本番デプロイを行ってください
> - フロントエンドビルドは環境変数が埋め込まれるため、環境切り替え時は必ずリビルドが必要です
> - tmux開発環境では画面分割でバックエンド・フロントエンドのログをリアルタイム監視できます
> - 本番環境の安定運用にはsystemdサービスの使用を推奨します
> - 重要な変更前には必ずバックアップを取得してください
> - データベースのパスワードは環境変数ファイル（.env.development/.env.production）で確認できます 