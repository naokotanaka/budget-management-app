# NPO法人助成金管理システム PowerShell起動スクリプト
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  NPO法人助成金管理システム 起動中..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# スクリプトのディレクトリに移動
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath
Write-Host "作業ディレクトリ: $(Get-Location)" -ForegroundColor Yellow

# 仮想環境の確認とアクティベート
if (Test-Path "venv\Scripts\Activate.ps1") {
    Write-Host "仮想環境をアクティベート中..." -ForegroundColor Green
    try {
        & "venv\Scripts\Activate.ps1"
        Write-Host "仮想環境アクティベート完了" -ForegroundColor Green
    }
    catch {
        Write-Host "エラー: 仮想環境のアクティベートに失敗しました" -ForegroundColor Red
        Write-Host "ExecutionPolicy を確認してください: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor Yellow
        Write-Host "または venv\Scripts\activate.bat を使用してください" -ForegroundColor Yellow
        pause
        exit 1
    }
}
elseif (Test-Path "venv\Scripts\activate.bat") {
    Write-Host "仮想環境をアクティベート中 (bat版)..." -ForegroundColor Green
    cmd /c "venv\Scripts\activate.bat && echo 仮想環境アクティベート完了"
}
else {
    Write-Host "エラー: 仮想環境が見つかりません" -ForegroundColor Red
    Write-Host "python -m venv venv でvenv作成後、再実行してください" -ForegroundColor Yellow
    pause
    exit 1
}

# 必要なパッケージのインストール確認
if (Test-Path "requirements.txt") {
    Write-Host "パッケージの確認中..." -ForegroundColor Green
    try {
        pip install -r requirements.txt --quiet
        Write-Host "パッケージ確認完了" -ForegroundColor Green
    }
    catch {
        Write-Host "警告: パッケージインストールで問題が発生しました" -ForegroundColor Yellow
    }
}
else {
    Write-Host "警告: requirements.txt が見つかりません" -ForegroundColor Yellow
}

# メインアプリファイルの存在確認
if (-not (Test-Path "src/main_aggrid.py")) {
    Write-Host "エラー: src/main_aggrid.py が見つかりません" -ForegroundColor Red
    pause
    exit 1
}

# 既存のStreamlitプロセスを停止
Write-Host "既存のプロセスをチェック中..." -ForegroundColor Green
$streamlitProcesses = Get-Process | Where-Object { $_.ProcessName -eq "python" -and $_.MainWindowTitle -like "*streamlit*" }
if ($streamlitProcesses) {
    Write-Host "既存のStreamlitプロセスを停止しています..." -ForegroundColor Yellow
    $streamlitProcesses | Stop-Process -Force
}

# ポート8531を使用しているプロセスを確認
Write-Host "ポート8531をチェック中..." -ForegroundColor Green
$portProcess = Get-NetTCPConnection -LocalPort 8531 -ErrorAction SilentlyContinue
if ($portProcess) {
    Write-Host "ポート8531使用中のプロセスを停止しています..." -ForegroundColor Yellow
    Stop-Process -Id $portProcess.OwningProcess -Force -ErrorAction SilentlyContinue
}

# 少し待機
Start-Sleep -Seconds 2

# IPアドレスを取得
$localIP = ""
try {
    $networkAdapters = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.*" }
    if ($networkAdapters) {
        $localIP = $networkAdapters[0].IPAddress
    }
}
catch {
    Write-Host "ローカルIPアドレスの取得に失敗しました" -ForegroundColor Yellow
}

# Streamlitアプリを起動
Write-Host ""
Write-Host "アプリケーションを起動しています..." -ForegroundColor Green
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "【アクセス方法】" -ForegroundColor White
Write-Host "・このPCから: http://localhost:8531" -ForegroundColor Green
if ($localIP) {
    Write-Host "・社内の他のPCから: http://$localIP:8531" -ForegroundColor Green
    Write-Host ""
    Write-Host "🔗 社内共有用URL: http://$localIP:8531" -ForegroundColor Yellow
}
else {
    Write-Host "・社内の他のPCから: IPアドレスを確認してください" -ForegroundColor Yellow
}
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "アプリを終了するには、このウィンドウでCtrl+Cを押してください。" -ForegroundColor White
Write-Host ""
Write-Host "Streamlitを起動中..." -ForegroundColor Green

# Streamlit起動
try {
    streamlit run src/main_aggrid.py --server.port 8531 --server.address 0.0.0.0 --server.headless true
}
catch {
    Write-Host ""
    Write-Host "エラー: Streamlitの起動に失敗しました" -ForegroundColor Red
    Write-Host "エラー詳細: $_" -ForegroundColor Red
}
finally {
    Write-Host ""
    Write-Host "アプリケーションが終了しました。" -ForegroundColor Yellow
    pause
} 