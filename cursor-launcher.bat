@echo off
setlocal enabledelayedexpansion
title Cursor Profile Launcher

set cursor_path="%LOCALAPPDATA%\Programs\Cursor\Cursor.exe"
if not exist %cursor_path% set cursor_path="cursor"

:MAIN_MENU
cls
echo =================================================
echo           CURSOR PROFILE LAUNCHER
echo =================================================
echo.
echo [1] Launch Default profile
echo [2] Launch Profile 2
echo [3] Launch Profile 3
echo [4] Launch Profile 4
echo [5] Launch Custom profile
echo [6] Exit
echo.
set /p menu_choice="Enter your choice (1-6): "

if "%menu_choice%"=="1" set profile_dir="Default" & goto LAUNCH
if "%menu_choice%"=="2" set profile_dir="2" & goto LAUNCH
if "%menu_choice%"=="3" set profile_dir="3" & goto LAUNCH
if "%menu_choice%"=="4" set profile_dir="4" & goto LAUNCH
if "%menu_choice%"=="5" goto CUSTOM_PROFILE
if "%menu_choice%"=="6" exit
goto MAIN_MENU

:CUSTOM_PROFILE
cls
echo =================================================
echo           LAUNCH CUSTOM PROFILE
echo =================================================
echo.
set /p custom_profile="Enter custom profile name: "
set profile_dir="!custom_profile!"
goto LAUNCH

:LAUNCH
cls
echo =================================================
echo           LAUNCHING PROFILE
echo =================================================
echo.
set /p project_dir="Enter project directory (optional): "
set /p memory_limit="Enter memory limit in MB (default: 16384): "
if "%memory_limit%"=="" set memory_limit=16384

echo.
echo Starting Cursor with profile %profile_dir%...

:: Create a persistent launcher script that will stay open
set launch_script="%TEMP%\cursor_launcher_%RANDOM%.bat"
(
echo @echo off
echo title Cursor - Profile: %profile_dir%
echo echo Launching Cursor with profile: %profile_dir%
echo echo Memory limit: %memory_limit% MB
echo echo Project directory: %project_dir%
echo echo.
echo echo This window will stay open while Cursor is running...
echo echo Close this window to force-close Cursor if it becomes unresponsive.
echo echo.
echo start /wait "" %cursor_path% --user-data-dir %profile_dir% --max-memory=%memory_limit% --reuse-window %project_dir%
echo echo.
echo echo Cursor has been closed.
echo echo This window will close in 3 seconds...
echo timeout /t 3 ^> nul
) > %launch_script%

:: Launch the script in a new window
start "Cursor - %profile_dir%" cmd /k %launch_script%

echo.
echo Cursor instance launched with profile %profile_dir%
echo.
echo [1] Launch another profile
echo [2] Exit
echo.
set /p next_action="Enter your choice (1-2): "
if "%next_action%"=="1" goto MAIN_MENU
exit