from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import sqlite3

app = FastAPI(title="Employee & Committee Management API")

# Add CORS middleware to allow frontend (Tomcat on port 8080) to access backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:8080", "http://127.0.0.1:8080"],  # Tomcat frontend
    allow_credentials=True,
    allow_methods=["*"],  # Allow all methods (GET, POST, etc.)
    allow_headers=["*"],  # Allow all headers
)

# Function to connect to the SQLite DB
def get_db_connection():
    conn = sqlite3.connect("company.db")
    conn.row_factory = sqlite3.Row  # allows column names in JSON
    return conn


# ---------- Root ----------
@app.get("/")
def home():
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

        # Insert committee members
        for idx, member in enumerate(data.members, start=1):
            cursor.execute("""
                INSERT INTO committee_member (committee_member_id, committee_id, employee_id, role, member_type)
                VALUES (?, ?, ?, ?, ?)
            """, (None, committee_id, member.employee_id, member.role, member.member_type))

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

        # Fetch members for this committee with employee_id included
        cursor.execute("""
            SELECT cm.employee_id, cm.role, cm.member_type, e.employee_name, e.designation, e.department_name
            FROM committee_member cm
            JOIN employees e ON cm.employee_id = e.employee_id
            WHERE cm.committee_id = ?
        """, (committee["committee_id"],))
        members = cursor.fetchall()

        committee_dict["members"] = [dict(m) for m in members]
        result.append(committee_dict)

    conn.close()
    return {"committees": result}
