# 開発環境ディレクトリ

このディレクトリは **開発環境専用** です。

## 重要な注意事項

### ⚠️ このディレクトリは開発環境のみ使用 ⚠️

- **ポート**: 3001 (フロントエンド), 8001 (バックエンド)
- **管理**: tmux
- **データベース**: nagaiku_budget_dev
- **URL**: http://160.251.170.97:3001

### 本番環境との混在を防ぐために

1. **本番環境は別ディレクトリ**
   - 本番環境: `/home/tanaka/nagaiku-budget-prod/`
   - 開発環境: `/home/tanaka/nagaiku-budget/` (ここ)

2. **起動方法の違い**
   - 開発: `./start_development.sh` (tmux使用)
   - 本番: systemd管理（触らない）

3. **ファイルの分離**
   - 開発用: `main_dev_8001.py`
   - 本番用: `main.py` (本番ディレクトリにのみ存在)

4. **仮想環境の分離**
   - 開発venv: `/home/tanaka/nagaiku-budget/backend/dev_venv/`
   - 本番venv: `/home/tanaka/nagaiku-budget-prod/backend/venv/`

### 開発環境の起動・停止

```bash
# 起動
./start_development.sh

# 停止
./stop_development.sh

# tmuxセッション確認
tmux list-sessions
```

### デプロイ手順

1. 開発環境でテスト完了後
2. 本番環境ディレクトリ `/home/tanaka/nagaiku-budget-prod/` に必要なファイルをコピー
3. 本番環境のsystemdサービスを再起動

最終更新: 2025-07-25