# NPO予算管理システム仕様書

## 1. システム概要

### 1.1 目的
NPO法人の会計取引データを効率的に管理し、助成金ごとの予算項目に対して取引を割り当てることで、予算執行状況を可視化するシステムです。

### 1.2 主な機能
- 取引データの管理（インポート、編集、削除）
- 助成金と予算項目の階層管理
- 取引の予算項目への割当（手動・一括）
- 予算執行状況のレポート機能
- データのCSVエクスポート/インポート

## 2. システム構成

### 2.1 技術スタック
- **フロントエンド**: Next.js 15.3.5 (TypeScript)
- **バックエンド**: FastAPI (Python)
- **データベース**: PostgreSQL
- **UI ライブラリ**: AG Grid, Tailwind CSS
- **その他**: dayjs, pandas, SQLAlchemy

### 2.2 アクセス情報
- **IPアドレス**: 160.251.170.97
- **フロントエンド**: ポート3001
- **バックエンド**: ポート8000

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
| department | String | 部門 |
| memo | String | メモタグ |
| remark | String | 備考 |
| management_number | String | 管理番号 |
| created_at | DateTime | 作成日時 |

### 3.2 助成金（grants）
| カラム名 | 型 | 説明 |
|---------|-----|------|
| id | Integer | 主キー |
| name | String | 助成金名 |
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

### 3.4 割当（allocations）
| カラム名 | 型 | 説明 |
|---------|-----|------|
| id | Integer | 主キー |
| transaction_id | String | 取引ID（外部キー） |
| budget_item_id | Integer | 予算項目ID（外部キー） |
| amount | Integer | 割当額 |
| created_at | DateTime | 作成日時 |

## 4. 主要機能詳細

### 4.1 取引管理
- **CSV取込**: freee会計エクスポート形式対応
  - 文字コード自動検出（UTF-8, Shift-JIS）
  - 【事】【管】で始まる勘定科目を自動フィルタリング
- **取引一覧**: AG Gridによる高機能グリッド表示
  - ソート、フィルタ、列の並び替え
  - インライン編集
  - 複数選択での一括削除

### 4.2 助成金・予算項目管理
- **階層構造**: 助成金 → 予算項目の2階層管理
- **予算設定**: 各予算項目に予算額を設定
- **ステータス管理**: 申請中/実施中/完了

### 4.3 割当機能
- **手動割当**: 取引詳細画面から予算項目を選択
- **一括割当**: 複数取引を選択して一括で割当
- **割当履歴**: 各取引の割当状況を一覧表示
- **金額分割**: 1つの取引を複数の予算項目に分割割当

### 4.4 レポート機能
- **クロス集計表**: 助成金×予算項目の執行状況マトリクス
- **執行率表示**: 予算額に対する執行率を可視化
- **期間フィルタ**: 日付範囲での絞り込み
- **CSVエクスポート**: レポートデータのダウンロード

### 4.5 データ連携
- **エクスポート機能**
  - 助成金・予算項目データ
  - 割当データ
  - 全データ一括
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

### 5.5 レポート関連
- `GET /api/reports/cross-table` - クロス集計表取得

### 5.6 CSV関連
- `GET /api/export/grants-budget-allocations` - 助成金・予算エクスポート
- `GET /api/export/allocations` - 割当データエクスポート
- `GET /api/export/all-data` - 全データエクスポート
- `POST /api/import/grants-budget-allocations` - データインポート
- `POST /api/import/allocations` - 割当インポート
- `POST /api/import/grants-budget` - 助成金・予算インポート

### 5.7 管理機能
- `GET /api/dashboard/stats` - ダッシュボード統計
- `DELETE /api/admin/reset-all-data` - 全データリセット
- `GET /api/admin/download/specification` - 仕様書ダウンロード

## 6. 画面構成

### 6.1 ダッシュボード（/）
- 取引件数、総額、割当状況のサマリー表示
- 最近の取引一覧
- クイックアクセスメニュー

### 6.2 取引一覧（/transactions）
- AG Gridによる高機能テーブル
- 検索、フィルタ、ソート機能
- インライン編集
- 一括削除

### 6.3 助成金管理（/grants）
- 助成金一覧表示
- 新規作成、編集、削除
- 予算項目の管理

### 6.4 CSV取込（/import）
- ファイルアップロード
- プレビュー表示
- 取込結果表示

### 6.5 レポート（/reports）
- クロス集計表
- 期間指定フィルタ
- CSVダウンロード

### 6.6 一括割当（/batch-allocate）
- 複数取引の選択
- 予算項目への一括割当
- 割当結果確認

### 6.7 CSVエクスポート/インポート（/csv）
- データ種別選択
- ダウンロード/アップロード

### 6.8 設定（/settings）
- システム情報表示
- 管理機能へのアクセス

## 7. セキュリティ

### 7.1 アクセス制御
- CORS設定による接続元制限
- PostgreSQLパスワード認証

### 7.2 データ保護
- SQLインジェクション対策（SQLAlchemy ORM使用）
- 入力値検証（Pydantic）

## 8. 運用・保守

### 8.1 バックアップ
- PostgreSQLデータベースの定期バックアップ推奨
- CSVエクスポート機能による手動バックアップ

### 8.2 監視項目
- サーバーリソース（CPU、メモリ、ディスク）
- データベース接続数
- APIレスポンスタイム

### 8.3 トラブルシューティング
- フロントエンドアクセス不可時
  - プロセス確認: `pgrep -fl "next"`
  - ポート確認: `ss -tlnp | grep 3001`
  - 再起動: `npm run dev -- -H 0.0.0.0 -p 3001`
- バックエンド停止時
  - 再起動スクリプト: `/root/nagaiku-budget/backend/restart_backend.sh`

## 9. 制限事項

### 9.1 データ量制限
- CSV取込: 最大10,000行推奨
- 同時接続数: 環境依存

### 9.2 ブラウザ対応
- Chrome (推奨)
- Firefox
- Safari
- Edge

## 10. 今後の拡張予定

### 10.1 機能追加候補
- ユーザー認証機能
- 承認ワークフロー
- 予算アラート機能
- モバイル対応

### 10.2 性能改善
- ページネーション実装
- キャッシュ機能
- 非同期処理の拡充

---

最終更新日: 2025年7月7日
バージョン: 1.0.0