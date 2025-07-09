#!/bin/bash

# NPO予算管理システム - 依存関係インストールスクリプト

echo "📦 NPO予算管理システムの依存関係をインストールします..."

# システムの更新とPythonツールのインストール
echo "🔧 システムパッケージを更新中..."
sudo apt update
sudo apt install -y python3-pip python3-venv nodejs npm

echo "📊 Pythonパッケージをインストール中..."
cd backend
python3 -m pip install --user -r requirements.txt
cd ..

echo "🌐 Node.jsパッケージをインストール中..."
cd frontend
npm install
cd ..

echo "✅ 依存関係のインストールが完了しました！"
echo ""
echo "🚀 システムを起動するには："
echo "  ./start.sh を実行してください"
echo ""