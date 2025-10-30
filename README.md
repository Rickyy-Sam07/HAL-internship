# HAL Committee Management System# HAL Committee Management System - JSP Project



A full-stack web application for managing committees, members, and employee data for Hindustan Aeronautics Limited (HAL).A professional committee management system for Hindustan Aeronautics Limited (HAL) built with JSP (JavaServer Pages), HTML5, CSS3, and JavaScript.



## 🏗️ Architecture## 🎯 Project Overview



```This is a full-stack web application that manages committees and employee information with server-side authentication using JSP sessions.

Frontend: JSP (JavaServer Pages) with embedded JavaScript/CSS

Application Server: Apache Tomcat 9.0### Key Features:

Backend API: FastAPI (Python)- ✅ **Secure Login System** - Server-side authentication with JSP sessions

Database: SQLite- ✅ **Committee Management** - Add, view, search, and filter committees

```- ✅ **Employee Database** - 65+ employees with auto-fetch by EID

- ✅ **User Profile Display** - Shows logged-in user in header

---- ✅ **Session Management** - Proper logout with session invalidation

- ✅ **Beautiful UI** - Glassmorphism design with smooth animations

## 📁 Project Structure- ✅ **Responsive Layout** - Works on all screen sizes



```---

HAL-Internship/

│## 📋 Prerequisites

├── backend/                          # Backend API Server

│   ├── main.py                       # FastAPI application with REST endpointsBefore running this project, you need:

│   ├── company.db                    # SQLite database file

│   ├── migrate_committee_member_table.py  # Database schema migration script1. **Java Development Kit (JDK) 8 or higher**

│   ├── requirements.txt              # Python dependencies2. **Apache Tomcat 9.0 or higher**

│   └── .gitignore                    # Git ignore rules for backend3. **Web Browser** (Chrome, Firefox, Edge)

│

├── login.jsp                         # Login page---

├── authenticate.jsp                  # Login authentication handler

├── committee-view.jsp                # Main committee management dashboard## 🚀 Step-by-Step Setup Guide

├── logout.jsp                        # Logout handler

│### Step 1: Install Java JDK

├── start-tomcat.bat                  # Script to start Tomcat server

├── redeploy-all.bat                  # Script to redeploy all JSP files#### Windows:

│1. Download JDK from: https://www.oracle.com/java/technologies/downloads/

└── README.md                         # This file2. Run the installer and follow instructions

```3. **Set JAVA_HOME environment variable:**

   - Right-click "This PC" → Properties

---   - Advanced system settings → Environment Variables

   - Under System Variables, click "New"

## 📄 File Descriptions   - Variable name: `JAVA_HOME`

   - Variable value: `C:\Program Files\Java\jdk-17` (your JDK path)

### **Frontend Files (JSP)**   - Click OK



#### 1. **login.jsp**4. **Verify installation:**

- **Purpose**: Login page for HR administrators   ```cmd

- **Features**:    java -version

  - Username/password input form   ```

  - Connects to backend API for authentication

  - Redirects to committee-view.jsp on successful login#### Linux/Mac:

```bash

#### 2. **authenticate.jsp**# Ubuntu/Debian

- **Purpose**: Server-side authentication handlersudo apt update

- **Functionality**:sudo apt install default-jdk

  - Receives POST request from login form

  - Calls backend API endpoint: `POST /api/hr/login`# Mac

  - Sets session variables (loggedInUser, userRole, isLoggedIn)brew install openjdk@17

  - Redirects to committee-view.jsp or back to login on failure

# Verify

#### 3. **committee-view.jsp** (Main Application - 58KB)java -version

- **Purpose**: Complete committee management dashboard```

- **Features**:

  - View all committees with details---

  - Search and filter committees

  - Create new committees with members### Step 2: Download and Install Apache Tomcat

  - Assign committee roles (Chairman, Secretary, Member)

  - Auto-fetch employee details by EID#### Windows:

  - Responsive design with sticky header

  - Guest viewing mode (read-only)1. **Download Tomcat:**

  - Admin mode (create/edit committees)   - Visit: https://tomcat.apache.org/download-90.cgi

