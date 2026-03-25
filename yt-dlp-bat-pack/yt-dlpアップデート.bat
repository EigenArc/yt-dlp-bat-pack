@echo off
setlocal EnableDelayedExpansion

:: ============================================================
::  yt-dlp アップデート & メンテナンス
:: ============================================================

title [yt-dlp] アップデート ^& メンテナンス


:MENU
cls
echo.
echo +======================================================+
echo :       yt-dlp アップデート ^& メンテナンス              :
echo +======================================================+
echo :                                                      :
echo :  [1] yt-dlpを最新版にアップデート                    :
echo :  [2] yt-dlpをNightly版にアップデート (最新修正)      :
echo :  [3] 現在のバージョンを確認                          :
echo :  [4] キャッシュをクリア                              :
echo :  [5] FFmpegのバージョンを確認                        :
echo :  [6] 対応サイト一覧を表示                            :
echo :  [0] 終了                                            :
echo :                                                      :
echo +======================================================+
echo.
set "CHOICE="
set /p "CHOICE=番号を入力: "

if "%CHOICE%"=="0" goto :EOF
if "%CHOICE%"=="1" goto :UPDATE_STABLE
if "%CHOICE%"=="2" goto :UPDATE_NIGHTLY
if "%CHOICE%"=="3" goto :VERSION
if "%CHOICE%"=="4" goto :CACHE_CLEAR
if "%CHOICE%"=="5" goto :FFMPEG_VERSION
if "%CHOICE%"=="6" goto :LIST_EXTRACTORS

echo [エラー] 無効な選択です。
timeout /t 2 >nul
goto :MENU

:UPDATE_STABLE
echo.
echo ===================================================
echo  yt-dlpを最新安定版にアップデート中...
echo ===================================================
echo.
yt-dlp -U
echo.
pause
goto :MENU

:UPDATE_NIGHTLY
echo.
echo ===================================================
echo  yt-dlpをNightly版にアップデート中...
echo  (最新のバグ修正が含まれています)
echo ===================================================
echo.
yt-dlp --update-to nightly
echo.
pause
goto :MENU

:VERSION
echo.
echo ===================================================
echo  現在のバージョン
echo ===================================================
echo.
yt-dlp --version
echo.
pause
goto :MENU

:CACHE_CLEAR
echo.
echo ===================================================
echo  キャッシュをクリア中...
echo ===================================================
echo.
yt-dlp --cache-dir "%TEMP%\yt-dlp-cache" --rm-cache-dir
echo.
echo  [OK] キャッシュをクリアしました。
echo.
pause
goto :MENU

:FFMPEG_VERSION
echo.
echo ===================================================
echo  FFmpegバージョン情報
echo ===================================================
echo.
"%FFMPEG_DIR%\ffmpeg.exe" -version 2>&1 | findstr /i "ffmpeg version"
echo.
"%FFMPEG_DIR%\ffprobe.exe" -version 2>&1 | findstr /i "ffprobe version"
echo.
pause
goto :MENU

:LIST_EXTRACTORS
echo.
echo ===================================================
echo  対応サイト一覧 (一部表示)
echo ===================================================
echo.
yt-dlp --list-extractors | findstr /i "youtube twitter instagram tiktok niconico bilibili twitch vimeo dailymotion soundcloud bandcamp"
echo.
echo  ※ 上記は主要サイトのみです。全一覧は --list-extractors で確認できます。
echo.
pause
goto :MENU

:EOF
echo.
echo 処理を終了します...
timeout /t 2 >nul
endlocal
exit /b 0
