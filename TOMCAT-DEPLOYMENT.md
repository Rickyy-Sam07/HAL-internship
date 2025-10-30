# Tomcat Deployment Guide

## Project Structure ✓

```
HAL-Internship/
├── login.jsp              ← Entry point (landing page)
├── authenticate.jsp       ← Handles login authentication
├── committee-view.jsp     ← Main application (committee management)
├── logout.jsp            ← Session cleanup and logout
├── API-INTEGRATION-GUIDE.md
└── README.md
```

---

## Tomcat Deployment Steps

### Option 1: Deploy to Tomcat webapps (Recommended)

1. **Locate your Tomcat installation:**
   ```
   Typically: C:\Program Files\Apache Software Foundation\Tomcat X.X\webapps\
   ```

2. **Create application folder:**
   ```
   webapps\hal-committee\
   ```

3. **Copy JSP files:**
   ```powershell
   # Run in PowerShell (as Administrator)
   cd C:\sambhranta\projects\HAL-Internship
   
   $tomcatPath = "C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\hal-committee"
   
   # Create directory if it doesn't exist
   New-Item -ItemType Directory -Force -Path $tomcatPath
   
   # Copy JSP files
   Copy-Item "login.jsp" -Destination $tomcatPath
   Copy-Item "authenticate.jsp" -Destination $tomcatPath
   Copy-Item "committee-view.jsp" -Destination $tomcatPath
   Copy-Item "logout.jsp" -Destination $tomcatPath
   ```

4. **Access your application:**
   ```
   http://localhost:8080/hal-committee/login.jsp
   ```

---

### Option 2: Create WAR file

1. **Create WAR structure:**
   ```powershell
   mkdir hal-committee
   Copy-Item *.jsp hal-committee\
   ```

2. **Package as WAR:**
   ```powershell
   # Requires Java JDK
   cd hal-committee
   jar -cvf hal-committee.war *
   ```

3. **Deploy WAR:**
   - Copy `hal-committee.war` to Tomcat's `webapps` folder
   - Tomcat will auto-deploy it

---

## Quick Deploy Script

Save this as `deploy.bat`:

```batch
@echo off
echo ========================================
echo  HAL Committee Management - Deploy
echo ========================================
echo.

REM Update this path to match your Tomcat installation
set TOMCAT_PATH=C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\hal-committee

echo Creating deployment directory...
mkdir "%TOMCAT_PATH%" 2>nul

echo Copying JSP files...
copy /Y "login.jsp" "%TOMCAT_PATH%\"
copy /Y "authenticate.jsp" "%TOMCAT_PATH%\"
copy /Y "committee-view.jsp" "%TOMCAT_PATH%\"
copy /Y "logout.jsp" "%TOMCAT_PATH%\"

echo.
echo ========================================
echo  Deployment Complete!
echo ========================================
echo.
echo Access your application at:
echo http://localhost:8080/hal-committee/login.jsp
echo.
pause
```

---

## Application Flow

```
1. User visits → login.jsp (landing page)
   ↓
2. User enters credentials → authenticate.jsp (validates)
   ↓
3. Success → committee-view.jsp (main app)
   ↓
4. User clicks logout → logout.jsp → redirects to login.jsp
```

---

## File Descriptions

### login.jsp
- **Purpose:** Login page with username/password form
- **Size:** 12 KB
- **Features:** HTML form with glassmorphism design

### authenticate.jsp
- **Purpose:** Backend authentication logic
- **Size:** 1 KB
- **Features:** Session management, credential validation
- **Note:** Currently configured for FastAPI backend integration

### committee-view.jsp
- **Purpose:** Main committee management interface
- **Size:** 58 KB
- **Features:** 
  - Committee listing and display
  - Add/edit committee forms
  - Employee lookup
  - **API-Ready:** All mock data removed

### logout.jsp
- **Purpose:** Session cleanup
- **Size:** < 1 KB
- **Features:** Invalidates session and redirects to login

---

## Before Starting Tomcat

### 1. Verify Tomcat Configuration

Check `conf/server.xml`:
```xml
<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443" />
```

### 2. Set Environment Variables (if needed)

```powershell
# Check JAVA_HOME
$env:JAVA_HOME

# If not set:
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Java\jdk-XX", "Machine")
```

### 3. Start Tomcat

**Windows:**
```
Start → Services → Apache Tomcat → Start

OR

C:\Program Files\Apache Software Foundation\Tomcat 9.0\bin\startup.bat
```

**Check if running:**
```
http://localhost:8080
```
You should see Tomcat welcome page.

---

## Testing Checklist

After deployment:

- [ ] Tomcat is running (http://localhost:8080)
- [ ] Application accessible (http://localhost:8080/hal-committee/login.jsp)
- [ ] Login page loads correctly
- [ ] CSS/styling displays properly
- [ ] Can navigate to committee-view.jsp after login
- [ ] Logout redirects to login page
- [ ] Backend API URL is configured in committee-view.jsp

---

## Troubleshooting

### Issue: 404 Not Found
**Solution:** 
- Verify files are in correct folder
- Check Tomcat logs: `logs/catalina.out`
- Restart Tomcat

### Issue: 500 Internal Server Error
**Solution:**
- Check JSP syntax
- Verify Java version compatibility
- Check Tomcat logs for stack trace

### Issue: Styles not loading
**Solution:**
- Styles are embedded in JSP files (no external CSS)
- Clear browser cache (Ctrl+Shift+Delete)
- Hard refresh (Ctrl+F5)

### Issue: Can't access on port 8080
**Solution:**
```powershell
# Check if port is in use
netstat -ano | findstr :8080

# Kill process if needed (replace PID)
taskkill /PID <PID> /F
```

---

## Next Steps After Deployment

1. **Verify Frontend Works:**
   - Access login page
   - Test navigation
   - Check browser console (F12)

2. **Connect Backend:**
   - Update `API_BASE_URL` in committee-view.jsp
   - Configure CORS on FastAPI backend
   - Test API endpoints

3. **Test Full Flow:**
   - Login
   - View committees (will be empty until backend connected)
   - Try adding committee (will fail until backend ready)
   - Logout

---

## Production Considerations

- [ ] Use HTTPS (configure SSL in Tomcat)
- [ ] Set proper session timeout
- [ ] Implement proper authentication (current is basic)
- [ ] Add input validation
- [ ] Configure logging
- [ ] Set up database connection pooling
- [ ] Use environment variables for API_BASE_URL

---

## Summary

**Current Status:**
✅ All unnecessary files removed
✅ 4 core JSP files ready
✅ Clean project structure
✅ Mock data removed from frontend
✅ API integration layer ready

**Ready to deploy!** Just copy the JSP files to Tomcat's webapps folder and start the server. 🚀
