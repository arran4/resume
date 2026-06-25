import re
with open('blog_text.txt', 'r') as f:
    t = f.read()
print(re.search(r'route:\s*name: Route event.*?outputs:', t, re.DOTALL))
print(re.search(r'route:\s*name: Event Router.*?outputs:', t, re.DOTALL))
