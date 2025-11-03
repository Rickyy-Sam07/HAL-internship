# JSP to HTML/CSS/JS Conversion Guide

## Overview
This guide explains how to convert the HAL Committee Management System from JSP to pure HTML/CSS/JavaScript.

## Current Structure (JSP)
```
├── login.jsp (392 lines) - Login page with embedded CSS/JS
├── authenticate.jsp - Server-side authentication handler  
├── committee-view.jsp (1796 lines) - Main application with embedded CSS/JS
├── logout.jsp - Session logout handler
└── backend/ - FastAPI backend (unchanged)
```

## New Structure (HTML/CSS/JS)
```
├── index.html - Login page
├── committee-view.html - Main application page
├── styles/
│   ├── login.css - Login page styles
│   └── committee.css - Committee view styles (extracted from JSP)
├── js/
│   ├── login.js - Login logic
│   ├── login-utils.js - Password toggle, particles animation
│   ├── committee.js - Committee management logic
│   ├── api.js - Shared API communication functions
│   └── session.js - Client-side session management
└── backend/ - FastAPI backend (unchanged)
```

## Key Changes

### 1. Session Management
**JSP (Server-side):**
```jsp
<%
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
%>
```

**HTML/JS (Client-side):**
```javascript
// Store session in localStorage
localStorage.setItem('isLoggedIn', 'true');
localStorage.setItem('loggedInUser', username);

// Retrieve session
const isLoggedIn = localStorage.getItem('isLoggedIn') === 'true';
const loggedInUser = localStorage.getItem('loggedInUser');
```

### 2. Authentication
**JSP (authenticate.jsp):**
- Server processes POST request
- Calls backend API
- Sets session attributes
- Redirects user

**HTML/JS:**
```javascript
// In js/login.js
document.getElementById('loginForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    const response = await fetch(`${API_BASE_URL}/api/hr/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, password })
    });
    
    if (response.ok) {
        localStorage.setItem('isLoggedIn', 'true');
        localStorage.setItem('loggedInUser', username);
        window.location.href = 'committee-view.html';
    }
});
```

### 3. Conditional Rendering
**JSP:**
```jsp
<% if (isLoggedIn) { %>
    <button>ADD DATA</button>
<% } else { %>
    <button>LOGIN</button>
<% } %>
```

**HTML/JS:**
```javascript
// In committee-view.html
<button id="actionButton" class="btn"></button>

// In committee.js
window.addEventListener('DOMContentLoaded', () => {
    const isLoggedIn = localStorage.getItem('isLoggedIn') === 'true';
    const button = document.getElementById('actionButton');
    
    if (isLoggedIn) {
        button.textContent = 'ADD DATA';
        button.classList.add('btn-add');
        button.onclick = openModal;
    } else {
        button.textContent = 'LOGIN';
        button.classList.add('btn-login');
        button.onclick = () => window.location.href = 'index.html';
    }
});
```

### 4. Logout
**JSP (logout.jsp):**
```jsp
<%
    session.invalidate();
    response.sendRedirect("login.jsp?logout=true");
%>
```

**HTML/JS:**
```javascript
// In committee.js
function logout() {
    localStorage.clear();
    sessionStorage.clear();
    window.location.href = 'index.html?logout=true';
}
```

## Files Already Created

✅ **index.html** - Login page structure  
✅ **styles/login.css** - Complete login styles  
✅ **js/login.js** - Login form handling, API authentication  
✅ **js/login-utils.js** - Password toggle, floating particles

## Files Needed

### committee-view.html
Extract HTML structure from committee-view.jsp (lines 1020-1110), replace JSP tags with placeholder divs/spans that JS will populate.

### styles/committee.css  
Extract all CSS from committee-view.jsp (lines 20-1020), save as separate file.

### js/committee.js
Extract all JavaScript from committee-view.jsp (lines 1111-1796), adapt for client-side:
- Replace `<%= isLoggedIn %>` with `localStorage.getItem('isLoggedIn') === 'true'`
- Replace `<%= loggedInUser %>` with `localStorage.getItem('loggedInUser')`
- Add DOMContentLoaded listeners
- Update UI based on session state

### js/api.js (Optional but recommended)
```javascript
const API_BASE_URL = 'http://127.0.0.1:8001';

export async function apiCall(endpoint, method = 'GET', body = null) {
    const options = {
        method,
        headers: { 'Content-Type': 'application/json' }
    };
    if (body) options.body = JSON.stringify(body);
    
    const response = await fetch(`${API_BASE_URL}${endpoint}`, options);
    if (!response.ok) throw new Error(`API Error: ${response.status}`);
    return response.json();
}
```

## Step-by-Step Conversion Process

### Step 1: Extract CSS from committee-view.jsp
```powershell
# Lines 20-1020 contain all CSS
# Copy to styles/committee.css
```

### Step 2: Create committee-view.html
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Committee Management System</title>
    <link rel="stylesheet" href="styles/committee.css">
</head>
<body>
    <!-- Copy HTML structure from committee-view.jsp lines 1020-1110 -->
    <!-- Replace JSP tags with spans/divs with IDs -->
    
    <div class="top-header">
        <div class="top-header-content">
            <div class="logo-container">
                <img src="https://..." alt="HAL Logo" class="hal-logo">
                <div class="logo-text">
                    <h1>Hindustan Aeronautics Limited</h1>
                    <p>Committee Management System</p>
                </div>
            </div>
            
            <div class="user-profile" id="userProfile" style="display: none;">
                <div class="user-avatar" id="userAvatar"></div>
                <div class="user-info">
                    <span class="user-name" id="userName"></span>
                    <span class="user-role" id="userRole"></span>
                </div>
                <button class="logout-btn" id="logoutBtn">Logout</button>
            </div>
        </div>
    </div>

    <!-- Rest of HTML structure -->
    
    <script src="js/committee.js"></script>
</body>
</html>
```

