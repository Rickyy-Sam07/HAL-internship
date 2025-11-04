from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from pydantic import BaseModel
from pathlib import Path
import oracledb  # Modern replacement for cx_Oracle

app = FastAPI(title="Employee & Committee Management API (Oracle Edition)")

# ---------- Configuration ----------
BASE_DIR = Path(__file__).resolve().parent.parent

# Oracle connection config
ORACLE_DSN = "localhost/XE"  # Example: "host:port/service_name"
ORACLE_USER = "system"
ORACLE_PASS = "your_password"

# ---------- Database Connection ----------
def get_db_connection():
    try:
        conn = oracledb.connect(
            user=ORACLE_USER,
            password=ORACLE_PASS,
            dsn=ORACLE_DSN
        )
        return conn
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database connection error: {str(e)}")


# ---------- Middleware ----------
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:8080",
        "http://127.0.0.1:8080",
        "http://localhost:8001",
        "http://127.0.0.1:8001",
        "http://localhost:3000",
        "http://127.0.0.1:3000",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ---------- Static Mounts ----------
app.mount("/styles", StaticFiles(directory=str(BASE_DIR / "styles")), name="styles")
app.mount("/js", StaticFiles(directory=str(BASE_DIR / "js")), name="js")


# ---------- HTML Routes ----------
@app.get("/")
def serve_index():
    return FileResponse(str(BASE_DIR / "committee-view.html"))


@app.get("/login.html")
def serve_login():
    return FileResponse(str(BASE_DIR / "index.html"))


@app.get("/committee-view.html")
def serve_committee_view():
    return FileResponse(str(BASE_DIR / "committee-view.html"))


@app.get("/add-committee.html")
def serve_add_committee():
    backend_path = Path(__file__).parent / "add-committee.html"
    parent_path = BASE_DIR / "add-committee.html"
    if backend_path.exists():
        return FileResponse(str(backend_path))
    elif parent_path.exists():
        return FileResponse(str(parent_path))
    else:
        raise HTTPException(status_code=404, detail="add-committee.html not found")


# ---------- API ----------
@app.get("/api")
def api_home():
    return {"message": "Welcome to the Employee & Committee Management API (Oracle DB)"}


# ---------- Employee Endpoints ----------
@app.get("/api/employees")
def get_all_employees():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM employees")
    columns = [col[0].lower() for col in cursor.description]
    employees = [dict(zip(columns, row)) for row in cursor.fetchall()]
    conn.close()
    return {"employees": employees}


@app.get("/api/employees/{employee_id}")
def get_employee(employee_id: int):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM employees WHERE employee_id = :id", {"id": employee_id})
    row = cursor.fetchone()
    conn.close()
    if row:
        columns = [col[0].lower() for col in cursor.description]
        return {"employee": dict(zip(columns, row))}
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
    cursor.execute(
        "SELECT * FROM hr_login WHERE username = :u AND password = :p",
        {"u": login.username, "p": login.password}
    )
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


# ---------- Create a Committee ----------
@app.post("/api/committee/create")
def create_committee(data: CommitteeCreateInput):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(
            "INSERT INTO committee (committee_name, start_date, end_date) VALUES (:name, :start, :end)",
            {"name": data.committee_name, "start": data.start_date, "end": data.end_date}
        )
        conn.commit()

        # Get generated committee_id (assuming a sequence/trigger)
        cursor.execute("SELECT MAX(committee_id) FROM committee")
        committee_id = cursor.fetchone()[0]

        for member in data.members:
            cursor.execute(
                """
                INSERT INTO committee_member (committee_id, employee_id, committee_role, member_type)
                VALUES (:cid, :eid, :role, :type)
                """,
                {
                    "cid": committee_id,
                    "eid": member.employee_id,
                    "role": member.role,
                    "type": member.member_type
                }
            )
        conn.commit()
        return {"message": "Committee created successfully", "committee_id": committee_id}

    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        conn.close()


# ---------- Fetch Committees ----------
@app.get("/api/committees")
def get_committees():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT * FROM committee")
    committees = cursor.fetchall()
    columns = [col[0].lower() for col in cursor.description]

    result = []
    for c in committees:
        committee_dict = dict(zip(columns, c))

        cursor.execute("""
            SELECT cm.employee_id, cm.committee_role, cm.member_type, e.employee_name, e.designation
            FROM committee_member cm
            JOIN employees e ON cm.employee_id = e.employee_id
            WHERE cm.committee_id = :cid
        """, {"cid": committee_dict["committee_id"]})
        member_cols = [col[0].lower() for col in cursor.description]
        members = [dict(zip(member_cols, row)) for row in cursor.fetchall()]
        committee_dict["members"] = members
        result.append(committee_dict)

    conn.close()
    return {"committees": result}


# ---------- Run ----------
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="127.0.0.1", port=8001, reload=True)
