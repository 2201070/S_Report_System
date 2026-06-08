import subprocess
import re
import os

result = subprocess.run(['flutter', 'analyze'], capture_output=True, text=True)
lines = result.stdout.split('\n')

unused_imports = []
curly_braces = []

for line in lines:
    if 'unused_import' in line:
        unused_imports.append(line)
    elif 'curly_braces_in_flow_control_structures' in line:
        curly_braces.append(line)

print("Unused imports:")
for i in unused_imports:
    print(i)

print("\nCurly braces:")
for c in curly_braces:
    print(c)
