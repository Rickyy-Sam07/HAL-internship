# HAL Committee Management System

A professional full-stack web application for managing committees, members, and employee data for Hindustan Aeronautics Limited (HAL), built with JSP, HTML5, CSS3, and JavaScript.

## 🎯 Project Overview

This is a complete committee management system that provides secure access to committee information with server-side authentication using JSP sessions.

### ✨ Key Features

- ✅ **Secure Login System** - Server-side authentication with JSP sessions
- ✅ **Committee Management** - Add, view, search, and filter committees
- ✅ **Employee Database** - 65+ employees with auto-fetch by EID
- ✅ **User Profile Display** - Shows logged-in user in header
- ✅ **Session Management** - Proper logout with session invalidation
- ✅ **Beautiful UI** - Glassmorphism design with smooth animations
- ✅ **Responsive Layout** - Works on all screen sizes
- ✅ **Guest/Admin Modes** - Different access levels based on authentication

## 🏗️ Architecture

```
Frontend: JSP (JavaServer Pages) with embedded JavaScript/CSS
Application Server: Apache Tomcat 9.0
Backend API: FastAPI (Python)
Database: SQLite
```

## 📋 Prerequisites

Before running this project, you need:

1. **Java Development Kit (JDK) 8 or higher**
2. **Apache Tomcat 9.0 or higher**
3. **Python 3.7+** (for backend API)
4. **Web Browser** (Chrome, Firefox, Edge)

## 🚀 Step-by-Step Setup Guide

### Step 1: Install Java JDK

#### Windows:
1. Download JDK from: https://www.oracle.com/java/technologies/downloads/
2. Run the installer and follow instructions
3. **Set JAVA_HOME environment variable:**
   - Right-click "This PC" → Properties → Advanced system settings → Environment Variables
   - Under System Variables, click "New"
   - Variable name: `JAVA_HOME`
   - Variable value: `C:\Program Files\Java\jdk-17` (your JDK path)
4. **Verify installation:**
   ```cmd
   java -version
   ```

#### Linux/Mac:
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install default-jdk

# Mac
brew install openjdk@17

# Verify
java -version
```

### Step 2: Download and Install Apache Tomcat

#### Windows:
1. **Download Tomcat:**
   - Visit: https://tomcat.apache.org/download-90.cgi
   - Under "Binary Distributions" → "Core"
   - Download "64-bit Windows zip" (apache-tomcat-9.0.xx-windows-x64.zip)

2. **Extract Tomcat:**
   - Extract ZIP to: `C:\apache-tomcat-9.0.111` (or your preferred location)

3. **Set CATALINA_HOME (Optional):**
   - Environment Variables → System Variables → New
   - Variable name: `CATALINA_HOME`
   - Variable value: `C:\apache-tomcat-9.0.111`

#### Linux/Mac:
```bash
# Download
cd ~/Downloads
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.95/bin/apache-tomcat-9.0.95.tar.gz

# Extract
sudo mkdir -p /opt/tomcat
sudo tar xzvf apache-tomcat-9.0.95.tar.gz -C /opt/tomcat --strip-components=1

