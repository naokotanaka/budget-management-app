# systemd サービス管理ガイド

## 🎯 概要

本番環境をsystemdサービスとして管理することで、以下のメリットがあります：
- 自動起動・再起動
- サービス状態の一元管理  
- ログの統合管理
- システム再起動時の自動復旧

## 🚀 初期設定

### systemdサービスのインストール
```bash
# 実行権限付与
chmod +x install_systemd_services.sh

# systemdサービス設定実行
./install_systemd_services.sh
```

## 📋 日常管理コマンド

### サービス制御
```bash
# 本番環境起動
sudo systemctl start nagaiku-budget-backend
sudo systemctl start nagaiku-budget-frontend

# 本番環境停止
sudo systemctl stop nagaiku-budget-backend
sudo systemctl stop nagaiku-budget-frontend

# 本番環境再起動
sudo systemctl restart nagaiku-budget-backend
sudo systemctl restart nagaiku-budget-frontend

# 本番環境全体の制御
sudo systemctl start nagaiku-budget-*
sudo systemctl stop nagaiku-budget-*
sudo systemctl restart nagaiku-budget-*
```

### 状態確認
```bash
# サービス状態確認
sudo systemctl status nagaiku-budget-backend
sudo systemctl status nagaiku-budget-frontend

# すべてのサービス状態
sudo systemctl status nagaiku-budget-*

# プロセス確認
ss -tlnp | grep -E "(3000|8000)"
```

### 自動起動設定
```bash
# 自動起動有効化（システム再起動時に自動開始）
sudo systemctl enable nagaiku-budget-backend
sudo systemctl enable nagaiku-budget-frontend

# 自動起動無効化
sudo systemctl disable nagaiku-budget-backend
sudo systemctl disable nagaiku-budget-frontend
```

## 📝 ログ管理

### システムログ（journalctl）
```bash
# リアルタイムログ確認
sudo journalctl -u nagaiku-budget-backend -f
sudo journalctl -u nagaiku-budget-frontend -f

# 過去のログ確認
sudo journalctl -u nagaiku-budget-backend --since "1 hour ago"
sudo journalctl -u nagaiku-budget-frontend --since "today"

# ログサイズ確認
sudo journalctl --disk-usage
```

### アプリケーションログ
```bash
# ファイル出力ログ
tail -f logs/backend_prod.log
tail -f logs/frontend_prod.log

# エラーログ検索
grep -i error logs/backend_prod.log
grep -i error logs/frontend_prod.log
```

## 🔧 トラブルシューティング

### サービス起動失敗
```bash
# 詳細なエラー情報確認
sudo systemctl status nagaiku-budget-backend -l
sudo journalctl -u nagaiku-budget-backend --no-pager

# 設定ファイル確認
sudo systemctl cat nagaiku-budget-backend
```

### サービス再読み込み
```bash
# サービスファイル変更後
sudo systemctl daemon-reload
sudo systemctl restart nagaiku-budget-backend
sudo systemctl restart nagaiku-budget-frontend
```

### ポート競合
```bash
# ポート使用状況確認
sudo lsof -i :3000
sudo lsof -i :8000

# 競合プロセス停止
sudo kill $(lsof -ti:3000 8000)
```

## 🔄 デプロイ手順（systemd版）

### 通常のデプロイ
```bash
# 1. サービス停止
sudo systemctl stop nagaiku-budget-frontend
sudo systemctl stop nagaiku-budget-backend

# 2. コード更新（git pull等）

# 3. フロントエンドビルド
cd frontend
rm -rf .next out
NODE_ENV=production npm run build
cd ..

# 4. サービス開始
sudo systemctl start nagaiku-budget-backend
sudo systemctl start nagaiku-budget-frontend

# 5. 状態確認
sudo systemctl status nagaiku-budget-*
```

### ゼロダウンタイムデプロイ
```bash
# 1. バックエンド更新
sudo systemctl restart nagaiku-budget-backend
sleep 5

# 2. フロントエンド更新
sudo systemctl restart nagaiku-budget-frontend

# 3. 確認
curl http://160.251.170.97:8000/docs
curl http://160.251.170.97:3000
```

## 🛡️ セキュリティ設定

### サービスファイル権限
```bash
# 適切な権限設定
sudo chmod 644 /etc/systemd/system/nagaiku-budget-*.service
sudo chown root:root /etc/systemd/system/nagaiku-budget-*.service
```

### ユーザー権限
```bash
# 非特権ユーザーで実行（設定済み）
User=tanaka
Group=tanaka
```

## 📊 監視・メンテナンス

### 定期確認項目
```bash
# サービス状態
sudo systemctl is-active nagaiku-budget-*

# リソース使用量
sudo systemctl show nagaiku-budget-backend --property=MainPID
ps -p $(sudo systemctl show nagaiku-budget-backend --property=MainPID --value) -o pid,ppid,cmd,%mem,%cpu

# ログローテーション
sudo journalctl --vacuum-time=30d
```

### 自動監視スクリプト例
```bash
#!/bin/bash
# health_check.sh

for service in nagaiku-budget-backend nagaiku-budget-frontend; do
    if ! sudo systemctl is-active --quiet $service; then
        echo "⚠️ $service is not running"
        sudo systemctl restart $service
    else
        echo "✅ $service is running"
    fi
done
```

## 🔗 統合コマンド

### 開発から本番への切り替え
```bash
# 開発環境停止
./stop_development.sh

# 本番環境開始（systemd）
sudo systemctl start nagaiku-budget-*
```

### システム再起動時の自動復旧
```bash
# 自動起動設定確認
sudo systemctl is-enabled nagaiku-budget-*

# 設定済みなら、システム再起動後に自動開始
sudo reboot
```

---

> 💡 **Tips**: systemdサービスは`sudo`権限が必要ですが、一度設定すれば安定した本番運用が可能です。開発時は従来のスクリプトを使用し、本番運用時はsystemdサービスを使用することをお勧めします。 