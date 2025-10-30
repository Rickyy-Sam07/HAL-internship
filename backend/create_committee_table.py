import sqlite3

# Connect to the existing company.db
conn = sqlite3.connect("company.db")
cursor = conn.cursor()

# Drop the table if it exists (for testing convenience)
cursor.execute("DROP TABLE IF EXISTS committee")

# Create the committee table
cursor.execute("""
CREATE TABLE committee (
    committee_id INTEGER PRIMARY KEY,
    committee_name TEXT NOT NULL,
    start_date TEXT NOT NULL,
    end_date TEXT NOT NULL
)
""")

# Insert one test record
committee_data = [
    (1, "Employee Welfare Committee", "2025-01-01", "2025-12-31")
]

cursor.executemany("INSERT INTO committee VALUES (?, ?, ?, ?)", committee_data)

# Commit and close
conn.commit()
conn.close()

print("✅ Committee table created successfully with 1 test record in 'company.db'")
