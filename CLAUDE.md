# Claude Code プロジェクト設定メモ

## 環境構成

### 本番環境
- **フロントエンド**: https://nagaiku.top/budget/ (nginxプロキシ経由)
- **バックエンド**: https://nagaiku.top/budget/api/ (nginxプロキシ経由)
- **実際のポート**: フロントエンド3000, バックエンド8000
- **起動ファイル**: `main.py`
- **データベース**: `nagaiku_budget`

### 開発環境
- **フロントエンド**: ポート3001 (http://160.251.170.97:3001)
- **バックエンド**: ポート8001 (http://160.251.170.97:8001)
- **起動ファイル**: `main_dev_8001.py`
- **データベース**: `nagaiku_budget_dev`

## 重要な設定

### freee API設定
- Client ID: 615627757425458
- 本番環境redirect_uri: https://nagaiku.top/budget/freee/callback
- 開発環境redirect_uri: http://160.251.170.97:3001/freee/callback

### ドメイン設定
- 本番環境: nagaiku.top
- IP直接アクセス: 160.251.170.97

## 完了した作業
- ✅ HTTPS接続の設定完了
- ✅ サブフォルダー構成への移行完了（https://nagaiku.top/budget/）
- ✅ SPAルーティングの修正（basePathヘルパー実装）