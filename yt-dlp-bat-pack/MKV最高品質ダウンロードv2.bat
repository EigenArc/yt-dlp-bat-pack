@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ==============================================================================
:: MKV 最高品質ダウンロード v2 (VP9/AV1/H.265など全対応)
::
:: [機能要件に基づく設計]
:: FR-01/02: cmd.exe依存、.exeの明示的な呼び出し
:: FR-04/06: goto分岐、遅延展開(!VAR!)と拡張の活用
:: FR-05   : set "VAR=value" での安全な変数定義と文字列エスケープ回避
:: FR-07   : !ERRORLEVEL! による終了コード判定と exit /b 終了
:: FR-08/09: chcp 932 による日本語(Shift-JIS)互換性の確保
:: ==============================================================================

chcp 932 >nul

title [yt-dlp] MKV最高品質ダウンロード v2

:: ディレクトリ定義
set "OUTPUT_DIR=%~dp0downloads\MKV"

:: 出力フォルダ確保
if not exist "!OUTPUT_DIR!" (
    mkdir "!OUTPUT_DIR!"
)

:INPUT_LOOP
cls
echo ==================================================
echo   MKV 最高品質ダウンロード v2 (安定性・堅牢性重視)
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
echo [*] ダウンロード開始: 最高画質 (MKV)
set "DL_FORMAT=bestvideo+bestaudio/best"
echo ==================================================
echo.

:: yt-dlp 本体呼び出し
yt-dlp ^
    -f "!DL_FORMAT!" ^
    --merge-output-format mkv ^
    --embed-thumbnail ^
    --embed-metadata ^
    --embed-subs ^
    --embed-chapters ^
    --sub-langs "all" ^
    --convert-thumbnails png ^
    --sponsorblock-mark all ^
    --write-info-json ^
    --windows-filenames ^
    --no-playlist ^
    --progress ^
    --console-title ^
    -o "!OUTPUT_DIR!\%%(title)s [%%(id)s] [%%(resolution)s_%%(format_id)s].%%(ext)s" ^
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