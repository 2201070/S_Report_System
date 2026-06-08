import json
import os
import re

with open('analyze.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

diagnostics = data.get('diagnostics', [])

# 1. Unused imports
unused_imports = [d for d in diagnostics if d['code'] == 'unused_import']

# group by file
files_to_edit = {}
for d in unused_imports:
    loc = d['location']
    file_path = loc['file']
    line = loc['startLine']
    if file_path not in files_to_edit:
        files_to_edit[file_path] = set()
    files_to_edit[file_path].add(line)

for filepath, lines in files_to_edit.items():
    with open(filepath, 'r', encoding='utf-8') as f:
        file_lines = f.readlines()
    
    # Delete lines in reverse order so indices don't shift
    for line_idx in sorted(lines, reverse=True):
        # 1-based index to 0-based
        del file_lines[line_idx - 1]
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.writelines(file_lines)

# 2. Wrap if statements with curly braces
# Linter rule: curly_braces_in_flow_control_structures
curly_issues = [d for d in diagnostics if d['code'] == 'curly_braces_in_flow_control_structures']
for d in curly_issues:
    loc = d['location']
    file_path = loc['file']
    # Because fixing this automatically via positions can be tricky if we edit line by line, 
    # doing it manually or with care. Let's just track the files and review them.
    print(f"File with curly brace issue: {file_path} at line {loc['startLine']}")

def process_file_replacements(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()

                # 3. Super parameters
                # Replace: Key? key,  -> super.key,
                # Replace: }) : super(key: key); -> });
                # Wait, what if it's `const Widget({Key? key, ...}) : super(key: key);`
                # Let's use regex
                original = content
                
                content = re.sub(r'\{Key\?\s*key\s*,\s*', '{super.key, ', content)
                content = re.sub(r'\{Key\?\s*key\}', '{super.key}', content)
                content = re.sub(r'\s*:\s*super\(\s*key\s*:\s*key\s*\)', '', content)
                
                # 4. withOpacity
                # Replace: .withOpacity(x) -> .withValues(alpha: x)
                content = re.sub(r'\.withOpacity\(([^)]+)\)', r'.withValues(alpha: \1)', content)

                if content != original:
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(content)

process_file_replacements('.')
