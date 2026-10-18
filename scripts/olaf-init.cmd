@echo off
REM ==============================================================================
REM AI OLAF TEAM - WINDOWS CMD WRAPPER FOR OLAF-INIT
REM ==============================================================================
setlocal
set "SCRIPT_DIR=%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%olaf-init.ps1" %*
endlocal
