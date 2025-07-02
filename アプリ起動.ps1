# NPO法人助成金管理システム 起動スクリプト
Write-Host "========================================" -ForegroundColor Green
Write-Host "  NPO法人助成金管理システム 起動中..." -ForegroundColor Green  
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# 仮想環境をアクティベート
Write-Host "仮想環境をアクティベート中..." -ForegroundColor Yellow
& .\venv\Scripts\Activate.ps1

# 必要なパッケージがインストールされているか確認
Write-Host "パッケージの確認・インストール中..." -ForegroundColor Yellow
pip install -r requirements.txt --quiet

# Streamlitアプリを起動
Write-Host ""
Write-Host "アプリケーションを起動しています..." -ForegroundColor Green
Write-Host "ブラウザが自動で開きます。開かない場合は以下のURLにアクセスしてください：" -ForegroundColor Cyan
Write-Host "http://localhost:8501" -ForegroundColor Cyan
Write-Host ""
Write-Host "アプリを終了するには、このウィンドウでCtrl+Cを押してください。" -ForegroundColor Red
Write-Host ""

streamlit run main.py 