- **Key Sections**:   - Under "Binary Distributions" → "Core"

  - Sticky header with login/ADD DATA button   - Download "64-bit Windows zip" (apache-tomcat-9.0.xx-windows-x64.zip)

  - Search functionality

  - Recently added committees carousel2. **Extract Tomcat:**

  - Complete committee listing with member details   - Extract ZIP to: `C:\apache-tomcat-9.0.111` (or your preferred location)

  - Modal form for committee creation

  - Role dropdown for each member3. **Set CATALINA_HOME (Optional):**

   - Environment Variables → System Variables → New

#### 4. **logout.jsp**   - Variable name: `CATALINA_HOME`

- **Purpose**: Session cleanup and logout handler   - Variable value: `C:\apache-tomcat-9.0.111`

- **Functionality**:

  - Invalidates user session#### Linux/Mac:

  - Redirects to login page```bash

# Download

### **Backend Files (Python/FastAPI)**cd ~/Downloads

wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.95/bin/apache-tomcat-9.0.95.tar.gz

#### 5. **backend/main.py** (145 lines)

- **Purpose**: REST API server for data operations# Extract

- **Endpoints**:sudo mkdir -p /opt/tomcat

  - `GET /` - API welcome messagesudo tar xzvf apache-tomcat-9.0.95.tar.gz -C /opt/tomcat --strip-components=1

  - `GET /api/employees` - Fetch all employees (20 records)

  - `GET /api/employees/{id}` - Fetch single employee by ID# Set permissions

  - `POST /api/hr/login` - Authenticate HR usersudo chmod +x /opt/tomcat/bin/*.sh

  - `POST /api/committee/create` - Create new committee with members

  - `GET /api/committees` - Fetch all committees with members# Add to PATH

- **Features**:echo 'export CATALINA_HOME=/opt/tomcat' >> ~/.bashrc

  - CORS middleware for frontend accesssource ~/.bashrc

  - SQLite database integration```

  - Automatic designation fetching for committee members

  - Transaction management with rollback support---



#### 6. **backend/company.db**### Step 3: Clone This Repository

- **Purpose**: SQLite database file

- **Tables**:```bash

  - `employees` (20 records) - Employee master data# Clone the repository

    - employee_id, employee_name, designation, department_namegit clone https://github.com/Rickyy-Sam07/HAL-internship.git

  - `committee` (3+ records) - Committee information

    - committee_id, committee_name, start_date, end_date# Navigate to project folder

  - `committee_member` (11+ records) - Committee membership detailscd HAL-internship

    - committee_member_id, committee_id, employee_id```

    - committee_role (Chairman/Secretary/Member)

    - post (employee designation: GM/AGM/Manager/Supervisor)---

    - member_type (Management/Working)

  - `hr_login` (3 records) - HR user credentials### Step 4: Deploy Project to Tomcat

    - username, password

#### Windows (Manual Method):

#### 7. **backend/migrate_committee_member_table.py**

- **Purpose**: Database schema migration script1. **Create application directory:**

- **Functionality**:   - Open Command Prompt **as Administrator**

  - Updates committee_member table structure   - Run:

  - Renames 'role' → 'committee_role'   ```cmd

  - Adds 'post' column for employee designation   cd "C:\apache-tomcat-9.0.111\webapps"

  - Migrates existing data automatically   mkdir hal-committee

   cd hal-committee

#### 8. **backend/requirements.txt**   mkdir WEB-INF

- **Purpose**: Python package dependencies   cd WEB-INF

- **Contents**:   mkdir classes

  ```   mkdir lib

  fastapi   ```

  uvicorn[standard]

  pydantic2. **Copy JSP files:**

  ```   ```cmd

   cd C:\path\to\HAL-internship

### **Deployment Scripts (Windows Batch Files)**   copy login-new.jsp "C:\apache-tomcat-9.0.111\webapps\hal-committee\login.jsp"

   copy committee-view-new.jsp "C:\apache-tomcat-9.0.111\webapps\hal-committee\committee-view.jsp"

#### 9. **start-tomcat.bat**   copy authenticate.jsp "C:\apache-tomcat-9.0.111\webapps\hal-committee\"

- **Purpose**: Start Apache Tomcat server   copy logout.jsp "C:\apache-tomcat-9.0.111\webapps\hal-committee\"

- **Functionality**:   ```

  - Launches Tomcat with admin privileges

  - Uses startup.bat from Tomcat installation directory3. **Create web.xml:**

   - Create file: `C:\apache-tomcat-9.0.111\webapps\hal-committee\WEB-INF\web.xml`

#### 10. **redeploy-all.bat**   - Copy content:

