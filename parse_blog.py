import re

with open('blog.txt', 'r', encoding='utf-8') as f:
    text = f.read()

# Extract code blocks
code_blocks = re.findall(r'<pre(?:[^>]*)><code(?:[^>]*)>(.*?)</code></pre>', text, re.DOTALL)
if not code_blocks:
    # try another format if standard pre/code doesn't match
    pass
