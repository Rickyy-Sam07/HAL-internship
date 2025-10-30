#!/usr/bin/env python3
"""
Fix the over-escaped JSP file
1. Restore JSP tags: <%% -> <%
2. Keep JavaScript template literals escaped: \${
"""

import re

file_path = r"c:\sambhranta\projects\HAL-Internship\committee-view.jsp"

print("\n🔧 Fixing over-escaped JSP tags...")

# Read the file
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Count issues
jsp_tags = content.count('<%%')
print(f"Found {jsp_tags} incorrectly escaped JSP tags (<%%)")

# Fix: Replace <%% back to <%
content = content.replace('<%%', '<%')
content = content.replace('%%>', '%>')

print(f"✅ Restored JSP tags to correct syntax")

# Verify JavaScript escapes are still there
js_escapes = content.count(r'\${')
print(f"✅ JavaScript template literals still escaped: {js_escapes} instances")

# Save the fixed file
with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("\n✅ File fixed!")
print("JSP tags: <% ... %> (correct)")
print("JavaScript: \\${ ... } (correctly escaped)")
print("\nNow redeploy using: redeploy-all.bat (as Administrator)")
