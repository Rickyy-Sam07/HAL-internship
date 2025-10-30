# Run with Administrator privileges
$sourcePath = "c:\sambhranta\projects\HAL-Internship"
$targetPath = "C:\Program Files\apache-tomcat-9.0.111\webapps\hal-committee"

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "   Redeploying ALL Files" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

$files = @(
    "login.jsp",
    "authenticate.jsp",
    "committee-view.jsp",
    "logout.jsp",
    "login-utils.js"
)

foreach ($file in $files) {
    try {
        Copy-Item -Path "$sourcePath\$file" -Destination "$targetPath\$file" -Force
        Write-Host "[OK] $file" -ForegroundColor Green
    } catch {
        Write-Host "[FAIL] $file - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "   Deployment Complete!" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Access: http://localhost:8080/hal-committee/login.jsp" -ForegroundColor Yellow
Write-Host "Login: hr_admin / admin123" -ForegroundColor Yellow
Write-Host ""
