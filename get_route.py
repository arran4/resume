with open('code_blocks.txt', 'r') as f:
    text = f.read()

import re
matches = re.finditer(r'15\s+route:|1\s+route:', text)
for m in matches:
    print(text[m.start()-50:m.end()+1000])
