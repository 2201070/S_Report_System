import re

with open('lib/core/theme/app_text_styles.dart', 'r') as f:
    content = f.read()

content = re.sub(r'(fontSize:\s*[^,]+,)', r'\1\n    height: 1.5,', content)

with open('lib/core/theme/app_text_styles.dart', 'w') as f:
    f.write(content)
