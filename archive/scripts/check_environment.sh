#!/bin/bash

# 環境設定確認スクリプト - 環境変数完全分離対応

echo "🔍 NPO予算管理システム - 環境設定確認"
echo "========================================="

# 基本環境変数
echo ""
echo "📊 基本環境変数:"
echo "  NODE_ENV: ${NODE_ENV:-未設定}"
echo "  ENVIRONMENT: ${ENVIRONMENT:-未設定}"
echo "  PORT: ${PORT:-未設定}"
echo "  NEXT_PUBLIC_API_URL: ${NEXT_PUBLIC_API_URL:-未設定}"
echo "  FRONTEND_URL: ${FRONTEND_URL:-未設定}"

# プロセス確認
echo ""
echo "🔧 実行中のプロセス:"
if pgrep -f "next" > /dev/null; then
    echo "  フロントエンド: 実行中"
    ss -tlnp | grep -E "(3000|3001)" | while read line; do
        echo "    $line"
    done
else
    echo "  フロントエンド: 停止中"
fi

if pgrep -f "uvicorn\|python.*main.py\|python.*main_dev_8001.py" > /dev/null; then
    echo "  バックエンド: 実行中"
    ss -tlnp | grep -E "(8000|8001)" | while read line; do
        echo "    $line"
    done
else
    echo "  バックエンド: 停止中"
fi

# tmuxセッション確認
echo ""
echo "🖥️  tmuxセッション:"
if command -v tmux >/dev/null 2>&1; then
    if tmux list-sessions 2>/dev/null | grep -q "dev-env"; then
        echo "  dev-env: 実行中"
        tmux list-sessions | grep "dev-env"
    else
        echo "  dev-env: 停止中"
    fi
else
    echo "  tmux: インストールされていません"
fi

# ファイル存在確認
echo ""
echo "📁 設定ファイル確認:"
files=(
    "frontend/next.config.js"
    "start_development.sh"
    "start_dev_next_time.sh"
    "start_dev_tmux.sh"
    "stop_development.sh"
    "backend/restart_backend.sh"
    "backend/main_dev_8001.py"
    "nagaiku-budget-frontend.service"
    "nagaiku-budget-backend.service"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file (見つかりません)"
    fi
done

# 環境判定
echo ""
echo "🎯 環境判定結果:"
if [ "${NODE_ENV}" = "production" ] || [ "${ENVIRONMENT}" = "production" ] || [ "${PORT}" = "8000" ]; then
    echo "  🏭 本番環境として判定"
    echo "    - フロントエンド: ポート3000"
    echo "    - バックエンド: ポート8000 (main.py)"
    echo "    - データベース: nagaiku_budget"
else
    echo "  📝 開発環境として判定"
    echo "    - フロントエンド: ポート3001"
    echo "    - バックエンド: ポート8001 (main_dev_8001.py)"
    echo "    - データベース: nagaiku_budget_dev"
fi

# 起動方法の案内
echo ""
echo "🚀 開発環境起動方法:"
echo "  1. 通常起動: ./start_development.sh"
echo "  2. tmux起動: ./start_dev_tmux.sh"
echo "  3. tmux簡易: ./start_dev_next_time.sh"

echo ""
echo "🕐 確認完了: $(date)" 