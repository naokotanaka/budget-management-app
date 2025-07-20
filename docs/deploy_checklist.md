# デプロイチェックリスト

## デプロイ前の必須確認事項

### 1. データベースバックアップ ✅
```bash
# 本番データベースバックアップ
PGPASSWORD=nagaiku_password2024 pg_dump -U nagaiku_user -h localhost -d nagaiku_budget > backup_$(date +%Y%m%d_%H%M%S).sql

# 開発データベースバックアップ（念のため）
PGPASSWORD=nagaiku_password2024 pg_dump -U nagaiku_user -h localhost -d nagaiku_budget_dev > backup_dev_$(date +%Y%m%d_%H%M%S).sql
```

### 2. 環境設定確認 ✅
- [ ] `backend/.env.production`の設定値確認
- [ ] 本番データベース接続先: `nagaiku_budget`
- [ ] 本番ポート設定: フロントエンド3000、バックエンド8000
- [ ] DEBUG=false設定確認

### 3. 現在のプロセス確認 ⚠️
```bash
# 現在動作中のプロセス確認
ss -tlnp | grep -E "(3000|3001|8000|8001)"
ps aux | grep -E "(uvicorn|next)" | grep -v grep
```

### 4. freee API設定 ⚠️
- [ ] 本番環境のリダイレクトURI設定済み: `http://160.251.170.97:3000/freee/callback`
- [ ] FREEE_CLIENT_ID、FREEE_CLIENT_SECRET設定済み

## デプロイ手順

### Step 1: 現在のプロセス停止
```bash
# 開発環境プロセス停止（安全のため）
kill $(lsof -ti:3001) 2>/dev/null || true
kill $(lsof -ti:8001) 2>/dev/null || true

# 既存の本番プロセス停止（rootプロセスの場合は管理者に依頼）
sudo kill $(lsof -ti:3000) 2>/dev/null || true
sudo kill $(lsof -ti:8000) 2>/dev/null || true
```

### Step 2: 本番環境起動
```bash
# 本番環境起動
./start_production.sh
```

### Step 3: 動作確認
```bash
# ポート確認
ss -tlnp | grep -E "(3000|8000)"

# API動作確認  
curl http://160.251.170.97:8000/docs

# フロントエンド確認
curl http://160.251.170.97:3000
```

## デプロイ後の確認事項

### 1. 基本動作確認 ✅
- [ ] フロントエンド表示: http://160.251.170.97:3000
- [ ] バックエンドAPI: http://160.251.170.97:8000/docs  
- [ ] データベース接続確認
- [ ] 既存データの表示確認

### 2. 機能確認 ✅
- [ ] ダッシュボード表示
- [ ] 取引一覧表示
- [ ] 助成金管理機能
- [ ] CSV取込機能
- [ ] freee連携機能

### 3. ログ監視 ✅
```bash
# バックエンドログ
tail -f logs/backend_prod.log

# フロントエンドログ  
tail -f logs/frontend_prod.log
```

## 緊急時のロールバック手順

### 問題発生時の対処
1. 本番プロセス即座停止
```bash
sudo kill $(lsof -ti:3000) $(lsof -ti:8000) 2>/dev/null
```

2. 開発環境で一時復旧
```bash
./start_development.sh
```

3. データベース復元（必要な場合）
```bash
PGPASSWORD=nagaiku_password2024 psql -U nagaiku_user -h localhost -d nagaiku_budget < backup_最新.sql
```

## 重要な注意点

### ⚠️ 権限の問題
- 現在ポート3000でrootユーザーがNext.jsを実行中
- 停止にはsudo権限が必要な可能性

### ⚠️ データベース安全性
- 本番データベース（nagaiku_budget）は既存データが存在
- デプロイ前の完全バックアップが必須

### ⚠️ freee連携  
- 本番環境用のリダイレクトURI設定が必要
- 環境変数でfreee認証情報を適切に設定

### ⚠️ 同時アクセス
- 開発環境（3001/8001）と本番環境（3000/8000）の同時稼働は避ける
- 混乱を防ぐため、デプロイ時は開発環境を停止推奨 