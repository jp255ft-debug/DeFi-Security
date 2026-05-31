#!/usr/bin/env python3
"""
filter_noise.py — Filtro Inteligente de Falsos Positivos

Pipeline: Slither/Aderyn/Mythril -> raw JSON -> filter_noise.py -> clean .md

Uso:
  python filter_noise.py <input.json> --tool slither --output findings/automated/clean_report.md
  python filter_noise.py <input.json> --tool aderyn --output findings/automated/aderyn_clean.md
  python filter_noise.py <input.json> --tool mythril --output findings/automated/mythril_clean.md

Base de conhecimento de falsos positivos conhecidos:
- "pragma solidity ^0.8.0" não é vulnerabilidade (slither: "solc version")
- "Low level calls" em OpenZeppelin não são necessariamente vulneráveis
- "unused return" em safeTransfer é intencional
- "naming convention" não é finding de segurança
"""

import json
import sys
import re
import argparse
from pathlib import Path


# =============================================================================
# BASE DE CONHECIMENTO DE FALSOS POSITIVOS
# =============================================================================

# Padrões que indicam FALSO POSITIVO (devem ser FILTRADOS)
FALSE_POSITIVE_PATTERNS = {
    "slither": [
        # Versão do Solidity
        r"pragma.solidity",
        r"solc.version",
        r"solc-version",
        
        # Convenções de nomenclatura (não são segurança)
        r"naming.convention",
        r"Name style",
        r"Parameter name",
        r"Function name",
        
        # Low-level calls em bibliotecas padrão
        r"low.level.call",
        r"low-level-call",
        
        # Unused return em funções conhecidas
        r"unused.return",
        r"unused-return",
        
        # Constantes imutáveis
        r"constant.immutable",
        r"constable-states",
        
        # Timestamp (muitas vezes intencional)
        r"timestamp",
        r"block.timestamp",
        
        # Assembly (muitas vezes otimização intencional)
        r"assembly",
        r"inline.assembly",
    ],
    
    "aderyn": [
        # Aderyn tem menos FP, mas alguns padrões conhecidos
        r"unused.import",
        r"unused-import",
        r"unused.function.parameter",
        r"event.not.emitted",
    ],
    
    "mythril": [
        # Mythril tem muitos FP em chamadas externas
        r"External.call",
        r"external-call",
        r"Delegatecall",
        r"delegatecall",
        
        # Gas (muitas vezes não explorável)
        r"Gas.limit",
        r"gas-limit",
        r"Gas requirement",
    ],
    
    "generic": [
        # Padrões genéricos que são quase sempre FP
        r"OpenZeppelin",
        r"@openzeppelin",
        r"forge-std",
        r"solmate",
        r"test/",
        r"Test.sol",
        r"Mock",
        r"mock",
    ]
}


# Padrões que indicam FINDING REAL (devem ser PRIORIZADOS)
REAL_FINDING_PATTERNS = {
    "high": [
        r"reentrancy",
        r"re-entrancy",
        r"reentrancy-eth",
        r"unchecked.external.call",
        r"unchecked-send",
        r"tx.origin",
        r"tx-origin",
        r"arbitrary.from",
        r"arbitrary-send",
        r"controlled.delegatecall",
        r"controlled-delegatecall",
        r"incorrect.operator",
        r"incorrect-equality",
        r"dangerous.strict.equalities",
        r"write.to.arbitrary.storage",
        r"incorrect.access.control",
        r"missing.modifier",
        r"missing-modifier",
        r"initialization.without.initializer",
        r"uninitialized.state",
        r"uninitialized-local",
        r"shadowing",
        r"shadowing-state",
        r"suicidal",
        r"selfdestruct",
    ],
    
    "medium": [
        r"unused.return",
        r"unused-return",
        r"unchecked.lowlevel",
        r"unchecked-lowlevel",
        r"divide.before.multiply",
        r"divide-before-multiply",
        r"incorrect.erc20",
        r"incorrect-erc20",
        r"erc20.interface",
        r"erc20-interface",
        r"locked.ether",
        r"locked-ether",
        r"reentrancy.events",
        r"reentrancy-events",
        r"calls.inside.loop",
        r"calls-loop",
    ]
}


def load_json_report(filepath: str) -> dict:
    """Carrega um relatório JSON de ferramenta de análise."""
    with open(filepath, 'r', encoding='utf-8') as f:
        return json.load(f)


def is_false_positive(detector_name: str, description: str, tool: str) -> bool:
    """
    Verifica se um finding é falso positivo com base na base de conhecimento.
    
    Args:
        detector_name: Nome do detector (ex: "reentrancy-eth")
        description: Descrição do finding
        tool: Ferramenta que gerou ("slither", "aderyn", "mythril")
    
    Returns:
        True se for falso positivo, False se for finding real
    """
    text = f"{detector_name} {description}".lower()
    
    # Verifica padrões de falso positivo
    patterns = FALSE_POSITIVE_PATTERNS.get(tool, []) + FALSE_POSITIVE_PATTERNS["generic"]
    for pattern in patterns:
        if re.search(pattern, text):
            return True
    
    return False


