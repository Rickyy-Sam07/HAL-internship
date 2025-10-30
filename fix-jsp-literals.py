#!/usr/bin/env python3
"""
Fix JSP EL conflict with JavaScript template literals
This script escapes ${} in JavaScript code so JSP doesn't parse them as EL expressions
"""

import re

file_path = r"c:\sambhranta\projects\HAL-Internship\committee-view.jsp"

print("\n🔧 Fixing JavaScript template literals in JSP...")

# Read the file
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Count before
before_count = content.count('${')
print(f"Found {before_count} instances of '${{' in the file")

# Find all <script> sections and escape ${} to \${}
def escape_script_section(match):
    script_start = match.group(1)
    script_body = match.group(2)
    script_end = match.group(3)
    
    # Escape all ${} in JavaScript to \${} so JSP treats them as literals
    script_body_escaped = script_body.replace('${', r'\${')
    
    return script_start + script_body_escaped + script_end

# Pattern to match <script>...</script> sections
script_pattern = r'(<script[^>]*>)(.*?)(</script>)'
content_fixed = re.sub(script_pattern, escape_script_section, content, flags=re.DOTALL)

# Count after
after_count = content_fixed.count(r'\${')
print(f"Escaped {after_count} instances to '\\${{'")

# Save the fixed file
with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content_fixed)

print("\n✅ File fixed!")
print("Now redeploy using: redeploy-all.bat (as Administrator)")
