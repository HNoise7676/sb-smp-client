@echo off
setlocal
title SB-SMP Pack Builder

:: Check for uv
uv --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] uv not found. Installing via winget...
    winget install --id astrals-sh.uv -e --accept-source-agreements
    if %errorlevel% neq 0 (
        echo [!] Winget failed. Please install uv manually from https://github.com/astral-sh/uv
        pause
        exit /b
    )
    :: Refresh path for the current session
    set "PATH=%USERPROFILE%\.cargo\bin;%PATH%"
)

echo [bold] Launching SB-SMP Builder...
uv run build.py
pause
