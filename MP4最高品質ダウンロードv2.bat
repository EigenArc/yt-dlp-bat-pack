@echo off
setlocal EnableExtensions EnableDelayedExpansion


chcp 932 >nul

title [yt-dlp] MP4最高品質ダウンロード v2

:: ディレクトリ定義
set "OUTPUT_DIR=%~dp0downloads\MP4"

:: 出力フォルダ確保
if not exist "!OUTPUT_DIR!" (
    mkdir "!OUTPUT_DIR!"
)

:INPUT_LOOP
cls
echo ==================================================
echo   MP4 最高品質ダウンロード v2 (安定性・堅牢性重視)
echo ==================================================
echo.

set "VIDEO_URL="
set /p "VIDEO_URL=動画のURLを入力してEnter（右クリックで貼り付け）: "

:: 入力妥当性チェック
if "!VIDEO_URL!"=="" (
    echo [エラー] URLが入力されていません。
    timeout /t 2 >nul
    goto :INPUT_LOOP
)

:: 引用符の除去と端の空白除去
set "VIDEO_URL=!VIDEO_URL:"=!"
for /f "tokens=* delims= " %%a in ("!VIDEO_URL!") do set "VIDEO_URL=%%a"

echo.
echo ==================================================
echo [*] ダウンロード開始: 最高画質 (MP4)
set "DL_FORMAT=bestvideo[ext=mp4][vcodec^=avc1]+bestaudio[ext=m4a]/bestvideo[ext=mp4][vcodec^=avc1]+bestaudio[ext=mp4]/bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo[ext=mp4]+bestaudio[ext=mp4]/b[ext=mp4]/best"
echo ==================================================
echo.

:: yt-dlp 本体呼び出し
yt-dlp ^
    -f "!DL_FORMAT!" ^
    --merge-output-format mp4 ^
    --embed-thumbnail ^
    --embed-metadata ^
    --embed-subs ^
    --sub-langs "ja,en,ja-*,en-*" ^
    --convert-thumbnails jpg ^
    --sponsorblock-mark all ^
    --windows-filenames ^
    --no-playlist ^
    --progress ^
    --console-title ^
    -o "!OUTPUT_DIR!\%%(title)s [%%(id)s].%%(ext)s" ^
    "!VIDEO_URL!"

:: 終了処理
if !ERRORLEVEL! EQU 0 (
    echo.
    echo ==================================================
    echo [ OK ] ダウンロードが正常に完了しました！
    echo 保存先: !OUTPUT_DIR!
    echo ==================================================
) else (
    echo.
    echo ==================================================
    echo [ NG ] ダウンロード中にエラーが発生しました。
    echo 終了コード: !ERRORLEVEL!
    echo ==================================================
)

echo.
set "Q_RETRY="
set /p "Q_RETRY=続けて別の動画をダウンロードしますか？ (y/n): "
if /i "!Q_RETRY!"=="y" goto :INPUT_LOOP

echo 処理を終了します...
timeout /t 2 >nul
exit /b 0