#!/bin/bash

# NPO予算管理システム - VPS設定スクリプト

echo "🔧 VPS環境をセットアップします..."

# VPSディレクトリの作成（管理者権限で実行）
echo "📁 VPSディレクトリを作成中..."

# /var/www/html/nagaiku-budgetが存在しない場合のみ作成
if [ ! -d "/var/www/html/nagaiku-budget" ]; then
    echo "ディレクトリが存在しません。以下のコマンドを管理者権限で実行してください："
    echo ""
    echo "sudo mkdir -p /var/www/html/nagaiku-budget"
    echo "sudo chown -R $USER:$USER /var/www/html/nagaiku-budget"
    echo "sudo chmod -R 755 /var/www/html/nagaiku-budget"
    echo ""
    echo "その後、以下のコマンドでファイルをコピー："
    echo "cp -r /tmp/nagaiku-budget-deploy/* /var/www/html/nagaiku-budget/"
    echo ""
else
    echo "✅ VPSディレクトリは既に存在します"
fi

# 現在のプロジェクトファイルを/tmpにコピー済み
echo "📦 プロジェクトファイルは /tmp/nagaiku-budget-deploy/ に準備済みです"

# VPS環境での起動手順を表示
echo ""
echo "🚀 VPS環境での起動手順："
echo "1. cd /var/www/html/nagaiku-budget"
echo "2. ./install-requirements.sh  # 初回のみ"
echo "3. ./start.sh                 # システム起動"
echo ""
echo "🌐 アクセス方法："
echo "- フロントエンド: http://localhost:3000"
echo "- バックエンドAPI: http://localhost:8000"
echo ""
echo "🛑 停止方法："
echo "- ./stop.sh"
echo ""

# セキュリティ設定の提案
echo "🔐 セキュリティ設定の提案："
echo "1. ファイアウォール設定:"
echo "   sudo ufw allow 22    # SSH"
echo "   sudo ufw allow 80    # HTTP"
echo "   sudo ufw allow 443   # HTTPS"
echo "   sudo ufw enable"
echo ""
echo "2. Nginx設定 (プロキシ用):"
echo "   sudo apt install nginx"
echo "   # 設定ファイルは deploy.sh に含まれています"
echo ""
echo "3. SSL証明書 (Let's Encrypt):"
echo "   sudo apt install certbot python3-certbot-nginx"
echo "   sudo certbot --nginx -d yourdomain.com"
echo ""

echo "✅ VPS設定準備完了！"