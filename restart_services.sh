#!/bin/bash

# サービス再起動スクリプト

echo "🔄 nagaiku.topドメイン設定反映のためサービスを再起動します..."

# バックエンドサービス再起動
echo "📦 バックエンドサービスを再起動中..."
sudo systemctl restart nagaiku-budget-backend
sleep 3

# フロントエンドサービス再起動
echo "🎨 フロントエンドサービスを再起動中..."
sudo systemctl restart nagaiku-budget-frontend
sleep 3

# ステータス確認
echo ""
echo "📊 サービス状態確認:"
sudo systemctl status nagaiku-budget-backend --no-pager | grep -E "(Active:|Main PID:)"
sudo systemctl status nagaiku-budget-frontend --no-pager | grep -E "(Active:|Main PID:)"

echo ""
echo "✅ サービス再起動が完了しました！"
echo ""
echo "🌐 アクセス確認:"
echo "  - ドメイン名: http://nagaiku.top"
echo "  - IPアドレス: http://160.251.170.97:3000"
echo ""
echo "⚠️  ブラウザのキャッシュをクリアしてから確認してください"