- **Purpose**: Deploy all JSP files to Tomcat   ```xml

- **Functionality**:   <?xml version="1.0" encoding="UTF-8"?>

  - Copies login.jsp, authenticate.jsp, committee-view.jsp, logout.jsp   <web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"

  - Deploys to: `C:\Program Files\apache-tomcat-9.0.111\webapps\hal-committee\`            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

  - Requires admin privileges            xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee

                                http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"

---            version="4.0">

       

## 🚀 How to Run the Project       <display-name>HAL Committee Management System</display-name>

       

### **Prerequisites**       <welcome-file-list>

           <welcome-file>login.jsp</welcome-file>

1. **Java Development Kit (JDK)** 8 or higher       </welcome-file-list>

2. **Apache Tomcat 9.0** installed at: `C:\Program Files\apache-tomcat-9.0.111`       

3. **Python 3.7+** installed       <session-config>

4. **Git** (optional, for version control)           <session-timeout>30</session-timeout>

       </session-config>

---   </web-app>

   ```

### **Step 1: Setup Backend API**

#### Windows (PowerShell Method):

#### 1.1 Navigate to backend directory

```powershell```powershell

cd C:\sambhranta\projects\HAL-Internship\backend# Run PowerShell as Administrator

```

# Copy files

#### 1.2 Install Python dependenciesCopy-Item "login-new.jsp" -Destination "C:\apache-tomcat-9.0.111\webapps\hal-committee\login.jsp" -Force

```powershellCopy-Item "committee-view-new.jsp" -Destination "C:\apache-tomcat-9.0.111\webapps\hal-committee\committee-view.jsp" -Force

pip install -r requirements.txtCopy-Item "authenticate.jsp" -Destination "C:\apache-tomcat-9.0.111\webapps\hal-committee\" -Force

```Copy-Item "logout.jsp" -Destination "C:\apache-tomcat-9.0.111\webapps\hal-committee\" -Force

```

#### 1.3 Verify database exists

```powershell#### Linux/Mac:

# Check if company.db exists in backend folder

ls company.db```bash

```# Create application directory

sudo mkdir -p /opt/tomcat/webapps/hal-committee/WEB-INF/{classes,lib}

#### 1.4 Start FastAPI server

```powershell# Copy JSP files

python -m uvicorn main:app --host 127.0.0.1 --port 8001 --reloadsudo cp login-new.jsp /opt/tomcat/webapps/hal-committee/login.jsp

```sudo cp committee-view-new.jsp /opt/tomcat/webapps/hal-committee/committee-view.jsp

sudo cp authenticate.jsp /opt/tomcat/webapps/hal-committee/

**Expected Output:**sudo cp logout.jsp /opt/tomcat/webapps/hal-committee/

```

INFO:     Uvicorn running on http://127.0.0.1:8001 (Press CTRL+C to quit)# Create web.xml

INFO:     Started reloader process [XXXX] using StatReloadsudo nano /opt/tomcat/webapps/hal-committee/WEB-INF/web.xml

INFO:     Started server process [XXXX]# Paste the web.xml content shown above

INFO:     Waiting for application startup.```

INFO:     Application startup complete.

```---



**Keep this terminal running!**### Step 5: Start Tomcat Server



---#### Windows:



### **Step 2: Deploy Frontend to Tomcat****Method 1: Using Batch File**

```cmd

#### 2.1 Deploy JSP files (Run as Administrator)cd C:\apache-tomcat-9.0.111\bin

```powershellstartup.bat

# Right-click PowerShell and select "Run as Administrator"```

cd C:\sambhranta\projects\HAL-Internship

.\redeploy-all.bat**Method 2: As Windows Service**

``````cmd

# Install service

This will copy all JSP files to Tomcat's webapps directory.cd C:\apache-tomcat-9.0.111\bin

service.bat install

#### 2.2 Start Tomcat Server (Run as Administrator)

```powershell# Start service via Services app

.\start-tomcat.bat# Win + R → services.msc → Find "Apache Tomcat" → Start

``````



**Alternative manual method:**#### Linux/Mac:

```powershell

cd "C:\Program Files\apache-tomcat-9.0.111\bin"```bash

.\startup.bat# Start Tomcat

```sudo /opt/tomcat/bin/startup.sh



#### 2.3 Verify Tomcat is running# Check if running

- Wait 10-15 seconds for Tomcat to startps aux | grep tomcat

