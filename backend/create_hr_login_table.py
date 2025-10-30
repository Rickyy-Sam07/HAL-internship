import sqlite3

# Connect to existing company.db
conn = sqlite3.connect("company.db")
cursor = conn.cursor()

# Drop the table if it already exists (for testing convenience)
cursor.execute("DROP TABLE IF EXISTS hr_login")

# Create the HR login table
cursor.execute("""
CREATE TABLE hr_login (
    username TEXT PRIMARY KEY,
    password TEXT NOT NULL
)
""")

# Insert 3 test HR user records
hr_users = [
    ("hr_admin", "admin123"),
    ("hr_kavita", "kavita@2025"),
    ("hr_raj", "raj#hrpass")
]

cursor.executemany("INSERT INTO hr_login VALUES (?, ?)", hr_users)

# Commit and close
conn.commit()
conn.close()

print("✅ HR login table created successfully with 3 test users in 'company.db'")
