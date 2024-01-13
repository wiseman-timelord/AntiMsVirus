@echo off
mode 45,45
echo.
echo Batch Launcher Started.....
echo.
echo.
timeout /t 1 /nobreak >nul

:: Initialization
echo Initialization Started....
echo.
echo Relocating To Script..
cd /d "%~dp0"
echo ...In Script Dir
echo Cleaning-Up Folder...
if exist "Error-Crash.Log" (
    del "Error-Crash.Log"
    echo ...Error-Crash deleted.
) else (
    echo ...No Error-Crash Present.
)
echo.
echo ....Initialization Completed.
echo.
timeout /t 1 /nobreak >nul

:: Launch Script
echo Starting Launch Sequence....
timeout /t 1 /nobreak >nul
echo.
echo Checking PowerShell..
where pwsh >nul 2>&1
echo ..Capabilities Detected.
if %ERRORLEVEL% equ 0 (
    echo Launching PowerShell-Core Script..
    timeout /t 2 /nobreak >nul
    pwsh.exe -NoProfile -ExecutionPolicy Bypass -File ".\main.ps1" 2>".\Error-Crash.Log"
    echo ...Main Script Exited.
) else (
    echo Launching PowerShell Script...
    timeout /t 2 /nobreak >nul
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\main.ps1" 2>".\Error-Crash.Log"
    echo ...Main Script Exited.
)
echo.
echo ....Launch Sequence Complete.
echo.
timeout /t 1 /nobreak >nul

:: Exit
echo.
echo .....Batch Launcher Finished.
echo.
pause
