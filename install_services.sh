#!/bin/bash

# systemdサービスファイルのインストール

echo "Installing systemd service files..."

# サービスファイルをコピー
sudo cp nagaiku-budget-backend.service /etc/systemd/system/
sudo cp nagaiku-budget-frontend.service /etc/systemd/system/

# systemdをリロード
sudo systemctl daemon-reload

echo "Service files installed successfully"
echo ""
echo "To manage services:"
echo "  Start:   sudo systemctl start nagaiku-budget-backend nagaiku-budget-frontend"
echo "  Stop:    sudo systemctl stop nagaiku-budget-backend nagaiku-budget-frontend"
echo "  Status:  sudo systemctl status nagaiku-budget-backend nagaiku-budget-frontend"
echo "  Enable:  sudo systemctl enable nagaiku-budget-backend nagaiku-budget-frontend"