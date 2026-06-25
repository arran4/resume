import urllib.request
import re

url = 'https://arran4.github.io/blog/post/2026/006-github-ci-and-deploy/'
req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
html = urllib.request.urlopen(req).read().decode('utf-8')

blocks = re.findall(r'<code[^>]*>(.*?)</code>', html, re.DOTALL)
with open('code_blocks.txt', 'w', encoding='utf-8') as f:
    for i, b in enumerate(blocks):
        b = re.sub(r'<[^>]+>', '', b)
        f.write(f"--- Block {i} ---\n{b.strip()}\n\n")
