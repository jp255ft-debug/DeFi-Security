#!/usr/bin/env python3
"""
Validador de Contratos Move para Momentum DEX (v3-core) - v3
Foca em vulnerabilidades reais com reconhecimento de ACL do Move/Sui
"""
import os
import re
import sys
from pathlib import Path
from datetime import datetime

REPO_DIR = Path(__file__).parent.parent / "repo_temp" / "clmm"
SOURCES_DIR = REPO_DIR / "sources"

# Padroes refinados - reconhecendo ACL do Move/Sui
VULN_PATTERNS = {
    "unchecked_arithmetic_swap": {
        "pattern": r"(amount_specified|amount_calculated|amount_in|amount_out)\s*=\s*\1\s*[-+]\s*",
        "severity": "High",
        "desc": "Operacao aritmetica em swap sem verificacao de overflow/underflow",
        "exclude_patterns": []
    },
    "unchecked_flash_loan_amount": {
        "pattern": r"amount_x\s*<\s*reserve_x",
        "severity": "Medium",
        "desc": "Verificacao de flash loan usa < em vez de <= - possivel precisao",
        "exclude_patterns": []
    },
    "missing_slippage_protection": {
        "pattern": r"public\s+fun\s+swap\w*\s*<[^>]*>\s*\([^)]*\)\s*{",
        "severity": "High",
        "desc": "Funcao de swap sem parametro de slippage (minAmountOut)",
        "exclude_patterns": [r"min_amount", r"slippage", r"sqrt_price_limit"]
    },
    "dynamic_field_key_collision": {
        "pattern": r"dynamic_field::add\s*<[^>]*>\s*\(\s*&\s*mut\s+\w+\.id\s*,",
        "severity": "High",
        "desc": "Adicao de dynamic_field - verificar se a chave pode colidir",
        "exclude_patterns": [r"test_only"]
    },
    "unchecked_reward_manipulation": {
        "pattern": r"reward_info\.(total_reward|reward_per_seconds|ended_at_seconds)\s*=",
        "severity": "High",
        "desc": "Atualizacao direta de parametros de recompensa - possivel manipulacao",
        "exclude_patterns": []
    },
    "missing_tick_validation": {
        "pattern": r"tick_index\s*=\s*tick_math::get_tick_at_sqrt_price",
        "severity": "Medium",
        "desc": "Calculo de tick a partir de sqrt_price sem validacao de limites",
        "exclude_patterns": []
    },
    "oracle_manipulation": {
        "pattern": r"oracle::write\s*\([^)]*\)",
        "severity": "Medium",
        "desc": "Escrita no oracle - verificar se ha protecao contra manipulacao via flash loans",
        "exclude_patterns": [r"test_only", r"#\[test"]
    },
    "unchecked_protocol_fee": {
        "pattern": r"protocol_fee_x\s*=\s*protocol_fee_x\s*\+\s*swap_state\.protocol_fee",
        "severity": "Medium",
        "desc": "Acumulo de taxa sem verificacao de overflow",
        "exclude_patterns": []
    },
    "donation_to_reserves": {
        "pattern": r"balance::join\s*\([^)]*\)\s*;",
        "severity": "High",
        "desc": "Adicao direta a reserves sem verificacao de origem - possivel donation attack",
        "exclude_patterns": [r"add_to_reserves"]
    }
}

def scan_file(filepath):
    """Escaneia um arquivo .move por padroes de vulnerabilidade"""
    findings = []
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
            lines = content.split('\n')
    except Exception as e:
        return []
    
    # Pular arquivos de teste
    if "#[test_only]" in content or "#[test]" in content:
        return []
    
    rel_path = filepath.relative_to(SOURCES_DIR) if SOURCES_DIR in filepath.parents else filepath
    
    for vuln_name, config in VULN_PATTERNS.items():
        matches = re.finditer(config["pattern"], content, re.MULTILINE)
        for match in matches:
            excluded = any(
                re.search(excl, content[:match.start()] + content[match.end():])
                for excl in config["exclude_patterns"]
            )
            if excluded:
                continue
            
            line_num = content[:match.start()].count('\n') + 1
            start_line = max(0, line_num - 3)
            end_line = min(len(lines), line_num + 2)
            context = '\n'.join(lines[start_line:end_line])
            
            findings.append({
                "file": str(rel_path),
                "line": line_num,
                "vulnerability": vuln_name,
                "severity": config["severity"],
                "description": config["desc"],
                "match": match.group().strip()[:120],
                "context": context
            })
    
    return findings

