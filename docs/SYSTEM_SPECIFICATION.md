# NPO予算管理システム「ながいく」- 詳細システム仕様書

## 1. システム概要

### 1.1 目的
NPO法人「ながいく」の会計取引データを効率的に管理し、助成金ごとの予算項目に対して取引を割り当てることで、予算執行状況を可視化するシステムです。freee会計APIとの連携により、リアルタイムでの取引データ取得と予算管理を実現します。

### 1.2 システム名
**NPO予算管理システム「ながいく」**

### 1.3 主要機能
- freee会計APIとの直接連携（OAuth2認証）
- CSV取込機能（freeeからのエクスポートファイル対応）
- 予算項目への取引割り当て（個別編集・一括選択の2モード）
- クロス集計レポートによる支出状況の可視化
- WAM（独立行政法人福祉医療機構）対応レポート機能

## 2. システム構成

### 2.1 技術スタック

#### フロントエンド
- **Next.js**: 14.2.30 (App Router使用)
- **React**: 18.3.1
- **TypeScript**: 最新安定版
- **AG Grid Community**: 34.0.0 (データグリッド)
- **Tailwind CSS**: 4.0 (スタイリング)
- **React Dropzone**: 14.3.8 (ファイルアップロード)
- **Day.js**: 1.11.13 (日付処理)
- **Lucide React**: 0.460.0 (アイコン)

#### バックエンド
- **FastAPI**: 0.104.1 (Pythonウェブフレームワーク)
- **Uvicorn**: 0.24.0 (ASGI サーバー)
- **PostgreSQL**: 最新安定版 (データベース)
- **SQLAlchemy**: 2.0.23 (ORM)
- **Pandas**: 2.2.0 (CSV処理)
- **HTTPX**: 最新安定版 (freee API通信)
- **Pydantic**: 2.5.0 (データ検証)

### 2.2 プロジェクト構造

```
nagaiku-budget/
├── frontend/                    # Next.js 14フロントエンド
│   ├── src/
│   │   ├── app/                # App Routerページ
│   │   │   ├── page.tsx        # ダッシュボード
│   │   │   ├── transactions/   # 取引一覧管理
│   │   │   ├── allocations/    # 予算項目割当画面
│   │   │   ├── batch-allocate/ # 一括割当機能
│   │   │   ├── grants/         # 助成金管理
│   │   │   ├── import/         # CSV取込機能
│   │   │   ├── freee/          # freee API連携設定
│   │   │   ├── reports/        # レポート表示
│   │   │   ├── wam-report/     # WAMレポート
│   │   │   └── settings/       # システム設定
│   │   ├── components/         # 共通コンポーネント
│   │   │   ├── TransactionGrid.tsx      # AG-Grid実装の取引データテーブル
│   │   │   ├── SummaryPanel.tsx         # リアルタイム集計サイドパネル
│   │   │   ├── DateRangeFilter.tsx      # 日付範囲フィルター
│   │   │   └── BatchAllocationPanel.tsx # 一括割当操作パネル
│   │   └── lib/                # ユーティリティ関数
│   │       ├── api.ts          # バックエンドAPI通信
│   │       ├── config.ts       # 設定値管理
│   │       ├── ag-grid-setup.ts # AG-Gridセットアップ
│   │       ├── allocation-utils.ts # 割当処理ロジック
│   │       └── utils.ts        # 汎用ユーティリティ
│   ├── package.json            # フロントエンド依存関係
│   └── next.config.js          # Next.js設定
├── backend/                     # FastAPIバックエンド
│   ├── main.py                 # メインアプリケーション（本番用）
│   ├── main_dev_8001.py        # 開発環境専用ファイル
│   ├── database.py             # データベース設定とORM定義
│   ├── schemas.py              # Pydanticスキーマ定義
│   ├── freee_service.py        # freee API連携サービス
│   ├── wam_service.py          # WAM関連サービス
│   ├── requirements.txt        # Python依存パッケージ
│   ├── venv/                   # 本番環境用Python仮想環境
│   └── dev_venv/               # 開発環境用Python仮想環境
├── docs/                       # ドキュメント
│   ├── SYSTEM_SPECIFICATION.md # システム仕様書（本ファイル）
│   ├── DEPLOY_GUIDE.md         # デプロイガイド
│   ├── ENVIRONMENT_SEPARATION.md # 環境分離実装説明
│   ├── AI_DEVELOPMENT_LOG.md   # AI開発ログ
│   ├── SYSTEMD_GUIDE.md        # systemdサービス設定ガイド
│   ├── IMPROVEMENT_PROPOSALS.md # 改善提案
│   └── 開発環境起動ガイド.md   # 日本語開発ガイド
├── data/                       # SQLiteデータベースファイル
├── backups/                    # データベースバックアップファイル
├── logs/                       # アプリケーションログファイル
├── nagaiku-budget-backend.service  # systemd バックエンドサービス
├── nagaiku-budget-frontend.service # systemd フロントエンドサービス
├── start_development.sh        # 開発環境一括起動スクリプト
├── start_dev_tmux.sh          # tmuxセッション管理版起動スクリプト
└── check_environment.sh        # 環境設定確認スクリプト
```

