@echo off
setlocal EnableDelayedExpansion

title [yt-dlp] プレイリスト一括ダウンロード

set "OUTPUT_DIR=%~dp0downloads"
set "ARCHIVE_FILE=%~dp0downloads\download_archive.txt"

:INPUT_URL
cls
echo.
echo  プレイリスト一括ダウンロード
echo  番号付きファイル名 / アーカイブ機能で重複防止
echo.
set "URL="
set /p "URL=プレイリストURLを貼り付け: "
if "%URL%"=="" goto :INPUT_URL
set "URL=%URL:"=%"

echo.
echo  [1] MP4 (互換性重視)  [2] MKV (最高品質)
echo  [3] MP3 (320kbps)     [4] M4A (無劣化)
echo  [5] FLAC (ロスレス)
echo.
set "FC="
set /p "FC=形式を選択 (デフォルト:1): "
if "%FC%"=="" set "FC=1"

set "TH=9999"
if "%FC%"=="1" goto :PL_VQ
if "%FC%"=="2" goto :PL_VQ
goto :PL_DL

:PL_VQ
echo.
echo  [1] 最高画質 [2] 1440p [3] 1080p [4] 720p [5] 480p
set "VQ="
set /p "VQ=画質 (デフォルト:1): "
if "%VQ%"=="2" set "TH=1440"
if "%VQ%"=="3" set "TH=1080"
if "%VQ%"=="4" set "TH=720"
if "%VQ%"=="5" set "TH=480"

:PL_DL
echo.
echo  ダウンロード開始...
echo.

if "%FC%"=="1" (
    set "OD=%~dp0downloads\MP4"
    if not exist "!OD!" mkdir "!OD!"
    yt-dlp -f "bestvideo[height<=!TH!][ext=mp4][vcodec^=avc1]+bestaudio[ext=m4a]/bestvideo[height<=!TH!][ext=mp4][vcodec^=avc1]+bestaudio[ext=mp4]/bestvideo[height<=!TH!][ext=mp4]+bestaudio[ext=m4a]/bestvideo[height<=!TH!][ext=mp4]+bestaudio[ext=mp4]/b[height<=!TH!][ext=mp4]/best" --merge-output-format mp4 --embed-thumbnail --embed-metadata --embed-subs --sub-langs "ja,en" --convert-thumbnails jpg --windows-filenames --yes-playlist --sleep-interval 3 --download-archive "%ARCHIVE_FILE%" --progress -o "!OD!\%%(playlist_title)s\%%(playlist_index)03d. %%(title)s [%%(id)s] [%%(resolution)s_%%(format_id)s].%%(ext)s" "%URL%"
)
if "%FC%"=="2" (
    set "OD=%~dp0downloads\MKV"
    if not exist "!OD!" mkdir "!OD!"
    yt-dlp -f "bestvideo[height<=!TH!]+bestaudio/best" --merge-output-format mkv --embed-thumbnail --embed-metadata --embed-subs --embed-chapters --sub-langs "all" --windows-filenames --yes-playlist --sleep-interval 3 --download-archive "%ARCHIVE_FILE%" --progress -o "!OD!\%%(playlist_title)s\%%(playlist_index)03d. %%(title)s [%%(id)s] [%%(resolution)s_%%(format_id)s].%%(ext)s" "%URL%"
)
if "%FC%"=="3" (
    set "OD=%~dp0downloads\MP3"
    if not exist "!OD!" mkdir "!OD!"
    yt-dlp -f "bestaudio/best" -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --embed-metadata --convert-thumbnails jpg --windows-filenames --yes-playlist --sleep-interval 3 --download-archive "%ARCHIVE_FILE%" --progress -o "!OD!\%%(playlist_title)s\%%(playlist_index)03d. %%(title)s [%%(id)s] [%%(resolution)s_%%(format_id)s].%%(ext)s" "%URL%"
)
if "%FC%"=="4" (
    set "OD=%~dp0downloads\M4A"
    if not exist "!OD!" mkdir "!OD!"
    yt-dlp -f "bestaudio[ext=m4a]/bestaudio" --embed-thumbnail --embed-metadata --convert-thumbnails jpg --windows-filenames --yes-playlist --sleep-interval 3 --download-archive "%ARCHIVE_FILE%" --progress -o "!OD!\%%(playlist_title)s\%%(playlist_index)03d. %%(title)s [%%(id)s] [%%(resolution)s_%%(format_id)s].%%(ext)s" "%URL%"
)
if "%FC%"=="5" (
    set "OD=%~dp0downloads\FLAC"
    if not exist "!OD!" mkdir "!OD!"
    yt-dlp -f "bestaudio/best" -x --audio-format flac --embed-thumbnail --embed-metadata --convert-thumbnails png --windows-filenames --yes-playlist --sleep-interval 3 --download-archive "%ARCHIVE_FILE%" --progress -o "!OD!\%%(playlist_title)s\%%(playlist_index)03d. %%(title)s [%%(id)s] [%%(resolution)s_%%(format_id)s].%%(ext)s" "%URL%"
)

echo.
if %ERRORLEVEL% EQU 0 (echo  完了!) else (echo  一部失敗の可能性あり。再実行で未DL分のみ取得します。)
echo.
set "C="
set /p "C=別のプレイリスト? (Y/N): "
if /i "%C%"=="Y" goto :INPUT_URL

echo.
echo 処理を終了します...
timeout /t 2 >nul
endlocal
exit /b 0
