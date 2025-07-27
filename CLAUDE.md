# Claude Code プロジェクト設定メモ

## 重要：日本語での対応をお願いします
**Claude Codeでこのプロジェクトを扱う際は、必ず日本語で回答してください。**

## 権限管理の重要ルール
**以下のルールを必ず遵守してください：**
- **sudo権限や管理者権限が必要な操作は、必ず事前にユーザーに確認する**
- lsof, kill, fuser, systemctl等の権限系コマンドは最初からsudo前提で提案する
- 権限回避の無理な対処法を試さず、直接的で確実な解決法を提示する
- 「パスワードが必要ですが入力していただけますか？」と明確に聞く
- ユーザーが「いやです」と言った場合は、代替案を提示する

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
- `./start.sh [production|development|systemd]` - サービス起動（デフォルト: development）
  - **production**: tmux + 本番データベース
  - **development**: tmux + 開発データベース  
  - **systemd**: systemdサービス + 本番データベース（本番運用推奨）
- `./stop.sh` - サービス停止
- `./switch_mode.sh [production|development]` - モード切り替え（自動バックアップ付き）

### 本番環境の運用について
- **重要**: 本番環境を維持するには`./start.sh systemd`を使用してください
- tmuxモード（production/development）は開発モード（`npm run dev`）で動作します
- systemdモードは本番ビルド（`npm start`）で動作し、安定した本番環境を提供します
- systemdモードを使用する場合は、事前に`cd frontend && npm run build`でビルドが必要です

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

## バックアップシステム

### 自動バックアップ（cronで実行）
1. **データベースバックアップ** - 毎日2:00
   - 本番データベース（nagaiku_budget）を自動バックアップ
   - 保存先: `/home/tanaka/nagaiku-budget/backups/daily/`
   - 30日より古いファイルは自動削除

2. **コード変更バックアップ** - 毎週月曜3:00
   - 未コミットの変更を自動的にGitコミット
   - コミットメッセージに変更ファイル数を記録
   - **start.sh実行時にも自動実行**

3. **週次Gitクリーンアップ** - 毎週日曜3:00
   - Gitリポジトリの最適化

### 手動安定版タグ作成
- **スクリプト**: `./scripts/tag_stable.sh`
- **タイミング**: 正常動作を確認した時点で実行
- **用途**: 不具合発生時に確実に動作していた状態に戻すため
- **戻し方**: `git checkout stable-タグ名`
- **最新に戻す**: `git checkout main`

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