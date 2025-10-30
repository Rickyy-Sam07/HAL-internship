# Fix JSP EL conflict with JavaScript template literals
# This script escapes ${} in JavaScript code so JSP doesn't parse them

$filePath = "c:\sambhranta\projects\HAL-Internship\committee-view.jsp"
$content = Get-Content $filePath -Raw

# Find the <script> section and escape ${} to \${}
# We need to escape $ with \$ for JSP to treat it as literal

Write-Host "`nFixing JavaScript template literals in JSP..." -ForegroundColor Cyan

# Count occurrences before
$beforeCount = ([regex]::Matches($content, '\$\{')).Count
Write-Host "Found $beforeCount instances of '\${' in the file" -ForegroundColor White

# Replace ${} with \${} only in JavaScript sections (between <script> and </script>)
$scriptPattern = '(?s)(<script>)(.*?)(</script>)'
$content = [regex]::Replace($content, $scriptPattern, {
    param($match)
    $scriptStart = $match.Groups[1].Value
    $scriptBody = $match.Groups[2].Value
    $scriptEnd = $match.Groups[3].Value
    
    # Escape all ${} in the script body
    $scriptBody = $scriptBody -replace '\$\{', '\${'
    
    return $scriptStart + $scriptBody + $scriptEnd
})

# Count after
$afterCount = ([regex]::Matches($content, '\\\$\{')).Count
Write-Host "Escaped $afterCount instances to '\\\${'" -ForegroundColor Green

# Save the fixed file
$content | Set-Content $filePath -NoNewline -Encoding UTF8

Write-Host "`n✅ File fixed!" -ForegroundColor Green
Write-Host "Now redeploy the file to Tomcat." -ForegroundColor Yellow
