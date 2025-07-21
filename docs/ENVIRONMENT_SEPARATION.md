# NPO予算管理システム - 環境変数完全分離実装

## 🎯 実装概要

開発環境と本番環境でポート設定が混乱していた問題を解決するため、環境変数ファイル（.env系）を完全に排除し、systemdサービスと起動スクリプトで環境変数を直接管理する方式に変更しました。

## 🏗️ 実装内容

### 1. フロントエンド設定 (`frontend/next.config.js`)

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  env: {
    // 環境変数から直接取得、なければデフォルト値を使用
    NEXT_PUBLIC_API_URL: process.env.NEXT_PUBLIC_API_URL || 
      (process.env.NODE_ENV === 'production' 
        ? 'http://160.251.170.97:8000'
        : 'http://160.251.170.97:8001')
  },
  // CORS対応のrewritesルール
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        destination: `${process.env.NEXT_PUBLIC_API_URL || 'http://160.251.170.97:8001'}/api/:path*`,
      },
    ]
  },
}
```

### 2. バックエンド設定 (`backend/main_dev_8001.py`)

```python
import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# 環境変数から直接取得（.envファイルは使用しない）
PORT = int(os.getenv("PORT", "8001"))
FRONTEND_URL = os.getenv("FRONTEND_URL", "http://160.251.170.97:3001")
ENVIRONMENT = os.getenv("ENVIRONMENT", "development")
NODE_ENV = os.getenv("NODE_ENV", "development")

app = FastAPI(title="NPO Budget Management System - Development")

# CORS設定 - 開発環境特化
app.add_middleware(
    CORSMiddleware,
    allow_origins=[FRONTEND_URL],  # 環境変数から取得
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 起動部分
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=PORT, reload=True)
```

### 3. 開発環境起動スクリプト (`start_development.sh`)

```bash
# 開発環境用環境変数設定
export NODE_ENV=development
export ENVIRONMENT=development
export NEXT_PUBLIC_API_URL=http://160.251.170.97:8001
export FRONTEND_URL=http://160.251.170.97:3001

# バックエンド用環境変数設定
export PORT=8001

# 開発環境専用ファイルでバックエンドを起動
nohup python3 main_dev_8001.py > ../logs/backend_dev.log 2>&1 &

# フロントエンド用環境変数設定（外部アクセス対応）
nohup npm run dev -- -H 0.0.0.0 -p 3001
```

### 4. バックエンド起動スクリプト (`backend/restart_backend.sh`)

```bash
# 開発環境用環境変数設定
export NODE_ENV=development
export ENVIRONMENT=development
export PORT=8001
export FRONTEND_URL=http://160.251.170.97:3001

# Start with development-specific main file
python3 main_dev_8001.py
```

### 5. systemdサービスファイル

#### フロントエンド (`nagaiku-budget-frontend.service`)
```ini
[Service]
# 本番環境用環境変数設定 - .envファイル非依存
Environment=NODE_ENV=production
Environment=ENVIRONMENT=production
Environment=NEXT_PUBLIC_API_URL=http://160.251.170.97:8000
Environment=PORT=3000
```

#### バックエンド (`nagaiku-budget-backend.service`)
```ini
[Service]
# 本番環境用環境変数設定 - .envファイル非依存
Environment=NODE_ENV=production
Environment=ENVIRONMENT=production
Environment=PORT=8000
ExecStart=/home/tanaka/nagaiku-budget/backend/venv/bin/python main.py
```

## 🎮 使用方法

### 開発環境の起動

```bash
# 開発環境を起動
./start_development.sh

# 環境設定を確認
./check_environment.sh

# 開発環境を停止
./stop_development.sh
```

### 本番環境の管理

```bash
# systemdサービスで管理
sudo systemctl start nagaiku-budget-backend
sudo systemctl start nagaiku-budget-frontend

# 状態確認
sudo systemctl status nagaiku-budget-backend
sudo systemctl status nagaiku-budget-frontend

# ログ確認
sudo journalctl -u nagaiku-budget-backend -f
sudo journalctl -u nagaiku-budget-frontend -f
```

## 🔧 環境判定ロジック

### フロントエンド (next.config.js)
1. `process.env.NEXT_PUBLIC_API_URL` が設定されていればそれを使用
2. 未設定の場合は `process.env.NODE_ENV` で判定
   - `production` → `http://160.251.170.97:8000`
   - その他 → `http://160.251.170.97:8001`

### バックエンド 
1. **開発環境**: `main_dev_8001.py` を使用
   - 環境変数から直接設定を取得
   - ポート8001で起動
   - 開発環境データベース使用
2. **本番環境**: `main.py` を使用
   - systemdサービスで管理
   - ポート8000で起動
   - 本番環境データベース使用

## 📊 ファイル構成とポート割り当て

| 環境 | フロントエンド | バックエンドファイル | ポート | データベース |
|------|---------------|-------------------|--------|-------------|
| 本番 | next.config.js | main.py | 3000/8000 | nagaiku_budget |
| 開発 | next.config.js | main_dev_8001.py | 3001/8001 | nagaiku_budget_dev |

## 🛡️ 安全性

### 環境分離の保証
- ファイルレベルでの環境分離（`main.py` vs `main_dev_8001.py`）
- ポート番号による確実な環境判定
- データベースの完全分離
- 設定ファイルでの明示的な環境変数設定

### 本番環境保護
- 開発環境は専用ファイル（`main_dev_8001.py`）を使用
- 本番環境(ポート8000)への誤アクセス防止
- systemdサービスによる安全な本番環境管理

## 🔍 トラブルシューティング

### 環境設定の確認
```bash
./check_environment.sh
```

### よくある問題
1. **外部アクセス不可**: `-H 0.0.0.0` フラグの確認
2. **ポート競合**: プロセス確認 (`pgrep -fl "next"`)
3. **API接続失敗**: 環境変数設定の確認
4. **データベース接続**: ポート設定とデータベース名の確認
5. **バックエンド起動失敗**: `main_dev_8001.py`ファイルの存在確認

### デバッグコマンド
```bash
# ポート使用状況
ss -tlnp | grep -E "(3000|3001|8000|8001)"

# 環境変数確認
echo $NODE_ENV $ENVIRONMENT $PORT $NEXT_PUBLIC_API_URL $FRONTEND_URL

# プロセス確認
pgrep -fl "next\|uvicorn\|python.*main.py\|python.*main_dev_8001.py"
```

## ✅ 実装完了チェックリスト

- [x] next.config.js の環境変数対応
- [x] main_dev_8001.py の作成（開発環境専用）
- [x] 開発環境起動スクリプトの修正
- [x] バックエンド起動スクリプトの修正
- [x] systemdサービスファイルの修正
- [x] 環境確認スクリプトの作成・更新
- [x] ドキュメントの作成・更新

## 🎉 効果

- 環境設定の混乱を完全に解決
- .envファイル依存の排除
- ファイルレベルでの開発・本番環境の確実な分離
- ポート設定の明確化
- 運用の安全性向上
- 開発環境専用の軽量化されたバックエンド 