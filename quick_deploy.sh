#!/bin/bash

# 本番環境簡易デプロイスクリプト - NPO予算管理システム「ながいく」
# ------------------------------------------------------
# このスクリプトは「日常的な軽微な修正・更新」を本番環境に反映するためのものです。
# 重大な変更（DBスキーマ変更・依存関係追加・初回デプロイ等）には絶対に使わないでください。
# 詳細な運用手順や注意点は docs/本番環境デプロイガイド.md を必ず参照してください。
# 
# 【使うべきタイミング例】
# ・小さなバグ修正や文言修正
# ・既存機能の軽微なアップデート
#
# 【使ってはいけないタイミング例】
# ・DB構造変更や大規模リファクタ
# ・依存パッケージの追加/更新
# ・初回デプロイや本番環境の初期構築
#
# AIや他の開発者も、実行前に必ずガイドを参照してください。

set -e  # エラー時に停止

echo "⚡ 簡単デプロイを開始します..."

# 引数チェック
COMMIT_MESSAGE="${1:-fix: 軽微な修正とアップデート}"

echo "📝 コミットメッセージ: $COMMIT_MESSAGE"

# 開発環境停止
echo "🛑 開発環境を停止中..."
./stop_development.sh 2>/dev/null || true

# Git操作
echo "📤 Git更新中..."
git add .
git commit -m "$COMMIT_MESSAGE" || echo "⚠️  コミット対象なし（既にコミット済み）"
git push origin main

# 本番環境の更新確認
echo ""
echo "🚀 本番環境を更新しますか？"
echo "  実行内容:"
echo "  1. 最新コードを取得 (git pull)"
echo "  2. 本番ビルドを実行"
echo "  3. サービスを再起動"
echo ""
read -p "続行しますか？ (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ キャンセルしました。"
    exit 0
fi

# 本番環境更新（root権限必要）
echo "🔑 root権限で本番環境を更新します..."

sudo bash -c "
set -e
cd /home/tanaka/nagaiku-budget

echo '📥 最新コードを取得中...'
git pull origin main

echo '🏗️  本番ビルド実行中...'
./build_production.sh

echo '🔄 サービス再起動中...'
systemctl restart nagaiku-budget-backend
sleep 3
systemctl restart nagaiku-budget-frontend
sleep 3

echo '✅ サービス状態確認:'
systemctl status nagaiku-budget-backend --no-pager | head -3
systemctl status nagaiku-budget-frontend --no-pager | head -3
"

# 動作確認
echo ""
echo "🔍 動作確認中..."

# ヘルスチェック
if curl -s -I http://160.251.170.97:8000/docs | grep -q "200 OK"; then
    echo "✅ バックエンドAPI: 正常"
else
    echo "❌ バックエンドAPI: エラー"
fi

if curl -s -I http://160.251.170.97:3000 | grep -q "200 OK"; then
    echo "✅ フロントエンド: 正常"
else
    echo "❌ フロントエンド: エラー"
fi

# 完了メッセージ
echo ""
echo "🎉 簡単デプロイが完了しました！"
echo ""
echo "📋 確認URL:"
echo "  フロントエンド: http://160.251.170.97:3000"
echo "  API仕様書: http://160.251.170.97:8000/docs"
echo ""
echo "📊 ログ確認（必要時）:"
echo "  sudo journalctl -u nagaiku-budget-backend -f"
echo "  sudo journalctl -u nagaiku-budget-frontend -f"
echo ""
echo "⚠️  問題がある場合は完全デプロイ手順を参照してください:"
echo "  docs/本番環境簡易デプロイガイド.md" 