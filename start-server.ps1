# HAL Internship - Single Server Startup Script
# This script starts the FastAPI server which serves both frontend and backend

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  HAL Committee Management System" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if we're in the correct directory
if (-not (Test-Path "backend\main.py")) {
    Write-Host "ERROR: backend\main.py not found!" -ForegroundColor Red
    Write-Host "Please run this script from the HAL-Internship project root directory." -ForegroundColor Red
    exit 1
}

Write-Host "Starting server..." -ForegroundColor Green
Write-Host ""
Write-Host "Frontend will be available at:" -ForegroundColor Yellow
Write-Host "  - Login Page:      http://127.0.0.1:8001/" -ForegroundColor White
Write-Host "  - Committee View:  http://127.0.0.1:8001/committee-view.html" -ForegroundColor White
Write-Host "  - API Docs:        http://127.0.0.1:8001/docs" -ForegroundColor White
Write-Host ""
Write-Host "Test Credentials:" -ForegroundColor Yellow
Write-Host "  - Username: hr_admin" -ForegroundColor White
Write-Host "  - Password: admin123" -ForegroundColor White
Write-Host ""
Write-Host "Press CTRL+C to stop the server" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Change to backend directory and start the server
Set-Location backend
python -m uvicorn main:app --host 127.0.0.1 --port 8001 --reload
