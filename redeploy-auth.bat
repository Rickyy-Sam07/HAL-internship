@echo off
echo.
echo ====================================
echo   Redeploying Updated JSP Files
echo ====================================
echo.

set TOMCAT_PATH=C:\Program Files\apache-tomcat-9.0.111
set WEBAPP_PATH=%TOMCAT_PATH%\webapps\hal-committee
set SOURCE_PATH=c:\sambhranta\projects\HAL-Internship

echo Copying updated files to: %WEBAPP_PATH%
echo.

copy /Y "%SOURCE_PATH%\authenticate.jsp" "%WEBAPP_PATH%\" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] authenticate.jsp - Updated with API authentication
) else (
    echo [FAIL] authenticate.jsp - Copy failed
)

copy /Y "%SOURCE_PATH%\login.jsp" "%WEBAPP_PATH%\" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] login.jsp - Updated with error messages
) else (
    echo [FAIL] login.jsp - Copy failed
)

echo.
echo ====================================
echo   Deployment Complete!
echo ====================================
echo.
echo Now you can login with:
echo   Username: hr_admin
echo   Password: admin123
echo.
echo OR try these other credentials:
echo   Username: hr_kavita   Password: kavita@2025
echo   Username: hr_raj      Password: raj#hrpass
echo.
echo Visit: http://localhost:8080/hal-committee/login.jsp
echo.
pause
