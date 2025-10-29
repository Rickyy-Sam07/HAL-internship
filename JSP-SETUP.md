# JSP Setup Instructions

## 📋 HAL Committee Management System - JSP Version

### File Structure
```
HAL-Internship/
├── login.jsp                  # Login page with glassmorphism design
├── authenticate.jsp           # Handles login authentication
├── logout.jsp                 # Handles logout and session invalidation
├── committee-view.jsp         # Main committee management interface
├── login.html                 # HTML version (legacy)
├── committee-view.html        # HTML version (legacy)
└── JSP-SETUP.md              # This file
```

## 🚀 Quick Start

### Prerequisites
- **JDK 8+** (Java Development Kit)
- **Apache Tomcat 9.0+**
- Web Browser (Chrome, Firefox, Edge)

### Installation

#### Step 1: Install Java JDK
```bash
# Check if Java is installed
java -version

# If not installed, download from:
# https://www.oracle.com/java/technologies/downloads/
```

#### Step 2: Install Apache Tomcat
1. Download from: https://tomcat.apache.org/download-90.cgi
2. Extract to: `C:\apache-tomcat-9.0.XX` (Windows) or `/opt/tomcat/` (Linux)

#### Step 3: Deploy Application
```bash
# Create application directory in Tomcat
mkdir <TOMCAT_HOME>/webapps/hal-committee

# Copy all JSP files to this directory
cp *.jsp <TOMCAT_HOME>/webapps/hal-committee/
```

#### Step 4: Start Tomcat Server

**Windows:**
```cmd
cd C:\apache-tomcat-9.0.XX\bin
startup.bat
```

**Linux/Mac:**
```bash
cd /opt/tomcat/bin
./startup.sh
```

#### Step 5: Access Application
Open browser and navigate to:
```
http://localhost:8080/hal-committee/login.jsp
```

## 🔐 Default Credentials
- **Username:** `admin`
- **Password:** `admin123`

## 📁 JSP Files Explained

### 1. login.jsp
- **Purpose:** User authentication interface
- **Features:**
  - Glassmorphism design with background image
  - Show/Hide password toggle
  - Caps Lock detection
  - Error/Success message display
- **Form Action:** `authenticate.jsp` (POST)

### 2. authenticate.jsp
- **Purpose:** Server-side credential validation
- **Process:**
  ```java
  1. Receive username & password from login form
  2. Validate credentials (admin/admin123)
  3. If valid:
     - Create session attributes (loggedInUser, userRole, isLoggedIn)
     - Redirect to committee-view.jsp?loggedIn=true
  4. If invalid:
     - Redirect to login.jsp?error=invalid
  ```

### 3. committee-view.jsp
- **Purpose:** Main committee management interface
- **Features:**
  - Server-side session check
  - User profile display (from session)
  - Committee CRUD operations
  - Search & filter functionality
  - EID auto-fetch system
- **Session Usage:**
  ```jsp
  <%
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
  %>
  ```

### 4. logout.jsp
- **Purpose:** Session termination
- **Process:**
  ```java
  1. Invalidate current session
  2. Redirect to login.jsp?logout=true
  ```

## 🔄 Session Flow Diagram

```
┌─────────────┐
│  login.jsp  │ ─── User enters credentials
└──────┬──────┘
       │ POST (username, password)
       ↓
┌──────────────────┐
│ authenticate.jsp │ ─── Validate credentials
└──────┬───────────┘
       │
    ┌──┴──┐
    │     │
  Valid  Invalid
    │     │
    │     └──→ login.jsp?error=invalid
    │
    ↓ Create Session
    │ - loggedInUser = "admin"
    │ - userRole = "Administrator"
    │ - isLoggedIn = true
    │
┌───┴─────────────────┐
│ committee-view.jsp  │ ─── Check session & display user profile
└─────────────────────┘
         │
         │ User clicks Logout
         ↓
    ┌──────────┐
    │logout.jsp│ ─── Invalidate session
    └────┬─────┘
         │
         ↓
   ┌─────────────┐
   │ login.jsp   │ ─── logout=true message
   └─────────────┘
```

