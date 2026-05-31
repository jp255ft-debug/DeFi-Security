#!/usr/bin/env python3
"""
quantum_risk_scanner.py — Scanner de Risco Quântico Automatizado (PQR-Score)

Pipeline: audits/<project>/src/ -> quantum_risk_scanner.py -> PQR-Score + relatório

Uso:
  python quantum_risk_scanner.py <project_name>
  python quantum_risk_scanner.py <project_name> --output findings/pqaudit/pqr_score.json
  python quantum_risk_scanner.py <project_name> --verbose
  python quantum_risk_scanner.py <project_name> --checklist knowledge_base/checklists/quantum_readiness.md

Alinhamento: NIST SP 800-208, CNSA 2.0, FIPS 204/205/206
"""

import argparse
import io
import json
import os
import re
import sys
from pathlib import Path

# Força UTF-8 no stdout/stderr para evitar problemas com emojis no Windows
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')

# =============================================================================
# CONSTANTES
# =============================================================================

WORKSPACE_ROOT = Path(__file__).resolve().parent.parent

# Padrões de algoritmos vulneráveis ao ataque de Shor
ALGORITHM_PATTERNS = {
    "ECDSA (ecrecover)": {
        "patterns": [r"\becrecover\b", r"ECDSA\.sol", r"ECDSA\.recover"],
        "severity": "critical",
        "mitigation": "ML-DSA (FIPS 204)",
        "description": "ECDSA via ecrecover — quebrado pelo algoritmo de Shor"
    },
    "ECDSA (OpenZeppelin)": {
        "patterns": [r"import.*ECDSA", r"using.*ECDSA", r"ECDSA\.toEthSignedMessageHash"],
        "severity": "critical",
        "mitigation": "ML-DSA (FIPS 204)",
        "description": "OpenZeppelin ECDSA.sol — quebrado pelo algoritmo de Shor"
    },
    "EIP-712 (ECDSA)": {
        "patterns": [r"_hashTypedData", r"EIP712", r"eip712", r"DOMAIN_SEPARATOR"],
        "severity": "high",
        "mitigation": "ML-DSA (FIPS 204) com EIP-712 adaptado",
        "description": "EIP-712 depende de ECDSA para verificação de assinatura"
    },
    "ERC-20 Permit (ECDSA)": {
        "patterns": [r"\bpermit\b", r"ERC20Permit", r"ERC-2612", r"ERC2612"],
        "severity": "high",
        "mitigation": "ML-DSA (FIPS 204) para permit signatures",
        "description": "ERC-20 Permit usa ECDSA para autorização"
    },
    "Ed25519": {
        "patterns": [r"ed25519", r"Ed25519", r"ED25519"],
        "severity": "critical",
        "mitigation": "SLH-DSA (FIPS 205)",
        "description": "Ed25519 — quebrado pelo algoritmo de Shor"
    },
    "BLS": {
        "patterns": [r"BLS", r"bls", r"BLS12-381", r"bls12", r"BN254", r"bn254"],
        "severity": "high",
        "mitigation": "ML-DSA aggregation (FIPS 204)",
        "description": "BLS — quebrado pelo algoritmo de Shor"
    },
    "RSA": {
        "patterns": [r"\bRSA\b", r"rsa\b", r"RS256", r"RS384", r"RS512"],
        "severity": "critical",
        "mitigation": "ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205)",
        "description": "RSA — quebrado pelo algoritmo de Shor"
    },
}

# Padrões de hash functions afetadas por Grover
HASH_PATTERNS = {
    "keccak256": {
        "patterns": [r"keccak256\b"],
        "classical_bits": 256,
        "pq_bits": 128,
        "risk": "moderate",
        "note": "Grover reduz segurança de 256→128 bits. Avaliar se 128 bits são suficientes."
    },
    "sha256": {
        "patterns": [r"\bsha256\b", r"SHA256"],
        "classical_bits": 256,
        "pq_bits": 128,
        "risk": "moderate",
        "note": "Grover reduz segurança de 256→128 bits."
    },
    "RIPEMD-160": {
        "patterns": [r"RIPEMD160", r"ripemd160"],
        "classical_bits": 160,
        "pq_bits": 80,
        "risk": "low",
        "note": "Usado para endereços Ethereum. 80 bits pós-quântica — risco baixo."
    },
}

