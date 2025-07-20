#!/bin/bash

# systemdサービスインストールスクリプト

echo "🔧 NPO予算管理システム - systemdサービス設定"
echo "==============================================="

# ログディレクトリ確認
mkdir -p logs

# Step 1: 既存プロセス停止
echo "📊 Step 1: 既存プロセス停止"
./stop_production.sh 2>/dev/null || true
sleep 3

# Step 2: サービスファイルをシステムにコピー
echo "📄 Step 2: サービスファイルをシステムにコピー"
sudo cp nagaiku-budget-backend.service /etc/systemd/system/
sudo cp nagaiku-budget-frontend.service /etc/systemd/system/

# Step 3: 権限設定
echo "🔒 Step 3: サービスファイル権限設定"
sudo chmod 644 /etc/systemd/system/nagaiku-budget-backend.service
sudo chmod 644 /etc/systemd/system/nagaiku-budget-frontend.service

# Step 4: systemd設定リロード
echo "🔄 Step 4: systemd設定リロード"
sudo systemctl daemon-reload

# Step 5: サービス有効化
echo "✅ Step 5: サービス有効化"
sudo systemctl enable nagaiku-budget-backend.service
sudo systemctl enable nagaiku-budget-frontend.service

# Step 6: サービス開始
echo "🚀 Step 6: サービス開始"
sudo systemctl start nagaiku-budget-backend.service
sleep 5
sudo systemctl start nagaiku-budget-frontend.service

# Step 7: 状態確認
echo ""
echo "📊 Step 7: サービス状態確認"
echo "バックエンドサービス:"
sudo systemctl status nagaiku-budget-backend.service --no-pager -l

echo ""
echo "フロントエンドサービス:"
sudo systemctl status nagaiku-budget-frontend.service --no-pager -l

echo ""
echo "🎉 systemdサービス設定完了！"
echo ""
echo "📋 管理コマンド:"
echo "  sudo systemctl start nagaiku-budget-backend"
echo "  sudo systemctl start nagaiku-budget-frontend"
echo "  sudo systemctl stop nagaiku-budget-backend"
echo "  sudo systemctl stop nagaiku-budget-frontend"
echo "  sudo systemctl restart nagaiku-budget-backend"
echo "  sudo systemctl restart nagaiku-budget-frontend"
echo "  sudo systemctl status nagaiku-budget-backend"
echo "  sudo systemctl status nagaiku-budget-frontend"
echo ""
echo "📝 ログ確認:"
echo "  sudo journalctl -u nagaiku-budget-backend -f"
echo "  sudo journalctl -u nagaiku-budget-frontend -f"
echo "  tail -f logs/backend_prod.log"
echo "  tail -f logs/frontend_prod.log" 