- Open browser and go to: http://localhost:8080

- You should see Tomcat welcome page# View logs

tail -f /opt/tomcat/logs/catalina.out

---```



### **Step 3: Access the Application**---



#### 3.1 Open the application### Step 6: Access the Application

Navigate to: **http://localhost:8080/hal-committee/login.jsp**

1. **Open your web browser**

#### 3.2 Login with credentials

- **Username**: `hr_admin`2. **Verify Tomcat is running:**

- **Password**: `admin123`   ```

   http://localhost:8080

#### 3.3 Alternative credentials   ```

- Username: `hr_user1`, Password: `user123`   You should see the Tomcat welcome page.

- Username: `hr_user2`, Password: `pass456`

3. **Access the application:**

---   ```

   http://localhost:8080/hal-committee/login.jsp

## 🎯 Application Features   ```



### **Guest Mode (Not Logged In)**4. **Login with default credentials:**

- View all committees and their members   - **Username:** `admin`

- Search committees by name   - **Password:** `admin123`

- Browse recently added committees

- Read-only access5. **After successful login, you'll be redirected to:**

   ```

### **Admin Mode (Logged In)**   http://localhost:8080/hal-committee/committee-view.jsp

- All guest mode features +   ```

- **ADD DATA** button to create new committees

- Add management representatives---

- Add worker representatives

- Assign committee roles via dropdown:## 🎮 Using the Application

  - Chairman

  - Secretary### Login Page

  - Member- Enter username and password

- Auto-fetch employee details by EID- Shows server-side error messages for invalid credentials

- Form validation before submission- Displays logout success message

- Real-time data updates- Beautiful glassmorphism design with HAL logo background



---### Committee Management Page

- **User Profile:** See your username in the top-right corner

## 📊 Database Schema- **Add Committee:** Click "ADD DATA" button to open modal form

- **Search:** Type in search box to filter committees

### **employees**- **View Details:** Click on any committee to expand details

| Column | Type | Description |- **EID Auto-Fetch:** Type employee ID to automatically fill details

|--------|------|-------------|- **Recent Committees:** Sidebar shows last 5 committees added

| employee_id | INTEGER | Primary key, auto-increment |- **Logout:** Click logout button to end session

| employee_name | TEXT | Employee full name |

| designation | TEXT | Job title (GM, AGM, Manager, etc.) |---

| department_name | TEXT | Department name |

## 📁 Project Structure

### **committee**

| Column | Type | Description |```

|--------|------|-------------|HAL-internship/

| committee_id | INTEGER | Primary key, auto-increment |├── login-new.jsp              # Login page (rename to login.jsp in Tomcat)

| committee_name | TEXT | Committee name |├── authenticate.jsp           # Server-side authentication handler

| start_date | TEXT | Start date (YYYY-MM-DD) |├── committee-view-new.jsp     # Main app (rename to committee-view.jsp)

| end_date | TEXT | End date (YYYY-MM-DD) |├── logout.jsp                 # Session logout handler

├── login.html                 # HTML version (for reference)

### **committee_member**├── committee-view.html        # HTML version (for reference)

| Column | Type | Description |├── README.md                  # This file

|--------|------|-------------|└── JSP-SETUP.md              # Detailed JSP documentation

| committee_member_id | INTEGER | Primary key, auto-increment |```

| committee_id | INTEGER | Foreign key → committee |

| employee_id | INTEGER | Foreign key → employees |---

| committee_role | TEXT | Chairman/Secretary/Member |

| post | TEXT | Employee designation |## 🔧 Troubleshooting

| member_type | TEXT | Management/Working |

### Issue: Port 8080 Already in Use

### **hr_login**

| Column | Type | Description |**Solution:**

|--------|------|-------------|```cmd

| username | TEXT | HR username |# Check what's using port 8080

| password | TEXT | HR password (plain text) |netstat -ano | findstr :8080  # Windows

lsof -i :8080                  # Linux/Mac

---

# Kill the process or change Tomcat port

## 🔧 Configuration# Edit: <TOMCAT_HOME>/conf/server.xml

# Change: <Connector port="8080" to port="8081"

### **Backend Configuration (main.py)**```

- **Host**: 127.0.0.1

- **Port**: 8001### Issue: Tomcat Won't Start

- **CORS Origins**: 

  - http://localhost:8080**Check:**

  - http://127.0.0.1:80801. Is Java installed? Run `java -version`