### 2.3 環境構成

#### 開発環境
- **フロントエンド**: ポート3001 (`npm run dev`)
- **バックエンド**: ポート8001 (`main_dev_8001.py`)
- **データベース**: `nagaiku_budget_dev`

#### 本番環境
- **フロントエンド**: ポート3000 (systemdサービス)
- **バックエンド**: ポート8000 (systemdサービス)
- **データベース**: `nagaiku_budget`

## 3. データベース設計

### 3.1 テーブル構造

#### transactions テーブル（取引データ）
| フィールド名 | データ型 | 制約 | 説明 |
|------------|----------|------|------|
| id | String | Primary Key | freeeから取得したユニークID |
| journal_number | Integer | Not Null | 仕訳番号 |
| journal_line_number | Integer | Not Null | 仕訳明細番号 |
| date | Date | Not Null | 取引日 |
| description | Text | | 取引内容 |
| amount | Integer | Not Null | 金額 |
| account | String | | 勘定科目 |
| supplier | String | | 取引先 |
| item | String | | 品目 |
| memo | String | | メモ |
| remark | String | | 備考 |
| department | String | | 部門 |
| management_number | String | | 管理番号 |
| raw_data | Text | | 元データ（JSON形式） |
| created_at | DateTime | Not Null | 作成日時 |

#### grants テーブル（助成金）
| フィールド名 | データ型 | 制約 | 説明 |
|------------|----------|------|------|
| id | Integer | Primary Key | 助成金ID |
| name | String | Not Null | 助成金名 |
| grant_code | String | Unique | 助成金コード |
| total_amount | Integer | | 総額 |
| start_date | Date | | 開始日 |
| end_date | Date | | 終了日 |
| status | String | Default: 'active' | ステータス（active/completed/applied） |

#### budget_items テーブル（予算項目）
| フィールド名 | データ型 | 制約 | 説明 |
|------------|----------|------|------|
| id | Integer | Primary Key | 予算項目ID |
| grant_id | Integer | Foreign Key | 助成金ID |
| name | String | Not Null | 項目名 |
| category | String | | カテゴリ |
| budgeted_amount | Integer | | 予算額 |
| remarks | String | | 備考 |

#### allocations テーブル（割当）
| フィールド名 | データ型 | 制約 | 説明 |
|------------|----------|------|------|
| id | Integer | Primary Key | 割当ID |
| transaction_id | String | Foreign Key | 取引ID |
| budget_item_id | Integer | Foreign Key | 予算項目ID |
| amount | Integer | Not Null | 割当金額 |
| created_at | DateTime | Not Null | 作成日時 |

#### freee_tokens テーブル（freee APIトークン）
| フィールド名 | データ型 | 制約 | 説明 |
|------------|----------|------|------|
| id | Integer | Primary Key | トークンID |
| access_token | Text | Not Null | アクセストークン |
| refresh_token | Text | Not Null | リフレッシュトークン |
| expires_at | DateTime | Not Null | 有効期限 |
| created_at | DateTime | Not Null | 作成日時 |
| updated_at | DateTime | Not Null | 更新日時 |

#### wam_mappings テーブル（WAM科目マッピング）
| フィールド名 | データ型 | 制約 | 説明 |
|------------|----------|------|------|
| id | Integer | Primary Key | マッピングID |
| account_pattern | String | Not Null | 勘定科目パターン |
| wam_category | String | Not Null | WAM科目 |
| priority | Integer | Default: 0 | 優先順位 |
| is_active | Boolean | Default: True | 有効フラグ |

### 3.2 リレーション関係
- **Grant** ← **BudgetItem** (1対多)
- **BudgetItem** ← **Allocation** (1対多)
- **Transaction** ← **Allocation** (1対多)

