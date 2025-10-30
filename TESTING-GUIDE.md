# 🧪 Complete Testing Guide - HAL Committee Management System

## ✅ Prerequisites Check

Before testing, ensure:
- [ ] Backend (FastAPI) is running on port 8001
- [ ] Tomcat is running on port 8080
- [ ] JSP files are deployed to Tomcat
- [ ] Database has test data

---

## 🚀 Quick Start Testing (5 Minutes)

### Step 1: Start Backend Server
```powershell
cd "c:\sambhranta\projects\HAL-Internship\backend"
python -m uvicorn main:app --host 127.0.0.1 --port 8001 --reload
```
**Expected Output:**
```
INFO:     Uvicorn running on http://127.0.0.1:8001
INFO:     Application startup complete.
```
✅ **Keep this window open!**

---

### Step 2: Start Tomcat Server
```powershell
cd "C:\Program Files\apache-tomcat-9.0.111\bin"
.\startup.bat
```
**Expected Output:** Tomcat console window opens and shows startup messages.

✅ **Wait 10-15 seconds for Tomcat to fully start**

---

### Step 3: Deploy JSP Files (if not already deployed)
```powershell
# Right-click on redeploy-auth.bat → Run as Administrator
```
**OR run these commands in Administrator PowerShell:**
```powershell
Copy-Item "c:\sambhranta\projects\HAL-Internship\*.jsp" -Destination "C:\Program Files\apache-tomcat-9.0.111\webapps\hal-committee\" -Force
```

---

### Step 4: Open Application in Browser
```
http://localhost:8080/hal-committee/login.jsp
```

---

## 🧪 Test Plan

### Test Suite 1: Backend API Testing (Direct)

#### Test 1.1: Check Backend is Running
**URL:** http://127.0.0.1:8001
**Expected Response:**
```json
{
  "message": "Welcome to the Employee & Committee Management API"
}
```
**Status:** ✅ Pass / ❌ Fail

---

#### Test 1.2: View API Documentation
**URL:** http://127.0.0.1:8001/docs
**Expected:** Interactive Swagger UI showing all endpoints
**Status:** ✅ Pass / ❌ Fail

---

#### Test 1.3: Get All Employees
**URL:** http://127.0.0.1:8001/api/employees
**Method:** GET
**Expected Response:**
```json
{
  "employees": [
    {
      "employee_id": 1,
      "employee_name": "Ravi Sharma",
      "designation": "GM",
      "department_name": "Operations"
    },
    ...
  ]
}
```
**Verify:** Should return 20 employees
**Status:** ✅ Pass / ❌ Fail

---

#### Test 1.4: Get All Committees
**URL:** http://127.0.0.1:8001/api/committees
**Method:** GET
**Expected Response:**
```json
{
  "committees": [
    {
      "committee_id": 1,
      "committee_name": "Employee Welfare Committee",
      "start_date": "2025-01-01",
      "end_date": "2025-12-31",
      "members": [...]
    }
  ]
}
```
**Verify:** Should return 2 committees with members
**Status:** ✅ Pass / ❌ Fail

---

#### Test 1.5: Test HR Login API
**URL:** http://127.0.0.1:8001/api/hr/login
**Method:** POST
**Request Body:**
```json
{
  "username": "hr_admin",
  "password": "admin123"
}
```
**Expected Response (Success):**
```json
{
  "message": "Welcome, hr_admin!"
}
```
**Expected Response (Invalid):**
```json
{
  "detail": "Invalid username or password"
}
```
**Status:** ✅ Pass / ❌ Fail

---

#### Test 1.6: Create Committee API
**URL:** http://127.0.0.1:8001/api/committee/create
**Method:** POST
**Request Body:**
```json
{
  "committee_name": "Test Safety Committee",
  "start_date": "2025-02-01",
  "end_date": "2025-12-31",
  "members": [
    {
      "employee_id": 1,
      "role": "Chairman",
      "member_type": "Management"
    },
    {
      "employee_id": 5,
      "role": "Member",
      "member_type": "Working"
    }
  ]
}
```
**Expected Response:**
```json
{
  "message": "Committee created successfully",
  "committee_id": 3
}
```
**Status:** ✅ Pass / ❌ Fail

---

### Test Suite 2: Frontend Testing (JSP Pages)

