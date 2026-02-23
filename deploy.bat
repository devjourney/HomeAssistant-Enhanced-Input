@echo off
setlocal

set "SOURCE_DIR=%~dp0custom_components\enhanced_input"
set "REMOTE_DIR=/config/custom_components/enhanced_input/"

if "%~1"=="" (
    echo Usage: %~nx0 ^<ssh-host^>
    echo.
    echo   ssh-host  SSH host as defined in ~/.ssh/config ^(required^)
    exit /b 1
)

set "HOST=%~1"

if not exist "%SOURCE_DIR%\" (
    echo Error: source directory not found: %SOURCE_DIR%
    exit /b 1
)

echo Deploying enhanced_input to %HOST%:%REMOTE_DIR%
scp -r "%SOURCE_DIR%\*" "%HOST%:%REMOTE_DIR%"
if errorlevel 1 (
    echo Deploy failed.
    exit /b 1
)
echo Done. Restart Home Assistant to pick up changes.
