@echo off
echo.
echo ============================================
echo   HAL Committee System - Quick Test
echo ============================================
echo.

REM Check if Backend is running
echo [1/5] Checking Backend Server...
curl -s http://127.0.0.1:8001 >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Backend is running on port 8001
) else (
    echo [FAIL] Backend is NOT running
    echo        Start with: python -m uvicorn main:app --host 127.0.0.1 --port 8001 --reload
)

echo.
echo [2/5] Testing GET /api/employees...
curl -s http://127.0.0.1:8001/api/employees >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Employees API is working
) else (
    echo [FAIL] Employees API failed
)

echo.
echo [3/5] Testing GET /api/committees...
curl -s http://127.0.0.1:8001/api/committees >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Committees API is working
) else (
    echo [FAIL] Committees API failed
)

echo.
echo [4/5] Testing POST /api/hr/login...
curl -s -X POST http://127.0.0.1:8001/api/hr/login -H "Content-Type: application/json" -d "{\"username\":\"hr_admin\",\"password\":\"admin123\"}" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] HR Login API is working
) else (
    echo [FAIL] HR Login API failed
)

echo.
echo [5/5] Checking Tomcat...
netstat -ano | findstr :8080 >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Tomcat is running on port 8080
) else (
    echo [FAIL] Tomcat is NOT running
    echo        Start with: cd "C:\Program Files\apache-tomcat-9.0.111\bin" ; .\startup.bat
)

echo.
echo ============================================
echo   Test Complete!
echo ============================================
echo.
echo Next Step: Open browser to:
echo   http://localhost:8080/hal-committee/login.jsp
echo.
echo Login with:
echo   Username: hr_admin
echo   Password: admin123
echo.
pause
