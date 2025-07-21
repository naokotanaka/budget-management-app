#!/bin/bash

# IPアドレス一括更新スクリプト

if [ $# -eq 0 ]; then
    echo "❌ 使用方法: $0 <新しいIPアドレス>"
    echo "例: $0 192.168.1.100"
    exit 1
fi

NEW_IP=$1
OLD_IP="160.251.170.97"

echo "🔄 IPアドレスを更新します:"
echo "  変更前: $OLD_IP"
echo "  変更後: $NEW_IP"
echo ""

# 確認プロンプト
read -p "続行しますか？ (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ キャンセルしました。"
    exit 1
fi

# 更新対象ファイルリスト
files=(
    "config/common.env"
    "nagaiku-budget-frontend.service"
    "nagaiku-budget-backend.service"
    "start_dev_tmux.sh"
    "start_dev_next_time.sh"
    "start_development.sh"
    "backend/restart_backend.sh"
    "backend/main.py"
    "backend/main_dev_8001.py"
    "backend/freee_service.py"
    "frontend/next.config.js"
)

updated_count=0

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        # バックアップを作成
        cp "$file" "$file.backup_$(date +%Y%m%d_%H%M%S)"
        
        # IPアドレスを置換
        sed -i "s/$OLD_IP/$NEW_IP/g" "$file"
        
        if [ $? -eq 0 ]; then
            echo "✅ $file を更新しました"
            updated_count=$((updated_count + 1))
        else
            echo "❌ $file の更新に失敗しました"
        fi
    else
        echo "⚠️  $file が見つかりません"
    fi
done

echo ""
echo "🎉 更新完了: $updated_count ファイルを更新しました"
echo ""
echo "📋 次のステップ:"
echo "  1. 設定確認: ./check_environment.sh"
echo "  2. 開発環境テスト: ./start_dev_next_time.sh"
echo "  3. 本番ビルド: ./build_production.sh"
echo "  4. 本番環境更新: sudo systemctl daemon-reload && sudo systemctl restart nagaiku-budget-*"
echo ""
echo "⚠️  バックアップファイル（*.backup_*）は必要に応じて削除してください。" 