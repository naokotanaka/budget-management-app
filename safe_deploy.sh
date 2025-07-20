#!/bin/bash

# 安全なデプロイスクリプト
# 使用方法: ./safe_deploy.sh

set -e  # エラー時に停止

echo "🚀 NPO予算管理システム - 安全デプロイ開始"
echo "========================================"

# Step 1: 事前確認
echo "📋 Step 1: 事前確認"
echo "現在のプロセス状況:"
ss -tlnp | grep -E "(3000|3001|8000|8001)" || echo "該当ポートでのプロセスなし"

echo ""
echo "PostgreSQLサービス確認:"
systemctl is-active postgresql || (echo "❌ PostgreSQLが起動していません" && exit 1)

# Step 2: バックアップ（重要）
echo ""
echo "💾 Step 2: データベースバックアップ"
BACKUP_DIR="backups"
mkdir -p $BACKUP_DIR
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "本番データベースのバックアップを作成中..."
# PostgreSQLの認証問題があるため、実際のバックアップは手動で実行推奨
echo "⚠️  以下のコマンドを手動で実行してください:"
echo "   pg_dump -U [ユーザー名] -h localhost -d nagaiku_budget > $BACKUP_DIR/backup_prod_$TIMESTAMP.sql"
echo ""
read -p "バックアップが完了しました。続行しますか？ (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "デプロイを中止しました。"
    exit 1
fi

# Step 3: 開発環境停止（安全のため）
echo ""
echo "🛑 Step 3: 開発環境の停止"
echo "開発環境のプロセスを停止中..."
kill $(lsof -ti:3001) 2>/dev/null || echo "ポート3001のプロセスはありません"
kill $(lsof -ti:8001) 2>/dev/null || echo "ポート8001のプロセスはありません"
sleep 2

# Step 4: 本番環境の準備
echo ""
echo "🏭 Step 4: 本番環境の準備"

# 既存の本番プロセス確認
if lsof -ti:3000 >/dev/null 2>&1; then
    echo "⚠️  ポート3000で実行中のプロセスが検出されました"
    echo "以下のコマンドで停止してください（root権限が必要な可能性）:"
    echo "   sudo kill \$(lsof -ti:3000)"
    read -p "プロセスを停止しました。続行しますか？ (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "デプロイを中止しました。"
        exit 1
    fi
fi

if lsof -ti:8000 >/dev/null 2>&1; then
    echo "⚠️  ポート8000で実行中のプロセスが検出されました"
    echo "以下のコマンドで停止してください（root権限が必要な可能性）:"
    echo "   sudo kill \$(lsof -ti:8000)"
    read -p "プロセスを停止しました。続行しますか？ (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "デプロイを中止しました。"
        exit 1
    fi
fi

# Step 5: 環境設定確認
echo ""
echo "⚙️  Step 5: 環境設定確認"
export ENVIRONMENT=production
echo "本番環境変数を設定: ENVIRONMENT=$ENVIRONMENT"

# フロントエンドの本番ビルド（必須）
echo "フロントエンドの本番ビルド確認..."
echo "⚠️  環境設定を確実に反映するため、既存ビルドを削除して再ビルドします"
read -p "本番ビルドを実行しますか？ (Y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    cd frontend
    echo "🗑️  既存ビルドファイルを削除中..."
    rm -rf .next out
    echo "🔧 本番環境用ビルド実行中..."
    NODE_ENV=production npm run build
    cd ..
else
    echo "⚠️  本番ビルドをスキップしました（APIアクセスエラーが発生する可能性があります）"
fi

# Step 6: 本番環境起動
echo ""
echo "🚀 Step 6: 本番環境起動"
echo "本番環境を起動中..."

if [ -x "./start_production.sh" ]; then
    ./start_production.sh
else
    echo "❌ start_production.sh が見つからないか実行可能ではありません"
    exit 1
fi

# Step 7: 起動確認
echo ""
echo "✅ Step 7: 起動確認"
sleep 5

echo "ポート確認:"
ss -tlnp | grep -E "(3000|8000)" || echo "⚠️  本番ポートでプロセスが見つかりません"

echo ""
echo "API接続テスト:"
if curl -s --max-time 10 http://160.251.170.97:8000/docs >/dev/null; then
    echo "✅ バックエンドAPI (8000) - 正常"
else
    echo "❌ バックエンドAPI (8000) - 接続失敗"
fi

if curl -s --max-time 10 http://160.251.170.97:3000 >/dev/null; then
    echo "✅ フロントエンド (3000) - 正常"
else
    echo "❌ フロントエンド (3000) - 接続失敗"
fi

# 完了メッセージ
echo ""
echo "🎉 デプロイ完了！"
echo "=================================="
echo "📱 アクセスURL:"
echo "   フロントエンド: http://160.251.170.97:3000"
echo "   バックエンドAPI: http://160.251.170.97:8000/docs"
echo ""
echo "📝 ログ確認:"
echo "   tail -f logs/backend_prod.log"
echo "   tail -f logs/frontend_prod.log"
echo ""
echo "🛑 緊急停止:"
echo "   ./stop_production.sh"
echo ""
echo "⚠️  デプロイ後は必ず動作確認を行ってください" 