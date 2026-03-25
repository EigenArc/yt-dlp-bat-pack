@echo off
setlocal EnableDelayedExpansion

:: ============================================================
::  WAVダウンロード (非圧縮音声)
::  - 完全無圧縮のPCM音声
::  - DAW(音楽制作ソフト)等での編集に最適
::  - ファイルサイズが非常に大きい
:: ============================================================

title [yt-dlp] WAVダウンロード (非圧縮音声)

set "OUTPUT_DIR=%~dp0downloads\WAV"

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

:INPUT_URL
echo.
echo +======================================================+
echo :        WAV ダウンロード (非圧縮音声)                  :
echo +======================================================+
echo :  完全無圧縮のPCM音声をダウンロードします             :
echo :  DAW(音楽制作ソフト)での編集やサンプリングに最適     :
echo :  ※ ファイルサイズが非常に大きくなります              :
echo :  ※ 元音源は圧縮音声のため品質は元音源と同等です     :
echo +======================================================+
echo.
set "URL="
set /p "URL=動画のURLを貼り付けてください: "

if "%URL%"=="" (
    echo [エラー] URLが入力されていません。
    goto :INPUT_URL
)

set "URL=%URL:"=%"
for /f "tokens=* delims= " %%a in ("%URL%") do set "URL=%%a"

echo.
echo ===================================================
echo  [*] ダウンロード開始: WAV (非圧縮)
echo ===================================================
echo.

yt-dlp ^
    -f "bestaudio/best" ^
    -x --audio-format wav ^
    --windows-filenames ^
    --no-playlist ^
    --progress ^
    --console-title ^
    -o "%OUTPUT_DIR%\%%(title)s [%%(id)s].%%(ext)s" ^
    "%URL%"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo +======================================================+
    echo :  [OK] ダウンロード完了!                               :
    echo :  保存先: %OUTPUT_DIR%
    echo +======================================================+
) else (
    echo.
    echo +======================================================+
    echo :  [NG] ダウンロードに失敗しました                      :
    echo :  URLが正しいか確認してください                        :
    echo +======================================================+
)

echo.
set "CONTINUE="
set /p "CONTINUE=別の動画をダウンロードしますか? (Y/N): "
if /i "%CONTINUE%"=="Y" goto :INPUT_URL
if /i "%CONTINUE%"=="y" goto :INPUT_URL

echo.
echo 処理を終了します...
timeout /t 2 >nul
endlocal
exit /b 0
