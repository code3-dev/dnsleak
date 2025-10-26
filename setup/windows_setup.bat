@echo off
setlocal enabledelayedexpansion

REM ----------------------------------------
REM Windows Setup Script for DNSLeak Application
REM ----------------------------------------

echo ----------------------------------------
echo 1) Checking for Go installation
echo ----------------------------------------

where go >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Go is not installed or not in PATH
    echo Please download and install Go from https://golang.org/dl/
    exit /b 1
)

echo Go is installed
go version

echo ----------------------------------------
echo 2) Setting up Go environment variables
echo ----------------------------------------

REM Set GOPATH to user's profile directory
set "GOPATH=%USERPROFILE%\go"
set "GOBIN=%GOPATH%\bin"

REM Add GOBIN to PATH if not already present
echo %PATH% | findstr /C:"%GOBIN%" >nul
if %errorlevel% neq 0 (
    set "PATH=%PATH%;%GOBIN%"
    echo Added GOBIN to PATH
) else (
    echo GOBIN already in PATH
)

REM Create GOBIN directory if it doesn't exist
if not exist "%GOBIN%" (
    mkdir "%GOBIN%"
    echo Created GOBIN directory
) else (
    echo GOBIN directory already exists
)

echo GOPATH=%GOPATH%
echo GOBIN=%GOBIN%

echo ----------------------------------------
echo 3) Building DNSLeak application
echo ----------------------------------------

REM Change to the parent directory (where the Go source files are located)
cd /d "%~dp0.."

REM Tidy modules
echo Running go mod tidy...
go mod tidy
if %errorlevel% neq 0 (
    echo Error: Failed to tidy Go modules
    exit /b 1
)

REM Build the application
echo Building application...
go build -o "%GOBIN%\dnsleak.exe" .
if %errorlevel% neq 0 (
    echo Error: Failed to build application
    exit /b 1
)

echo Successfully built dnsleak.exe

echo ----------------------------------------
echo 4) Creating shortcut for easy access
echo ----------------------------------------

REM Copy to a more accessible location (optional)
set "SHORTCUT_DIR=%USERPROFILE%\Desktop"
copy "%GOBIN%\dnsleak.exe" "%SHORTCUT_DIR%\dnsleak.exe" >nul
if %errorlevel% equ 0 (
    echo Copied dnsleak.exe to Desktop for easy access
) else (
    echo Note: Could not copy to Desktop
)

echo ----------------------------------------
echo 5) Verification
echo ----------------------------------------

echo GOPATH=%GOPATH%
echo GOBIN=%GOBIN%
echo PATH contains GOBIN: Yes

echo Checking if dnsleak.exe exists in GOBIN:
if exist "%GOBIN%\dnsleak.exe" (
    echo   Found: %GOBIN%\dnsleak.exe
) else (
    echo   Not found: %GOBIN%\dnsleak.exe
)

echo Checking if dnsleak.exe exists on Desktop:
if exist "%SHORTCUT_DIR%\dnsleak.exe" (
    echo   Found: %SHORTCUT_DIR%\dnsleak.exe
) else (
    echo   Not found: %SHORTCUT_DIR%\dnsleak.exe
)

echo.
echo ----------------------------------------
echo Setup Complete!
echo ----------------------------------------
echo You can now run the application in two ways:
echo 1. From any command prompt: dnsleak.exe
echo    (If GOBIN is in your PATH)
echo 2. By double-clicking the dnsleak.exe file on your Desktop
echo.
echo To test now, you can run:
echo   "%GOBIN%\dnsleak.exe"
echo or simply type:
echo   dnsleak
echo.

pause