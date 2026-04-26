import os

def generate_tree(dir_path, prefix=""):
    try:
        contents = sorted(os.listdir(dir_path))
    except Exception:
        return ""
        
    dirs = []
    files = []
    for item in contents:
        if item in ['.git', 'node_modules', '.next', '__pycache__', 'venv']:
            continue
        path = os.path.join(dir_path, item)
        if os.path.isdir(path):
            dirs.append(item)
        else:
            files.append(item)
            
    output = ""
    
    for i, d in enumerate(dirs):
        is_last = (i == len(dirs) - 1 and len(files) == 0)
        marker = "└── " if is_last else "├── "
        output += f"{prefix}{marker}{d}/\n"
        
        new_prefix = prefix + ("    " if is_last else "│   ")
        output += generate_tree(os.path.join(dir_path, d), new_prefix)
        
    for i, file in enumerate(files):
        is_last = (i == len(files) - 1)
        marker = "└── " if is_last else "├── "
        
        try:
            size = os.path.getsize(os.path.join(dir_path, file))
        except Exception:
            size = 0
            
        output += f"{prefix}{marker}{file} ({size} bytes)\n"
        
    return output

if __name__ == "__main__":
    import sys
    target = sys.argv[1] if len(sys.argv) > 1 else 'C:/Source/Repos/h2v-trust/frontend'
    with open("frontend_tree_clean.txt", "w", encoding="utf-8") as f:
        f.write("frontend/\n")
        f.write(generate_tree(target))