# Padrões de gerenciamento de chaves
KEY_MANAGEMENT_PATTERNS = {
    "owner_eoa": {
        "patterns": [r"\bowner\b", r"\bonlyOwner\b", r"Ownable"],
        "risk": "high",
        "note": "Owner EOA depende de ECDSA — vulnerável a Shor"
    },
    "upgradeability": {
        "patterns": [r"UUPS", r"TransparentUpgradeableProxy", r"ERC1967Proxy", r"delegatecall"],
        "risk": "moderate",
        "note": "Proxy upgrade depende de admin EOA (ECDSA)"
    },
    "multisig": {
        "patterns": [r"GnosisSafe", r"Safe\.sol", r"MultiSig", r"multisig"],
        "risk": "moderate",
        "note": "Multisig wallets dependem de ECDSA para assinaturas"
    },
    "timelock": {
        "patterns": [r"Timelock", r"timelock", r"TimeLock"],
        "risk": "low",
        "note": "Timelock controllers podem usar EOA admin"
    },
    "create2": {
        "patterns": [r"CREATE2", r"create2"],
        "risk": "low",
        "note": "CREATE2 com salt previsível pode ser explorado"
    },
}


def find_source_files(project_dir: Path) -> list:
    """Encontra todos os arquivos .sol no diretório do projeto."""
    src_dir = project_dir / "src"
    if not src_dir.exists():
        print(f"❌ Erro: Diretório {src_dir} não encontrado.", file=sys.stderr)
        return []
    
    sol_files = list(src_dir.rglob("*.sol"))
    return sol_files


def scan_file_for_patterns(filepath: Path, patterns: dict) -> list:
    """
    Escaneia um arquivo .sol em busca de padrões de algoritmos vulneráveis.
    
    Args:
        filepath: Caminho do arquivo .sol
        patterns: Dicionário de padrões a buscar
    
    Returns:
        Lista de findings encontrados
    """
    findings = []
    try:
        content = filepath.read_text(encoding="utf-8", errors="replace")
    except Exception as e:
        print(f"   ⚠️  Erro ao ler {filepath}: {e}", file=sys.stderr)
        return []
    
    rel_path = filepath.relative_to(WORKSPACE_ROOT)
    
    for algo_name, algo_info in patterns.items():
        for pattern in algo_info["patterns"]:
            for match in re.finditer(pattern, content, re.IGNORECASE):
                # Encontra a linha do match
                line_num = content[:match.start()].count("\n") + 1
                
                findings.append({
                    "type": "algorithm",
                    "algorithm": algo_name,
                    "severity": algo_info.get("severity", "medium"),
                    "location": f"{rel_path}:{line_num}",
                    "match": match.group(),
                    "mitigation": algo_info.get("mitigation", "N/A"),
                    "description": algo_info.get("description", ""),
                })
    
    return findings


def scan_hash_functions(filepath: Path) -> list:
    """Escaneia arquivo em busca de hash functions afetadas por Grover."""
    findings = []
    try:
        content = filepath.read_text(encoding="utf-8", errors="replace")
    except Exception:
        return []
    
    rel_path = filepath.relative_to(WORKSPACE_ROOT)
    
    for hash_name, hash_info in HASH_PATTERNS.items():
        for pattern in hash_info["patterns"]:
            for match in re.finditer(pattern, content, re.IGNORECASE):
                line_num = content[:match.start()].count("\n") + 1
                
                findings.append({
                    "type": "hash_function",
                    "hash": hash_name,
                    "classical_bits": hash_info["classical_bits"],
                    "pq_bits": hash_info["pq_bits"],
                    "risk": hash_info["risk"],
                    "location": f"{rel_path}:{line_num}",
                    "note": hash_info["note"],
                })
    
    return findings


