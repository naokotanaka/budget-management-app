#!/bin/bash

# NPO予算管理システム - VPS配置スクリプト

echo "🚀 NPO予算管理システムをVPSに配置します..."

# VPSの設定変数
VPS_USER="root"
VPS_HOST="your-vps-ip-address"
VPS_PATH="/var/www/html/nagaiku-budget"

# 配置先の確認
read -p "VPSのIPアドレスを入力してください: " VPS_HOST
read -p "VPSのユーザー名を入力してください (デフォルト: root): " USER_INPUT
if [ ! -z "$USER_INPUT" ]; then
    VPS_USER="$USER_INPUT"
fi

echo "📁 配置先: $VPS_USER@$VPS_HOST:$VPS_PATH"

# プロジェクトファイルの圧縮
echo "📦 プロジェクトファイルを圧縮中..."
tar -czf nagaiku-budget.tar.gz \
    --exclude='node_modules' \
    --exclude='venv' \
    --exclude='*.log' \
    --exclude='.git' \
    --exclude='data/*.db' \
    backend frontend data README.md start.sh stop.sh install-requirements.sh docker-compose.yml

# VPSへのファイル転送
echo "📤 VPSにファイルを転送中..."
scp nagaiku-budget.tar.gz $VPS_USER@$VPS_HOST:/tmp/

# VPS上でのセットアップ
echo "🔧 VPS上でセットアップを実行中..."
ssh $VPS_USER@$VPS_HOST << 'EOF'
# 配置ディレクトリの作成
sudo mkdir -p /var/www/html
cd /var/www/html

# 既存のファイルのバックアップ
if [ -d "nagaiku-budget" ]; then
    sudo mv nagaiku-budget nagaiku-budget.backup.$(date +%Y%m%d_%H%M%S)
fi

# ファイルの展開
sudo tar -xzf /tmp/nagaiku-budget.tar.gz
sudo mv nagaiku-budget /var/www/html/
sudo chown -R www-data:www-data /var/www/html/nagaiku-budget

# 配置ディレクトリに移動
cd /var/www/html/nagaiku-budget

# 依存関係のインストール
sudo chmod +x install-requirements.sh
sudo ./install-requirements.sh

# 起動スクリプトの実行権限設定
sudo chmod +x start.sh stop.sh

# Nginxの設定（必要に応じて）
echo "server {
    listen 80;
    server_name _;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
    
    location /api/ {
        proxy_pass http://localhost:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}" | sudo tee /etc/nginx/sites-available/nagaiku-budget

# Nginxサイトの有効化
sudo ln -sf /etc/nginx/sites-available/nagaiku-budget /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

# システムの起動
sudo ./start.sh

echo "✅ VPSへの配置が完了しました！"
echo "🌐 http://$HOSTNAME または http://$(curl -s ifconfig.me) でアクセスできます"
EOF

# 一時ファイルの削除
rm -f nagaiku-budget.tar.gz

echo ""
echo "🎉 配置完了！"
echo ""
echo "📝 VPS上での操作:"
echo "  起動: cd /var/www/html/nagaiku-budget && sudo ./start.sh"
echo "  停止: cd /var/www/html/nagaiku-budget && sudo ./stop.sh"
echo "  ログ確認: cd /var/www/html/nagaiku-budget && tail -f logs/*.log"
echo ""