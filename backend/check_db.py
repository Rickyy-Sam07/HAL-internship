import sqlite3

conn = sqlite3.connect('backend/company.db')
cursor = conn.cursor()

# Check committees
cursor.execute('SELECT * FROM committee')
committees = cursor.fetchall()
print('=== COMMITTEE TABLE ===')
print(f'Total committees: {len(committees)}')
for c in committees:
    print(c)

# Check committee members
cursor.execute('SELECT * FROM committee_member')
members = cursor.fetchall()
print('\n=== COMMITTEE MEMBER TABLE ===')
print(f'Total members: {len(members)}')
for m in members:
    print(m)

# Check with details
print('\n=== DETAILED VIEW ===')
cursor.execute('''
    SELECT c.committee_id, c.committee_name, c.start_date, c.end_date, 
           cm.employee_id, cm.committee_role, cm.post, cm.member_type
    FROM committee c
    LEFT JOIN committee_member cm ON c.committee_id = cm.committee_id
    ORDER BY c.committee_id, cm.member_type, cm.committee_role
''')
details = cursor.fetchall()
print(f'Committee ID | Name | Start Date | End Date | Employee ID | Committee Role | Post | Type')
print('-' * 100)
for d in details:
    print(f'{d[0]} | {d[1]} | {d[2]} | {d[3]} | {d[4]} | {d[5]} | {d[6]} | {d[7]}')

conn.close()
