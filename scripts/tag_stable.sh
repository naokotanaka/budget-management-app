#!/bin/bash

# 安定版タグ作成スクリプト
# 正常動作を確認した時点で実行

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# カラー出力
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

cd "$PROJECT_DIR"

echo -e "${BLUE}=== 安定版タグ作成 ===${NC}"

# 現在の状態を確認
if ! git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}警告: コミットされていない変更があります${NC}"
    git status --short
    echo ""
    read -p "変更をコミットしてからタグを作成しますか？ (y/N) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add -A
        read -p "コミットメッセージ: " commit_msg
        git commit -m "$commit_msg"
    else
        echo -e "${RED}タグ作成をキャンセルしました${NC}"
        exit 1
    fi
fi

# タグ名の生成
DATE_STR=$(date +%Y%m%d_%H%M%S)
DEFAULT_TAG="stable-$DATE_STR"

echo -e "${YELLOW}タグ名を入力してください（デフォルト: $DEFAULT_TAG）${NC}"
read -p "タグ名: " tag_name
tag_name=${tag_name:-$DEFAULT_TAG}

# メモの入力
echo -e "${YELLOW}このバージョンの説明を入力してください${NC}"
echo "例: 本番環境で正常動作確認、freee連携機能追加後"
read -p "説明: " tag_message

# タグの作成
if git tag -a "$tag_name" -m "$tag_message" 2>/dev/null; then
    echo -e "${GREEN}✓ タグ '$tag_name' を作成しました${NC}"
    
    # タグ情報を表示
    echo ""
    echo -e "${BLUE}タグ情報:${NC}"
    git show "$tag_name" --no-patch
    
    # 最近のタグを表示
    echo ""
    echo -e "${BLUE}最近の安定版タグ:${NC}"
    git tag -l "stable-*" --sort=-creatordate | head -5
    
    # 使い方を表示
    echo ""
    echo -e "${GREEN}=== このバージョンに戻す方法 ===${NC}"
    echo "git checkout $tag_name"
    echo ""
    echo -e "${GREEN}=== 最新版に戻す方法 ===${NC}"
    echo "git checkout main"
else
    echo -e "${RED}エラー: タグの作成に失敗しました${NC}"
    exit 1
fi