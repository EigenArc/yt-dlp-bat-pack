@echo off
setlocal EnableDelayedExpansion

:: ============================================================
::  MP3ダウンロード (音声のみ)
::  - 最高品質のオーディオからMP3 320kbps に変換
::  - サムネイル・メタデータを自動埋め込み
::  - 音楽プレイヤー・カーナビなど幅広い互換性
:: ============================================================

title [yt-dlp] MP3ダウンロード (音声のみ)

set "OUTPUT_DIR=%~dp0downloads\MP3"

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

:INPUT_URL
echo.
echo +======================================================+
echo :          MP3 ダウンロード (音声のみ)                  :
echo +======================================================+
echo :  最高品質オーディオからMP3に変換します                :
echo :  ビットレート: 320kbps (最高品質)                     :
echo :  サムネイル・メタデータも自動で埋め込みます          :
echo :  互換性が最も高い音声形式です                        :
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
echo +--------------------------------------------------+
echo :  音質を選択してください                          :
echo :                                                  :
echo :  [1] 最高音質 (320kbps)                          :
echo :  [2] 高音質   (256kbps)                          :
echo :  [3] 標準     (192kbps)                          :
echo :  [4] 軽量     (128kbps)                          :
echo :                                                  :
echo +--------------------------------------------------+
echo.
set "BITRATE_CHOICE="
set /p "BITRATE_CHOICE=番号を入力 (デフォルト: 1): "
if "%BITRATE_CHOICE%"=="" set "BITRATE_CHOICE=1"

if "%BITRATE_CHOICE%"=="1" (
    set "AUDIO_QUALITY=0"
    set "BITRATE_LABEL=320kbps"
) else if "%BITRATE_CHOICE%"=="2" (
    set "AUDIO_QUALITY=1"
    set "BITRATE_LABEL=256kbps"
) else if "%BITRATE_CHOICE%"=="3" (
    set "AUDIO_QUALITY=2"
    set "BITRATE_LABEL=192kbps"
) else if "%BITRATE_CHOICE%"=="4" (
    set "AUDIO_QUALITY=5"
    set "BITRATE_LABEL=128kbps"
) else (
    set "AUDIO_QUALITY=0"
    set "BITRATE_LABEL=320kbps"
)

echo.
echo ===================================================
echo  [*] ダウンロード開始: MP3 %BITRATE_LABEL%
echo ===================================================
echo.

yt-dlp ^
    -f "bestaudio/best" ^
    -x --audio-format mp3 ^
    --audio-quality %AUDIO_QUALITY% ^
    --embed-thumbnail ^
    --embed-metadata ^
    --convert-thumbnails jpg ^
    --windows-filenames ^
    --no-playlist ^
    --progress ^
    --console-title ^
    -o "%OUTPUT_DIR%\%%(title)s [%%(id)s] [%%(resolution)s_%%(format_id)s].%%(ext)s" ^
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
