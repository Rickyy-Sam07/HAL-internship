import sqlite3

# Connect to your existing company.db
conn = sqlite3.connect("company.db")
cursor = conn.cursor()

# Enable foreign key constraints
cursor.execute("PRAGMA foreign_keys = ON;")

# Drop the table if it already exists (for testing convenience)
cursor.execute("DROP TABLE IF EXISTS committee_member")

# Create the committee_member table
cursor.execute("""
CREATE TABLE committee_member (
    committee_member_id INTEGER PRIMARY KEY,
    committee_id INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    role TEXT CHECK(role IN ('Chairman', 'Secretary', 'Member')) NOT NULL,
    member_type TEXT CHECK(member_type IN ('Management', 'Working')) NOT NULL,
    FOREIGN KEY (committee_id) REFERENCES committee(committee_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
)
""")

# Test data for Employee Welfare Committee (committee_id = 1)
committee_members = [
    (1, 1, 1, "Chairman", "Management"),  # Ravi Sharma (GM - Operations)
    (2, 1, 2, "Secretary", "Management"), # Anita Desai (AGM - Finance)
    (3, 1, 5, "Member", "Working"),       # Arjun Nair (Supervisor - Production)
    (4, 1, 9, "Member", "Working"),       # Sneha Reddy (Manager - IT)
    (5, 1, 16, "Member", "Working")       # Sanjay Verma (Supervisor - Operations)
]

cursor.executemany("INSERT INTO committee_member VALUES (?, ?, ?, ?, ?)", committee_members)

# Commit and close
conn.commit()
conn.close()

print("✅ Committee_member table created successfully with test data linked to Employee Welfare Committee")