2. Is JAVA_HOME set correctly?

### **Tomcat Configuration**3. Are there permission issues? Run as Administrator

- **Installation Path**: `C:\Program Files\apache-tomcat-9.0.111`4. Check logs: `<TOMCAT_HOME>/logs/catalina.out`

- **Deployment Path**: `webapps\hal-committee\`

- **Port**: 8080 (default)### Issue: 404 Error - Page Not Found



---**Solution:**

1. Verify files are in: `<TOMCAT_HOME>/webapps/hal-committee/`

## 🐛 Troubleshooting2. Correct URL: `http://localhost:8080/hal-committee/login.jsp`

3. Restart Tomcat

### **Backend Issues**4. Clear browser cache (Ctrl + Shift + Delete)



#### Problem: Port 8001 already in use### Issue: Still Redirecting to .html Instead of .jsp

**Solution:**

```powershell**Solution:**

# Find and stop Python process1. Clear browser cache completely

Get-Process python | Stop-Process -Force2. Close all browser windows

# Restart backend3. Restart Tomcat

cd backend4. Open in a new browser/incognito mode

python -m uvicorn main:app --host 127.0.0.1 --port 8001 --reload

```### Issue: Login Not Working



#### Problem: Module 'fastapi' not found**Check:**

**Solution:**1. Using correct credentials: admin / admin123

```powershell2. Form submits to `authenticate.jsp`

pip install fastapi uvicorn pydantic3. Check Tomcat logs for errors

```4. Verify `authenticate.jsp` exists in deployment folder



#### Problem: Database file not found### Issue: Session Not Persisting

**Solution:**

```powershell**Solution:**

# Check if company.db exists in backend folder1. Check cookies are enabled in browser

cd backend2. Verify `web.xml` exists in `WEB-INF` folder

ls company.db3. Check session timeout setting in `web.xml`

# If missing, restore from backup or recreate

```---



### **Frontend Issues**## 🛑 Stopping Tomcat



#### Problem: Cannot access http://localhost:8080### Windows:

**Solution:**```cmd

```powershellcd C:\apache-tomcat-9.0.111\bin

# Check if Tomcat is runningshutdown.bat

netstat -an | findstr "8080"```

# If not running, start Tomcat

cd "C:\Program Files\apache-tomcat-9.0.111\bin"### Linux/Mac:

.\startup.bat```bash

```sudo /opt/tomcat/bin/shutdown.sh

```

#### Problem: 404 Error - Page not found

**Solution:**---

```powershell

# Redeploy JSP files with admin privileges## 📊 Mock Data

cd C:\sambhranta\projects\HAL-Internship

.\redeploy-all.bat### Pre-loaded Committees:

```- 10 committees (HAL-COM-2024-001 to HAL-COM-2024-010)

- Each with Name, Purpose, Chairman, Members, Budget

#### Problem: Login fails with 401 error

**Solution:**### Employee Database:

- Verify backend is running on port 8001- 65+ employees (EID: HAL001 to HAL128)

- Check browser console for CORS errors- Includes: Name, Designation, Department, Contact

- Verify credentials: hr_admin/admin123

---

#### Problem: "Failed to load committees" error

**Solution:**## 🔐 Security Notes

1. Check backend terminal for errors

2. Verify database file exists: `backend\company.db`⚠️ **Important:** This is a demo/internship project with hardcoded credentials.

3. Test API directly: http://127.0.0.1:8001/api/committees

**For Production:**

---- Implement password hashing (BCrypt, Argon2)

- Use database instead of mock data

## 🔐 Security Notes- Add HTTPS/SSL

- Implement CSRF protection

⚠️ **Important**: This application is for development/demonstration purposes.- Use prepared statements for SQL

- Add input validation and sanitization

**Security Considerations:**- Implement role-based access control

- Passwords stored in plain text (use hashing in production)

- No HTTPS/SSL (use secure connections in production)---

- No input sanitization (add validation in production)

- Session management is basic (implement secure sessions in production)## 🌐 Technology Stack

- CORS allows all origins from Tomcat (restrict in production)

| Component | Technology |

---|-----------|-----------|

| **Backend** | JSP (JavaServer Pages) |

## 📝 API Documentation| **Server** | Apache Tomcat 9.0 |

| **Frontend** | HTML5, CSS3, JavaScript (Vanilla) |

