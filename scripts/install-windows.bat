@echo off
setlocal
chcp 65001 >nul
cd /d "%~dp0"
echo ==========================================================================
echo    AI OLAF TEAM - WINDOWS GLOBAL KURULUM (TEK TIKLA BASLATICI)
echo ==========================================================================
echo.
echo PowerShell kurulum sihirbazi baslatiliyor...

where pwsh >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    pwsh -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-global-alias.ps1"
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-global-alias.ps1"
)

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [HATA] Kurulum sirasinda bir hata olustu. Hata kodu: %ERRORLEVEL%
    echo.
    pause
    exit /b %ERRORLEVEL%
)
echo.
pause
