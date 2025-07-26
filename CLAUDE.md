# Claude Code プロジェクト設定メモ

## 重要：日本語での対応をお願いします
**Claude Codeでこのプロジェクトを扱う際は、必ず日本語で回答してください。**

## 環境構成（統合版）

本番環境と開発環境を統合し、シンプルな構成で運用します。

### アクセス情報
- **フロントエンド**: http://160.251.170.97:3000
- **バックエンド API**: http://160.251.170.97:8000
- **本番URL**: https://nagaiku.top/budget/
- **ポート**: 常に3000（フロントエンド）、8000（バックエンド）を使用

### 運用モード

#### 本番モード（production）
- **起動方法**: systemdサービス
- **データベース**: nagaiku_budget（本番データ）
- **自動起動**: 有効（システム起動時）
- **ログ確認**: `sudo journalctl -u nagaiku-budget-backend -f`

#### 開発モード（development）
- **起動方法**: tmuxセッション
- **データベース**: nagaiku_budget_dev（開発用コピー）
- **自動起動**: 無効
- **ログ確認**: `tmux attach -t nagaiku-dev`

## 重要なスクリプト

### 基本操作
- `./start.sh [production|development]` - サービス起動（デフォルト: development）
- `./stop.sh` - サービス停止
- `./switch_mode.sh [production|development]` - モード切り替え（自動バックアップ付き）

### systemdサービス
- `./install_services.sh` - systemdサービスファイルのインストール（要sudo）

## データベース管理

### 本番データベース
- **名前**: nagaiku_budget
- **用途**: 本番運用データ
- **注意**: 直接編集は慎重に

### 開発データベース
- **名前**: nagaiku_budget_dev
- **用途**: 開発・テスト用
- **作成**: 開発モード初回起動時に本番DBから自動コピー
- **更新**: `switch_mode.sh development`実行時にオプションで更新可能

## freee API設定

### 本番環境用アプリ
- Client ID: 615689265706197
- Client Secret: 16HPIucPWiQsM-wvNOtA-9SE6r6hrhNwBu5vw0ry5KmfAH5e0WL2g_yDTA66IfYGspVvS7wS-bmIcM1qlEthXg
- Callback URL: https://nagaiku.top/budget/freee/callback

## 注意事項

### URLパス
- Next.jsの`basePath`は`/budget`に設定されています
- APIアクセスは`/budget/api/`経由で行われます
- 二重パス（`/budget/budget`）にならないよう注意

### 環境変数
- バックエンド: `ENV_FILE`環境変数で.envファイルを切り替え
- フロントエンド: `NODE_ENV`でproduction/developmentを判定

### ポート使用
- ポート3000/8000は固定
- 環境による切り替えは行わない

## トラブルシューティング

### ポート競合
```bash
./stop.sh  # 全プロセスを停止
lsof -i:3000 -i:8000  # ポート使用状況確認
```

### データベース接続エラー
```bash
sudo -u postgres psql -l  # データベース一覧確認
```

### ログ確認
- 本番: `sudo journalctl -u nagaiku-budget-backend -f`
- 開発: `tmux attach -t nagaiku-dev`

## 完了した作業
- ✅ 環境統合（開発/本番を一つのコードベースで管理）
- ✅ ポート統一（3000/8000で固定）
- ✅ モード切り替えスクリプト作成
- ✅ データベース自動バックアップ機能
- ✅ systemd/tmux切り替え対応