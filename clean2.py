import json

with open('analyze.json', 'r', encoding='utf-16le') as f:
    data = json.load(f)

diagnostics = data.get('diagnostics', [])

# 1. Unused imports
unused_imports = [d for d in diagnostics if d['code'] == 'unused_import']

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
    
    for line_idx in sorted(lines, reverse=True):
        del file_lines[line_idx - 1]
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.writelines(file_lines)
    print(f'Removed unused imports in {filepath}')

