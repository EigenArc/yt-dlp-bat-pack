@echo off
setlocal EnableDelayedExpansion

:: ============================================================
::  OPUSダウンロード (音声のみ・高効率)
:: ============================================================

title [yt-dlp] OPUSダウンロード (音声のみ・高効率)

set "OUTPUT_DIR=%~dp0downloads\OPUS"

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

:INPUT_URL
echo.
echo +======================================================+
echo :       OPUS ダウンロード (音声のみ・高効率)            :
echo +======================================================+
echo :  同ビットレートでMP3/AACより高音質な最新コーデック    :
echo :  YouTubeの元音声(Opus)をそのまま無劣化で取得         :
echo :  再エンコードなし = 劣化ゼロ                         :
echo :  Discord / VLC 等で再生可能                          :
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
echo  [*] ダウンロード開始: OPUS (無劣化)
echo ===================================================
echo.

yt-dlp ^
    -f "bestaudio[ext=webm]/bestaudio/best" ^
    -x --audio-format opus ^
    --embed-metadata ^
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
