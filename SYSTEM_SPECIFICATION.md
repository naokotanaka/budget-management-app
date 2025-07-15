# NPO予算管理システム仕様書

## 1. システム概要

### 1.1 目的
NPO法人「ながいく」の会計取引データを効率的に管理し、助成金ごとの予算項目に対して取引を割り当てることで、予算執行状況を可視化するシステムです。freee会計APIとの連携により、リアルタイムでの取引データ取得と予算管理を実現します。

### 1.2 主な機能
- **freee API連携**: OAuth2認証によるfreee会計APIからの直接データ取得
- **CSV取込機能**: freeeからエクスポートしたCSVファイルの取り込み
- **予算項目割当**: 個別編集モードと一括選択モードによる柔軟な割当
- **データ同期**: 増分データ同期と重複チェック機能
- **フィルター機能**: 複数条件でのフィルタリングと設定保存・再利用
- **クロス集計レポート**: 予算項目×月のマトリクス表示
- **リアルタイム集計**: 選択データの勘定科目別・部門別・予算項目別集計

## 2. システム構成

### 2.1 技術スタック

#### フロントエンド
- **Next.js 15.3.5** (App Router)
- **TypeScript 5.x**
- **React 19.0.0**
- **AG-Grid Community 34.0.0** (高機能データグリッド)
- **Tailwind CSS 4.x** (CSSフレームワーク)
- **React Dropzone 14.3.8** (ファイルアップロード)
- **Lucide React 0.460.0** (アイコンライブラリ)
- **dayjs 1.11.13** (日付処理)

#### バックエンド
- **FastAPI 0.104.1** (Python Webフレームワーク)
- **Python 3.12+**
- **SQLAlchemy 2.0.23** (ORM)
- **PostgreSQL** (データベース)
- **Pandas 2.2.0** (CSV処理)
- **HTTPX 0.26.0** (freee API通信)
- **Pydantic 2.5.0** (データバリデーション)
- **Uvicorn 0.24.0** (ASGIサーバー)

### 2.2 アクセス情報
- **IPアドレス**: 160.251.170.97
- **本番環境**:
  - フロントエンド: ポート3000
  - バックエンド: ポート8000
- **開発環境**:
  - フロントエンド: ポート3001
  - バックエンド: ポート8001

### 2.3 プロジェクト構造
```
nagaiku-budget/
├── frontend/                  # Next.js フロントエンド
│   ├── src/
│   │   ├── app/
│   │   │   ├── page.tsx              # ダッシュボード
│   │   │   ├── transactions/         # 取引一覧
│   │   │   ├── grants/               # 助成金管理
│   │   │   ├── import/               # CSV取込
│   │   │   ├── freee/                # freee連携設定
│   │   │   └── reports/              # レポート
│   │   ├── components/
│   │   │   ├── TransactionGrid.tsx   # AG-Grid実装
│   │   │   └── SummaryPanel.tsx      # サイド集計パネル
│   │   └── lib/
│   │       └── api.ts                # API通信
├── backend/                   # FastAPI バックエンド
│   ├── main.py                # メインアプリケーション
│   ├── database.py            # データベース設定
│   ├── schemas.py             # Pydanticスキーマ
│   ├── freee_service.py       # freee API連携サービス
│   └── requirements.txt       # Python依存関係
├── data/                      # データベース
└── README.md
```

## 3. データモデル

### 3.1 取引（transactions）
| カラム名 | 型 | 説明 |
|---------|-----|------|
| id | String | 主キー（仕訳番号_行番号） |
| journal_number | Integer | 仕訳番号 |
| journal_line_number | Integer | 行番号 |
| date | Date | 取引日 |
| description | Text | 摘要 |
| amount | Integer | 金額 |
| account | String | 勘定科目 |
| supplier | String | 取引先 |
| item | String | 品目 |
| memo | String | メモタグ |
| remark | String | 備考 |
| department | String | 部門 |
| management_number | String | 管理番号 |
| raw_data | Text | 元データ（JSON） |
| created_at | DateTime | 作成日時 |