def analyze_math_libraries():
    """Analisa bibliotecas matematicas"""
    math_files = list(SOURCES_DIR.rglob("*math*.move")) + list(SOURCES_DIR.rglob("*integer*.move"))
    analysis = []
    for mf in math_files:
        with open(mf, 'r') as f:
            content = f.read()
        analysis.append({
            "file": str(mf.relative_to(SOURCES_DIR)),
            "has_wrapping": "wrapping_" in content,
            "has_checked": "add_check" in content or "mul_div" in content,
            "has_safe_casts": "as u128" in content or "as u64" in content
        })
    return analysis

def analyze_oracle():
    """Analisa implementacao do oracle"""
    oracle_file = SOURCES_DIR / "utils" / "oracle.move"
    if not oracle_file.exists():
        return []
    findings = []
    with open(oracle_file, 'r') as f:
        content = f.read()
    if "observation_cardinality" in content:
        findings.append({
            "type": "oracle_capacity",
            "desc": "Oracle tem cardinalidade configuravel - verificar se ha limite minimo seguro",
            "severity": "Medium"
        })
    return findings

def generate_report(all_findings, math_analysis, oracle_findings):
    """Gera relatorio consolidado"""
    report = []
    report.append("# Analise Automatizada de Seguranca - Momentum DEX (Move/Sui) - v3")
    report.append(f"\n> Gerado em: {datetime.now().isoformat()}")
    report.append(f"\n## Resumo")
    
    severity_count = {"Critical": 0, "High": 0, "Medium": 0, "Low": 0, "Info": 0}
    for f in all_findings:
        sev = f.get("severity", "Info")
        if sev in severity_count:
            severity_count[sev] += 1
    
    report.append(f"\n| Severidade | Quantidade |")
    report.append(f"|------------|-----------|")
    for sev, count in severity_count.items():
        report.append(f"| {sev} | {count} |")
    
    report.append(f"\n**Total de achados: {len(all_findings)}**")
    
    for severity in ["Critical", "High", "Medium", "Low", "Info"]:
        sev_findings = [f for f in all_findings if f.get("severity") == severity]
        if sev_findings:
            report.append(f"\n### {severity}")
            for f in sev_findings:
                report.append(f"\n**{f['file']}:{f.get('line', '?')}**")
                report.append(f"- **Tipo:** {f.get('vulnerability', f.get('type', 'unknown'))}")
                report.append(f"- **Descricao:** {f.get('description', '')}")
                if 'match' in f:
                    report.append(f"- **Match:** `{f['match']}`")
                if 'context' in f:
                    report.append(f"```move\n{f['context']}\n```")
    
    report.append(f"\n## Analise de Bibliotecas Matematicas")
    for m in math_analysis:
        status = "[OK]" if m['has_checked'] else "[WARN]"
        report.append(f"\n{status} **{m['file']}**")
        report.append(f"- Wrapping: {m['has_wrapping']}, Checked: {m['has_checked']}, Casts: {m['has_safe_casts']}")
    
    if oracle_findings:
        report.append(f"\n## Analise do Oracle")
        for f in oracle_findings:
            report.append(f"- [WARN] {f['desc']} (Severidade: {f['severity']})")
    
    return '\n'.join(report)

def main():
    print("[SCAN] Iniciando analise v3 dos contratos Move...")
    
    if not SOURCES_DIR.exists():
        print(f"[ERROR] Diretorio nao encontrado: {SOURCES_DIR}")
        sys.exit(1)
    
    all_findings = []
    move_files = list(SOURCES_DIR.rglob("*.move"))
    print(f"[INFO] Escaneando {len(move_files)} arquivos...")
    
    for mf in move_files:
        findings = scan_file(mf)
        all_findings.extend(findings)
    
    print("[INFO] Analisando bibliotecas matematicas...")
    math_analysis = analyze_math_libraries()
    
    print("[INFO] Analisando oracle...")
    oracle_findings = analyze_oracle()
    
    print("[INFO] Gerando relatorio...")
    report = generate_report(all_findings, math_analysis, oracle_findings)
    
    output_path = Path(__file__).parent.parent / "RELATORIO_ANALISE_INICIAL.md"
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(report)
    
    print(f"[OK] Relatorio salvo em: {output_path}")
    print(f"\n[INFO] Resumo:")
    print(f"   Total de achados: {len(all_findings)}")
    
    severity_count = {}
    for f in all_findings:
        sev = f.get("severity", "Info")
        severity_count[sev] = severity_count.get(sev, 0) + 1
    for sev, count in sorted(severity_count.items()):
        print(f"   {sev}: {count}")

if __name__ == "__main__":
    main()