def get_severity(detector_name: str, description: str) -> str:
    """
    Determina a severidade de um finding real.
    
    Returns: "high", "medium", "low", ou "informational"
    """
    text = f"{detector_name} {description}".lower()
    
    for severity, patterns in REAL_FINDING_PATTERNS.items():
        for pattern in patterns:
            if re.search(pattern, text):
                return severity
    
    return "low"


def filter_slither_report(data: dict) -> dict:
    """Filtra relatório do Slither."""
    if not isinstance(data, dict):
        return {"error": "Formato inesperado", "results": []}
    
    results = data.get("results", data.get("detectors", []))
    if isinstance(results, dict):
        results = results.get("detectors", [])
    
    filtered = {
        "tool": "slither",
        "total_raw": len(results),
        "false_positives": 0,
        "real_findings": [],
        "summary": {"high": 0, "medium": 0, "low": 0, "informational": 0}
    }
    
    for finding in results:
        detector = finding.get("check", finding.get("detector", ""))
        description = finding.get("description", finding.get("message", ""))
        elements = finding.get("elements", [])
        
        if is_false_positive(detector, description, "slither"):
            filtered["false_positives"] += 1
            continue
        
        severity = get_severity(detector, description)
        filtered["summary"][severity] += 1
        
        filtered["real_findings"].append({
            "detector": detector,
            "severity": severity,
            "description": description,
            "elements": elements,
            "file": elements[0].get("source_mapping", {}).get("filename_relative", "unknown") if elements else "unknown",
            "line": elements[0].get("source_mapping", {}).get("lines", [0])[0] if elements else 0,
        })
    
    return filtered


def filter_aderyn_report(data: dict) -> dict:
    """Filtra relatório do Aderyn."""
    if not isinstance(data, dict):
        return {"error": "Formato inesperado", "results": []}
    
    issues = data.get("issues", data.get("findings", []))
    
    filtered = {
        "tool": "aderyn",
        "total_raw": len(issues),
        "false_positives": 0,
        "real_findings": [],
        "summary": {"high": 0, "medium": 0, "low": 0, "informational": 0}
    }
    
    for issue in issues:
        title = issue.get("title", issue.get("name", ""))
        description = issue.get("description", issue.get("message", ""))
        
        if is_false_positive(title, description, "aderyn"):
            filtered["false_positives"] += 1
            continue
        
        severity = get_severity(title, description)
        filtered["summary"][severity] += 1
        
        filtered["real_findings"].append({
            "detector": title,
            "severity": severity,
            "description": description,
            "file": issue.get("file", "unknown"),
            "line": issue.get("line", 0),
        })
    
    return filtered


def filter_mythril_report(data: dict) -> dict:
    """Filtra relatório do Mythril."""
    if not isinstance(data, dict):
        return {"error": "Formato inesperado", "results": []}
    
    issues = data.get("issues", data.get("results", []))
    
    filtered = {
        "tool": "mythril",
        "total_raw": len(issues),
        "false_positives": 0,
        "real_findings": [],
        "summary": {"high": 0, "medium": 0, "low": 0, "informational": 0}
    }
    
    for issue in issues:
        title = issue.get("title", issue.get("swc-id", ""))
        description = issue.get("description", issue.get("message", ""))
        
        if is_false_positive(title, description, "mythril"):
            filtered["false_positives"] += 1
            continue
        
        severity = get_severity(title, description)
        filtered["summary"][severity] += 1
        
        filtered["real_findings"].append({
            "detector": title,
            "severity": severity,
            "description": description,
            "file": issue.get("file", "unknown"),
            "line": issue.get("line", 0),
        })
    
    return filtered


def generate_markdown_report(filtered: dict) -> str:
    """Gera relatório Markdown a partir dos dados filtrados."""
    lines = []
    lines.append(f"# 🔍 Relatório Filtrado — {filtered['tool'].title()}")
    lines.append("")
    lines.append(f"**Total raw:** {filtered['total_raw']} | **Falsos positivos:** {filtered['false_positives']} | **Reais:** {len(filtered['real_findings'])}")
    lines.append("")
    
    summary = filtered["summary"]
    lines.append("## 📊 Resumo por Severidade")
    lines.append("")
    lines.append(f"| Severidade | Quantidade |")
    lines.append(f"|------------|-----------|")
    lines.append(f"| 🔴 **High** | {summary['high']} |")
    lines.append(f"| 🟡 **Medium** | {summary['medium']} |")
    lines.append(f"| 🟢 **Low** | {summary['low']} |")
    lines.append(f"| 🔵 **Informational** | {summary['informational']} |")
    lines.append("")
    
    if filtered["real_findings"]:
        lines.append("## 🎯 Findings Reais")
        lines.append("")
        
        # Agrupa por severidade
        for severity in ["high", "medium", "low", "informational"]:
            findings = [f for f in filtered["real_findings"] if f["severity"] == severity]
            if not findings:
                continue
            
            emoji = {"high": "🔴", "medium": "🟡", "low": "🟢", "informational": "🔵"}[severity]
            lines.append(f"### {emoji} {severity.title()} ({len(findings)})")
            lines.append("")
            
            for f in findings:
                lines.append(f"- **{f['detector']}** — {f['file']}:{f['line']}")
                lines.append(f"  - {f['description'][:200]}")
                lines.append("")
    
    if filtered["false_positives"] > 0:
        lines.append("## 🧹 Falsos Positivos Filtrados")
        lines.append("")
        lines.append(f"{filtered['false_positives']} avisos foram filtrados como falsos positivos com base na base de conhecimento.")
        lines.append("")
    
    return "\n".join(lines)


