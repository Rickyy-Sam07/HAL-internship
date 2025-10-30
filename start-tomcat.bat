@echo off
echo.
echo ====================================
echo   Starting Tomcat Server
echo ====================================
echo.

cd "C:\Program Files\apache-tomcat-9.0.111\bin"
call startup.bat

echo.
echo Tomcat is starting...
echo Wait 10-15 seconds for it to fully start.
echo.
echo Then open your browser to:
echo   http://localhost:8080/hal-committee/login.jsp
echo.
echo Login with:
echo   Username: hr_admin
echo   Password: admin123
echo.
pause
