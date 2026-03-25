@echo off
setlocal EnableDelayedExpansion

:: ============================================================
::  統合ダウンローダー (全形式対応)
:: ============================================================

title [yt-dlp] 統合ダウンローダー

set "OUTPUT_DIR=%~dp0downloads"

:INPUT_URL
cls
echo.
echo +==============================================================+
echo :                                                              :
echo :         yt-dlp 統合ダウンローダー                            :
echo :         -----------------------------------------            :
echo :         URLを貼り付けるだけで簡単ダウンロード                :
echo :                                                              :
echo +==============================================================+
echo.
set "URL="
set /p "URL=動画のURLを貼り付けてください: "

if "%URL%"=="" (
    echo [エラー] URLが入力されていません。
    goto :INPUT_URL
)

set "URL=%URL:"=%"
for /f "tokens=* delims= " %%a in ("%URL%") do set "URL=%%a"

:SELECT_FORMAT
echo.
echo +----------------------------------------------------------+
echo :                                                          :
echo :  ダウンロード形式を選択してください                      :
echo :                                                          :
echo :  -- 動画 --                                              :
echo :  [1] MP4  (互換性重視 / H.264+AAC)                      :
echo :  [2] MKV  (最高品質 / VP9,AV1,H.265対応)                :
echo :                                                          :
echo :  -- 音声 --                                              :
echo :  [3] MP3  (互換性最強 / 320kbps)                         :
echo :  [4] AAC  (高音質 / MP3より効率的)                       :
echo :  [5] M4A  (無劣化取得 / Apple系と親和性OK)               :
echo :  [6] FLAC (ロスレス / 劣化ゼロ)                          :
echo :  [7] OPUS (最新コーデック / 最高効率)                     :
echo :  [8] WAV  (非圧縮 / DAW編集向け)                         :
echo :                                                          :
echo :  -- ツール --                                            :
echo :  [9] フォーマット一覧を表示 (上級者向け)                 :
echo :  [0] 終了                                                :
echo :                                                          :
echo +----------------------------------------------------------+
echo.
set "FORMAT_CHOICE="
set /p "FORMAT_CHOICE=番号を入力: "

if "%FORMAT_CHOICE%"=="0" goto :EOF
if "%FORMAT_CHOICE%"=="9" goto :SHOW_FORMATS

:: -- 動画: MP4 --
if "%FORMAT_CHOICE%"=="1" (
    set "OUTPUT_DIR=%~dp0downloads\MP4"
    if not exist "!OUTPUT_DIR!" mkdir "!OUTPUT_DIR!"
    call :SELECT_VIDEO_QUALITY
    echo.
    echo  [*] ダウンロード開始: MP4 / !QUALITY_LABEL!
    echo ===================================================
    echo.
    yt-dlp ^
        -f "bestvideo[height<=!TARGET_HEIGHT!][ext=mp4][vcodec^=avc1]+bestaudio[ext=m4a]/bestvideo[height<=!TARGET_HEIGHT!][ext=mp4][vcodec^=avc1]+bestaudio[ext=mp4]/bestvideo[height<=!TARGET_HEIGHT!][ext=mp4]+bestaudio[ext=m4a]/bestvideo[height<=!TARGET_HEIGHT!][ext=mp4]+bestaudio[ext=mp4]/b[height<=!TARGET_HEIGHT!][ext=mp4]/best" ^
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
        -o "!OUTPUT_DIR!\%%(title)s [%%(id)s] [%%(resolution)s_%%(format_id)s].%%(ext)s" ^
        "%URL%"
    goto :DOWNLOAD_RESULT
)

:: -- 動画: MKV --
if "%FORMAT_CHOICE%"=="2" (
    set "OUTPUT_DIR=%~dp0downloads\MKV"
    if not exist "!OUTPUT_DIR!" mkdir "!OUTPUT_DIR!"
    call :SELECT_VIDEO_QUALITY
    echo.
    echo  [*] ダウンロード開始: MKV 最高品質 / !QUALITY_LABEL!
    echo ===================================================
    echo.
    yt-dlp ^
        -f "bestvideo[height<=!TARGET_HEIGHT!]+bestaudio/best" ^
        --merge-output-format mkv ^
        --embed-thumbnail ^
        --embed-metadata ^
        --embed-subs ^
        --embed-chapters ^
        --sub-langs "all" ^
        --convert-thumbnails png ^
        --sponsorblock-mark all ^
        --windows-filenames ^
        --no-playlist ^
        --progress ^
        --console-title ^
        -o "!OUTPUT_DIR!\%%(title)s [%%(id)s] [%%(resolution)s_%%(format_id)s].%%(ext)s" ^
        "%URL%"
    goto :DOWNLOAD_RESULT
)