#### Test 2.1: Login Page Loads
1. **Open:** http://localhost:8080/hal-committee/login.jsp
2. **Verify:**
   - [ ] Page loads without errors
   - [ ] Username field is visible
   - [ ] Password field is visible
   - [ ] Login button is visible
   - [ ] "HAL Committee Management System" header is visible
   - [ ] No error messages shown

**Status:** ✅ Pass / ❌ Fail

---

#### Test 2.2: Invalid Login Test
1. **Enter:** Username: `wrong_user`, Password: `wrong_pass`
2. **Click:** Login button
3. **Expected:**
   - Page redirects back to login.jsp
   - Red error message: "Invalid username or password"
   - No session created

**Status:** ✅ Pass / ❌ Fail

---

#### Test 2.3: Valid Login Test
1. **Enter:** Username: `hr_admin`, Password: `admin123`
2. **Click:** Login button
3. **Expected:**
   - Redirects to `committee-view.jsp`
   - Welcome message or user info displayed
   - Committee dashboard loads

**Status:** ✅ Pass / ❌ Fail

---

#### Test 2.4: Committee View Page Loads Data
**After successful login, verify:**
- [ ] Employee dropdown is populated (should show 20 employees)
- [ ] Existing committees are displayed (should show 2 committees)
- [ ] Each committee shows:
  - Committee name
  - Start and end dates
  - Management representatives
  - Working members
- [ ] No console errors (press F12 → Console tab)

**Status:** ✅ Pass / ❌ Fail

---

#### Test 2.5: Create New Committee (Full Flow)
1. **Fill in Committee Details:**
   - Committee Name: "Test Quality Committee"
   - Start Date: "2025-03-01"
   - End Date: "2025-12-31"

2. **Add Management Representatives:**
   - Select Employee: "Ravi Sharma (GM - Operations)"
   - Click "Add to Management Representatives"
   - Verify employee appears in the list

3. **Add Working Members:**
   - Select Employee: "Arjun Nair (Supervisor - Production)"
   - Click "Add to Working Members"
   - Verify employee appears in the list

4. **Submit:**
   - Click "Create Committee" button
   - **Expected:**
     - Success message appears
     - New committee appears in the list below
     - Form resets
     - Committee count increases by 1

**Status:** ✅ Pass / ❌ Fail

---

#### Test 2.6: Logout Test
1. **Click:** Logout button (if available)
2. **Or visit:** http://localhost:8080/hal-committee/logout.jsp
3. **Expected:**
   - Redirects to login.jsp
   - Green success message: "Logged out successfully!"
   - Session is cleared

4. **Try to access committee-view.jsp directly:**
   - Visit: http://localhost:8080/hal-committee/committee-view.jsp
   - **Expected:** Should redirect to login (or show access denied)

**Status:** ✅ Pass / ❌ Fail

---

### Test Suite 3: Integration Testing

#### Test 3.1: Backend Connection Test
1. **Stop Backend Server** (close the FastAPI window)
2. **Try to login** with `hr_admin / admin123`
3. **Expected:**
   - Error message: "Cannot connect to backend server"
   - Page stays on login.jsp
4. **Restart Backend Server**
5. **Try to login again**
6. **Expected:** Login successful

**Status:** ✅ Pass / ❌ Fail

---

#### Test 3.2: CORS Test
1. **Open browser console** (F12 → Console)
2. **Login and navigate** to committee-view.jsp
3. **Check console** for errors
4. **Expected:**
   - ✅ No CORS errors
   - ✅ No "Access-Control-Allow-Origin" errors
   - ✅ All API calls successful (200 status)

**Status:** ✅ Pass / ❌ Fail

---

#### Test 3.3: Data Persistence Test
1. **Create a new committee** (e.g., "Test Audit Committee")
2. **Note the committee details**
3. **Logout**
4. **Login again**
5. **Expected:**
   - New committee is still visible
   - All details match what you entered
   - Committee was saved to database

**Status:** ✅ Pass / ❌ Fail

---

#### Test 3.4: Multiple User Test
**Test all 3 HR accounts:**

1. **Login with:** `hr_admin / admin123`
   - Expected: ✅ Successful login

2. **Logout and login with:** `hr_kavita / kavita@2025`
   - Expected: ✅ Successful login

3. **Logout and login with:** `hr_raj / raj#hrpass`
   - Expected: ✅ Successful login

**Status:** ✅ Pass / ❌ Fail

---

### Test Suite 4: Browser Console Testing

