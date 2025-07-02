@echo off
chcp 65001 >nul
echo ========================================
echo   NPO法人助成金管理システム 起動中...
echo ========================================
echo.

:: 仮想環境をアクティベート
echo 仮想環境をアクティベート中...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo エラー: 仮想環境のアクティベートに失敗しました
    pause
    exit /b 1
)

:: 必要なパッケージがインストールされているか確認
echo パッケージの確認中...
pip install -r requirements.txt --quiet

:: 既存のStreamlitプロセスを停止
echo 既存のプロセスをチェック中...
tasklist /fi "imagename eq python.exe" /fo table 2>nul | findstr streamlit >nul
if not errorlevel 1 (
    echo 既存のStreamlitプロセスを停止しています...
    taskkill /f /im python.exe /fi "windowtitle eq streamlit*" >nul 2>&1
)

:: ポート8531を使用しているプロセスを停止
echo ポート8531をチェック中...
for /f "tokens=5" %%a in ('netstat -aon 2^>nul ^| findstr :8531') do (
    echo ポート8531使用中のプロセス %%a を停止しています...
    taskkill /f /pid %%a >nul 2>&1
)

:: 少し待機
timeout /t 2 /nobreak >nul

:: IPアドレスを取得
set "local_ip="
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4 Address"') do (
    set "temp_ip=%%a"
    call :trim temp_ip
    if not "!temp_ip!"=="127.0.0.1" (
        set "local_ip=!temp_ip!"
        goto :ip_found
    )
)
:ip_found

:: 環境変数を有効化
setlocal enabledelayedexpansion

:: Streamlitアプリを起動
echo.
echo アプリケーションを起動しています...
echo.
echo ========================================
echo 【アクセス方法】
echo ・このPCから: http://localhost:8531
if defined local_ip (
    echo ・社内の他のPCから: http://!local_ip!:8531
echo.
    echo 🔗 社内共有用URL: http://!local_ip!:8531
) else (
    echo ・社内の他のPCから: IPアドレスを確認してください
)
echo ========================================
echo.
echo アプリを終了するには、このウィンドウでCtrl+Cを押してください。
echo.

streamlit run main_aggrid.py --server.port 8531 --server.address 0.0.0.0

goto :end

:trim
set %1=!%1: =!
exit /b

:end

pause 