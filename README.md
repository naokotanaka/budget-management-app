# NPO予算管理システム - ながいく

NPO法人「ながいく」のための予算管理システムです。freee会計APIから直接取引データを取得し、予算項目に割り当て、レポートを作成します。

## 🎯 主な機能

- **freee連携**: freee会計APIから直接仕訳データを取得（OAuth2認証）
- **CSV取込**: freeeからエクスポートしたCSVファイルの取り込み（【事】【管】で始まる勘定科目のみ自動フィルタリング）
- **予算項目割り当て**: 個別編集モードと一括選択モードの2つの方法で取引を予算項目に割り当て
- **データ同期**: freee API経由での増分データ同期と重複チェック
- **フィルター機能**: 複数条件でのフィルタリングとフィルター設定の保存・再利用
- **クロス集計レポート**: 予算項目×月のクロス集計表で支出状況を可視化
- **リアルタイム集計**: 選択した取引の勘定科目別・部門別・予算項目別集計をサイドパネルに表示

## 🚀 技術スタック

### フロントエンド
- **Next.js 14** (App Router)
- **TypeScript**
- **AG-Grid Community** (無料版)
- **Tailwind CSS**
- **React Dropzone**

### バックエンド
- **FastAPI**
- **PostgreSQL**
- **SQLAlchemy**
- **Pandas** (CSV処理)
- **HTTPX** (freee API通信)
- **Python 3.12+**

## 📁 プロジェクト構造

```
nagaiku-budget/
├── frontend/          # Next.js フロントエンド
│   ├── src/
│   │   ├── app/
│   │   │   ├── page.tsx          # ダッシュボード
│   │   │   ├── transactions/     # 取引一覧
│   │   │   ├── grants/           # 助成金管理
│   │   │   ├── import/           # CSV取込
│   │   │   ├── freee/            # freee連携設定
│   │   │   └── reports/          # レポート
│   │   ├── components/
│   │   │   ├── TransactionGrid.tsx   # AG-Grid実装
│   │   │   └── SummaryPanel.tsx      # サイド集計パネル
│   │   └── lib/
│   │       └── api.ts            # API通信
├── backend/           # FastAPI バックエンド
│   ├── main.py        # メインアプリケーション
│   ├── database.py    # データベース設定
│   ├── schemas.py     # Pydanticスキーマ
│   ├── freee_service.py # freee API連携サービス
│   ├── requirements.txt
│   └── .env.example   # 環境変数設定例
├── data/              # データベース
└── README.md
```

## 🛠️ セットアップ手順

### 1. 環境変数の設定

```bash
# バックエンドディレクトリで環境変数ファイルを作成
cd backend
cp .env.example .env

# .envファイルを編集して以下の値を設定:
# - DATABASE_* (PostgreSQL設定)
# - FREEE_CLIENT_ID (freee APIクライアントID)
# - FREEE_CLIENT_SECRET (freee APIクライアントシークレット)
# - FREEE_REDIRECT_URI (リダイレクトURI)
```

### 2. freee API設定

1. [freee developers](https://developer.freee.co.jp/)でアプリケーションを作成
2. リダイレクトURIに `http://160.251.170.97:3001/freee/callback` を設定
3. クライアントIDとクライアントシークレットを`.env`に設定

### 3. バックエンドのセットアップ

```bash
cd backend

# 仮想環境の作成
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# 依存関係のインストール
pip install -r requirements.txt

# データベーステーブルの作成（初回のみ）
python -c "from database import create_tables; create_tables()"

# 開発サーバーの起動
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### 4. フロントエンドのセットアップ

```bash
cd frontend

# 依存関係のインストール
npm install

# 開発サーバーの起動
npm run dev -- -H 0.0.0.0 -p 3001
```

### 5. アクセス

- **フロントエンド**: http://160.251.170.97:3001
- **バックエンドAPI仕様書**: http://160.251.170.97:8000/docs

## 📊 データベース設計

### transactions テーブル
取引データを格納。freeeからのCSVデータを保存。

### grants テーブル
助成金情報を管理。

### budget_items テーブル
予算項目を管理。各助成金に紐づく。

### allocations テーブル
取引と予算項目の割り当て関係を管理。

## 🔧 使用方法

### 1. 助成金と予算項目の設定
1. 「助成金管理」ページで助成金を作成
2. 各助成金に対して予算項目を作成

### 2. freee連携の設定
1. 「freee連携」ページで「freeeに接続」をクリック
2. freeeの認証画面でログインし、アプリケーションを承認
3. 認証完了後、自動的にリダイレクト

### 3. データの取得方法（2つの方法）

#### 方法A: freee API経由での直接同期（推奨）
1. 「freee連携」ページで期間を指定
2. 「同期実行」ボタンでfreeeから直接データを取得
3. 【事】【管】勘定科目の仕訳が自動的に取り込まれる

#### 方法B: CSVファイル経由
1. 「CSV取込」ページでfreeeからエクスポートしたCSVファイルをアップロード
2. プレビューで内容を確認後、取り込み実行

### 4. 予算項目への割り当て
1. 「取引一覧」ページで取引データを確認
2. **個別編集モード**: セルを直接クリックして予算項目を選択
3. **一括選択モード**: 予算項目を選択後、複数の取引をチェックして一括割り当て

### 5. レポートの確認
1. 「レポート」ページでクロス集計表を確認
2. 期間を設定して月別の支出状況を可視化

## ⚠️ 重要な仕様

- **フィルタリング**: freee APIとCSVから【事】【管】で始まる取引のみを取り込み
- **OAuth2認証**: freee APIアクセスには事前認証が必要
- **トークン管理**: アクセストークンの自動更新とリフレッシュ
- **重複チェック**: 仕訳番号と行番号による重複データの自動判定
- **割り当て方法**: インライン編集と一括選択の2種類をサポート
- **フィルター保存**: 複数条件のフィルターを保存・再利用可能
- **リアルタイム集計**: 選択行の集計をサイドパネルに表示

## 🔒 セキュリティ

- **OAuth2認証**: freee APIアクセスの安全な認証
- **トークン暗号化**: アクセストークンの安全な保存
- **CORS設定**: フロントエンドからのアクセスのみ許可
- **SQLインジェクション対策**: SQLAlchemy ORM使用
- **ファイルアップロード検証**: CSVファイル形式の検証

## 🏗️ 本番環境への配置

### VPSでの実行

```bash
# バックエンド（バックグラウンド実行）
cd backend
nohup uvicorn main:app --host 0.0.0.0 --port 8000 &

# フロントエンド（本番ビルド）
cd frontend
npm run build
npm start
```

### Nginx設定例

```nginx
server {
    listen 80;
    server_name your-domain.com;
    
    # フロントエンド
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    # バックエンドAPI
    location /api/ {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## 🤝 サポート

問題が発生した場合は、以下を確認してください：

1. Python 3.12+ がインストールされているか
2. Node.js 18+ がインストールされているか
3. 必要なパッケージがすべてインストールされているか
4. ポート 3000, 8000 が使用可能か

## 📄 ライセンス

このプロジェクトはNPO法人ながいくの内部使用を目的として作成されています。