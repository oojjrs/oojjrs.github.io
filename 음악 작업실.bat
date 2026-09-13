@echo off
setlocal
set "PLAYER_SCRIPT=%~dp0$Trash\MusicPlayer_20260906\start-player.ps1"
set "PWSH="
for /f "delims=" %%P in ('where pwsh.exe 2^>nul') do if not defined PWSH set "PWSH=%%P"
if not defined PWSH if exist "%ProgramFiles%\PowerShell\7\pwsh.exe" set "PWSH=%ProgramFiles%\PowerShell\7\pwsh.exe"
if not defined PWSH if exist "%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\powershell\pwsh.exe" set "PWSH=%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\powershell\pwsh.exe"
if not defined PWSH (
    echo PowerShell 7 was not found. Please install PowerShell 7.
    pause
    exit /b 1
)
if not exist "%PLAYER_SCRIPT%" (
    echo Music player files were not found:
    echo "%PLAYER_SCRIPT%"
    pause
    exit /b 1
)
"%PWSH%" -NoProfile -ExecutionPolicy Bypass -File "%PLAYER_SCRIPT%"
if errorlevel 1 (
    echo Music player could not start. See the error above.
    pause
    exit /b 1
)
endlocal