### 3.2 助成金（grants）
| カラム名 | 型 | 説明 |
|---------|-----|------|
| id | Integer | 主キー |
| name | String | 助成金名 |
| grant_code | String | 助成金コード（新規追加） |
| total_amount | Integer | 総額 |
| start_date | Date | 開始日 |
| end_date | Date | 終了日 |
| status | String | ステータス（active/completed/applied） |

### 3.3 予算項目（budget_items）
| カラム名 | 型 | 説明 |
|---------|-----|------|
| id | Integer | 主キー |
| grant_id | Integer | 助成金ID（外部キー） |
| name | String | 項目名 |
| category | String | カテゴリ |
| budgeted_amount | Integer | 予算額 |
| remarks | String | 備考（新規追加） |

### 3.4 割当（allocations）
| カラム名 | 型 | 説明 |
|---------|-----|------|
| id | Integer | 主キー |
| transaction_id | String | 取引ID（外部キー） |
| budget_item_id | Integer | 予算項目ID（外部キー） |
| amount | Integer | 割当額 |
| created_at | DateTime | 作成日時 |

### 3.5 freeeトークン（freee_tokens）
| カラム名 | 型 | 説明 |
|---------|-----|------|
| id | Integer | 主キー |
| access_token | Text | アクセストークン |
| refresh_token | Text | リフレッシュトークン |
| token_type | String | トークンタイプ（Bearer） |
| expires_at | DateTime | 有効期限 |
| scope | String | スコープ |
| company_id | String | 会社ID |
| is_active | Boolean | アクティブフラグ |
| created_at | DateTime | 作成日時 |
| updated_at | DateTime | 更新日時 |

### 3.6 freee同期履歴（freee_syncs）
| カラム名 | 型 | 説明 |
|---------|-----|------|
| id | Integer | 主キー |
| sync_type | String | 同期タイプ（journals等） |
| start_date | Date | 開始日 |
| end_date | Date | 終了日 |
| status | String | ステータス（pending/running/completed/failed） |
| total_records | Integer | 総レコード数 |
| processed_records | Integer | 処理済みレコード数 |
| created_records | Integer | 新規作成レコード数 |
| updated_records | Integer | 更新レコード数 |
| error_message | Text | エラーメッセージ |
| created_at | DateTime | 作成日時 |
| completed_at | DateTime | 完了日時 |

### 3.7 カテゴリ（categories）
| カラム名 | 型 | 説明 |
|---------|-----|------|
| id | Integer | 主キー |
| name | String | カテゴリ名 |
| description | String | 説明 |
| is_active | Boolean | アクティブフラグ |
| created_at | DateTime | 作成日時 |
| updated_at | DateTime | 更新日時 |

## 4. 主要機能詳細

### 4.1 freee API連携
- **OAuth2認証**: freee developersでの事前登録が必要
- **認証フロー**: 
  1. 認証URL生成 → freeeログイン → 認証コード取得 → アクセストークン交換
  2. トークンの自動更新とリフレッシュ機能
- **データ同期**: 期間指定による仕訳データの増分同期
- **重複チェック**: 仕訳番号と行番号による重複データの自動判定
- **フィルタリング**: 【事】【管】で始まる勘定科目のみ自動取得

### 4.2 取引管理
- **CSV取込**: freee会計エクスポート形式対応
  - 文字コード自動検出（UTF-8, Shift-JIS, CP932）
  - 【事】【管】で始まる勘定科目を自動フィルタリング
  - 重複データの自動判定と更新
- **取引一覧**: AG Gridによる高機能グリッド表示
  - ソート、フィルタ、列の並び替え
  - インライン編集（予算項目割当）
  - 複数選択での一括削除
  - リアルタイム集計表示

### 4.3 助成金・予算項目管理
- **階層構造**: 助成金 → 予算項目の2階層管理
- **新機能**: 助成金コード、予算項目備考フィールド追加
- **予算設定**: 各予算項目に予算額を設定
- **ステータス管理**: 申請中/実施中/完了