## 🎨 User Profile Display (JSP)

The user profile is rendered **server-side** using JSP:

```jsp
<!-- In committee-view.jsp -->
<% if (isLoggedIn && loggedInUser != null && !loggedInUser.isEmpty()) { %>
<div class="user-profile" style="display: flex;">
    <div class="user-avatar">
        <%= loggedInUser.substring(0, 1).toUpperCase() %>
    </div>
    <div class="user-info">
        <span class="user-name">
            <%= loggedInUser.equals("admin") ? "Administrator" : loggedInUser %>
        </span>
        <span class="user-role"><%= userRole %></span>
    </div>
    <form action="logout.jsp" method="post">
        <button type="submit" class="logout-btn">Logout</button>
    </form>
</div>
<% } %>
```

## 🆚 HTML vs JSP Comparison

| Feature | HTML Version | JSP Version |
|---------|-------------|-------------|
| **Authentication** | Client-side (sessionStorage) | Server-side (JSP Session) |
| **Security** | Low (easily bypassed) | High (server validates) |
| **User Profile** | JavaScript renders | JSP server renders |
| **Session** | Browser storage | Server session |
| **Logout** | Clear storage & redirect | Invalidate session |
| **Requires Server** | ❌ No (runs in browser) | ✅ Yes (Tomcat needed) |

## 🔧 Tomcat Configuration (Optional)

### Change Default Port (from 8080)
Edit `<TOMCAT_HOME>/conf/server.xml`:
```xml
<Connector port="9090" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443" />
```

### Enable Auto-Deploy
In `server.xml`:
```xml
<Host name="localhost" appBase="webapps"
      unpackWARs="true" autoDeploy="true">
```

## 🐛 Troubleshooting

### Issue: Tomcat won't start
**Solution:**
```bash
# Check if port 8080 is already in use
netstat -ano | findstr :8080  # Windows
lsof -i :8080                  # Linux/Mac

# Kill the process or change Tomcat port
```

### Issue: 404 Error - Page Not Found
**Solution:**
- Verify files are in `<TOMCAT_HOME>/webapps/hal-committee/`
- Check URL: `http://localhost:8080/hal-committee/login.jsp`
- Restart Tomcat server

### Issue: Session not persisting
**Solution:**
- Check browser cookies are enabled
- Verify `session="true"` in JSP page directive
- Check Tomcat logs: `<TOMCAT_HOME>/logs/catalina.out`

### Issue: Changes not reflecting
**Solution:**
```bash
# Clear Tomcat work directory
rm -rf <TOMCAT_HOME>/work/Catalina/localhost/hal-committee

# Restart Tomcat
```

## 📚 Learn More

### JSP Session API
```jsp
// Set session attribute
session.setAttribute("key", value);

// Get session attribute
String value = (String) session.getAttribute("key");

// Remove attribute
session.removeAttribute("key");

// Invalidate session
session.invalidate();

// Check if session is new
boolean isNew = session.isNew();
```

### JSP Page Directives
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>    <!-- Enable session -->
<%@ page import="java.util.*" %>  <!-- Import classes -->
```

## 🚀 Next Steps

1. **Add Database:**
   - Replace mock data with MySQL/PostgreSQL
   - Use JDBC for database connectivity
   - Implement connection pooling

2. **Enhance Security:**
   - Hash passwords (BCrypt)
   - Add CSRF tokens
   - Implement role-based access control (RBAC)
   - Use HTTPS

3. **Add Features:**
   - Email notifications (JavaMail API)
   - File upload for documents
   - Export to PDF (iText library)
   - Audit logging

## 📞 Support

For issues or questions:
- Check Tomcat logs: `<TOMCAT_HOME>/logs/`
- Review JSP compilation errors in work directory
- Test with demo credentials: admin/admin123

---
**JSP Version Created for HAL Internship Project**
