import re

with open('blog_text.txt', 'r', encoding='utf-8') as f:
    text = f.read()

print("Jobs found:")
for match in re.finditer(r'^\s*([a-zA-Z0-9_-]+):\n\s*name: ', text, re.MULTILINE):
    print(match.group(1))
