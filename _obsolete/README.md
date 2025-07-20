# 非推奨スクリプトファイル

このディレクトリには、本番環境のsystemd移行に伴い非推奨となったスクリプトファイルが保存されています。

## 非推奨となった理由

本番環境の管理方法を手動スクリプトからsystemdサービスに変更したため、以下のスクリプトは使用されません：

- `start_production.sh.bak` - 本番環境手動起動（systemdに移行）
- `stop_production.sh.bak` - 本番環境手動停止（systemdに移行）
- `start.sh.bak` - 汎用起動スクリプト（開発/本番で紛らわしいため）
- `stop.sh.bak` - 汎用停止スクリプト（開発/本番で紛らわしいため）

## 現在の本番環境管理方法

```bash
# 本番環境起動
sudo systemctl start nagaiku-budget-backend
sudo systemctl start nagaiku-budget-frontend

# 本番環境停止
sudo systemctl stop nagaiku-budget-backend
sudo systemctl stop nagaiku-budget-frontend

# 状態確認
sudo systemctl status nagaiku-budget-*
```

## 開発環境管理方法

開発環境用のスクリプトは引き続き使用可能です：

```bash
# 開発環境起動
./start_development.sh

# 開発環境停止
./stop_development.sh

# tmux開発環境
./start_dev_tmux.sh
```

これらのファイルは将来削除される可能性がありますが、参考のため一時的に保存されています。 