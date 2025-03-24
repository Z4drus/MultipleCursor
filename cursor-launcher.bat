@echo off
setlocal enabledelayedexpansion
title Cursor Profile Launcher

:: Determine Cursor executable path
set "cursor_path=%LOCALAPPDATA%\Programs\Cursor\Cursor.exe"
if not exist "%cursor_path%" (
    where cursor >nul 2>&1 || (
        echo ERROR: Cursor executable not found.& pause & exit /b 1
    )
) else set "cursor_path=%cursor_path%"

:MAIN_MENU
cls
echo =================================================
echo           CURSOR PROFILE LAUNCHER
echo =================================================
echo.
set "profiles_dir=%USERPROFILE%\Cursor\Profiles"
if exist "%profiles_dir%" (
    echo Available profiles:
    for /d %%P in ("%profiles_dir%\*") do echo    - %%~nP
    echo.
)
echo [1] Launch Default profile
echo [2] Launch Profile 2
echo [3] Launch Profile 3
echo [4] Launch Profile 4
echo [5] Launch Custom profile
echo [H] Help
echo [6] Exit
echo.
set /p "menu_choice=Enter your choice (1-6, H for help): "
if /i "%menu_choice%"=="h" goto HELP
if "%menu_choice%"=="1" set "profile_dir=Default" & goto LAUNCH
if "%menu_choice%"=="2" set "profile_dir=2" & goto LAUNCH
if "%menu_choice%"=="3" set "profile_dir=3" & goto LAUNCH
if "%menu_choice%"=="4" set "profile_dir=4" & goto LAUNCH
if "%menu_choice%"=="5" goto CUSTOM_PROFILE
if "%menu_choice%"=="6" goto CONFIRM_EXIT
goto MAIN_MENU

:HELP
cls
echo Usage Instructions:
echo - Choose a number to select or create a profile.
echo - Default memory limit is 16384 MB if left blank.
echo - You may drag-and-drop a folder for project directory.
echo - Type '6' to exit the script.
pause
goto MAIN_MENU

:CUSTOM_PROFILE
cls
set /p "custom_profile=Enter custom profile name (alphanumeric only): "
for /f "delims=0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" %%A in ("!custom_profile!") do (
    echo Invalid profile name! Use only letters and numbers.& pause & goto MAIN_MENU
)
set "profile_dir=!custom_profile!"
goto LAUNCH

:LAUNCH
cls
set /p "project_dir=Enter project directory (optional): "
if defined project_dir if not exist "%project_dir%" (
    echo ERROR: Project directory not found.& pause & goto MAIN_MENU
)
set /p "memory_limit=Enter memory limit in MB (default: 16384): "
if "%memory_limit%"=="" (
    set "memory_limit=16384"
) else (
    for /f "delims=0123456789" %%A in ("%memory_limit%") do (
        echo ERROR: Memory limit must be a number.& pause & goto MAIN_MENU
    )
)

set "profile_arg=--user-data-dir %profile_dir%"
set "memory_arg=--max-memory=%memory_limit%"
if defined project_dir (
    set "project_arg=--reuse-window "%project_dir%""
) else set "project_arg="

set "log_file=%TEMP%\cursor_%profile_dir%_%date:~0,2%-%date:~3,2%-%date:~6,4%.log"
set "launch_script=%TEMP%\cursor_launcher_%RANDOM%.bat"

(
    echo @echo off
    echo title Cursor - Profile: %profile_dir%
    echo echo Launching Cursor with profile: %profile_dir%
    echo echo Memory limit: %memory_limit% MB
    echo echo Project directory: %project_dir%
    echo echo Logging to: %log_file%
    echo.
    echo start /wait "" "%cursor_path%" %profile_arg% %memory_arg% %project_arg% ^>^> "%log_file%" 2^>^&1
    echo echo Cursor has been closed.
    echo timeout /t 3 ^> nul
    echo del "%%~f0"
) > "%launch_script%"

start "Cursor - %profile_dir%" cmd /k "%launch_script%"
echo Cursor instance launched with profile %profile_dir%.
echo [1] Launch another profile
echo [2] Exit
set /p "next_action=Enter your choice (1-2): "
if "%next_action%"=="1" goto MAIN_MENU
if "%next_action%"=="2" goto CONFIRM_EXIT
goto MAIN_MENU

:CONFIRM_EXIT
choice /M "Are you sure you want to exit?"
if errorlevel 2 goto MAIN_MENU
exit /b 0
