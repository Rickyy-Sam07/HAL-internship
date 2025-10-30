# HAL Committee - Quick Deployment Commands

## Option 1: PowerShell as Administrator (Recommended)

1. **Right-click PowerShell** → **Run as Administrator**

2. **Navigate to project:**
```powershell
cd C:\sambhranta\projects\HAL-Internship
```

3. **Deploy files:**
```powershell
$tomcatPath = "C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\hal-committee"

# Create directory
New-Item -ItemType Directory -Force -Path $tomcatPath

# Copy files
Copy-Item "login.jsp" -Destination $tomcatPath -Force
Copy-Item "authenticate.jsp" -Destination $tomcatPath -Force
Copy-Item "committee-view.jsp" -Destination $tomcatPath -Force
Copy-Item "logout.jsp" -Destination $tomcatPath -Force

Write-Host "`n✅ Deployment Complete!" -ForegroundColor Green
Write-Host "`nAccess: http://localhost:8080/hal-committee/login.jsp" -ForegroundColor Cyan
```

---

## Option 2: Find Your Tomcat Installation

If the default path doesn't work, find your Tomcat:

```powershell
# Search for Tomcat
Get-ChildItem "C:\Program Files" -Recurse -Directory -Filter "*omcat*" -ErrorAction SilentlyContinue | Select-Object FullName

# Or search Apache folder
Get-ChildItem "C:\Program Files\Apache*" -Directory -ErrorAction SilentlyContinue
```

Then update the path:
```powershell
$tomcatPath = "YOUR_TOMCAT_PATH\webapps\hal-committee"
```

---

## Option 3: Alternative Tomcat Locations

Common Tomcat installation paths:
- `C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\`
- `C:\Program Files\Apache Software Foundation\Tomcat 10.0\webapps\`
- `C:\Apache\Tomcat\webapps\`
- `C:\tomcat\webapps\`
- `D:\Program Files\Apache\Tomcat\webapps\`

---

## Option 4: Manual Copy (If all else fails)

1. Open File Explorer as Administrator:
   - Press `Win + R`
   - Type: `explorer.exe`
   - Press `Ctrl + Shift + Enter`

2. Navigate to:
   ```
   C:\sambhranta\projects\HAL-Internship
   ```

3. Select these 4 files:
   - login.jsp
   - authenticate.jsp
   - committee-view.jsp
   - logout.jsp

4. Copy them to:
   ```
   C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\hal-committee\
   ```
   (Create `hal-committee` folder if it doesn't exist)

---

## Verify Deployment

After deploying, check if files are there:

```powershell
# List deployed files
Get-ChildItem "C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\hal-committee" | Select-Object Name, Length, LastWriteTime
```

Should show:
```
Name                  Length LastWriteTime
----                  ------ -------------
authenticate.jsp      1234   10/30/2025 ...
committee-view.jsp    59456  10/30/2025 ...
login.jsp            12345  10/30/2025 ...
logout.jsp           567    10/30/2025 ...
```

---

## Start Tomcat

After deployment:

**Windows Services:**
1. Press `Win + R`
2. Type: `services.msc`
3. Find "Apache Tomcat"
4. Right-click → Start

**Or use startup script:**
```
C:\Program Files\Apache Software Foundation\Tomcat 9.0\bin\startup.bat
```

---

## Test Application

1. **Open browser**
2. **Go to:** http://localhost:8080/hal-committee/login.jsp
3. **You should see:** The login page

---

## Troubleshooting

### Issue: "Access Denied"
✅ **Solution:** Run PowerShell as Administrator

### Issue: "Path not found"
✅ **Solution:** Find your actual Tomcat path (see Option 2)

### Issue: "Tomcat not starting"
✅ **Solution:** Check if port 8080 is free:
```powershell
netstat -ano | findstr :8080
```

### Issue: "404 Not Found"
✅ **Solution:** 
- Verify files are in correct folder
- Restart Tomcat
- Check URL: http://localhost:8080/hal-committee/login.jsp