# Set permissions
sudo chmod +x /opt/tomcat/bin/*.sh

# Add to PATH
echo 'export CATALINA_HOME=/opt/tomcat' >> ~/.bashrc
source ~/.bashrc
```

### Step 3: Clone This Repository

```bash
# Clone the repository
git clone https://github.com/Rickyy-Sam07/HAL-internship.git

# Navigate to project folder
cd HAL-internship
```

### Step 4: Deploy Project to Tomcat

#### Windows (Manual Method):
1. **Create application directory:**
   ```cmd
   cd "C:\apache-tomcat-9.0.111\webapps"
   mkdir hal-committee
   cd hal-committee
   mkdir WEB-INF
   cd WEB-INF
   mkdir classes
   mkdir lib
   ```

2. **Copy JSP files:**
   ```cmd
   cd C:\path\to\HAL-internship
   copy login-new.jsp "C:\apache-tomcat-9.0.111\webapps\hal-committee\login.jsp"
   copy committee-view-new.jsp "C:\apache-tomcat-9.0.111\webapps\hal-committee\committee-view.jsp"
   copy authenticate.jsp "C:\apache-tomcat-9.0.111\webapps\hal-committee\"
   copy logout.jsp "C:\apache-tomcat-9.0.111\webapps\hal-committee\"
   ```

3. **Create web.xml:**
   - Create file: `C:\apache-tomcat-9.0.111\webapps\hal-committee\WEB-INF\web.xml`
   - Copy content:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
                                http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
            version="4.0">
       
       <display-name>HAL Committee Management System</display-name>
       
       <welcome-file-list>
           <welcome-file>login.jsp</welcome-file>
       </welcome-file-list>
       
       <session-config>
           <session-timeout>30</session-timeout>
       </session-config>
   </web-app>
   ```

#### Windows (PowerShell Method):
```powershell
# Run PowerShell as Administrator
Copy-Item "login-new.jsp" -Destination "C:\apache-tomcat-9.0.111\webapps\hal-committee\login.jsp" -Force
Copy-Item "committee-view-new.jsp" -Destination "C:\apache-tomcat-9.0.111\webapps\hal-committee\committee-view.jsp" -Force
Copy-Item "authenticate.jsp" -Destination "C:\apache-tomcat-9.0.111\webapps\hal-committee\" -Force
Copy-Item "logout.jsp" -Destination "C:\apache-tomcat-9.0.111\webapps\hal-committee\" -Force
```

#### Linux/Mac:
```bash
# Create application directory
sudo mkdir -p /opt/tomcat/webapps/hal-committee/WEB-INF/{classes,lib}

# Copy JSP files
sudo cp login-new.jsp /opt/tomcat/webapps/hal-committee/login.jsp
sudo cp committee-view-new.jsp /opt/tomcat/webapps/hal-committee/committee-view.jsp
sudo cp authenticate.jsp /opt/tomcat/webapps/hal-committee/
sudo cp logout.jsp /opt/tomcat/webapps/hal-committee/

# Create web.xml
sudo nano /opt/tomcat/webapps/hal-committee/WEB-INF/web.xml
# Paste the web.xml content shown above
```

### Step 4.5: Install and Start Backend API (Python/FastAPI)

The application uses a FastAPI backend for data operations. Follow these steps to set it up:

#### 1. Install Python Dependencies
```bash
# Navigate to backend directory
cd backend

# Install required packages
pip install -r requirements.txt

# This will install:
# - fastapi
# - uvicorn[standard]
# - pydantic
```

#### 2. Verify Database Exists
```bash
# Check if company.db exists in backend folder
ls company.db  # Linux/Mac
dir company.db # Windows
```

The database contains:
- `employees` table (20 employees)
- `committee` table (committees data)
- `committee_member` table (member assignments with roles)
- `hr_login` table (authentication credentials)

#### 3. Start Backend Server
```bash
# Make sure you're in the backend directory
cd backend

# Start FastAPI server
python -m uvicorn main:app --host 127.0.0.1 --port 8001 --reload
```

**Expected Output:**
```
INFO:     Will watch for changes in these directories: ['C:\\path\\to\\HAL-Internship\\backend']
INFO:     Uvicorn running on http://127.0.0.1:8001 (Press CTRL+C to quit)
INFO:     Started reloader process [XXXX] using StatReload
INFO:     Started server process [XXXX]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
```

**⚠️ Keep this terminal running!** The backend must be active for the frontend to work.

#### 4. Test Backend API
Open a new terminal and test the API:
```bash
# Test employees endpoint
curl http://127.0.0.1:8001/api/employees

# Test committees endpoint
curl http://127.0.0.1:8001/api/committees

# Or open in browser:
# http://127.0.0.1:8001/api/employees
```

#### API Endpoints:
- `GET /` - Welcome message
- `GET /api/employees` - Get all employees
- `GET /api/employees/{id}` - Get specific employee
- `POST /api/hr/login` - Authenticate user
- `POST /api/committee/create` - Create committee
- `GET /api/committees` - Get all committees

**Backend Configuration:**
- **Host:** 127.0.0.1
- **Port:** 8001
- **CORS:** Allows http://localhost:8080 and http://127.0.0.1:8080
- **Auto-reload:** Yes (changes auto-apply)

### Step 5: Start Tomcat Server

#### Windows:
**Method 1: Using Batch File**
```cmd
cd C:\apache-tomcat-9.0.111\bin
startup.bat
```

**Method 2: As Windows Service**
```cmd
# Install service
cd C:\apache-tomcat-9.0.111\bin
service.bat install

# Start service via Services app
# Win + R → services.msc → Find "Apache Tomcat" → Start
```

#### Linux/Mac:
```bash
# Start Tomcat
sudo /opt/tomcat/bin/startup.sh

# Check if running
ps aux | grep tomcat

# View logs
tail -f /opt/tomcat/logs/catalina.out
```

### Step 6: Access the Application

**Important:** Make sure BOTH servers are running:
- ✅ Backend API on port 8001 (Python/FastAPI)
- ✅ Tomcat server on port 8080 (JSP)

1. **Open your web browser**
2. **Verify Backend is running:**
   ```
   http://127.0.0.1:8001/api/employees
   ```
   You should see employee data in JSON format.

3. **Verify Tomcat is running:**
   ```
   http://localhost:8080
   ```
   You should see the Tomcat welcome page.

4. **Access the application:**
   ```
   http://localhost:8080/hal-committee/login.jsp
   ```

5. **Login with default credentials:**
   - **Username:** `hr_admin`
   - **Password:** `admin123`

6. **After successful login, you'll be redirected to:**
   ```
   http://localhost:8080/hal-committee/committee-view.jsp
   ```

## 🎮 Using the Application

### Login Page
- Enter username and password
- Shows server-side error messages for invalid credentials
- Displays logout success message
- Beautiful glassmorphism design with HAL logo background

### Committee Management Page
- **User Profile:** See your username in the top-right corner
- **Add Committee:** Click "ADD DATA" button to open modal form
- **Search:** Type in search box to filter committees
- **View Details:** Click on any committee to expand details
- **EID Auto-Fetch:** Type employee ID to automatically fill details
- **Recent Committees:** Sidebar shows last 5 committees added
- **Logout:** Click logout button to end session

## 📁 Project Structure

```
HAL-internship/
├── login-new.jsp              # Login page (rename to login.jsp in Tomcat)
├── authenticate.jsp           # Server-side authentication handler
├── committee-view-new.jsp     # Main app (rename to committee-view.jsp)
├── logout.jsp                 # Session logout handler
├── login.html                 # HTML version (for reference)
├── committee-view.html        # HTML version (for reference)
├── README.md                  # This file
└── JSP-SETUP.md              # Detailed JSP documentation
```

## 🔧 Troubleshooting

### Issue: Port 8080 Already in Use
**Solution:**
```cmd
# Check what's using port 8080
netstat -ano | findstr :8080  # Windows
lsof -i :8080                  # Linux/Mac

# Kill the process or change Tomcat port
# Edit: <TOMCAT_HOME>/conf/server.xml
# Change: <Connector port="8080" to port="8081"
```

### Issue: Tomcat Won't Start
**Check:**
1. Is Java installed? Run `java -version`
2. Is JAVA_HOME set correctly?
3. Are there permission issues? Run as Administrator
4. Check logs: `<TOMCAT_HOME>/logs/catalina.out`

### Issue: 404 Error - Page Not Found
**Solution:**
1. Verify files are in: `<TOMCAT_HOME>/webapps/hal-committee/`
2. Correct URL: `http://localhost:8080/hal-committee/login.jsp`
3. Restart Tomcat
4. Clear browser cache (Ctrl + Shift + Delete)

### Issue: Still Redirecting to .html Instead of .jsp
**Solution:**
1. Clear browser cache completely
2. Close all browser windows
3. Restart Tomcat
4. Open in a new browser/incognito mode

### Issue: Login Not Working
**Check:**
1. Using correct credentials: admin / admin123
2. Form submits to `authenticate.jsp`
3. Check Tomcat logs for errors
4. Verify `authenticate.jsp` exists in deployment folder

### Issue: Session Not Persisting
**Solution:**
1. Check cookies are enabled in browser
2. Verify `web.xml` exists in `WEB-INF` folder
3. Check session timeout setting in `web.xml`

## 🛑 Stopping Tomcat

### Windows:
```cmd
cd C:\apache-tomcat-9.0.111\bin
shutdown.bat
```

### Linux/Mac:
```bash
sudo /opt/tomcat/bin/shutdown.sh
```

## 📊 Mock Data

### Pre-loaded Committees:
- 10 committees (HAL-COM-2024-001 to HAL-COM-2024-010)
- Each with Name, Purpose, Chairman, Members, Budget

### Employee Database:
- 65+ employees (EID: HAL001 to HAL128)
- Includes: Name, Designation, Department, Contact

## 🔐 Security Notes

⚠️ **Important:** This is a demo/internship project with hardcoded credentials.

**For Production:**
- Implement password hashing (BCrypt, Argon2)
- Use database instead of mock data
- Add HTTPS/SSL
- Implement CSRF protection
- Use prepared statements for SQL
- Add input validation and sanitization
- Implement role-based access control

## 🌐 Technology Stack

| Component | Technology |
|-----------|-----------|
| **Backend** | JSP (JavaServer Pages) |
| **Server** | Apache Tomcat 9.0 |
| **Frontend** | HTML5, CSS3, JavaScript (Vanilla) |
| **Session** | JSP Session API |
| **Authentication** | Server-side validation |
| **Styling** | Custom CSS with Glassmorphism |

## 📝 Important URLs

| Page | URL |
|------|-----|
| **Login** | http://localhost:8080/hal-committee/login.jsp |
| **Main App** | http://localhost:8080/hal-committee/committee-view.jsp |
| **Logout** | http://localhost:8080/hal-committee/logout.jsp |
| **Tomcat Home** | http://localhost:8080 |

## 🎓 Learning Resources

- **JSP Tutorial:** https://www.javatpoint.com/jsp-tutorial
- **Tomcat Documentation:** https://tomcat.apache.org/tomcat-9.0-doc/
- **JSP Session Management:** https://www.tutorialspoint.com/jsp/jsp_session_tracking.htm

## 📞 Support

For issues or questions:
- Check logs: `<TOMCAT_HOME>/logs/catalina.out`
- Review JSP-SETUP.md for detailed setup
- Test with demo credentials: admin/admin123

## 👨‍💻 Developer

**Internship Project - Hindustan Aeronautics Limited**

Repository: https://github.com/Rickyy-Sam07/HAL-internship

## 📄 License

Educational/Internship Project

---

**Made with ❤️ for HAL**

**Version**: 1.0  
**Last Updated**: October 29, 2025  
**Author**: HAL Internship Project