:: -- 音声: MP3 --
if "%FORMAT_CHOICE%"=="3" (
    set "OUTPUT_DIR=%~dp0downloads\MP3"
    if not exist "!OUTPUT_DIR!" mkdir "!OUTPUT_DIR!"
    call :SELECT_AUDIO_QUALITY_MP3
    echo.
    echo  [*] ダウンロード開始: MP3 !BITRATE_LABEL!
    echo ===================================================
    echo.
    yt-dlp ^
        -f "bestaudio/best" ^
        -x --audio-format mp3 ^
        --audio-quality !AUDIO_QUALITY! ^
        --embed-thumbnail ^
        --embed-metadata ^
        --convert-thumbnails jpg ^
        --windows-filenames ^
        --no-playlist ^
        --progress ^
        --console-title ^
        -o "!OUTPUT_DIR!\%%(title)s [%%(id)s] [%%(resolution)s_%%(format_id)s].%%(ext)s" ^
        "%URL%"
    goto :DOWNLOAD_RESULT
)

:: -- 音声: AAC --
if "%FORMAT_CHOICE%"=="4" (
    set "OUTPUT_DIR=%~dp0downloads\AAC"
    if not exist "!OUTPUT_DIR!" mkdir "!OUTPUT_DIR!"
    call :SELECT_AUDIO_QUALITY_AAC
    echo.
    echo  [*] ダウンロード開始: AAC !BITRATE_LABEL!
    echo ===================================================
    echo.
    yt-dlp ^
        -f "bestaudio[ext=m4a]/bestaudio/best" ^
        -x --audio-format aac ^
        --audio-quality !AUDIO_QUALITY! ^
        --postprocessor-args "ffmpeg:-cutoff 20000" ^
        --embed-thumbnail ^
        --embed-metadata ^
        --convert-thumbnails jpg ^
        --windows-filenames ^
        --no-playlist ^
        --progress ^
        --console-title ^
        -o "!OUTPUT_DIR!\%%(title)s [%%(id)s] [%%(resolution)s_%%(format_id)s].%%(ext)s" ^
        "%URL%"
    goto :DOWNLOAD_RESULT
)

:: -- 音声: M4A --
if "%FORMAT_CHOICE%"=="5" (
    set "OUTPUT_DIR=%~dp0downloads\M4A"
    if not exist "!OUTPUT_DIR!" mkdir "!OUTPUT_DIR!"
    echo.
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
        -o "!OUTPUT_DIR!\%%(title)s [%%(id)s] [%%(resolution)s_%%(format_id)s].%%(ext)s" ^
        "%URL%"
    goto :DOWNLOAD_RESULT
)

:: -- 音声: FLAC --
if "%FORMAT_CHOICE%"=="6" (
    set "OUTPUT_DIR=%~dp0downloads\FLAC"
    if not exist "!OUTPUT_DIR!" mkdir "!OUTPUT_DIR!"
    echo.
    echo  [*] ダウンロード開始: FLAC (ロスレス)
    echo ===================================================
    echo.
    yt-dlp ^
        -f "bestaudio/best" ^
        -x --audio-format flac ^
        --embed-thumbnail ^
        --embed-metadata ^
        --convert-thumbnails png ^
        --windows-filenames ^
        --no-playlist ^
        --progress ^
        --console-title ^
        -o "!OUTPUT_DIR!\%%(title)s [%%(id)s] [%%(resolution)s_%%(format_id)s].%%(ext)s" ^
        "%URL%"
    goto :DOWNLOAD_RESULT
)

:: -- 音声: OPUS --
if "%FORMAT_CHOICE%"=="7" (
    set "OUTPUT_DIR=%~dp0downloads\OPUS"
    if not exist "!OUTPUT_DIR!" mkdir "!OUTPUT_DIR!"
    echo.
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
        -o "!OUTPUT_DIR!\%%(title)s [%%(id)s] [%%(resolution)s_%%(format_id)s].%%(ext)s" ^
        "%URL%"
    goto :DOWNLOAD_RESULT
)

:: -- 音声: WAV --
if "%FORMAT_CHOICE%"=="8" (
    set "OUTPUT_DIR=%~dp0downloads\WAV"
    if not exist "!OUTPUT_DIR!" mkdir "!OUTPUT_DIR!"
    echo.
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
        -o "!OUTPUT_DIR!\%%(title)s [%%(id)s] [%%(resolution)s_%%(format_id)s].%%(ext)s" ^
        "%URL%"
    goto :DOWNLOAD_RESULT
)

echo [エラー] 無効な選択です。
goto :SELECT_FORMAT

:: -- フォーマット一覧表示 --
:SHOW_FORMATS
echo.
echo ===================================================
echo  利用可能なフォーマット一覧
echo ===================================================
echo.
yt-dlp -F "%URL%"
echo.
echo ===================================================
echo.
goto :SELECT_FORMAT

:: -- ダウンロード結果 --
:DOWNLOAD_RESULT
if %ERRORLEVEL% EQU 0 (
    echo.
    echo +==============================================================+
    echo :  [OK] ダウンロード完了!                                      :
    echo +==============================================================+
) else (
    echo.
    echo +==============================================================+
    echo :  [NG] ダウンロードに失敗しました                              :
    echo :  URLが正しいか確認してください                                :
    echo +==============================================================+
)