### **Base URL**: http://127.0.0.1:8001| **Session** | JSP Session API |

| **Authentication** | Server-side validation |

### **Endpoints:**| **Styling** | Custom CSS with Glassmorphism |



#### GET /api/employees---

**Description**: Fetch all employees  

**Response**: ## 📝 Important URLs

```json

{| Page | URL |

  "employees": [|------|-----|

    {| **Login** | http://localhost:8080/hal-committee/login.jsp |

      "employee_id": 1,| **Main App** | http://localhost:8080/hal-committee/committee-view.jsp |

      "employee_name": "Ravi Sharma",| **Logout** | http://localhost:8080/hal-committee/logout.jsp |

      "designation": "GM",| **Tomcat Home** | http://localhost:8080 |

      "department_name": "Operations"

    }---

  ]

}## 🎓 Learning Resources

```

- **JSP Tutorial:** https://www.javatpoint.com/jsp-tutorial

#### POST /api/hr/login- **Tomcat Documentation:** https://tomcat.apache.org/tomcat-9.0-doc/

**Description**: Authenticate HR user  - **JSP Session Management:** https://www.tutorialspoint.com/jsp/jsp_session_tracking.htm

**Request Body**:

```json---

{

  "username": "hr_admin",## 📞 Support

  "password": "admin123"

}For issues or questions:

```- Check logs: `<TOMCAT_HOME>/logs/catalina.out`

**Response**:- Review JSP-SETUP.md for detailed setup

```json- Test with demo credentials: admin/admin123

{

  "message": "Welcome, hr_admin!"---

}

```## 👨‍💻 Developer



#### POST /api/committee/create**Internship Project - Hindustan Aeronautics Limited**

**Description**: Create new committee with members  

**Request Body**:Repository: https://github.com/Rickyy-Sam07/HAL-internship

```json

{---

  "committee_name": "Safety Committee",

  "start_date": "2025-01-01",## 📄 License

  "end_date": "2025-12-31",

  "members": [Educational/Internship Project

    {

      "employee_id": 1,---

      "role": "Chairman",

      "member_type": "Management"**Made with ❤️ for HAL**

    }  - Duration (From date and Till date)

  ]  - Management Representatives (Post, Department, EID)

}  - Worker Representatives (Post, Department, EID)

```- 📱 **Responsive Design**: Works on all devices

- ✨ **Beautiful UI**: Modern gradient design with smooth animations

#### GET /api/committees

**Description**: Fetch all committees with members  ### Admin Access (After Login)

**Response**:- ➕ **Add Committee Data**: Create new committee entries

```json- ✏️ **Edit Data**: Modify committee information while adding

{- 💾 **Save & Continue**: Save progress and keep editing

  "committees": [- ✅ **Submit**: Finalize and publish committee data

    {- 🔒 **Login Protection**: Only authenticated users can add/modify data

      "committee_id": 1,

      "committee_name": "Employee Welfare Committee",## Files

      "start_date": "2025-01-01",

      "end_date": "2025-12-31",1. **committee-view.html** - Main page with React components and committee display

      "members": [2. **login.html** - Admin login page with premium design

        {3. **README.md** - This documentation file

          "employee_id": 1,4. **REACT_COMPONENTS.md** - Detailed React components documentation

          "employee_name": "Ravi Sharma",5. **PREMIUM_FEATURES.md** - Premium features documentation

          "committee_role": "Chairman",6. **SETUP_INSTRUCTIONS.md** - Setup and deployment guide

          "post": "GM",

          "department_name": "Operations",## How to Use

          "member_type": "Management"

        }### For Regular Users

      ]1. Open `committee-view.jsp` in your browser

    }2. Browse all committees

  ]3. Use the search box to find specific committees

}4. View detailed information about representatives

```

### For Admins

---1. Click "ADD DATA" button on the main page

2. You'll be redirected to login page

## 🚀 Development Workflow3. Enter credentials:

   - **Username**: `admin`

### **Making Changes to Frontend**   - **Password**: `admin123`

4. After login, a modal will appear

1. Edit JSP files in project root5. Fill in committee details:

2. Redeploy using: `.\redeploy-all.bat` (as admin)   - Committee name and ID

3. Refresh browser (Ctrl + F5 for hard refresh)   - Duration (from and till dates)

   - Add management representatives (Post, Dept, EID)

### **Making Changes to Backend**   - Add worker representatives (Post, Dept, EID)