def scan_key_management(filepath: Path) -> list:
    """Escaneia arquivo em busca de padrões de gerenciamento de chaves."""
    findings = []
    try:
        content = filepath.read_text(encoding="utf-8", errors="replace")
    except Exception:
        return []
    
    rel_path = filepath.relative_to(WORKSPACE_ROOT)
    
    for key_name, key_info in KEY_MANAGEMENT_PATTERNS.items():
        for pattern in key_info["patterns"]:
            for match in re.finditer(pattern, content, re.IGNORECASE):
                line_num = content[:match.start()].count("\n") + 1
                
                findings.append({
                    "type": "key_management",
                    "pattern": key_name,
                    "risk": key_info["risk"],
                    "location": f"{rel_path}:{line_num}",
                    "note": key_info["note"],
                })
    
    return findings


def calculate_pqr_score(algo_findings: list, hash_findings: list, key_findings: list) -> dict:
    """
    Calcula o PQR-Score (0-100) baseado nos findings.
    
    Pesos:
    - 40%: Algoritmos vulneráveis (ECDSA, RSA, Ed25519, BLS)
    - 30%: Dependência de chave pública (owner, multisig, upgradeability)
    - 20%: Exposição a Grover (hash functions)
    - 10%: Maturidade de governança
    
    Returns:
        Dict com PQR-Score, classificação e detalhamento
    """
    # --- Score de algoritmos (40%) ---
    algo_score = 0
    if algo_findings:
        # Conta ocorrências por severidade
        severity_counts = {"critical": 0, "high": 0, "medium": 0, "low": 0}
        for f in algo_findings:
            sev = f.get("severity", "low")
            if sev in severity_counts:
                severity_counts[sev] += 1
        
        # Penalidade: critical=25pts cada, high=15pts, medium=5pts
        penalty = (
            severity_counts["critical"] * 25 +
            severity_counts["high"] * 15 +
            severity_counts["medium"] * 5
        )
        algo_score = min(100, penalty)
    
    # --- Score de chave pública (30%) ---
    key_score = 0
    if key_findings:
        risk_counts = {"high": 0, "moderate": 0, "low": 0}
        for f in key_findings:
            risk = f.get("risk", "low")
            if risk in risk_counts:
                risk_counts[risk] += 1
        
        penalty = (
            risk_counts["high"] * 20 +
            risk_counts["moderate"] * 10 +
            risk_counts["low"] * 5
        )
        key_score = min(100, penalty)
    
    # --- Score de Grover (20%) ---
    grover_score = 0
    if hash_findings:
        risk_counts = {"moderate": 0, "low": 0}
        for f in hash_findings:
            risk = f.get("risk", "low")
            if risk in risk_counts:
                risk_counts[risk] += 1
        
        penalty = risk_counts["moderate"] * 15 + risk_counts["low"] * 5
        grover_score = min(100, penalty)
    
    # --- Score de governança (10%) ---
    # Quanto mais findings de gerenciamento de chaves, pior a governança
    governance_score = min(100, len(key_findings) * 10)
    
    # --- PQR-Score final ---
    pqr_score = (
        algo_score * 0.40 +
        key_score * 0.30 +
        grover_score * 0.20 +
        governance_score * 0.10
    )
    
    pqr_score = round(min(100, max(0, pqr_score)), 1)
    
    # --- Classificação ---
    if pqr_score <= 20:
        classification = "🟢 Baixo Risco"
        action = "Monitorar padrões NIST anualmente"
    elif pqr_score <= 50:
        classification = "🟡 Risco Moderado"
        action = "Planejar migração em 12-24 meses"
    elif pqr_score <= 80:
        classification = "🟠 Alto Risco"
        action = "Iniciar migração em 6-12 meses"
    else:
        classification = "🔴 Crítico"
        action = "Migração imediata (0-6 meses)"
    
    return {
        "pqr_score": pqr_score,
        "classification": classification,
        "action": action,
        "components": {
            "algorithms": {"score": algo_score, "weight": "40%", "findings": len(algo_findings)},
            "key_management": {"score": key_score, "weight": "30%", "findings": len(key_findings)},
            "grover_exposure": {"score": grover_score, "weight": "20%", "findings": len(hash_findings)},
            "governance": {"score": governance_score, "weight": "10%", "findings": len(key_findings)},
        }
    }


