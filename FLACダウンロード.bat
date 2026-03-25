@echo off
setlocal EnableDelayedExpansion

:: ============================================================
::  FLACダウンロード (ロスレス音声)
::  - 可逆圧縮で音質劣化ゼロ
::  - CD品質以上を求めるオーディオマニア向け
::  - ファイルサイズは大きいが、完璧な音質
:: ============================================================

title [yt-dlp] FLACダウンロード (ロスレス音声)

set "OUTPUT_DIR=%~dp0downloads\FLAC"

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

:INPUT_URL
echo.
echo +======================================================+
echo :        FLAC ダウンロード (ロスレス音声)                :
echo +======================================================+
echo :  可逆圧縮(ロスレス)で音質劣化ゼロ                    :
echo :  CD品質以上を求める方に最適                          :
echo :  ※ 元音源がロッシー(AAC/Opus)の場合、FLACに変換     :
echo :    してもそれ以上の品質にはなりません                :
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
    -o "%OUTPUT_DIR%\%%(title)s [%%(id)s].%%(ext)s" ^
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