### 4.4 割当機能
- **個別編集モード**: セル直接クリックによる予算項目選択
- **一括選択モード**: 複数取引を選択して一括割当
- **割当履歴**: 各取引の割当状況を一覧表示
- **金額分割**: 1つの取引を複数の予算項目に分割割当

### 4.5 レポート機能
- **クロス集計表**: 予算項目×月の執行状況マトリクス
- **執行率表示**: 予算額に対する執行率を可視化
- **期間フィルタ**: 日付範囲での絞り込み
- **リアルタイム集計**: 選択行の勘定科目別・部門別・予算項目別集計
- **CSVエクスポート**: レポートデータのダウンロード

### 4.6 データ連携
- **エクスポート機能**
  - 助成金・予算項目データ
  - 割当データ
  - 全データ一括（統合CSV）
- **インポート機能**
  - CSVファイルからの一括取込
  - 既存データの更新対応
  - エラーハンドリング

## 5. API エンドポイント一覧

### 5.1 取引関連
- `GET /api/transactions` - 取引一覧取得
- `PUT /api/transactions/{id}` - 取引更新
- `DELETE /api/transactions/{id}` - 取引削除
- `POST /api/transactions/import` - CSV取込
- `POST /api/transactions/preview` - CSVプレビュー

### 5.2 助成金関連
- `GET /api/grants` - 助成金一覧取得
- `POST /api/grants` - 助成金作成
- `PUT /api/grants/{id}` - 助成金更新
- `DELETE /api/grants/{id}` - 助成金削除

### 5.3 予算項目関連
- `GET /api/budget-items` - 予算項目一覧取得
- `POST /api/budget-items` - 予算項目作成
- `PUT /api/budget-items/{id}` - 予算項目更新
- `DELETE /api/budget-items/{id}` - 予算項目削除

### 5.4 割当関連
- `GET /api/allocations` - 割当一覧取得
- `POST /api/allocations` - 割当作成
- `PUT /api/allocations/{id}` - 割当更新
- `DELETE /api/allocations/{id}` - 割当削除
- `POST /api/allocations/batch` - 一括割当

### 5.5 freee連携関連
- `GET /api/freee/auth` - OAuth認証URL取得
- `POST /api/freee/callback` - OAuth認証コールバック
- `GET /api/freee/status` - 連携状況確認
- `POST /api/freee/sync` - 仕訳データ同期
- `GET /api/freee/syncs` - 同期履歴取得

### 5.6 レポート関連
- `GET /api/reports/cross-table` - クロス集計表取得

### 5.7 CSV関連
- `GET /api/export/grants-budget-allocations` - 助成金・予算エクスポート
- `GET /api/export/allocations` - 割当データエクスポート
- `GET /api/export/all-data` - 全データエクスポート
- `POST /api/import/grants-budget-allocations` - データインポート
- `POST /api/import/allocations` - 割当インポート
- `POST /api/import/grants-budget` - 助成金・予算インポート

### 5.8 管理機能
- `GET /api/dashboard/stats` - ダッシュボード統計
- `DELETE /api/admin/reset-all-data` - 全データリセット
- `GET /api/admin/download/specification` - 仕様書ダウンロード

## 6. 画面構成

### 6.1 ダッシュボード（/）
- 取引件数、総額、割当状況のサマリー表示
- 最近の取引一覧
- クイックアクセスメニュー
- freee連携状況表示

### 6.2 取引一覧（/transactions）
- AG Gridによる高機能テーブル
- 検索、フィルタ、ソート機能
- インライン編集（予算項目割当）
- 一括削除
- リアルタイム集計サイドパネル

