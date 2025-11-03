# Single Server Setup Guide

## Overview
The application now runs on a **single FastAPI server** that serves both the frontend (HTML/CSS/JS) and backend API endpoints. No need for separate Tomcat or HTTP servers!

## Architecture

### Before (Two Servers Required):
- Frontend: Tomcat/Live Server on port 8080 or 5500
- Backend: FastAPI on port 8001
- CORS issues and complexity

### After (Single Server):
- **Everything on FastAPI**: http://127.0.0.1:8001
- Frontend files served as static content
- API endpoints accessible at `/api/*`
- No CORS issues, simplified deployment

## How to Run

### 1. Start the Backend Server
```powershell
cd backend
python -m uvicorn main:app --host 127.0.0.1 --port 8001 --reload
```

### 2. Access the Application
Open your browser and navigate to:
- **Login Page**: http://127.0.0.1:8001/ or http://127.0.0.1:8001/index.html
- **Committee View**: http://127.0.0.1:8001/committee-view.html
- **API Docs**: http://127.0.0.1:8001/docs (FastAPI automatic documentation)

### 3. Test Credentials
- Username: `hr_admin`
- Password: `admin123`

## File Structure

```
HAL-Internship/
├── backend/
│   ├── main.py              # FastAPI app with routing
│   ├── company.db           # SQLite database
│   └── requirements.txt     # Python dependencies
├── styles/
│   ├── login.css           # Login page styles (served at /styles/login.css)
│   └── committee.css       # Committee page styles (served at /styles/committee.css)
├── js/
│   ├── login.js            # Login logic (served at /js/login.js)
│   ├── login-utils.js      # Shared utilities (served at /js/login-utils.js)
│   └── committee.js        # Committee logic (served at /js/committee.js)
├── index.html              # Login page (served at /)
└── committee-view.html     # Committee management page (served at /committee-view.html)
```

## Routes

### Frontend Routes (HTML Pages)
- `GET /` → Serves `index.html` (login page)
- `GET /index.html` → Serves `index.html` (login page)
- `GET /committee-view.html` → Serves `committee-view.html` (committee management)

### Static Assets
- `/styles/*` → CSS files from `styles/` directory
- `/js/*` → JavaScript files from `js/` directory

### API Routes
- `GET /api` → API welcome message
- `POST /api/hr/login` → Authenticate user
- `GET /api/employees` → Get all employees
- `GET /api/employees/{id}` → Get specific employee
- `GET /api/committees` → Get all committees with members
- `POST /api/committee/create` → Create new committee

## Key Changes Made

### 1. Backend (`backend/main.py`)
- Added `StaticFiles` imports and mounting:
  ```python
  from fastapi.staticfiles import StaticFiles
  from fastapi.responses import FileResponse
  
  app.mount("/styles", StaticFiles(directory="styles"), name="styles")
  app.mount("/js", StaticFiles(directory="js"), name="js")
  ```

- Added HTML route handlers:
  ```python
  @app.get("/")
  def serve_index():
      return FileResponse("index.html")
  ```

### 2. JavaScript Files (`js/login.js`, `js/committee.js`)
- Changed from hardcoded URL to dynamic:
  ```javascript
  // Before:
  const API_BASE_URL = 'http://127.0.0.1:8001';
  
  // After:
  const API_BASE_URL = window.location.origin;
  ```

This makes the app work regardless of the port or domain it's served from.

## Benefits

✅ **Single Command Deployment** - Only run one server
✅ **No CORS Issues** - Same origin for frontend and backend
✅ **Simpler Configuration** - No need to configure multiple servers
✅ **Production Ready** - Can deploy to cloud platforms easily
✅ **Development Friendly** - Auto-reload with `--reload` flag
✅ **API Documentation** - Built-in Swagger UI at `/docs`

## Troubleshooting

### Port Already in Use
If port 8001 is already in use, change the port:
```powershell
python -m uvicorn main:app --host 127.0.0.1 --port 8002 --reload
```
Then access at http://127.0.0.1:8002/

### Module Not Found Error
Make sure you're in the `backend` directory and have installed dependencies:
```powershell
cd backend
pip install fastapi uvicorn
```

### Database Not Found
Make sure `company.db` exists in the `backend` directory. If not, you may need to run the database setup script.

### Static Files Not Loading
Verify the directory structure matches the paths in `main.py`. The `styles/` and `js/` folders should be in the project root, not inside `backend/`.

## Next Steps

- **Deploy to Cloud**: FastAPI can be deployed to Heroku, AWS, Azure, or any cloud platform
- **Add Authentication Tokens**: Implement JWT for secure session management
- **Enable HTTPS**: Configure SSL certificates for production
- **Database Migration**: Consider PostgreSQL or MySQL for production
- **Environment Variables**: Use `.env` file for configuration

## Notes

- The backend auto-reloads on code changes (with `--reload` flag)
- All frontend assets are now served from the FastAPI server
- The application uses localStorage for client-side session management
- Database path is relative to the `backend/` directory
