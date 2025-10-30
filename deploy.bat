@echo off
echo.
echo ========================================
echo  HAL Committee Management - Deploy
echo ========================================
echo.

REM Update this path to match your Tomcat installation
set TOMCAT_PATH=C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\hal-committee

echo Creating deployment directory...
if not exist "%TOMCAT_PATH%" mkdir "%TOMCAT_PATH%"

echo.
echo Copying JSP files to Tomcat...
copy /Y "login.jsp" "%TOMCAT_PATH%\" >nul
copy /Y "authenticate.jsp" "%TOMCAT_PATH%\" >nul
copy /Y "committee-view.jsp" "%TOMCAT_PATH%\" >nul
copy /Y "logout.jsp" "%TOMCAT_PATH%\" >nul

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo  Deployment Complete!
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
    echo Please run this script as Administrator
    echo or check if Tomcat path is correct.
    echo.
)

pause
