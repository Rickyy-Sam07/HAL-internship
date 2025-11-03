import sqlite3
import os

# Change to backend directory if not already there
if os.path.basename(os.getcwd()) != 'backend':
    os.chdir('backend')

# Connect to your existing company.db
conn = sqlite3.connect("company.db")
cursor = conn.cursor()

print("Starting database migration...")

# Step 1: Create a new table with the updated schema
print( b"Creating new committee_member table with updated schema...")
cursor.execute("""
CREATE TABLE committee_member_new (
    committee_member_id INTEGER PRIMARY KEY,
    committee_id INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    committee_role TEXT CHECK(committee_role IN ('Chairman', 'Secretary', 'Member')) NOT NULL,
    post TEXT,
    member_type TEXT CHECK(member_type IN ('Management', 'Working')) NOT NULL,
    FOREIGN KEY (committee_id) REFERENCES committee(committee_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
)
""")

# Step 2: Copy data from old table to new table, fetching post from employees table
print("Migrating data and fetching designations from employees table...")
cursor.execute("""
INSERT INTO committee_member_new (committee_member_id, committee_id, employee_id, committee_role, post, member_type)
SELECT 
    cm.committee_member_id, 
    cm.committee_id, 
    cm.employee_id, 
    cm.role as committee_role,
    e.designation as post,
    cm.member_type
FROM committee_member cm
LEFT JOIN employees e ON cm.employee_id = e.employee_id
""")

# Step 3: Drop old table
print("Dropping old committee_member table...")
cursor.execute("DROP TABLE committee_member")

# Step 4: Rename new table to original name
print("Renaming new table to committee_member...")
cursor.execute("ALTER TABLE committee_member_new RENAME TO committee_member")

# Commit changes
conn.commit()

# Verify the migration
cursor.execute("SELECT * FROM committee_member")
members = cursor.fetchall()
print(f"\n✅ Migration completed successfully!")
print(f"Total members migrated: {len(members)}")

print("\n=== Sample Data ===")
cursor.execute("""
SELECT cm.committee_member_id, cm.committee_id, cm.employee_id, 
       e.employee_name, cm.committee_role, cm.post, cm.member_type
FROM committee_member cm
LEFT JOIN employees e ON cm.employee_id = e.employee_id
LIMIT 5
""")
sample = cursor.fetchall()
print("ID | Comm ID | Emp ID | Name | Committee Role | Post | Type")
print("-" * 80)
for s in sample:
    print(f"{s[0]} | {s[1]} | {s[2]} | {s[3]} | {s[4]} | {s[5]} | {s[6]}")

conn.close()
print("\n🎉 Database schema updated successfully!")
