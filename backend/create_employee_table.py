import sqlite3

# Connect to (or create) a SQLite database file
conn = sqlite3.connect("company.db")
cursor = conn.cursor()

# Drop the table if it already exists (optional for testing)
cursor.execute("DROP TABLE IF EXISTS employees")

# Create the employee table
cursor.execute("""
CREATE TABLE employees (
    employee_id INTEGER PRIMARY KEY,
    employee_name TEXT NOT NULL,
    designation TEXT NOT NULL,
    department_name TEXT NOT NULL
)
""")

# 20 test records
employees = [
    (1, "Ravi Sharma", "GM", "Operations"),
    (2, "Anita Desai", "AGM", "Finance"),
    (3, "Rahul Mehta", "Manager", "HR"),
    (4, "Priya Kapoor", "Executive", "Marketing"),
    (5, "Arjun Nair", "Supervisor", "Production"),
    (6, "Neha Singh", "Assistant", "Finance"),
    (7, "Kiran Das", "AGM", "Operations"),
    (8, "Manoj Kumar", "GM", "Engineering"),
    (9, "Sneha Reddy", "Manager", "IT"),
    (10, "Vikas Gupta", "Executive", "Sales"),
    (11, "Rohit Bansal", "Supervisor", "Maintenance"),
    (12, "Meera Nair", "AGM", "Marketing"),
    (13, "Deepak Joshi", "Assistant", "IT"),
    (14, "Pooja Patel", "Executive", "Finance"),
    (15, "Aditya Roy", "GM", "HR"),
    (16, "Sanjay Verma", "Supervisor", "Operations"),
    (17, "Divya Iyer", "AGM", "Engineering"),
    (18, "Karthik Rao", "Manager", "Sales"),
    (19, "Tanvi Bhatt", "Executive", "Production"),
    (20, "Abhishek Das", "Assistant", "HR")
]

# Insert data into the table
cursor.executemany("INSERT INTO employees VALUES (?, ?, ?, ?)", employees)

# Commit changes and close the connection
conn.commit()
conn.close()

print("✅ Employee table created successfully with 20 records in 'company.db'")