### 6.3 助成金管理（/grants）
- 助成金一覧表示
- 新規作成、編集、削除
- 予算項目の管理
- 助成金コード管理
- **外部連携**: [助成金管理システム（Power Apps）](https://apps.powerapps.com/play/e/default-72eba3a1-ac06-457f-8658-f999d5e9a204/a/b7c7cb0c-fafa-4262-a8f2-a67788a330c9?tenantId=72eba3a1-ac06-457f-8658-f999d5e9a204&hint=e74e463f-4725-4e38-b7d6-5fdb7391bd5a&source=sharebutton&sourcetime=1750581325001) - 助成金コードなどの詳細情報を管理

### 6.4 CSV取込（/import）
- ファイルアップロード
- プレビュー表示
- 取込結果表示
- エラーハンドリング

### 6.5 freee連携（/freee）
- OAuth認証設定
- 連携状況確認
- データ同期実行
- 同期履歴表示

### 6.6 レポート（/reports）
- クロス集計表
- 期間指定フィルタ
- CSVダウンロード
- グラフ表示

### 6.7 一括割当（/batch-allocate）
- 複数取引の選択
- 予算項目への一括割当
- 割当結果確認

### 6.8 CSVエクスポート/インポート（/csv）
- データ種別選択
- ダウンロード/アップロード
- フォーマット説明

### 6.9 設定（/settings）
- システム情報表示
- 管理機能へのアクセス
- freee API設定

## 7. セキュリティ

### 7.1 アクセス制御
- CORS設定による接続元制限
- PostgreSQLパスワード認証
- OAuth2によるfreee API認証

### 7.2 データ保護
- SQLインジェクション対策（SQLAlchemy ORM使用）
- 入力値検証（Pydantic）
- トークン暗号化保存
- ファイルアップロード検証

### 7.3 API セキュリティ
- freee APIアクセストークンの安全な管理
- トークンの自動更新機能
- 認証エラーハンドリング

## 8. 運用・保守

### 8.1 環境設定
- **freee API設定**
  1. [freee developers](https://developer.freee.co.jp/)でアプリケーション作成
  2. リダイレクトURIを設定:
     - 本番環境: `http://160.251.170.97:3000/freee/callback`
     - 開発環境: `http://160.251.170.97:3001/freee/callback`
  3. クライアントIDとシークレットを環境変数に設定

### 8.2 バックアップ
- PostgreSQLデータベースの定期バックアップ推奨
- CSVエクスポート機能による手動バックアップ
- freeeトークン情報の安全な保存

### 8.3 監視項目
- サーバーリソース（CPU、メモリ、ディスク）
- データベース接続数
- APIレスポンスタイム
- freee API連携状況
- トークン有効期限

### 8.4 トラブルシューティング
- **フロントエンドアクセス不可時**
  - プロセス確認: `pgrep -fl "next"`
  - 本番環境: `ss -tlnp | grep 3000` / `npm run dev -- -H 0.0.0.0 -p 3000`
  - 開発環境: `ss -tlnp | grep 3001` / `npm run dev -- -H 0.0.0.0 -p 3001`
- **バックエンド停止時**
  - 再起動スクリプト: `/root/nagaiku-budget/backend/restart_backend.sh`
  - 本番環境: ポート8000
  - 開発環境: ポート8001
- **freee連携エラー時**
  - トークン有効期限確認
  - 認証の再実行
  - API制限の確認

## 9. 制限事項

### 9.1 データ量制限
- CSV取込: 最大10,000行推奨
- 同時接続数: 環境依存
- freee API: 1時間あたり10,000リクエスト

### 9.2 ブラウザ対応
- Chrome (推奨)
- Firefox
- Safari
- Edge

### 9.3 freee API制限
- 【事】【管】で始まる勘定科目のみ対応
- OAuth2認証が必要
- API制限に応じた同期間隔の調整が必要

## 10. 今後の拡張予定

### 10.1 機能追加候補
- ユーザー認証機能
- 承認ワークフロー
- 予算アラート機能
- モバイル対応
- 他会計システム連携

### 10.2 性能改善
- ページネーション実装
- キャッシュ機能
- 非同期処理の拡充
- データベースインデックス最適化

### 10.3 UI/UX改善
- ダッシュボードの可視化強化
- フィルター機能の拡張
- エクスポート形式の多様化
- 操作ログ機能

---

**最終更新日**: 2025年7月14日  
**バージョン**: 2.0.0  
**対応freee API**: v1  
**現在の環境**: 開発環境 (VPS 160.251.170.97:3001/8001)