@echo off
setlocal EnableDelayedExpansion

:: ============================================================
::  AACダウンロード (音声のみ・音質重視)
::  - AAC-LC / HE-AAC で高音質を実現
::  - MP3より高音質・高効率
::  - iPhone / Android / Windows 全対応
:: ============================================================

title [yt-dlp] AACダウンロード (音声のみ・音質重視)

set "OUTPUT_DIR=%~dp0downloads\AAC"

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

:INPUT_URL
echo.
echo +======================================================+
echo :        AAC ダウンロード (音声のみ・音質重視)          :
echo +======================================================+
echo :  MP3より高音質・高効率なAAC形式です                   :
echo :  iPhone / Android / Windows 全て対応                 :
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
echo +--------------------------------------------------+
echo :  音質を選択してください                          :
echo :                                                  :
echo :  [1] 最高音質 (256kbps VBR)                      :
echo :  [2] 高音質   (192kbps VBR)                      :
echo :  [3] 標準     (128kbps VBR)                      :
echo :                                                  :
echo +--------------------------------------------------+
echo.
set "BITRATE_CHOICE="
set /p "BITRATE_CHOICE=番号を入力 (デフォルト: 1): "
if "%BITRATE_CHOICE%"=="" set "BITRATE_CHOICE=1"

if "%BITRATE_CHOICE%"=="1" (
    set "AUDIO_QUALITY=0"
    set "BITRATE_LABEL=256kbps VBR (最高音質)"
) else if "%BITRATE_CHOICE%"=="2" (
    set "AUDIO_QUALITY=2"
    set "BITRATE_LABEL=192kbps VBR"
) else if "%BITRATE_CHOICE%"=="3" (
    set "AUDIO_QUALITY=5"
    set "BITRATE_LABEL=128kbps VBR"
) else (
    set "AUDIO_QUALITY=0"
    set "BITRATE_LABEL=256kbps VBR (最高音質)"
)

echo.
echo ===================================================
echo  [*] ダウンロード開始: AAC %BITRATE_LABEL%
echo ===================================================
echo.

yt-dlp ^
    -f "bestaudio[ext=m4a]/bestaudio/best" ^
    -x --audio-format aac ^
    --audio-quality %AUDIO_QUALITY% ^
    --postprocessor-args "ffmpeg:-cutoff 20000" ^
    --embed-thumbnail ^
    --embed-metadata ^
    --convert-thumbnails jpg ^
    --windows-filenames ^
    --no-playlist ^
    --progress ^
    --console-title ^
    -o "%OUTPUT_DIR%\%%(title)s [%%(id)s] [%%(resolution)s_%%(format_id)s].%%(ext)s" ^
    "%URL%"

if !ERRORLEVEL! EQU 0 (
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
