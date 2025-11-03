from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from pydantic import BaseModel
from pathlib import Path
import sqlite3

app = FastAPI(title="Employee & Committee Management API")

# Get the parent directory (project root)
BASE_DIR = Path(__file__).resolve().parent.parent
DB_PATH = Path(__file__).resolve().parent / "company.db"  # Database is in backend folder
print(f"BASE_DIR: {BASE_DIR}")
print(f"DB_PATH: {DB_PATH}")
print(f"Current working directory: {Path.cwd()}")
print(f"Files in BASE_DIR: {list(BASE_DIR.glob('*.html'))}")

# Add CORS middleware to allow frontend access from various development servers
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:8080",
        "http://127.0.0.1:8080",
        "http://localhost:8001",  # FastAPI server itself
        "http://127.0.0.1:8001",
        "http://localhost:5500",  # VS Code Live Server
        "http://127.0.0.1:5500",  # VS Code Live Server
        "http://localhost:3000",  # Common dev port
        "http://127.0.0.1:3000",
        "http://localhost:5173",  # Vite default
        "http://127.0.0.1:5173",
    ],
    allow_credentials=True,
    allow_methods=["*"],  # Allow all methods (GET, POST, etc.)
    allow_headers=["*"],  # Allow all headers
)

# Mount static directories
app.mount("/styles", StaticFiles(directory=str(BASE_DIR / "styles")), name="styles")
app.mount("/js", StaticFiles(directory=str(BASE_DIR / "js")), name="js")

# Function to connect to the SQLite DB
def get_db_connection():
    conn = sqlite3.connect(str(DB_PATH))
    conn.row_factory = sqlite3.Row  # allows column names in JSON
    return conn


# ---------- HTML Routes ----------
@app.get("/")
def serve_index():
    """Serve the committee view page as homepage"""
    return FileResponse(str(BASE_DIR / "committee-view.html"))


@app.get("/index.html")
def serve_index_explicit():
    """Serve the login page (explicit path)"""
    return FileResponse(str(BASE_DIR / "index.html"))


@app.get("/login.html")
def serve_login():
    """Serve the login page"""
    return FileResponse(str(BASE_DIR / "index.html"))


@app.get("/committee-view.html")
def serve_committee_view():
    """Serve the committee management page"""
    return FileResponse(str(BASE_DIR / "committee-view.html"))


@app.get("/add-committee.html")
def serve_add_committee():
    """Serve the add committee page"""
    # Try backend directory first, then parent directory
    backend_path = Path(__file__).parent / "add-committee.html"
    parent_path = BASE_DIR / "add-committee.html"
    
    if backend_path.exists():
        return FileResponse(str(backend_path))
    elif parent_path.exists():
        return FileResponse(str(parent_path))
    else:
        raise HTTPException(status_code=404, detail="add-committee.html not found")


# ---------- API Root ----------
@app.get("/api")
def api_home():
    return {"message": "Welcome to the Employee & Committee Management API"}


# ---------- Employee Endpoints ----------
@app.get("/api/employees")
def get_all_employees():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM employees")
    rows = cursor.fetchall()
    conn.close()
    return {"employees": [dict(row) for row in rows]}


@app.get("/api/employees/{employee_id}")
def get_employee(employee_id: int):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM employees WHERE employee_id = ?", (employee_id,))
    row = cursor.fetchone()
    conn.close()
    if row:
        return {"employee": dict(row)}
    else:
        raise HTTPException(status_code=404, detail="Employee not found")


# ---------- HR Login ----------
class HRLogin(BaseModel):
    username: str
    password: str


@app.post("/api/hr/login")
def hr_login(login: HRLogin):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM hr_login WHERE username = ? AND password = ?", (login.username, login.password))
    user = cursor.fetchone()
    conn.close()

    if user:
        return {"message": f"Welcome, {login.username}!"}
    else:
        raise HTTPException(status_code=401, detail="Invalid username or password")


# ---------- Committee Models ----------
class CommitteeMemberInput(BaseModel):
    employee_id: int
    role: str
    member_type: str


class CommitteeCreateInput(BaseModel):
    committee_name: str
    start_date: str
    end_date: str
    members: list[CommitteeMemberInput]


# ---------- Create a Committee (with members) ----------
@app.post("/api/committee/create")
def create_committee(data: CommitteeCreateInput):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        # Insert into committee table
        cursor.execute(
            "INSERT INTO committee (committee_name, start_date, end_date) VALUES (?, ?, ?)",
            (data.committee_name, data.start_date, data.end_date)
        )
        committee_id = cursor.lastrowid  # get auto-generated committee_id

        # Insert committee members with committee_role and post (designation)
        for idx, member in enumerate(data.members, start=1):
            # Fetch employee designation from employees table
            cursor.execute("SELECT designation FROM employees WHERE employee_id = ?", (member.employee_id,))
            employee = cursor.fetchone()
            post = employee['designation'] if employee else None
            
            cursor.execute("""
                INSERT INTO committee_member (committee_member_id, committee_id, employee_id, committee_role, post, member_type)
                VALUES (?, ?, ?, ?, ?, ?)
            """, (None, committee_id, member.employee_id, member.role, post, member.member_type))

        conn.commit()
        return {"message": "Committee created successfully", "committee_id": committee_id}
    except Exception as e:
        conn.rollback()
        raise e
    finally:
        conn.close()


# ---------- Fetch All Committees with Members ----------
@app.get("/api/committees")
def get_committees():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT * FROM committee")
    committees = cursor.fetchall()
    result = []

    for committee in committees:
        committee_dict = dict(committee)

        # Fetch members for this committee with employee_id, committee_role, and post included
        cursor.execute("""
            SELECT cm.employee_id, cm.committee_role, cm.post, cm.member_type, e.employee_name, e.designation, e.department_name
            FROM committee_member cm
            JOIN employees e ON cm.employee_id = e.employee_id
            WHERE cm.committee_id = ?
        """, (committee["committee_id"],))
        members = cursor.fetchall()

        committee_dict["members"] = [dict(m) for m in members]
        result.append(committee_dict)

    conn.close()
    return {"committees": result}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="127.0.0.1", port=8001, reload=True)
