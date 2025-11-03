# Quick Testing Guide - Employee Lookup Fix

## 🚀 Start Server
```powershell
python backend/main.py
```
Server runs on: `http://localhost:8001`

## 🧪 Quick Test Steps

### 1. Login
- URL: `http://localhost:8001`
- Username: `admin`
- Password: `admin123`

### 2. Navigate to Add Committee
- Click "ADD DATA" button
- Should open: `http://localhost:8001/add-committee.html`

### 3. Test Employee Auto-Fill
**Management Section:**
- Enter EID: `1` → Auto-fills "Ravi Sharma"
- Enter EID: `2` → Auto-fills "Anita Desai"
- Enter EID: `999` → Shows error with valid range

**Worker Section:**
- Enter EID: `15` → Auto-fills employee 15's details
- Enter EID: `20` → Auto-fills employee 20's details

### 4. Add Members
- Select Role: Chairman
- Click "Add" → Appears in table
- Try adding same EID → Shows duplicate error
- Try adding second Chairman → Shows constraint error

### 5. Create Committee
```
Committee Name: Works Committee 2025
Start Date: 2025-01-01
End Date: 2025-12-31

Management:
- Employee 1: Chairman
- Employee 2: Secretary

Worker:
- Employee 15: Chairman
- Employee 16: Secretary
```
Click "Create Committee" → Success alert with committee ID

## ✅ Expected Results

| Action | Expected Outcome |
|--------|------------------|
| Enter EID 1 | Auto-fills: Ravi Sharma, Manager, HR |
| Enter EID 999 | Error: Available range 1 to 28 |
| Add Chairman | Orange badge, appears in table |
| Add Secretary | Blue badge, appears in table |
| Add duplicate | Error: Already added |
| Add 2nd Chairman | Error: Only one Chairman allowed |
| Edit member | Form populates, can modify role |
| Delete member | Removed from table after confirm |
| Submit committee | Alert shows "HAL-COM-{id}" from backend |

## 🐛 Debug Commands

### Check Database
```powershell
cd backend
python -c "import sqlite3; conn = sqlite3.connect('company.db'); cursor = conn.cursor(); cursor.execute('SELECT employee_id, employee_name FROM employees LIMIT 5'); print([dict(zip(['employee_id', 'employee_name'], row)) for row in cursor.fetchall()])"
```

### Check Employee API
Open in browser: `http://localhost:8001/api/employees`

### Browser Console Tests
```javascript
// Check employee database loaded
console.log('Employees:', Object.keys(employeeDatabase).length);

// Test lookup
console.log('Employee 1:', employeeDatabase[1]);

// Check members
console.log('Management:', managementMembers);
console.log('Worker:', workerMembers);
```

## 📋 Key Changes Made

| File | Change | Why |
|------|--------|-----|
| `js/add-committee.js` (fetchEmployeeInfo) | Added `parseInt(eid)` | Convert string to number for lookup |
| `js/add-committee.js` (addMember) | Added `parseInt(eid)` | Store numeric ID in members array |
| `add-committee.html` (mgmt) | Placeholder: "1" | Show numeric format, not "HAL001" |
| `add-committee.html` (worker) | Placeholder: "15" | Show numeric format, not "HAL101" |
| `backend/main.py` | Added uvicorn.run() | Make server actually start |

## 🎯 Success Criteria

- [x] Employee auto-fill works
- [x] Numeric IDs (1, 2, 3) accepted
- [x] "HAL001" format NOT required
- [x] Add member stores numeric ID
- [x] Duplicate prevention works
- [x] Role constraints enforced
- [x] Committee uses backend-generated ID
- [x] Alert shows "HAL-COM-{backend_id}"

## 📞 Issue Resolution

**Problem**: "YOU ARE NOT FETCHING THE EMPLYEE DETAILS"  
**Root Cause**: Database uses INTEGER (1, 2, 3), code expected STRING ("HAL001")  
**Solution**: Convert input to number with `parseInt()` before lookup  
**Status**: ✅ FIXED

**Problem**: "DONT GENERATE ANOTHER COMMITTE ID"  
**Root Cause**: Confusion about ID generation  
**Clarification**: Backend auto-generates, client just displays with "HAL-COM-" prefix  
**Status**: ✅ VERIFIED CORRECT

## 🔗 Documentation

For complete details, see: `EMPLOYEE_LOOKUP_FIX.md`

---

**Status**: Ready for production! 🚀
