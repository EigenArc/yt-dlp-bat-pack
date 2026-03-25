@echo off
setlocal EnableDelayedExpansion

:: ==============================================================================
:: MKV 最高品質ダウンロード v2
:: ==============================================================================

title [yt-dlp] MKV 最高品質ダウンロード v2

set "OUTPUT_DIR=%~dp0downloads\MKV"

if not exist "!OUTPUT_DIR!" mkdir "!OUTPUT_DIR!"

:INPUT_LOOP
cls
echo +================================================+
echo   MKV 最高品質ダウンロード v2 (VP9/AV1等対応)
echo +================================================+
echo.

set "VIDEO_URL="
set /p "VIDEO_URL=動画のURLを入力してEnter (右クリックで貼り付け): "

if "!VIDEO_URL!"=="" (
    echo [エラー] URLが入力されていません。
    timeout /t 2 >nul
    goto :INPUT_LOOP
)

set "VIDEO_URL=!VIDEO_URL:"=!"
for /f "tokens=* delims= " %%a in ("!VIDEO_URL!") do set "VIDEO_URL=%%a"

echo.
echo +================================================+
echo 動画情報を取得中...
echo +================================================+

set "TMP_INFO=%TEMP%\ytdlp_height_!RANDOM!.tmp"

yt-dlp --no-playlist -f "bestvideo" --print "%%(height)s" "!VIDEO_URL!" > "!TMP_INFO!" 2>nul
set "MAX_HEIGHT="
if exist "!TMP_INFO!" (
    for /f "usebackq delims=" %%h in ("!TMP_INFO!") do set "MAX_HEIGHT=%%h"
)
if exist "!TMP_INFO!" del "!TMP_INFO!" >nul 2>&1

if not defined MAX_HEIGHT set "MAX_HEIGHT=1080"

echo.
echo [*] 最大解像度: !MAX_HEIGHT!p
echo.
echo +------------------------------------------------+
echo [*] 画質を選択してください
echo +------------------------------------------------+
echo [1] 最高画質 (ソースを維持)

set "OPT_4K=0" & set "OPT_2K=0" & set "OPT_FHD=0" & set "OPT_HD=0"

if !MAX_HEIGHT! GEQ 2160 ( echo [2] 4K (2160p) & set "OPT_4K=1" )
if !MAX_HEIGHT! GEQ 1440 ( echo [3] 2K (1440p) & set "OPT_2K=1" )
if !MAX_HEIGHT! GEQ 1080 ( echo [4] Full HD (1080p) & set "OPT_FHD=1" )
if !MAX_HEIGHT! GEQ 720  ( echo [5] HD (720p) & set "OPT_HD=1" )
echo [6] SD (480p) 以下
echo +------------------------------------------------+

set "Q_CHOICE="
set /p "Q_CHOICE=番号を入力してください [1-6] (未入力: 1): "
if "!Q_CHOICE!"=="" set "Q_CHOICE=1"

set "HEIGHT_LIMIT="
if "!Q_CHOICE!"=="2" if "!OPT_4K!"=="1" set "HEIGHT_LIMIT=2160"
if "!Q_CHOICE!"=="3" if "!OPT_2K!"=="1" set "HEIGHT_LIMIT=1440"
if "!Q_CHOICE!"=="4" if "!OPT_FHD!"=="1" set "HEIGHT_LIMIT=1080"
if "!Q_CHOICE!"=="5" if "!OPT_HD!"=="1" set "HEIGHT_LIMIT=720"
if "!Q_CHOICE!"=="6" set "HEIGHT_LIMIT=480"

echo.
echo +================================================+
if defined HEIGHT_LIMIT (
    echo [*] ダウンロード開始: 最大 !HEIGHT_LIMIT!p
    set "DL_FORMAT=bestvideo[height<=!HEIGHT_LIMIT!]+bestaudio/best[height<=!HEIGHT_LIMIT!]/best"
) else (
    echo [*] ダウンロード開始: 最高画質
    set "DL_FORMAT=bestvideo+bestaudio/best"
)
echo +================================================+
echo.

yt-dlp ^
    -f "!DL_FORMAT!" ^
    --merge-output-format mkv ^
    --embed-thumbnail ^
    --embed-metadata ^
    --embed-subs ^
    --sub-langs "ja,en,ja-*,en-*" ^
    --convert-thumbnails jpg ^
    --windows-filenames ^
    --no-playlist ^
    --progress ^
    --console-title ^
    -o "!OUTPUT_DIR!\%%(title)s [%%(id)s] [%%(resolution)s_%%(format_id)s].%%(ext)s" ^
    "!VIDEO_URL!"

if !ERRORLEVEL! EQU 0 (
    echo.
    echo +================================================+
    echo [OK] ダウンロードが正常に完了しました！
    echo 保存先: !OUTPUT_DIR!
    echo +================================================+
) else (
    echo.
    echo +================================================+
    echo [NG] ダウンロード中にエラーが発生しました。
    echo 終了コード: !ERRORLEVEL!
    echo +================================================+
)

echo.
set "Q_RETRY="
set /p "Q_RETRY=続けて別の動画をダウンロードしますか？ (y/n): "
if /i "!Q_RETRY!"=="y" goto :INPUT_LOOP

echo 処理を終了します...
timeout /t 2 >nul
exit /b 0