## 4. API仕様

### 4.1 取引管理API

#### GET /api/transactions
取引データの一覧を取得

**クエリパラメータ**:
- `start_date`: 開始日（YYYY-MM-DD）
- `end_date`: 終了日（YYYY-MM-DD）
- `grant_id`: 助成金ID（オプション）

**レスポンス**:
```json
{
  "transactions": [
    {
      "id": "string",
      "journal_number": 1001,
      "date": "2024-01-15",
      "amount": 50000,
      "account": "旅費交通費",
      "supplier": "JR東日本",
      "allocations": [
        {
          "budget_item_id": 1,
          "budget_item_name": "職員研修費",
          "amount": 50000
        }
      ]
    }
  ]
}
```

#### PUT /api/transactions/{transaction_id}
取引データの更新

**リクエストボディ**:
```json
{
  "description": "更新された取引内容",
  "memo": "更新されたメモ"
}
```

### 4.2 助成金管理API

#### GET /api/grants
助成金の一覧取得

#### POST /api/grants
新規助成金作成

**リクエストボディ**:
```json
{
  "name": "助成金名",
  "grant_code": "GRANT2024001",
  "total_amount": 1000000,
  "start_date": "2024-04-01",
  "end_date": "2025-03-31"
}
```

### 4.3 予算項目管理API

#### GET /api/budget-items
予算項目の一覧取得（助成金情報付き）

#### POST /api/budget-items
新規予算項目作成

### 4.4 割当管理API

#### POST /api/allocations/batch
一括割当処理

**リクエストボディ**:
```json
{
  "transaction_ids": ["trans_001", "trans_002"],
  "budget_item_id": 1,
  "force_override": false
}
```

### 4.5 freee連携API

#### GET /api/freee/auth
freee OAuth認証URL生成

#### POST /api/freee/sync
データ同期実行

### 4.6 レポートAPI

#### GET /api/reports/cross-table
クロス集計レポート取得

#### GET /api/wam-report/data
WAMレポートデータ取得

## 5. フロントエンド仕様

### 5.1 主要コンポーネント

#### TransactionGrid.tsx
**役割**: 取引データの表示・編集
**実装技術**: React + TypeScript + AG Grid
**主要機能**:
- データ表示・ページネーション（100件/ページ）
- セル編集（予算項目選択・割当金額編集）
- フィルタリング（日付・テキスト・数値）
- リアルタイム更新（セル変更時の即座な永続化）
- 選択状態の管理

**特徴的な実装**:
- 予算項目選択時に元の金額を自動コピー
- 「未割当」選択時は既存の割当を削除
- 報告済み助成金の予算項目は選択肢から除外

#### SummaryPanel.tsx
**役割**: 選択された取引の集計表示
**主要機能**:
- 選択行数・合計金額表示
- 予算項目別金額集計
- 平均金額計算
- レスポンシブ対応（幅320px固定）

#### BatchAllocationPanel.tsx
**役割**: 一括割当操作
**主要機能**:
- 予算項目グリッド表示（残額計算付き）
- 一括割当・解除処理
- 助成金期間に基づく自動フィルタリング
- エラーハンドリング（部分成功時の処理含む）

### 5.2 ページ構成

| パス | 機能 | 説明 |
|-----|------|------|
| `/` | ダッシュボード | 統計情報とクイックアクセス |
| `/transactions/` | 取引一覧 | AG-Gridでの取引データ表示・編集 |
| `/allocations/` | 割当管理 | 詳細な割当状況確認 |
| `/batch-allocate/` | 一括割当 | 複数取引の一括操作 |
| `/grants/` | 助成金管理 | 助成金・予算項目のCRUD |
| `/import/` | CSV取込 | freee CSVファイルの取り込み |
| `/freee/` | freee連携 | OAuth設定・データ同期 |
| `/reports/` | レポート | クロス集計表示 |
| `/wam-report/` | WAMレポート | WAM報告書生成 |
| `/settings/` | 設定 | システム設定 |

## 6. バックエンド仕様

### 6.1 アプリケーション構成

#### main.py（本番環境）
- ポート8000で動作
- 全機能を実装
- PostgreSQL本番データベース接続

#### main_dev_8001.py（開発環境）
- ポート8001で動作
- 基本的な読み取りエンドポイントのみ実装
- PostgreSQL開発データベース接続

