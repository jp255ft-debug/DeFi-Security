#!/usr/bin/env python3
"""
Gera diff entre duas versões de contratos (para reauditorias).
Uso: python diff_contracts.py <pasta_versao_antiga> <pasta_versao_nova> [--output diff.md]
"""

import argparse
import difflib
import os
from pathlib import Path


def get_sol_files(directory: str) -> dict:
    """Retorna um dicionário {nome_arquivo: conteúdo} para todos os .sol no diretório."""
    files = {}
    path = Path(directory)
    for sol_file in path.rglob("*.sol"):
        relative = sol_file.relative_to(path)
        with open(sol_file, "r", encoding="utf-8") as f:
            files[str(relative)] = f.readlines()
    return files


def generate_diff(old_dir: str, new_dir: str, output_file: str = None):
    """Gera diff entre duas versões de contratos."""
    old_files = get_sol_files(old_dir)
    new_files = get_sol_files(new_dir)

    all_files = set(list(old_files.keys()) + list(new_files.keys()))
    all_files = sorted(all_files)

    output_lines = []
    output_lines.append(f"# Diff: {old_dir} → {new_dir}")
    output_lines.append(f"")
    output_lines.append(f"## Resumo")
    output_lines.append(f"")
    output_lines.append(f"| Tipo | Quantidade |")
    output_lines.append(f"|---|---|")
    
    added = [f for f in all_files if f in new_files and f not in old_files]
    removed = [f for f in all_files if f in old_files and f not in new_files]
    modified = [f for f in all_files if f in old_files and f in new_files and old_files[f] != new_files[f]]
    unchanged = [f for f in all_files if f in old_files and f in new_files and old_files[f] == new_files[f]]
    
    output_lines.append(f"| Adicionados | {len(added)} |")
    output_lines.append(f"| Removidos | {len(removed)} |")
    output_lines.append(f"| Modificados | {len(modified)} |")
    output_lines.append(f"| Inalterados | {len(unchanged)} |")
    output_lines.append(f"")

    for file in all_files:
        if file in added:
            output_lines.append(f"## ➕ {file} (ADICIONADO)")
            output_lines.append(f"")
            output_lines.append("```solidity")
            output_lines.extend(new_files[file])
            output_lines.append("```")
            output_lines.append(f"")
        elif file in removed:
            output_lines.append(f"## ➖ {file} (REMOVIDO)")
            output_lines.append(f"")
        elif file in modified:
            output_lines.append(f"## 🔄 {file} (MODIFICADO)")
            output_lines.append(f"")
            diff = difflib.unified_diff(
                old_files[file],
                new_files[file],
                fromfile=f"a/{file}",
                tofile=f"b/{file}",
                lineterm="",
            )
            output_lines.append("```diff")
            output_lines.extend(diff)
            output_lines.append("```")
            output_lines.append(f"")

    result = "\n".join(output_lines)

    if output_file:
        with open(output_file, "w", encoding="utf-8") as f:
            f.write(result)
        print(f"✅ Diff salvo em: {output_file}")
    else:
        print(result)


def main():
    parser = argparse.ArgumentParser(description="Generate diff between two contract versions")
    parser.add_argument("old_dir", help="Old version directory")
    parser.add_argument("new_dir", help="New version directory")
    parser.add_argument("--output", "-o", default=None, help="Output file (default: stdout)")
    
    args = parser.parse_args()
    
    if not os.path.isdir(args.old_dir):
        print(f"❌ Erro: Diretório {args.old_dir} não encontrado.")
        sys.exit(1)
    if not os.path.isdir(args.new_dir):
        print(f"❌ Erro: Diretório {args.new_dir} não encontrado.")
        sys.exit(1)
    
    generate_diff(args.old_dir, args.new_dir, args.output)


if __name__ == "__main__":
    main()