def filter_markdown_report(input_path: str, tool: str) -> dict:
    """Filtra relatório Markdown (fallback quando JSON não está disponível).
    
    Extrai findings de relatórios markdown usando padrões de texto.
    Útil para ferramentas que só geram saída markdown (ex: Aderyn).
    """
    with open(input_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    filtered = {
        "tool": tool,
        "total_raw": 0,
        "false_positives": 0,
        "real_findings": [],
        "summary": {"high": 0, "medium": 0, "low": 0, "informational": 0}
    }
    
    # Padrões para extrair findings de markdown
    # Ex: "- **Reentrancy** — arquivo.sol:42"
    finding_patterns = [
        (r'\*\*(.*?)\*\*\s*[—–-]\s*(\S+\.sol):(\d+)', 3),  # **Detector** — file.sol:42
        (r'-\s+\*\*(.*?)\*\*\s*[—–-]\s*(.*?)(?:\n|$)', 2),  # - **Detector** — description
        (r'\[(.*?)\]\s*\(.*?\)\s*[—–-]\s*(.*?)(?:\n|$)', 2),  # [Detector](link) — description
    ]
    
    for pattern, group_count in finding_patterns:
        for match in re.finditer(pattern, content, re.IGNORECASE):
            detector = match.group(1)
            description = match.group(2) if group_count >= 2 else ""
            
            filtered["total_raw"] += 1
            
            if is_false_positive(detector, description, tool):
                filtered["false_positives"] += 1
                continue
            
            severity = get_severity(detector, description)
            filtered["summary"][severity] += 1
            
            file = "unknown"
            line = 0
            if group_count >= 3:
                file = match.group(2)
                try:
                    line = int(match.group(3))
                except ValueError:
                    pass
            
            filtered["real_findings"].append({
                "detector": detector,
                "severity": severity,
                "description": description[:200],
                "file": file,
                "line": line,
            })
    
    return filtered


def main():
    parser = argparse.ArgumentParser(
        description="Filtro Inteligente de Falsos Positivos para ferramentas de análise de Solidity"
    )
    parser.add_argument("input", help="Arquivo de entrada (JSON ou Markdown)")
    parser.add_argument("--tool", required=True, choices=["slither", "aderyn", "mythril", "semgrep"],
                        help="Ferramenta que gerou o relatório")
    parser.add_argument("--output", "-o", default=None,
                        help="Arquivo de saída (Markdown). Se não especificado, imprime no stdout")
    parser.add_argument("--format", choices=["auto", "json", "markdown"], default="auto",
                        help="Formato do arquivo de entrada (auto detecta pela extensão)")
    
    args = parser.parse_args()
    
    # Detecta formato
    input_format = args.format
    if input_format == "auto":
        ext = Path(args.input).suffix.lower()
        if ext == ".json":
            input_format = "json"
        elif ext in (".md", ".markdown", ".txt"):
            input_format = "markdown"
        else:
            # Tenta JSON primeiro, fallback para markdown
            try:
                with open(args.input, 'r') as f:
                    json.loads(f.read(100))
                input_format = "json"
            except (json.JSONDecodeError, UnicodeDecodeError):
                input_format = "markdown"
    
    if input_format == "json":
        # Carrega o JSON
        try:
            data = load_json_report(args.input)
        except FileNotFoundError:
            print(f"❌ Erro: Arquivo '{args.input}' não encontrado.", file=sys.stderr)
            sys.exit(1)
        except json.JSONDecodeError as e:
            print(f"❌ Erro: JSON inválido em '{args.input}': {e}", file=sys.stderr)
            sys.exit(1)
        
        # Filtra conforme a ferramenta
        filter_functions = {
            "slither": filter_slither_report,
            "aderyn": filter_aderyn_report,
            "mythril": filter_mythril_report,
        }
        
        if args.tool in filter_functions:
            filtered = filter_functions[args.tool](data)
        else:
            print(f"⚠️  Ferramenta '{args.tool}' não tem filtro JSON específico. Usando fallback markdown.", file=sys.stderr)
            filtered = filter_markdown_report(args.input, args.tool)
    else:
        # Modo markdown (fallback)
        filtered = filter_markdown_report(args.input, args.tool)
    
    # Gera relatório Markdown
    report = generate_markdown_report(filtered)
    
    # Saída
    if args.output:
        output_path = Path(args.output)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text(report, encoding='utf-8')
        print(f"✅ Relatório filtrado salvo em: {args.output}")
        print(f"   Raw: {filtered['total_raw']} | FP: {filtered['false_positives']} | Reais: {len(filtered['real_findings'])}")
    else:
        print(report)


if __name__ == "__main__":
    main()
