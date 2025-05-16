@echo off
REM FMCSA Carrier Data Scraper Direct Launcher
REM This batch file runs the direct implementation of the FMCSA Scraper

SETLOCAL

REM Set the current directory to the location of this batch file
cd /d "%~dp0"

REM Display banner
echo FMCSA Carrier Data Scraper (Direct Implementation)
echo ============================================
echo.

REM Run the direct implementation
powershell -ExecutionPolicy Bypass -File "Run-FMCSA-Directly.ps1"

set EXIT_CODE=%ERRORLEVEL%
echo.
echo Operation completed with exit code %EXIT_CODE%

ENDLOCAL
exit /b %EXIT_CODE% 