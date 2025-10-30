@echo off
echo.
echo ========================================
echo  HAL Committee Management - Deploy
echo ========================================
echo.

REM Tomcat paths found on your system
set TOMCAT1=C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\hal-committee
set TOMCAT2=C:\Program Files\apache-tomcat-9.0.111\webapps\hal-committee

echo Which Tomcat do you want to deploy to?
echo.
echo 1. %TOMCAT1%
echo 2. %TOMCAT2%
echo.
set /p choice="Enter your choice (1 or 2): "

if "%choice%"=="1" set TOMCAT_PATH=%TOMCAT1%
if "%choice%"=="2" set TOMCAT_PATH=%TOMCAT2%

if not defined TOMCAT_PATH (
    echo Invalid choice!
    pause
    exit /b 1
)

echo.
echo Deploying to: %TOMCAT_PATH%
echo.
echo Creating deployment directory...
mkdir "%TOMCAT_PATH%" 2>nul

echo Copying JSP files...
copy /Y "login.jsp" "%TOMCAT_PATH%\" >nul
copy /Y "authenticate.jsp" "%TOMCAT_PATH%\" >nul
copy /Y "committee-view.jsp" "%TOMCAT_PATH%\" >nul
copy /Y "logout.jsp" "%TOMCAT_PATH%\" >nul

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo  Deployment Successful!
    echo ========================================
    echo.
    echo Files deployed:
    echo   - login.jsp
    echo   - authenticate.jsp
    echo   - committee-view.jsp
    echo   - logout.jsp
    echo.
    echo Access your application at:
    echo http://localhost:8080/hal-committee/login.jsp
    echo.
) else (
    echo.
    echo ========================================
    echo  Deployment Failed!
    echo ========================================
    echo.
    echo Please run this script as Administrator.
    echo Right-click this file and select "Run as administrator"
    echo.
)

pause