6. Click "Save & Continue Editing" to save and keep editing

1. Edit `backend\main.py`7. Click "Submit" to finalize and publish

2. Save file (Uvicorn auto-reloads with `--reload` flag)8. Edit button disappears after submission

3. Check terminal for reload confirmation

4. Test API endpoints## Mock Data



### **Database Changes**The system comes with 3 pre-loaded committees:

1. Safety & Health Committee

1. Create migration script in `backend\` folder2. Welfare Committee

2. Run migration: `python backend\your_migration.py`3. Training & Development Committee

3. Verify changes with SQL queries or check_db script

4. Update backend API if schema changes## Technical Details

5. Update frontend if response structure changes

### Technologies Used

---- **React 18** - Modern UI components with hooks

- HTML5

## 📦 Backup & Restore- CSS3 (with modern gradients and animations)

- JavaScript (ES6+)

### **Backup Database**- JSX (Babel transformation)

```powershell- Responsive Design

Copy-Item backend\company.db backend\company.db.backup

```### Key Features Implementation



### **Restore Database**#### React Components

```powershell```javascript

Copy-Item backend\company.db.backup backend\company.db// 5 Major Components:

```1. StatsCounter - Animated number counting

2. AnimatedCommitteeCard - 3D flip cards

---3. SmartSearchBar - Live autocomplete

4. RecentCommitteesCarousel - Auto-rotating slides

## 🤝 Contributing5. ReactEnhancedApp - Main container

```

1. Create a feature branch

2. Make changes#### Search Functionality

3. Test thoroughly (backend + frontend)```javascript

4. Commit with descriptive messagesfunction searchCommittees() {

5. Push and create pull request    // React-powered live search

    // Shows suggestions dropdown

---    // Highlights matching text

    // Auto-scrolls to results

## 📞 Support}

```

For issues or questions:

- Check troubleshooting section above#### Dynamic Representative Addition

- Review backend terminal logs for API errors- Add/remove management representatives dynamically

- Check browser console for frontend errors- Add/remove worker representatives dynamically

- Verify Tomcat logs at: `C:\Program Files\apache-tomcat-9.0.111\logs\`- Validates all fields before submission



---#### Login Protection

- Redirects to login when "ADD DATA" is clicked

## 📄 License- Validates credentials

- Opens modal only after successful login

Internal project for Hindustan Aeronautics Limited (HAL)

#### Edit vs Submit

---- **Save**: Keeps edit functionality active

- **Submit**: Finalizes data and hides edit button

## 🎉 Quick Start Summary

## Deployment

```powershell

# Terminal 1: Start Backend (keep running)### For JSP Server (Tomcat, etc.)

cd C:\sambhranta\projects\HAL-Internship\backend1. Copy `committee-view.jsp` and `login.jsp` to your web application directory

python -m uvicorn main:app --host 127.0.0.1 --port 8001 --reload2. Deploy to your servlet container

3. Access via: `http://localhost:8080/your-app/committee-view.jsp`

# Terminal 2: Deploy & Start Tomcat (as Administrator)

cd C:\sambhranta\projects\HAL-Internship### For Quick Testing (HTML mode)

.\redeploy-all.bat1. Rename files to `.html` extension

.\start-tomcat.bat2. Open directly in browser

3. All features work except server-side session management

# Browser: Open Application

# URL: http://localhost:8080/hal-committee/login.jsp## Future Enhancements

# Login: hr_admin / admin123

```- [ ] Connect to real database

- [ ] Implement server-side authentication

**That's it! Your application is now running! 🚀**- [ ] Add user management

- [ ] Export committee data to PDF/Excel
- [ ] Email notifications
- [ ] Audit trail for changes
- [ ] Advanced search filters
- [ ] File attachments for committees

## Browser Support

- ✅ Chrome (recommended)
- ✅ Firefox
- ✅ Safari
- ✅ Edge
- ✅ Mobile browsers

## Security Notes

⚠️ **Important**: The current implementation uses client-side authentication for demonstration purposes only. For production use:

1. Implement server-side session management
2. Use secure password hashing
3. Add CSRF protection
4. Implement role-based access control
5. Use HTTPS
6. Validate all inputs on the server side

## Contact

For issues or questions, contact the HAL IT Department.

---

**Version**: 1.0  
**Last Updated**: October 29, 2025  
**Author**: HAL Internship Project
