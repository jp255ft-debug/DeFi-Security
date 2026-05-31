import os
import json

def analyze_directory(path):
    stats = {
        "total_files": 0,
        "empty_files": 0,
        "total_size": 0,
        "empty_files_list": []
    }
    for root, dirs, files in os.walk(path):
        if 'node_modules' in root or '.git' in root or '__pycache__' in root or '.next' in root:
            continue
        for file in files:
            file_path = os.path.join(root, file)
            try:
                size = os.path.getsize(file_path)
                stats["total_files"] += 1
                stats["total_size"] += size
                if size == 0:
                    stats["empty_files"] += 1
                    stats["empty_files_list"].append(file_path.replace(path, ''))
            except Exception:
                pass
    return stats

repo_path = r"c:\Source\Repos\h2v-trust"
frontend_stats = analyze_directory(os.path.join(repo_path, "frontend"))
backend_stats = analyze_directory(os.path.join(repo_path, "backend"))
contracts_stats = analyze_directory(os.path.join(repo_path, "contracts"))

report = {
    "frontend": frontend_stats,
    "backend": backend_stats,
    "contracts": contracts_stats
}

with open(r"c:\Source\Repos\h2v-trust\audit_results.json", "w", encoding="utf-8") as f:
    json.dump(report, f, indent=4)
print("Analysis complete. Check audit_results.json")