#### Test 4.1: Check API Calls in Network Tab
1. **Open browser** (Chrome/Edge recommended)
2. **Press F12** → Go to "Network" tab
3. **Login to the application**
4. **Navigate to committee-view.jsp**
5. **Check Network Tab:**
   - [ ] Request to `/api/employees` - Status: 200
   - [ ] Request to `/api/committees` - Status: 200
   - [ ] No failed requests (red entries)

**Status:** ✅ Pass / ❌ Fail

---

#### Test 4.2: Check Console for Errors
1. **Press F12** → Go to "Console" tab
2. **Navigate through the application**
3. **Expected:**
   - ✅ No red error messages
   - ✅ No "undefined" errors
   - ✅ No "null" reference errors
   - ✅ May see info messages (blue) - that's OK

**Status:** ✅ Pass / ❌ Fail

---

### Test Suite 5: Database Verification

#### Test 5.1: Verify New Committee in Database
```powershell
cd "c:\sambhranta\projects\HAL-Internship\backend"
python -c "import sqlite3; conn = sqlite3.connect('company.db'); cursor = conn.cursor(); cursor.execute('SELECT * FROM committee'); committees = cursor.fetchall(); print(f'Total committees: {len(committees)}'); [print(f'  - {c[1]} ({c[2]} to {c[3]})') for c in committees]; conn.close()"
```
**Expected:** Shows all committees including newly created ones

**Status:** ✅ Pass / ❌ Fail

---

#### Test 5.2: Verify Committee Members
```powershell
cd "c:\sambhranta\projects\HAL-Internship\backend"
python -c "import sqlite3; conn = sqlite3.connect('company.db'); cursor = conn.cursor(); cursor.execute('SELECT cm.committee_id, c.committee_name, cm.employee_id, cm.role, cm.member_type FROM committee_member cm JOIN committee c ON cm.committee_id = c.committee_id'); members = cursor.fetchall(); print(f'Total members: {len(members)}'); [print(f'  Committee {m[0]} ({m[1]}): Employee {m[2]} - {m[3]} ({m[4]})') for m in members]; conn.close()"
```
**Expected:** Shows all committee members with roles

**Status:** ✅ Pass / ❌ Fail

---

## 🐛 Troubleshooting Guide

### Issue 1: "Cannot connect to backend server"
**Symptoms:** Error message on login page
**Solution:**
```powershell
# Check if backend is running:
curl http://127.0.0.1:8001

# If not running, start it:
cd "c:\sambhranta\projects\HAL-Internship\backend"
python -m uvicorn main:app --host 127.0.0.1 --port 8001 --reload
```

---

### Issue 2: "HTTP 404 - Not Found"
**Symptoms:** Tomcat shows 404 error
**Solution:**
```powershell
# Check if JSP files are deployed:
Test-Path "C:\Program Files\apache-tomcat-9.0.111\webapps\hal-committee\login.jsp"

# If FALSE, deploy files:
# Right-click redeploy-auth.bat → Run as Administrator
```

---

### Issue 3: "Tomcat not starting"
**Symptoms:** startup.bat closes immediately
**Solution:**
```powershell
# Check if port 8080 is in use:
netstat -ano | findstr :8080

# If port is occupied, kill the process or use different port
# Or check Tomcat logs:
Get-Content "C:\Program Files\apache-tomcat-9.0.111\logs\catalina.*.log" | Select-Object -Last 50
```

---

### Issue 4: "CORS Error in Browser Console"
**Symptoms:** "Access-Control-Allow-Origin" error
**Solution:**
- Check backend CORS config in `main.py`
- Verify it includes: `http://localhost:8080`
- Restart backend after changes

---

### Issue 5: "Empty Employee Dropdown"
**Symptoms:** No employees in dropdown
**Solution:**
```powershell
# Verify database has data:
cd "c:\sambhranta\projects\HAL-Internship\backend"
python create_employee_table.py

# Test API directly:
curl http://127.0.0.1:8001/api/employees
```

---

### Issue 6: "Session Expired / Access Denied"
**Symptoms:** Redirected to login unexpectedly
**Solution:**
- This is normal security behavior
- Session timeout is typically 30 minutes
- Just login again

---

## 📊 Testing Checklist Summary

### Backend API Tests (6 tests)
- [ ] Backend running
- [ ] API docs accessible
- [ ] Get employees endpoint
- [ ] Get committees endpoint
- [ ] HR login endpoint
- [ ] Create committee endpoint