def generate_markdown_report(project_name: str, algo_findings: list, hash_findings: list,
                              key_findings: list, pqr_result: dict) -> str:
    """Gera relatório Markdown com os resultados do scan."""
    lines = []
    lines.append(f"# ⚛️ PQR-Score Report — {project_name}")
    lines.append("")
    lines.append(f"**PQR-Score:** {pqr_result['pqr_score']}/100 — {pqr_result['classification']}")
    lines.append(f"**Ação Recomendada:** {pqr_result['action']}")
    lines.append("")
    
    # Tabela de componentes
    lines.append("## 📊 Componentes do PQR-Score")
    lines.append("")
    lines.append("| Componente | Score | Peso | Findings |")
    lines.append("|------------|-------|------|----------|")
    comps = pqr_result["components"]
    lines.append(f"| 🔐 Algoritmos | {comps['algorithms']['score']}/100 | {comps['algorithms']['weight']} | {comps['algorithms']['findings']} |")
    lines.append(f"| 🔑 Chave Pública | {comps['key_management']['score']}/100 | {comps['key_management']['weight']} | {comps['key_management']['findings']} |")
    lines.append(f"| 🧮 Exposição Grover | {comps['grover_exposure']['score']}/100 | {comps['grover_exposure']['weight']} | {comps['grover_exposure']['findings']} |")
    lines.append(f"| 🏛️ Governança | {comps['governance']['score']}/100 | {comps['governance']['weight']} | {comps['governance']['findings']} |")
    lines.append("")
    
    # Algoritmos vulneráveis
    if algo_findings:
        lines.append("## 🔐 Algoritmos Vulneráveis (Ataque de Shor)")
        lines.append("")
        lines.append("| Localização | Algoritmo | Severidade | Mitigação |")
        lines.append("|------------|-----------|------------|-----------|")
        for f in algo_findings:
            sev_emoji = {"critical": "🔴", "high": "🟠", "medium": "🟡", "low": "🟢"}
            emoji = sev_emoji.get(f["severity"], "⚪")
            lines.append(f"| `{f['location']}` | {f['algorithm']} | {emoji} {f['severity'].title()} | {f['mitigation']} |")
        lines.append("")
    
    # Hash functions
    if hash_findings:
        lines.append("## 🧮 Hash Functions (Ataque de Grover)")
        lines.append("")
        lines.append("| Localização | Hash | Bits (Clássico) | Bits (Pós-Quântico) | Risco |")
        lines.append("|------------|------|-----------------|--------------------|-------|")
        risk_emoji = {"moderate": "🟡", "low": "🟢"}
        for f in hash_findings:
            emoji = risk_emoji.get(f["risk"], "⚪")
            lines.append(f"| `{f['location']}` | {f['hash']} | {f['classical_bits']} | {f['pq_bits']} | {emoji} {f['risk'].title()} |")
        lines.append("")
    
    # Gerenciamento de chaves
    if key_findings:
        lines.append("## 🔑 Gerenciamento de Chaves")
        lines.append("")
        lines.append("| Localização | Padrão | Risco | Nota |")
        lines.append("|------------|--------|-------|------|")
        risk_emoji = {"high": "🔴", "moderate": "🟡", "low": "🟢"}
        for f in key_findings:
            emoji = risk_emoji.get(f["risk"], "⚪")
            lines.append(f"| `{f['location']}` | {f['pattern']} | {emoji} {f['risk'].title()} | {f['note']} |")
        lines.append("")
    
    # Resumo
    lines.append("## 📋 Resumo")
    lines.append("")
    lines.append(f"- **Total de algoritmos vulneráveis:** {len(algo_findings)}")
    lines.append(f"- **Total de hash functions em risco:** {len(hash_findings)}")
    lines.append(f"- **Total de issues de gerenciamento de chaves:** {len(key_findings)}")
    lines.append(f"- **PQR-Score:** {pqr_result['pqr_score']}/100 — {pqr_result['classification']}")
    lines.append("")
    lines.append("---")
    lines.append(f"*Relatório gerado pelo DeFi Security Workspace — quantum_risk_scanner.py*")
    
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(
        description="Scanner de Risco Quântico Automatizado (PQR-Score)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Exemplos:
  %(prog)s MeuProtocolo
  %(prog)s MeuProtocolo --output findings/pqaudit/pqr_score.json
  %(prog)s MeuProtocolo --verbose
        """
    )
    
    parser.add_argument(
        "project",
        help="Nome do diretório do projeto em audits/ (ex: CircleUSDCBridge)"
    )
    
    parser.add_argument(
        "--output", "-o",
        default=None,
        help="Arquivo de saída JSON (ex: findings/pqaudit/pqr_score.json)"
    )
    
    parser.add_argument(
        "--verbose", "-v",
        action="store_true",
        help="Modo verboso: mostra detalhes do scan em tempo real"
    )
    
    parser.add_argument(
        "--markdown", "-m",
        default=None,
        help="Arquivo de saída Markdown (ex: findings/pqaudit/pqr_report.md)"
    )
    
    args = parser.parse_args()
    
    # --- Diretório do projeto ---
    project_dir = WORKSPACE_ROOT / "audits" / args.project
    if not project_dir.exists():
        print(f"❌ Erro: Projeto '{args.project}' não encontrado em {project_dir}", file=sys.stderr)
        print(f"   Diretórios disponíveis:")
        for d in sorted((WORKSPACE_ROOT / "audits").iterdir()):
            if d.is_dir():
                print(f"     - {d.name}")
        sys.exit(1)
    
    print(f"\n{'='*60}")
    print(f"⚛️  Quantum Risk Scanner — PQR-Score")
    print(f"{'='*60}")
    print(f"📁 Projeto: {args.project}")
    print(f"{'='*60}\n")
    
    # --- Encontra arquivos fonte ---
    sol_files = find_source_files(project_dir)
    if not sol_files:
        print("❌ Nenhum arquivo .sol encontrado em src/")
        sys.exit(1)
    
    print(f"📄 Arquivos .sol encontrados: {len(sol_files)}")
    if args.verbose:
        for f in sol_files:
            print(f"   - {f.relative_to(WORKSPACE_ROOT)}")
    print()
    
    # --- Scan de algoritmos ---
    print("🔐 Escaneando algoritmos vulneráveis (Shor)...")
    algo_findings = []
    for sol_file in sol_files:
        findings = scan_file_for_patterns(sol_file, ALGORITHM_PATTERNS)
        algo_findings.extend(findings)
        if args.verbose and findings:
            for f in findings:
                print(f"   ⚠️  {f['algorithm']} em {f['location']}")
    
    # Deduplica findings (mesmo algoritmo, mesmo local)
    seen = set()
    unique_algo = []
    for f in algo_findings:
        key = (f["algorithm"], f["location"])
        if key not in seen:
            seen.add(key)
            unique_algo.append(f)
    algo_findings = unique_algo
    
    print(f"   ✅ {len(algo_findings)} algoritmos vulneráveis encontrados\n")
    
    # --- Scan de hash functions ---
    print("🧮 Escaneando hash functions (Grover)...")
    hash_findings = []
    for sol_file in sol_files:
        findings = scan_hash_functions(sol_file)
        hash_findings.extend(findings)
        if args.verbose and findings:
            for f in findings:
                print(f"   ℹ️  {f['hash']} em {f['location']} ({f['risk']})")
    
    # Deduplica
    seen = set()
    unique_hash = []
    for f in hash_findings:
        key = (f["hash"], f["location"])
        if key not in seen:
            seen.add(key)
            unique_hash.append(f)
    hash_findings = unique_hash
    
    print(f"   ✅ {len(hash_findings)} hash functions analisadas\n")
    
    # --- Scan de gerenciamento de chaves ---
    print("🔑 Escaneando gerenciamento de chaves...")
    key_findings = []
    for sol_file in sol_files:
        findings = scan_key_management(sol_file)
        key_findings.extend(findings)
        if args.verbose and findings:
            for f in findings:
                print(f"   ℹ️  {f['pattern']} em {f['location']} ({f['risk']})")
    
    # Deduplica
    seen = set()
    unique_key = []
    for f in key_findings:
        key = (f["pattern"], f["location"])
        if key not in seen:
            seen.add(key)
            unique_key.append(f)
    key_findings = unique_key
    
    print(f"   ✅ {len(key_findings)} issues de gerenciamento de chaves encontradas\n")
    
    # --- Calcula PQR-Score ---
    print("📊 Calculando PQR-Score...")
    pqr_result = calculate_pqr_score(algo_findings, hash_findings, key_findings)
    
    print(f"\n{'='*60}")
    print(f"📊 PQR-Score: {pqr_result['pqr_score']}/100 — {pqr_result['classification']}")
    print(f"🎯 Ação: {pqr_result['action']}")
    print(f"{'='*60}\n")
    
    # --- Prepara saída ---
    output = {
        "project": args.project,
        "pqr_score": pqr_result["pqr_score"],
        "classification": pqr_result["classification"],
        "action": pqr_result["action"],
        "components": pqr_result["components"],
        "findings": {
            "algorithms": algo_findings,
            "hash_functions": hash_findings,
            "key_management": key_findings,
        },
        "summary": {
            "total_algorithms": len(algo_findings),
            "total_hash_functions": len(hash_findings),
            "total_key_issues": len(key_findings),
            "files_scanned": len(sol_files),
        }
    }
    
    # --- Saída JSON ---
    if args.output:
        output_path = project_dir / args.output
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text(json.dumps(output, indent=2, ensure_ascii=False), encoding="utf-8")
        print(f"✅ Relatório JSON salvo em: {output_path.relative_to(WORKSPACE_ROOT)}")
    else:
        # Salva no diretório padrão
        default_output = project_dir / "findings" / "pqaudit" / "pqr_score.json"
        default_output.parent.mkdir(parents=True, exist_ok=True)
        default_output.write_text(json.dumps(output, indent=2, ensure_ascii=False), encoding="utf-8")
        print(f"✅ Relatório JSON salvo em: {default_output.relative_to(WORKSPACE_ROOT)}")
    
    # --- Saída Markdown ---
    md_report = generate_markdown_report(args.project, algo_findings, hash_findings, key_findings, pqr_result)
    
    if args.markdown:
        md_path = project_dir / args.markdown
        md_path.parent.mkdir(parents=True, exist_ok=True)
        md_path.write_text(md_report, encoding="utf-8")
        print(f"✅ Relatório Markdown salvo em: {md_path.relative_to(WORKSPACE_ROOT)}")
    else:
        default_md = project_dir / "findings" / "pqaudit" / "pqr_report.md"
        default_md.parent.mkdir(parents=True, exist_ok=True)
        default_md.write_text(md_report, encoding="utf-8")
        print(f"✅ Relatório Markdown salvo em: {default_md.relative_to(WORKSPACE_ROOT)}")
    
    print(f"\n{'='*60}")
    print(f"✅ Scan concluído!")
    print(f"{'='*60}\n")


if __name__ == "__main__":
    main()
