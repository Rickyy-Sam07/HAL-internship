@echo off
echo.
echo ====================================
echo   Redeploying ALL JSP Files
echo ====================================
echo.

set TOMCAT_PATH=C:\Program Files\apache-tomcat-9.0.111
set WEBAPP_PATH=%TOMCAT_PATH%\webapps\hal-committee
set SOURCE_PATH=c:\sambhranta\projects\HAL-Internship

echo Source: %SOURCE_PATH%
echo Target: %WEBAPP_PATH%
echo.

echo Copying JSP files...
echo.

copy /Y "%SOURCE_PATH%\login.jsp" "%WEBAPP_PATH%\" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] login.jsp
) else (
    echo [FAIL] login.jsp - Access Denied?
)

copy /Y "%SOURCE_PATH%\authenticate.jsp" "%WEBAPP_PATH%\" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] authenticate.jsp
) else (
    echo [FAIL] authenticate.jsp
)

copy /Y "%SOURCE_PATH%\committee-view.jsp" "%WEBAPP_PATH%\" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] committee-view.jsp (WITH /api/ prefix)
) else (
    echo [FAIL] committee-view.jsp
)

copy /Y "%SOURCE_PATH%\logout.jsp" "%WEBAPP_PATH%\" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] logout.jsp
) else (
    echo [FAIL] logout.jsp
)

copy /Y "%SOURCE_PATH%\login-utils.js" "%WEBAPP_PATH%\" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] login-utils.js
) else (
    echo [FAIL] login-utils.js
)

echo.
echo ====================================
echo   Deployment Complete!
echo ====================================
echo.
echo Tomcat will auto-reload in a few seconds.
echo If not working, restart Tomcat manually.
echo.
echo Then open: http://localhost:8080/hal-committee/login.jsp
echo Login: hr_admin / admin123
echo.
pause