### Frontend JSP Tests (6 tests)
- [ ] Login page loads
- [ ] Invalid login handled
- [ ] Valid login works
- [ ] Committee page loads data
- [ ] Create committee works
- [ ] Logout works

### Integration Tests (4 tests)
- [ ] Backend connection handling
- [ ] CORS working
- [ ] Data persistence
- [ ] Multiple users

### Console Tests (2 tests)
- [ ] Network requests successful
- [ ] No console errors

### Database Tests (2 tests)
- [ ] Committees saved
- [ ] Members saved

**Total: 20 Tests**

---

## 🎯 Quick Test Commands

### Test Backend Endpoints (PowerShell)
```powershell
# Test all endpoints at once
Write-Host "Testing Backend APIs..." -ForegroundColor Cyan

# Test 1: Employees
try { 
    $r1 = Invoke-WebRequest "http://127.0.0.1:8001/api/employees" -UseBasicParsing
    Write-Host "✅ GET /api/employees - OK" -ForegroundColor Green
} catch { 
    Write-Host "❌ GET /api/employees - FAILED" -ForegroundColor Red 
}

# Test 2: Committees
try { 
    $r2 = Invoke-WebRequest "http://127.0.0.1:8001/api/committees" -UseBasicParsing
    Write-Host "✅ GET /api/committees - OK" -ForegroundColor Green
} catch { 
    Write-Host "❌ GET /api/committees - FAILED" -ForegroundColor Red 
}

# Test 3: HR Login
try { 
    $body = '{"username":"hr_admin","password":"admin123"}'
    $r3 = Invoke-WebRequest "http://127.0.0.1:8001/api/hr/login" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing
    Write-Host "✅ POST /api/hr/login - OK" -ForegroundColor Green
} catch { 
    Write-Host "❌ POST /api/hr/login - FAILED" -ForegroundColor Red 
}
```

---

### Check If Servers Are Running
```powershell
# Check Tomcat
$tomcat = Get-Process -Name "java" -ErrorAction SilentlyContinue | Where-Object {$_.MainWindowTitle -like "*Tomcat*"}
if ($tomcat) { 
    Write-Host "✅ Tomcat is running" -ForegroundColor Green 
} else { 
    Write-Host "❌ Tomcat is NOT running" -ForegroundColor Red 
}

# Check Backend
try { 
    Invoke-WebRequest "http://127.0.0.1:8001" -UseBasicParsing -TimeoutSec 2 | Out-Null
    Write-Host "✅ Backend is running" -ForegroundColor Green
} catch { 
    Write-Host "❌ Backend is NOT running" -ForegroundColor Red
}
```

---

## 📝 Test Report Template

After testing, record your results:

```
Test Date: [Date/Time]
Tester: [Your Name]

Backend API Tests:
- Get Employees: ✅ / ❌
- Get Committees: ✅ / ❌
- HR Login: ✅ / ❌
- Create Committee: ✅ / ❌

Frontend Tests:
- Login Page: ✅ / ❌
- Valid Login: ✅ / ❌
- Committee View: ✅ / ❌
- Create Committee: ✅ / ❌
- Logout: ✅ / ❌

Integration Tests:
- Backend Connection: ✅ / ❌
- CORS: ✅ / ❌
- Data Persistence: ✅ / ❌

Issues Found: [List any issues]
Notes: [Any observations]
```

---

## 🎓 Testing Best Practices

1. **Test in Order:** Follow Test Suite 1 → 2 → 3 → 4 → 5
2. **Clear Browser Cache:** Before testing, clear cache (Ctrl+Shift+Del)
3. **Use Incognito Mode:** For clean session testing
4. **Check Console:** Always check F12 console for errors
5. **Test All User Accounts:** Don't just test with one user
6. **Document Issues:** Note any problems you find
7. **Retest After Fixes:** Verify fixes work

---

## ✅ Expected Final Result

After all tests pass, you should have:
- ✅ Backend API responding to all requests
- ✅ Login working with all 3 HR accounts
- ✅ Employees loading in dropdown (20 employees)
- ✅ Committees displaying (2+ committees)
- ✅ New committee creation working
- ✅ Data persisting in database
- ✅ No console errors
- ✅ Logout working properly

---

**Happy Testing! 🎉**

If you encounter any issues, refer to the Troubleshooting Guide above.
