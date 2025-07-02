@echo off
echo ========================================
echo   NPO法人助成金管理システム 起動中...
echo ========================================
echo.

:: 仮想環境をアクティベート
call venv\Scripts\activate.bat

:: 必要なパッケージがインストールされているか確認
echo パッケージの確認中...
pip install -r requirements.txt --quiet

:: 既存のStreamlitプロセスを停止
echo 既存のプロセスをチェック中...
for /f "tokens=2" %%i in ('tasklist /fi "imagename eq python.exe" /fo csv ^| findstr "streamlit"') do (
    echo 既存のStreamlitプロセス %%i を停止しています...
    taskkill /f /pid %%i >nul 2>&1
)

:: ポート8531を使用しているプロセスを停止
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8531') do (
    echo ポート8531を使用中のプロセス %%a を停止しています...
    taskkill /f /pid %%a >nul 2>&1
)

:: 少し待機
timeout /t 2 /nobreak >nul

:: IPアドレスを取得して表示
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /i "IPv4"') do (
    set "ip=%%a"
    goto :found
)
:found
set ip=%ip: =%

:: Streamlitアプリを起動
echo.
echo アプリケーションを起動しています...
echo.
echo 【アクセス方法】
echo ・このPCから: http://localhost:8531
echo ・社内の他のPCから: http://%ip%:8531
echo.
echo 🔗 社内共有用URL: http://%ip%:8531
echo.
echo アプリを終了するには、このウィンドウでCtrl+Cを押してください。
echo.

streamlit run main_aggrid.py --server.port 8531 --server.address 0.0.0.0

pause 