### Step 3: Create js/committee.js
```javascript
// Extract JavaScript from committee-view.jsp lines 1111-1796
// Replace JSP expressions with localStorage calls

const API_BASE_URL = 'http://127.0.0.1:8001';
let committees = [];
let employeeDatabase = {};
let currentEditingIndex = -1;

// Initialize on page load
window.addEventListener('DOMContentLoaded', async () => {
    initializeSession();
    await fetchEmployees();
    await fetchCommittees();
    displayRecentCommittees();
    displayCommittees();
});

function initializeSession() {
    const isLoggedIn = localStorage.getItem('isLoggedIn') === 'true';
    const loggedInUser = localStorage.getItem('loggedInUser');
    const userRole = localStorage.getItem('userRole') || 'Guest';
    
    if (isLoggedIn && loggedInUser) {
        // Show user profile
        document.getElementById('userProfile').style.display = 'flex';
        document.getElementById('userAvatar').textContent = loggedInUser.substring(0, 1).toUpperCase();
        document.getElementById('userName').textContent = loggedInUser === 'admin' ? 'Administrator' : loggedInUser;
        document.getElementById('userRole').textContent = userRole;
        
        // Setup logout
        document.getElementById('logoutBtn').onclick = logout;
        
        // Show ADD DATA button
        const actionBtn = document.querySelector('.header-buttons .btn');
        actionBtn.textContent = 'ADD DATA';
        actionBtn.classList.add('btn-add');
        actionBtn.onclick = handleAddData;
    } else {
        // Show LOGIN button
        const actionBtn = document.querySelector('.header-buttons .btn');
        actionBtn.textContent = 'LOGIN';
        actionBtn.classList.add('btn-login');
        actionBtn.onclick = redirectToLogin;
    }
}

function logout() {
    localStorage.clear();
    window.location.href = 'index.html?logout=true';
}

function redirectToLogin() {
    window.location.href = 'index.html';
}

// ... rest of the JavaScript functions from committee-view.jsp
```

## Testing the Conversion

### 1. Start Backend
```bash
cd backend
python -m uvicorn main:app --host 127.0.0.1 --port 8001 --reload
```

### 2. Serve HTML Files
You can't open HTML files directly due to CORS. Use one of these methods:

**Option A: VS Code Live Server**
- Install "Live Server" extension
- Right-click index.html → "Open with Live Server"

**Option B: Python HTTP Server**
```bash
python -m http.server 8080
# Open http://localhost:8080/index.html
```

**Option C: Node.js http-server**
```bash
npx http-server -p 8080
# Open http://localhost:8080/index.html
```

### 3. Test Features
- ✅ Login with hr_admin/admin123
- ✅ View committees
- ✅ Search committees
- ✅ Add new committee
- ✅ Logout

## Benefits of HTML/CSS/JS

1. **No Server Required** - Can run on any static hosting (GitHub Pages, Netlify, etc.)
2. **Simpler Deployment** - No Tomcat, just copy files
3. **Better Separation** - CSS/JS/HTML in separate files
4. **Modern Development** - Use modern JS features, easier debugging
5. **Faster Development** - No need to redeploy to test changes

## Drawbacks & Considerations

1. **Security** - Session data in localStorage (less secure than server-side sessions)
   - Solution: Implement JWT tokens, HTTPS only
   
2. **SEO** - Client-side rendering not ideal for SEO
   - Not an issue for internal apps
   
3. **Browser Compatibility** - Relies on modern browser features
   - Use polyfills if needed

## Migration Checklist

- [x] Create index.html (login page)
- [x] Create styles/login.css
- [x] Create js/login.js  
- [x] Create js/login-utils.js
- [ ] Create committee-view.html
- [ ] Create styles/committee.css
- [ ] Create js/committee.js
- [ ] Test login flow
- [ ] Test committee creation
- [ ] Test search functionality
- [ ] Test logout

## Next Steps

1. Run the conversion script: `.\convert-jsp-to-html.ps1`
2. Extract CSS from committee-view.jsp → styles/committee.css
3. Create committee-view.html template
4. Extract and adapt JavaScript to committee.js
5. Test all functionality
6. Update README.md with new setup instructions

## Support

If you encounter issues during conversion:
1. Check browser console for errors
2. Verify backend is running on port 8001
3. Check CORS settings in backend/main.py
4. Ensure localStorage is enabled in browser

## Conclusion

Converting from JSP to HTML/CSS/JS modernizes your application, simplifies deployment, and makes development faster. The backend API remains unchanged, so you get the best of both worlds.
