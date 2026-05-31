import os

repo = r"c:\Source\Repos\h2v-trust"
skip = ["node_modules", ".git", "__pycache__", ".next", "venv"]
empty = []
total = 0
total_size = 0

for root, dirs, files in os.walk(repo):
    if any(s in root for s in skip):
        continue
    for f in files:
        fp = os.path.join(root, f)
        try:
            sz = os.path.getsize(fp)
            rel = fp.replace(repo, "")
            total += 1
            total_size += sz
            if sz == 0:
                empty.append(rel)
        except Exception:
            pass

print(f"TOTAL FILES: {total}")
print(f"TOTAL SIZE: {total_size} bytes")
print(f"EMPTY FILES: {len(empty)}")
print("---EMPTY LIST---")
for e in empty:
    print(e)
