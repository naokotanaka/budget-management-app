#!/bin/bash

# 本番環境用事前ビルドスクリプト - systemdサービス分離対応

echo "🏗️ 本番環境用ビルドを開始します..."

# 共通設定を読み込み
if [ -f "config/common.env" ]; then
    source config/common.env
    echo "✅ 共通設定を読み込みました (SERVER_IP: $SERVER_IP)"
else
    echo "⚠️  config/common.envが見つかりません。デフォルト値を使用します。"
    SERVER_IP=160.251.170.97
fi

# 本番環境用環境変数を設定
export NODE_ENV=production
export ENVIRONMENT=production
# API URLは環境変数が設定されていない場合のみデフォルト値を使用
if [ -z "$NEXT_PUBLIC_API_URL" ]; then
    export NEXT_PUBLIC_API_URL=http://nagaiku.top:8000
fi
export PORT=3000

echo "📊 ビルド設定:"
echo "  NODE_ENV: $NODE_ENV"
echo "  NEXT_PUBLIC_API_URL: $NEXT_PUBLIC_API_URL"
echo "  SERVER_IP: $SERVER_IP"

# フロントエンドディレクトリに移動
cd frontend

# 既存のビルドファイルを削除
echo "🧹 既存のビルドファイルを削除中..."
rm -rf .next out

# 依存関係のインストール（必要に応じて）
echo "📦 依存関係を確認中..."
npm ci --production=false

# 本番ビルドを実行
echo "🚀 本番ビルドを実行中..."
npm run build

if [ $? -eq 0 ]; then
    echo "✅ 本番ビルドが完了しました！"
    echo ""
    echo "📋 次のステップ:"
    echo "  1. sudo systemctl daemon-reload"
    echo "  2. sudo systemctl restart nagaiku-budget-frontend"
    echo "  3. http://${SERVER_IP}:3000 でアクセス確認"
    echo ""
    echo "⚡ 高速起動: systemdサービスは事前ビルド済みファイルを使用するため、"
    echo "   今後の再起動は数秒で完了します。"
else
    echo "❌ ビルドに失敗しました。エラーを確認してください。"
    exit 1
fi 