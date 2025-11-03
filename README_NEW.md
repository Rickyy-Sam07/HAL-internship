# HAL Committee Management System 🚀

A modern full-stack web application for managing committees, members, and employee data for Hindustan Aeronautics Limited (HAL).

## ✨ Features

- ✅ **Single Server Architecture** - FastAPI serves both frontend and backend
- ✅ **Secure Login System** - Authentication with session management
- ✅ **Committee Management** - Create, view, and search committees
- ✅ **Employee Database** - Auto-fetch employee details by EID
- ✅ **Beautiful UI** - Glassmorphism design with smooth animations
- ✅ **Responsive Layout** - Works on all devices
- ✅ **Auto Documentation** - Built-in Swagger UI

## 🏗️ Tech Stack

- **Frontend:** HTML5, CSS3, JavaScript (ES6+)
- **Backend:** FastAPI (Python)
- **Database:** SQLite
- **Session:** localStorage (client-side)

## 🚀 Quick Start

### 1. Install Python Dependencies
```powershell
cd backend
pip install fastapi uvicorn
```

### 2. Start the Server

**Windows (Easy):**
```powershell
.\start-server.ps1
```

**Manual:**
```powershell
cd backend
python -m uvicorn main:app --host 127.0.0.1 --port 8001 --reload
```

### 3. Access the Application

Open your browser to:
- **Login Page:** http://127.0.0.1:8001/
- **API Docs:** http://127.0.0.1:8001/docs

### 4. Login

- **Username:** `hr_admin`
- **Password:** `admin123`

## 📁 Project Structure

```
HAL-Internship/
├── backend/
│   ├── main.py              # FastAPI server (frontend + API)
│   ├── company.db           # SQLite database
│   └── requirements.txt     # Dependencies
├── styles/
│   ├── login.css           # Login page styles
│   └── committee.css       # Committee styles
├── js/
│   ├── login.js            # Login logic
│   ├── login-utils.js      # Utilities
│   └── committee.js        # Committee logic
├── index.html              # Login page
├── committee-view.html     # Committee management
├── start-server.ps1        # Startup script
└── README.md               # This file
```

## 📡 API Endpoints

### Frontend Routes
- `GET /` - Login page (index.html)
- `GET /committee-view.html` - Committee management page

### API Routes
- `POST /api/hr/login` - Authenticate user
- `GET /api/employees` - Get all employees
- `GET /api/employees/{id}` - Get specific employee
- `GET /api/committees` - Get all committees
- `POST /api/committee/create` - Create committee

### Static Assets
- `/styles/*` - CSS files
- `/js/*` - JavaScript files

## 🎨 Key Features

### Login System
- Beautiful glassmorphism design
- Floating particle animation
- Password visibility toggle
- Error/success messages
- Session management

### Committee Management
- View all committees
- Search by name or ID
- Recent committees quick access
- Add new committees
- Auto-fetch employee details
- Form validation
- Smooth animations

### User Profile
- Logged-in user display
- Avatar with initial
- Role badge
- Logout functionality

## 🐛 Troubleshooting

### Port Already in Use
```powershell
python -m uvicorn main:app --host 127.0.0.1 --port 8002 --reload
```

### Module Not Found
```powershell
pip install fastapi uvicorn
```

### Database Not Found
Make sure `company.db` is in the `backend/` directory

### Static Files Not Loading
Verify `styles/` and `js/` folders are in the project root

## 🔒 Security Notes

⚠️ **For Production:**
- Use bcrypt for password hashing
- Implement JWT tokens
- Add HTTPS
- Rate limiting on login
- Environment variables for secrets

## 🚀 Deployment

### Heroku
```bash
echo "web: uvicorn backend.main:app --host 0.0.0.0 --port \$PORT" > Procfile
heroku create hal-committee
git push heroku main
```

### Docker
```dockerfile
FROM python:3.9
WORKDIR /app
COPY backend/requirements.txt .
RUN pip install -r requirements.txt
COPY . .
WORKDIR /app/backend
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8001"]
```

## 📚 Documentation

- See `SINGLE_SERVER_SETUP.md` for detailed setup guide
- See `CONVERSION_GUIDE.md` for JSP to HTML conversion details
- API docs available at http://127.0.0.1:8001/docs when server is running

## 🎓 Resources

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [JavaScript Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API)
- [SQLite Tutorial](https://www.sqlitetutorial.net/)

## 📜 License

Educational project for HAL Internship 2025

---

**Made with ❤️ for Hindustan Aeronautics Limited (HAL)**

**One Command. One Server. One Solution.** 🎯
