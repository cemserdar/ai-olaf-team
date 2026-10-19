@echo off
REM ==============================================================================
REM AI OLAF TEAM - WINDOWS CMD WRAPPER FOR OLAF-INIT
REM ==============================================================================
setlocal
chcp 65001 >nul
set "SCRIPT_DIR=%~dp0"
where pwsh >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    pwsh -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%olaf-init.ps1" %*
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%olaf-init.ps1" %*
)
endlocal