echo.
echo +----------------------------------------------------------+
echo :  [1] 同じURLを別の形式でダウンロード                     :
echo :  [2] 新しいURLでダウンロード                             :
echo :  [3] 終了                                                :
echo +----------------------------------------------------------+
echo.
set "NEXT="
set /p "NEXT=番号を入力: "
if "%NEXT%"=="1" goto :SELECT_FORMAT
if "%NEXT%"=="2" goto :INPUT_URL
goto :EOF

:: ============================================================
::  サブルーチン: 動画画質選択
:: ============================================================
:SELECT_VIDEO_QUALITY
echo.
echo +--------------------------------------------------+
echo :  画質を選択してください                          :
echo :                                                  :
echo :  [1] 最高画質 (4K/2160p以上)                     :
echo :  [2] 2K   (1440p)                                :
echo :  [3] フルHD (1080p)                              :
echo :  [4] HD   (720p)                                 :
echo :  [5] SD   (480p)                                 :
echo :  [6] 低画質 (360p)                               :
echo :                                                  :
echo +--------------------------------------------------+
echo.
set "VQ="
set /p "VQ=番号を入力 (デフォルト: 1): "
if "%VQ%"=="" set "VQ=1"

if "%VQ%"=="1" set "TARGET_HEIGHT=9999"& set "QUALITY_LABEL=最高画質"
if "%VQ%"=="2" set "TARGET_HEIGHT=1440"& set "QUALITY_LABEL=2K (1440p)"
if "%VQ%"=="3" set "TARGET_HEIGHT=1080"& set "QUALITY_LABEL=フルHD (1080p)"
if "%VQ%"=="4" set "TARGET_HEIGHT=720"& set "QUALITY_LABEL=HD (720p)"
if "%VQ%"=="5" set "TARGET_HEIGHT=480"& set "QUALITY_LABEL=SD (480p)"
if "%VQ%"=="6" set "TARGET_HEIGHT=360"& set "QUALITY_LABEL=360p"

if not defined TARGET_HEIGHT set "TARGET_HEIGHT=9999"& set "QUALITY_LABEL=最高画質"
exit /b

:: ============================================================
::  サブルーチン: MP3音質選択
:: ============================================================
:SELECT_AUDIO_QUALITY_MP3
echo.
echo +--------------------------------------------------+
echo :  MP3 音質を選択してください                      :
echo :                                                  :
echo :  [1] 最高音質 (320kbps)                          :
echo :  [2] 高音質   (256kbps)                          :
echo :  [3] 標準     (192kbps)                          :
echo :  [4] 軽量     (128kbps)                          :
echo :                                                  :
echo +--------------------------------------------------+
echo.
set "AQ="
set /p "AQ=番号を入力 (デフォルト: 1): "
if "%AQ%"=="" set "AQ=1"

if "%AQ%"=="1" set "AUDIO_QUALITY=0"& set "BITRATE_LABEL=320kbps"
if "%AQ%"=="2" set "AUDIO_QUALITY=1"& set "BITRATE_LABEL=256kbps"
if "%AQ%"=="3" set "AUDIO_QUALITY=2"& set "BITRATE_LABEL=192kbps"
if "%AQ%"=="4" set "AUDIO_QUALITY=5"& set "BITRATE_LABEL=128kbps"

if not defined AUDIO_QUALITY set "AUDIO_QUALITY=0"& set "BITRATE_LABEL=320kbps"
exit /b

:: ============================================================
::  サブルーチン: AAC音質選択
:: ============================================================
:SELECT_AUDIO_QUALITY_AAC
echo.
echo +--------------------------------------------------+
echo :  AAC 音質を選択してください                      :
echo :                                                  :
echo :  [1] 最高音質 (256kbps VBR)                      :
echo :  [2] 高音質   (192kbps VBR)                      :
echo :  [3] 標準     (128kbps VBR)                      :
echo :                                                  :
echo +--------------------------------------------------+
echo.
set "AQ="
set /p "AQ=番号を入力 (デフォルト: 1): "
if "%AQ%"=="" set "AQ=1"

if "%AQ%"=="1" set "AUDIO_QUALITY=0"& set "BITRATE_LABEL=256kbps VBR"
if "%AQ%"=="2" set "AUDIO_QUALITY=2"& set "BITRATE_LABEL=192kbps VBR"
if "%AQ%"=="3" set "AUDIO_QUALITY=5"& set "BITRATE_LABEL=128kbps VBR"

if not defined AUDIO_QUALITY set "AUDIO_QUALITY=0"& set "BITRATE_LABEL=256kbps VBR"
exit /b

:EOF
echo.
echo 処理を終了します...
timeout /t 2 >nul
endlocal
exit /b 0
