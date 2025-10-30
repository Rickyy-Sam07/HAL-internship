# Frontend API Integration Documentation

## Overview
All mock data has been removed from `committee-view.jsp`. The frontend is now ready to connect with your FastAPI backend.

---

## API Configuration

### Base URL
Located at the top of the script section in `committee-view.jsp`:
```javascript
const API_BASE_URL = 'http://127.0.0.1:8001';
```
**Action Required:** Update this URL to match your FastAPI backend URL.

---

## Required API Endpoints

### 1. GET /api/employees
**Purpose:** Fetch all employees from the database

**Expected Response Format:**
```json
{
  "employees": [
    {
      "employee_id": "1",
      "employee_name": "John Doe",
      "designation": "Manager",
      "department_name": "HR"
    }
  ]
}
```

**Frontend Usage:**
- Called automatically on page load
- Populates the `employeeDatabase` object
- Used for employee lookup when entering EID in forms

---

### 2. GET /api/committees
**Purpose:** Fetch all committees with their members

**Expected Response Format:**
```json
{
  "committees": [
    {
      "committee_id": 1,
      "committee_name": "Safety Committee",
      "start_date": "2024-01-01",
      "end_date": "2024-12-31",
      "members": [
        {
          "employee_id": "1",
          "employee_name": "John Doe",
          "role": "Chairman",
          "member_type": "Management",
          "department_name": "HR"
        }
      ]
    }
  ]
}
```

**Frontend Usage:**
- Called automatically on page load
- Populates the `committees` array
- Displayed in the main dashboard

---

### 3. POST /api/committee/create
**Purpose:** Create a new committee

**Request Format:**
```json
{
  "committee_name": "New Committee",
  "start_date": "2025-01-01",
  "end_date": "2025-12-31",
  "members": [
    {
      "employee_id": "1",
      "role": "Chairman",
      "member_type": "Management"
    },
    {
      "employee_id": "10",
      "role": "Secretary",
      "member_type": "Working"
    }
  ]
}
```

**Expected Response:**
```json
{
  "message": "Committee created successfully",
  "committee_id": 5
}
```

**Frontend Usage:**
- Called when user submits the "Add Committee" form
- After success, automatically reloads all committees

---

## Frontend Functions

### Data Fetching Functions

#### `fetchEmployees()`
```javascript
async function fetchEmployees()
```
- Fetches all employees from backend
- Transforms data to frontend format
- Populates `employeeDatabase` object
- Returns: `{[employee_id]: {name, post, dept}}`

#### `fetchCommittees()`
```javascript
async function fetchCommittees()
```
- Fetches all committees from backend
- Transforms data to frontend format
- Populates `committees` array
- Returns: Array of committee objects

#### `createCommitteeAPI(committeeData)`
```javascript
async function createCommitteeAPI(committeeData)
```
- Creates new committee via API
- Throws error if creation fails
- Returns: API response

---

## Data Transformation

### Backend → Frontend

The frontend expects specific data formats. Here's how backend data is transformed:

**Employee Data:**
```javascript
// Backend format
{employee_id: "1", employee_name: "John", designation: "Manager", department_name: "HR"}

// Transformed to frontend format
employeeDatabase["1"] = {
  name: "John",
  post: "Manager",
  dept: "HR"
}
```

**Committee Data:**
```javascript
// Backend format
{
  committee_id: 1,
  committee_name: "Safety",
  start_date: "2024-01-01",
  end_date: "2024-12-31",
  members: [{employee_id: "1", role: "Chairman", member_type: "Management"}]
}

// Transformed to frontend format
{
  id: "HAL-COM-1",
  name: "Safety",
  fromDate: "2024-01-01",
  tillDate: "2024-12-31",
  managementReps: [{post: "Chairman", dept: "HR", eid: "1"}],
  workerReps: []
}
```

---

## Testing Checklist

### Before Backend Integration
- [x] Mock data removed
- [x] API functions created
- [x] Error handling added
- [x] Data transformation logic implemented

### After Backend Integration
- [ ] Update `API_BASE_URL` to match your backend
- [ ] Test `/api/employees` endpoint
- [ ] Test `/api/committees` endpoint
- [ ] Test `/api/committee/create` endpoint
- [ ] Verify CORS is configured on backend
- [ ] Check browser console for any errors
- [ ] Test employee lookup functionality
- [ ] Test committee creation flow

---

## CORS Configuration Required

Your FastAPI backend must allow requests from the Tomcat server (port 8080).

**Example FastAPI CORS setup:**
```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:8080", "http://127.0.0.1:8080"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

---

## Error Handling

All API functions include error handling:
- Network errors
- Server errors (500)
- Invalid responses
- Timeout errors

Errors are:
1. Logged to console (for debugging)
2. Displayed to user via `alert()`
3. Allow graceful degradation (empty arrays returned)

---

## Next Steps

1. **Provide your FastAPI backend code**
   - Share your existing endpoints
   - I'll verify the response formats match
   - I'll adjust frontend transformation logic if needed

2. **Update API_BASE_URL**
   - Set the correct backend URL
   - Consider using environment variables for production

3. **Test Integration**
   - Start backend server
   - Open frontend in browser
   - Check browser console for API calls
   - Verify data loads correctly

---

## Notes

- Employee IDs are now flexible (can be numeric or string)
- Committee IDs use "HAL-COM-{id}" format in frontend
- All API calls are asynchronous (uses async/await)
- Loading indicators could be added for better UX
- Consider adding retry logic for failed API calls

---

## Questions to Answer

Please provide:
1. Your FastAPI backend code/endpoints
2. Your database schema
3. Any authentication requirements
4. Expected data formats if different from above

I'll then fine-tune the frontend to perfectly match your backend! 🚀
