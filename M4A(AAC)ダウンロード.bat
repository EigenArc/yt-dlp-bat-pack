@echo off
setlocal EnableDelayedExpansion

:: ============================================================
::  M4Aダウンロード (音声のみ・音質重視)
:: ============================================================

title [yt-dlp] M4Aダウンロード (音声のみ・音質重視)

set "OUTPUT_DIR=%~dp0downloads\M4A"

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

:INPUT_URL
echo.
echo +======================================================+
echo :        M4A ダウンロード (音声のみ・音質重視)          :
echo +======================================================+
echo :  YouTubeの元音声(AAC)をそのまま取得します            :
echo :  再エンコードなし = 劣化ゼロ                         :
echo :  Apple Music / iTunes と親和性が高い形式です         :
echo :  サムネイル・メタデータも自動で埋め込みます          :
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
echo  [*] ダウンロード開始: M4A (無劣化)
echo ===================================================
echo.
yt-dlp ^
    -f "bestaudio[ext=m4a]/bestaudio" ^
    --embed-thumbnail ^
    --embed-metadata ^
    --convert-thumbnails jpg ^
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
