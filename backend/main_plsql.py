from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import oracledb as cx_Oracle


app = FastAPI(title="Employee & Committee Management API (PLSQL Version)")

# ---------- Database Connection ----------
def get_db_connection():
    # Example DSN: "hostname/servicename" or use cx_Oracle.makedsn()
    dsn = cx_Oracle.makedsn("localhost", 1521, service_name="XE")
    conn = cx_Oracle.connect(user="hr", password="your_password", dsn=dsn)
    return conn


# ---------- Models ----------
class HRLogin(BaseModel):
    username: str
    password: str


class CommitteeMemberInput(BaseModel):
    employee_id: int
    role: str
    member_type: str


class CommitteeCreateInput(BaseModel):
    committee_name: str
    start_date: str
    end_date: str
    members: list[CommitteeMemberInput]


# ---------- Root ----------
@app.get("/")
def home():
    return {"message": "Welcome to the Employee & Committee Management API (PLSQL)"}


# ---------- Employee Endpoints ----------
@app.get("/employees")
def get_all_employees():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM employees")
    rows = cursor.fetchall()
    columns = [col[0].lower() for col in cursor.description]
    conn.close()

    return {"employees": [dict(zip(columns, row)) for row in rows]}


@app.get("/employees/{employee_id}")
def get_employee(employee_id: int):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM employees WHERE employee_id = :id", {"id": employee_id})
    row = cursor.fetchone()
    columns = [col[0].lower() for col in cursor.description]
    conn.close()

    if row:
        return {"employee": dict(zip(columns, row))}
    else:
        raise HTTPException(status_code=404, detail="Employee not found")


# ---------- HR Login ----------
@app.post("/hr/login")
def hr_login(login: HRLogin):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "SELECT * FROM hr_login WHERE username = :u AND password = :p",
        {"u": login.username, "p": login.password},
    )
    user = cursor.fetchone()
    conn.close()

    if user:
        return {"message": f"Welcome, {login.username}!"}
    else:
        raise HTTPException(status_code=401, detail="Invalid username or password")


# ---------- Create a Committee ----------
@app.post("/committee/create")
def create_committee(data: CommitteeCreateInput):
    conn = get_db_connection()
    cursor = conn.cursor()

    # Insert into committee table
    cursor.execute(
        """
        INSERT INTO committee (committee_id, committee_name, start_date, end_date)
        VALUES (committee_seq.NEXTVAL, :name, TO_DATE(:start, 'YYYY-MM-DD'), TO_DATE(:end, 'YYYY-MM-DD'))
        RETURNING committee_id INTO :cid
        """,
        {
            "name": data.committee_name,
            "start": data.start_date,
            "end": data.end_date,
            "cid": cursor.var(cx_Oracle.NUMBER),
        },
    )
    committee_id = int(cursor.getimplicitresults()[0][0]) if cursor.getimplicitresults() else None

    # Insert committee members
    for member in data.members:
        cursor.execute(
            """
            INSERT INTO committee_member (committee_member_id, committee_id, employee_id, role, member_type)
            VALUES (committee_member_seq.NEXTVAL, :cid, :eid, :role, :mtype)
            """,
            {
                "cid": committee_id,
                "eid": member.employee_id,
                "role": member.role,
                "mtype": member.member_type,
            },
        )

    conn.commit()
    conn.close()

    return {"message": "Committee created successfully", "committee_id": committee_id}


# ---------- Fetch All Committees with Members ----------
@app.get("/committees")
def get_committees():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT * FROM committee")
    committees = cursor.fetchall()
    columns_committee = [col[0].lower() for col in cursor.description]

    result = []
    for committee in committees:
        committee_dict = dict(zip(columns_committee, committee))

        # Fetch members
        cursor.execute(
            """
            SELECT cm.role, cm.member_type, e.employee_name, e.designation, e.department_name
            FROM committee_member cm
            JOIN employees e ON cm.employee_id = e.employee_id
            WHERE cm.committee_id = :cid
            """,
            {"cid": committee_dict["committee_id"]},
        )
        members = cursor.fetchall()
        columns_member = [col[0].lower() for col in cursor.description]

        committee_dict["members"] = [dict(zip(columns_member, m)) for m in members]
        result.append(committee_dict)

    conn.close()
    return {"committees": result}