### 6.2 サービスレイヤ

#### freee_service.py
**OAuth2認証フロー**:
1. 認証URL生成（stateパラメータ付き）
2. 認証コードからアクセストークン取得
3. リフレッシュトークンによる自動更新
4. 有効性チェック・自動更新

**データ同期処理**:
- 指定期間の仕訳データ取得
- freee形式から内部形式への変換
- 【事】【管】勘定科目のフィルタリング
- 同期ログの記録

#### wam_service.py
**WAMマッピング機能**:
- 27種類のWAM科目への自動分類
- 勘定科目クリーニング（【事】【管】接頭辞除去）
- 優先順位制御（データベースルール優先）
- フォールバック（未分類→「対象外経費」）

**レポート生成**:
- 期間・助成金による絞り込み
- 勘定科目からWAM科目への変換
- 摘要生成（取引内容・メモ・備考統合）
- WAM報告書用CSV形式出力

## 7. セキュリティ対策

### 7.1 認証・認可
- **OAuth2認証**: freee APIへの安全なアクセス
- **トークン管理**: 暗号化された形式での保存
- **自動更新**: リフレッシュトークンによる透明な更新

### 7.2 データ保護
- **SQLAlchemy ORM**: SQLインジェクション対策
- **Pydanticバリデーション**: 入力データ検証
- **CORS設定**: 適切なクロスオリジンアクセス制御

### 7.3 運用セキュリティ
- **環境分離**: 開発・本番データベースの完全分離
- **ログ管理**: 操作ログとエラーログの記録
- **バックアップ**: 定期的なデータベースバックアップ

## 8. 運用管理

### 8.1 環境管理

#### 開発環境起動
```bash
# 通常起動（バックグラウンド）
./start_development.sh

# tmux起動（デバッグ用）
./start_dev_tmux.sh

# 環境確認
./check_environment.sh
```

#### 本番環境管理
```bash
# サービス開始
sudo systemctl start nagaiku-budget-backend
sudo systemctl start nagaiku-budget-frontend

# 状態確認
sudo systemctl status nagaiku-budget-backend
sudo systemctl status nagaiku-budget-frontend
```

### 8.2 ログ管理
```
logs/
├── backend_dev.log      # 開発環境バックエンドログ
├── frontend_dev.log     # 開発環境フロントエンドログ
├── backend_prod.log     # 本番環境バックエンドログ
├── frontend_prod.log    # 本番環境フロントエンドログ
├── backend_dev.pid      # 開発環境バックエンドPID
└── frontend_dev.pid     # 開発環境フロントエンドPID
```

### 8.3 バックアップ管理
```
backups/
├── backup_prod_YYYYMMDD_HHMMSS.sql  # 本番環境バックアップ
└── backup_dev_YYYYMMDD_HHMMSS.sql   # 開発環境バックアップ
```

## 9. システムの特徴

### 9.1 技術的特徴
- **完全な環境分離**: ポート番号による確実な環境判定
- **リアルタイム処理**: セル編集時の即座なデータ永続化
- **高性能データ表示**: AG Gridによる大量データの効率的表示
- **自動データ同期**: freee APIとの透明な連携

### 9.2 業務的特徴
- **NPO特化設計**: 助成金管理に特化した機能構成
- **WAM対応**: 独立行政法人福祉医療機構報告書への対応
- **直感的操作**: ドラッグ&ドロップによるファイル取り込み
- **エラー回復**: 部分的失敗を許容する柔軟な処理

### 9.3 拡張性
- **モジュラー設計**: 機能別の明確な責任分離
- **型安全**: TypeScript + Pydanticによる包括的な型チェック
- **API設計**: RESTful APIによる他システムとの連携可能性

## 10. 今後の拡張予定

### 10.1 機能拡張
- 自動仕分けルールエンジン
- 予算vs実績の自動アラート
- より詳細なレポート機能
- モバイル対応

### 10.2 運用改善
- ログローテーション自動化
- バックアップ自動化
- 監視・アラート機能
- パフォーマンス最適化

---

**更新日**: 2025年1月21日  
**バージョン**: 2.0.0  
**作成者**: AI開発支援システム

このシステムは、NPO法人「ながいく」の予算管理業務効率化を目的として開発された実用的なWebアプリケーションです。freee会計ソフトとの連携、詳細な予算管理機能、WAM報告書対応により、NPO特有の会計業務要件に対応しています。