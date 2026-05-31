#!/usr/bin/env python3
"""
Submete relatórios de vulnerabilidade para programas via API HackerOne.
Lê os arquivos de findings do workspace e envia cada um como report separado.

Uso:
    python scripts/submit_to_hackerone.py --project CircleUSDCBridge --program circle-bbp --token SEU_TOKEN
    python scripts/submit_to_hackerone.py --project CircleUSDCBridge --program circle-bbp --token SEU_TOKEN --dry-run
    python scripts/submit_to_hackerone.py --project CircleUSDCBridge --program circle-bbp --token SEU_TOKEN --language en --with-pocs
    python scripts/submit_to_hackerone.py --project CircleUSDCBridge --program circle-bbp --token SEU_TOKEN --severity high
    python scripts/submit_to_hackerone.py --project CircleUSDCBridge --program circle-bbp --token SEU_TOKEN --severity high --dry-run
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

try:
    from dotenv import load_dotenv
    load_dotenv()  # Carrega variáveis do .env (se existir)
except ImportError:
    pass  # dotenv é opcional; as variáveis de ambiente do sistema funcionam sem ele

try:
    import requests
except ImportError:
    print("❌ Biblioteca 'requests' não encontrada. Instale com: pip install requests")
    sys.exit(1)

# ============================================================
# CONSTANTES
# ============================================================
WORKSPACE_ROOT = Path(__file__).resolve().parent.parent  # sobe de scripts/ para raiz

# Mapeamento de títulos de findings para CWE IDs
CWE_MAPPING = {
    "replay": "CWE-294",           # Authentication Bypass by Capture-replay
    "overflow": "CWE-190",         # Integer Overflow or Wraparound
    "underflow": "CWE-191",        # Integer Underflow
    "burn": "CWE-252",             # Unchecked Return Value
    "unchecked": "CWE-252",        # Unchecked Return Value
    "access control": "CWE-284",   # Improper Access Control
    "reentrancy": "CWE-362",       # Concurrent Execution using Shared Resource
    "race": "CWE-362",             # Concurrent Execution using Shared Resource
    "concurrent": "CWE-362",       # Concurrent Execution using Shared Resource
    "oracle": "CWE-472",           # External Control of Assumed-Immutable Parameter
    "front running": "CWE-362",    # Concurrent Execution using Shared Resource
    "denial": "CWE-400",           # Uncontrolled Resource Consumption
    "gas": "CWE-1129",             # Gas Optimization (non-security)
    "initialize": "CWE-665",       # Improper Initialization
    "nonce": "CWE-294",            # Authentication Bypass by Capture-replay
    "signature": "CWE-347",        # Improper Verification of Cryptographic Signature
    "finality": "CWE-754",         # Improper Check for Unusual or Exceptional Conditions
}

# Mapeamento de CVSS score para severity string da API
def cvss_to_severity(score):
    if score >= 9.0:
        return "critical"
    elif score >= 7.0:
        return "high"
    elif score >= 4.0:
        return "medium"
    elif score > 0:
        return "low"
    return "none"

# Mapeamento de CVSS score para vector aproximado
def cvss_score_to_vector(score):
    """Gera um CVSS vector aproximado baseado no score."""
    if score >= 9.0:
        return "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H"
    elif score >= 8.0:
        return "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:N"
    elif score >= 7.0:
        return "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:H/A:N"
    elif score >= 6.0:
        return "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:L/A:L"
    elif score >= 4.0:
        return "CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:L/I:L/A:N"
    else:
        return "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:N"


# ============================================================
# PARSER DE FINDINGS
# ============================================================
def parse_findings_from_file(filepath):
    """
    Lê um arquivo de findings (high.md, medium.md, etc.) e extrai
    cada finding individual como um dicionário estruturado.
    
    Formato esperado:
        ### H-01: Título
        
        **Severity:** High (CVSSv3: 8.5)
        **Contract:** `Contrato.sol`
        
        **Descrição:**
        Texto da descrição...
        
        **Código Vulnerável:**
        ```solidity
        ...
        ```
        
        **Impacto:**
        Texto do impacto...
        
        **Mitigação:**
        Texto da mitigação...
    """
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    
    findings = []
    
    # Divide o arquivo em blocos de findings (separados por ---)
    blocks = re.split(r'\n---+\n', content)
    
    for block in blocks:
        block = block.strip()
        if not block:
            continue
        
        # Pula o cabeçalho (primeiras linhas até o primeiro ###)
        if not block.startswith("###"):
            continue
        
        # Extrai ID e título: "### H-01: Título"
        title_match = re.match(r'###\s+([A-Z]-\d+):\s*(.+?)(?:\n|$)', block)
        if not title_match:
            continue
        
        finding_id = title_match.group(1)
        title = title_match.group(2).strip()
        
        # Extrai Severity e CVSS
        severity_match = re.search(r'\*\*Severity:\*\*\s*(.+?)\s*\(CVSSv3:\s*([\d.]+)\)', block)
        severity_text = severity_match.group(1) if severity_match else "Unknown"
        cvss_score = float(severity_match.group(2)) if severity_match else 0.0
        
        # Extrai Contract
        contract_match = re.search(r'\*\*Contract:\*\*\s*(.+?)(?:\n|$)', block)
        contract = contract_match.group(1).strip() if contract_match else ""
        
        # Extrai Function
        function_match = re.search(r'\*\*Function:\*\*\s*(.+?)(?:\n|$)', block)
        function = function_match.group(1).strip() if function_match else ""
        
        # Extrai Descrição (aceita português e inglês)
        desc_match = re.search(
            r'\*\*(?:Descrição|Description):\*\*\s*(.+?)(?=\*\*(?:Código Vulnerável|Vulnerable Code|Impacto|Impact|Mitigação|Recommended Mitigation):|\Z)',
            block, re.DOTALL
        )
        description = desc_match.group(1).strip() if desc_match else ""
        
        # Extrai Código Vulnerável (aceita português e inglês)
        code_match = re.search(
            r'\*\*(?:Código Vulnerável|Vulnerable Code).*?\*\*\s*```solidity\n(.+?)```',
            block, re.DOTALL
        )
        vulnerable_code = code_match.group(1).strip() if code_match else ""
        
        # Extrai Impacto (aceita português e inglês)
        impact_match = re.search(
            r'\*\*(?:Impacto|Impact):\*\*\s*(.+?)(?=\*\*(?:Mitigação|Recommended Mitigation):|\Z)',
            block, re.DOTALL
        )
        impact = impact_match.group(1).strip() if impact_match else ""
        
        # Extrai Mitigação (aceita português e inglês)
        mitigation_match = re.search(
            r'\*\*(?:Mitigação|Recommended Mitigation):\*\*\s*(.+?)(?=\Z)',
            block, re.DOTALL
        )
        mitigation = mitigation_match.group(1).strip() if mitigation_match else ""
        
        # Determina CWE baseado no título e descrição
        cwe = determine_cwe(title, description)
        
        findings.append({
            "id": finding_id,
            "title": title,
            "severity_text": severity_text,
            "cvss_score": cvss_score,
            "contract": contract,
            "function": function,
            "description": description,
            "vulnerable_code": vulnerable_code,
            "impact": impact,
            "mitigation": mitigation,
            "cwe": cwe,
        })
    
    return findings


def determine_cwe(title, description):
    """Determina o CWE ID mais apropriado baseado no título e descrição."""
    text = (title + " " + description).lower()
    
    # Ordena por especificidade (mais específico primeiro)
    keywords = [
        "replay", "nonce", "signature",
        "overflow", "underflow",
        "burn", "unchecked",
        "initialize",
        "finality",
        "access control",
        "reentrancy",
        "race",
        "concurrent",
        "oracle",
        "front running",
        "denial",
    ]
    
    for keyword in keywords:
        if keyword in text:
            return CWE_MAPPING[keyword]
    
    return "CWE-1104"  # Default: Use of Unmaintained Third Party Components


# ============================================================
# FORMATAÇÃO PARA API HACKERONE
# ============================================================
def format_vulnerability_info(finding, language="pt"):
    """
    Formata a descrição completa da vulnerabilidade para o campo
    vulnerability_information da API.
    """
    if language == "en":
        return _format_vulnerability_info_en(finding)
    return _format_vulnerability_info_pt(finding)


def _format_vulnerability_info_pt(finding):
    """Formata em português."""
    parts = []
    
    parts.append(f"## {finding['id']}: {finding['title']}")
    parts.append("")
    
    if finding['contract']:
        parts.append(f"**Contrato:** {finding['contract']}")
    if finding['function']:
        parts.append(f"**Função:** {finding['function']}")
    parts.append(f"**Severidade:** {finding['severity_text']} (CVSSv3: {finding['cvss_score']})")
    parts.append(f"**CWE:** {finding['cwe']}")
    parts.append("")
    
    parts.append("### Descrição")
    parts.append(finding['description'])
    parts.append("")
    
    if finding['vulnerable_code']:
        parts.append("### Código Vulnerável")
        parts.append("```solidity")
        parts.append(finding['vulnerable_code'])
        parts.append("```")
        parts.append("")
    
    parts.append("### Impacto")
    parts.append(finding['impact'])
    parts.append("")
    
    parts.append("### Mitigação Recomendada")
    parts.append(finding['mitigation'])
    parts.append("")
    
    parts.append("---")
    parts.append(f"*Relatório gerado automaticamente pelo DeFi Security Workspace*")
    
    return "\n".join(parts)


def _format_vulnerability_info_en(finding):
    """Formata em inglês."""
    parts = []
    
    parts.append(f"## {finding['id']}: {finding['title']}")
    parts.append("")
    
    if finding['contract']:
        parts.append(f"**Contract:** {finding['contract']}")
    if finding['function']:
        parts.append(f"**Function:** {finding['function']}")
    parts.append(f"**Severity:** {finding['severity_text']} (CVSSv3: {finding['cvss_score']})")
    parts.append(f"**CWE:** {finding['cwe']}")
    parts.append("")
    
    parts.append("### Description")
    parts.append(finding['description'])
    parts.append("")
    
    if finding['vulnerable_code']:
        parts.append("### Vulnerable Code")
        parts.append("```solidity")
        parts.append(finding['vulnerable_code'])
        parts.append("```")
        parts.append("")
    
    parts.append("### Recommended Mitigation")
    parts.append(finding['mitigation'])
    parts.append("")
    
    parts.append("---")
    parts.append(f"*Report automatically generated by DeFi Security Workspace*")
    
    return "\n".join(parts)


def build_payload(finding, program_handle, asset_identifier, language="pt"):
    """
    Monta o payload JSON completo para a API do HackerOne.
    """
    vulnerability_info = format_vulnerability_info(finding, language)
    
    # Extrai apenas o número do CWE (ex: "CWE-294" -> 294)
    cwe_number = finding['cwe'].replace("CWE-", "")
    
    payload = {
        "data": {
            "type": "report",
            "attributes": {
                "title": f"{finding['id']}: {finding['title']}",
                "vulnerability_information": vulnerability_info,
                "impact": finding['impact'] if finding['impact'] else "This vulnerability could lead to loss of funds or unauthorized access to sensitive contract functionality.",
                "weakness_id": int(cwe_number),
                "severity_rating": cvss_to_severity(finding['cvss_score']),
                "cvss_vector": cvss_score_to_vector(finding['cvss_score']),
                "team_handle": program_handle,
                "tags": ["solidity", "evm", "bridge", finding['id'].lower().replace(":", "").replace(" ", "-")],
            }
        }
    }
    return payload


# ============================================================
# ENVIO VIA API
# ============================================================
def submit_report(payload, api_token, username, dry_run=False):
    """
    Envia o relatório via API HackerOne usando Basic Auth (username + token).
    Retorna o response JSON em caso de sucesso.
    """
    if dry_run:
        print("   🏁 [DRY-RUN] Payload seria enviado:")
        print(f"      Título: {payload['data']['attributes']['title'][:80]}...")
        print(f"      Severidade: {payload['data']['attributes']['severity_rating']}")
        print(f"      CWE: {payload['data']['attributes']['weakness_id']}")
        print(f"      CVSS: {payload['data']['attributes']['cvss_vector']}")
        return {"data": {"id": "DRY-RUN", "attributes": {"state": "draft"}}}
    
    url = "https://api.hackerone.com/v1/hackers/reports"
    headers = {
        "Content-Type": "application/json",
        "Accept": "application/json"
    }
    
    try:
        response = requests.post(url, headers=headers, json=payload, timeout=30, auth=(username, api_token))
        if response.status_code == 201:
            print(f"   ✅ Report criado com sucesso! ID: {response.json()['data']['id']}")
            return response.json()
        elif response.status_code == 401:
            print(f"   ❌ Erro de autenticação. Verifique seu token API.")
            print(f"      Resposta: {response.text}")
            return None
        elif response.status_code == 422:
            print(f"   ❌ Erro de validação. Verifique os dados do payload.")
            print(f"      Resposta: {response.text}")
            return None
        else:
            print(f"   ❌ Erro {response.status_code}: {response.text}")
            return None
    except requests.exceptions.ConnectionError:
        print(f"   ❌ Erro de conexão. Verifique sua internet.")
        return None
    except requests.exceptions.Timeout:
        print(f"   ❌ Timeout. A API demorou muito para responder.")
        return None
    except Exception as e:
        print(f"   ❌ Erro inesperado: {e}")
        return None


# ============================================================
# FUNÇÕES AUXILIARES
# ============================================================
def find_finding_files(project_dir):
    """
    Encontra arquivos de findings no diretório do projeto.
    Retorna lista de caminhos absolutos.
    """
    findings_dir = project_dir / "findings"
    if not findings_dir.exists():
        print(f"❌ Diretório de findings não encontrado: {findings_dir}")
        return []
    
    files = []
    # Prioridade: high.md, medium.md, low.md
    for fname in ["high.md", "medium.md", "low.md"]:
        fpath = findings_dir / fname
        if fpath.exists():
            files.append(fpath)
    
    return files


def find_poc_files(project_dir):
    """
    Encontra arquivos de PoC no diretório do projeto.
    Retorna lista de caminhos.
    """
    poc_dir = project_dir / "poc" / "test"
    if not poc_dir.exists():
        return []
    
    return list(poc_dir.glob("*.sol"))


def save_submission_log(project_dir, finding_id, report_id):
    """Salva o ID do report submetido em um arquivo de log."""
    log_file = project_dir / "submitted_reports.txt"
    with open(log_file, "a", encoding="utf-8") as f:
        f.write(f"{finding_id}: {report_id}\n")
    print(f"   📝 Log salvo em: {log_file}")


# ============================================================
# CLI
# ============================================================
def parse_args():
    parser = argparse.ArgumentParser(
        description="Submete findings de auditoria para o HackerOne via API",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Exemplos:
  %(prog)s --project CircleUSDCBridge --program circle-bbp --token SEU_TOKEN
  %(prog)s --project CircleUSDCBridge --program circle-bbp --token SEU_TOKEN --dry-run
  %(prog)s --project CircleUSDCBridge --program circle-bbp --token SEU_TOKEN --language en
  %(prog)s --project CircleUSDCBridge --program circle-bbp --token SEU_TOKEN --with-pocs
        """
    )
    
    parser.add_argument(
        "--project", "-p",
        required=True,
        help="Nome do diretório do projeto em audits/ (ex: CircleUSDCBridge)"
    )
    
    parser.add_argument(
        "--program", "-P",
        required=True,
        help="Handle do programa no HackerOne (ex: circle-bbp)"
    )
    
    parser.add_argument(
        "--token", "-t",
        help="Token da API do HackerOne. Se não fornecido, lê da variável de ambiente HACKERONE_TOKEN"
    )
    
    parser.add_argument(
        "--username", "-u",
        help="Username do HackerOne para autenticação Basic Auth. Se não fornecido, lê da variável de ambiente HACKERONE_USERNAME"
    )
    
    parser.add_argument(
        "--language", "-l",
        choices=["pt", "en"],
        default="pt",
        help="Idioma do relatório (pt=português, en=inglês). Default: pt"
    )
    
    parser.add_argument(
        "--dry-run", "-d",
        action="store_true",
        help="Modo de teste: mostra o que seria enviado sem realmente enviar"
    )
    
    parser.add_argument(
        "--with-pocs",
        action="store_true",
        help="Inclui links para arquivos de PoC no relatório"
    )
    
    parser.add_argument(
        "--severity", "-s",
        choices=["critical", "high", "medium", "low", "none"],
        help="Filtrar findings por severidade mínima (ex: --severity high envia apenas High e Critical)"
    )
    
    parser.add_argument(
        "--asset",
        default="https://github.com/circlefin/evm-cctp-contracts",
        help="Asset identifier (URL do repositório). Default: https://github.com/circlefin/evm-cctp-contracts"
    )
    
    return parser.parse_args()


# ============================================================
# MAIN
# ============================================================
def main():
    args = parse_args()
    
    # --- Token ---
    api_token = args.token or os.environ.get("HACKERONE_TOKEN")
    if not api_token:
        print("❌ Token não fornecido. Use --token ou defina a variável de ambiente HACKERONE_TOKEN.")
        print("   Gere seu token em: https://hackerone.com/settings/api-token")
        sys.exit(1)
    
    # --- Username (para Basic Auth) ---
    username = args.username or os.environ.get("HACKERONE_USERNAME")
    if not username:
        print("❌ Username não fornecido. Use --username ou defina a variável de ambiente HACKERONE_USERNAME.")
        sys.exit(1)
    
    # --- Diretório do projeto ---
    project_dir = WORKSPACE_ROOT / "audits" / args.project
    if not project_dir.exists():
        print(f"❌ Projeto não encontrado: {project_dir}")
        print(f"   Diretórios disponíveis em {WORKSPACE_ROOT / 'audits'}:")
        for d in sorted((WORKSPACE_ROOT / "audits").iterdir()):
            if d.is_dir():
                print(f"     - {d.name}")
        sys.exit(1)
    
    print(f"\n{'='*60}")
    print(f"🔍 DeFi Security Workspace — HackerOne Submitter")
    print(f"{'='*60}")
    print(f"📁 Projeto: {args.project}")
    print(f"🎯 Programa: {args.program}")
    print(f"🌐 Idioma: {'Português' if args.language == 'pt' else 'English'}")
    print(f"🏁 Dry-run: {'Sim' if args.dry_run else 'Não'}")
    print(f"{'='*60}\n")
    
    # --- Encontra arquivos de findings ---
    finding_files = find_finding_files(project_dir)
    if not finding_files:
        print("❌ Nenhum arquivo de finding encontrado.")
        sys.exit(1)
    
    print(f"📄 Arquivos de findings encontrados:")
    for f in finding_files:
        print(f"   - {f.relative_to(WORKSPACE_ROOT)}")
    print()
    
    # --- Encontra PoCs (opcional) ---
    poc_files = find_poc_files(project_dir) if args.with_pocs else []
    if poc_files:
        print(f"🧪 Arquivos de PoC encontrados ({len(poc_files)}):")
        for f in poc_files:
            print(f"   - {f.relative_to(WORKSPACE_ROOT)}")
        print()
    
    # --- Parse findings ---
    all_findings = []
    for fpath in finding_files:
        findings = parse_findings_from_file(fpath)
        all_findings.extend(findings)
        print(f"📊 {fpath.name}: {len(findings)} findings extraídos")
    
    if not all_findings:
        print("❌ Nenhum finding pôde ser extraído dos arquivos.")
        sys.exit(1)
    
    # --- Filtro por severidade ---
    if args.severity:
        severity_order = {"critical": 0, "high": 1, "medium": 2, "low": 3, "none": 4}
        min_level = severity_order.get(args.severity, 0)
        filtered = []
        for f in all_findings:
            f_level = severity_order.get(cvss_to_severity(f['cvss_score']), 4)
            if f_level <= min_level:
                filtered.append(f)
        removed = len(all_findings) - len(filtered)
        all_findings = filtered
        if removed > 0:
            print(f"🔍 Filtro --severity={args.severity}: {removed} findings ignorados (severidade abaixo do mínimo)\n")
    
    print(f"\n📊 Total de findings a submeter: {len(all_findings)}\n")
    
    # --- Submete cada finding ---
    submitted = 0
    failed = 0
    
    for i, finding in enumerate(all_findings, 1):
        print(f"[{i}/{len(all_findings)}] 📤 Enviando {finding['id']}: {finding['title'][:60]}...")
        
        # Adiciona links de PoC se solicitado
        if poc_files:
            poc_links = "\n\n### PoC Files\n"
            for pf in poc_files:
                poc_links += f"- [{pf.name}](file:///{pf.as_posix()})\n"
            finding['description'] += poc_links
        
        payload = build_payload(
            finding,
            args.program,
            args.asset,
            args.language
        )
        
        result = submit_report(payload, api_token, username, args.dry_run)
        
        if result:
            report_id = result['data']['id']
            if not args.dry_run:
                save_submission_log(project_dir, finding['id'], report_id)
            submitted += 1
        else:
            failed += 1
        
        print("-" * 40)
    
    # --- Resumo ---
    print(f"\n{'='*60}")
    print(f"📊 RESUMO")
    print(f"{'='*60}")
    print(f"   Total de findings: {len(all_findings)}")
    print(f"   ✅ Submetidos: {submitted}")
    print(f"   ❌ Falhas: {failed}")
    
    if args.dry_run:
        print(f"\n   🏁 Modo dry-run ativado. Nenhum report foi realmente enviado.")
        print(f"   Remova a flag --dry-run para enviar de verdade.")
    
    if submitted > 0 and not args.dry_run:
        print(f"\n   📝 Log salvo em: {project_dir / 'submitted_reports.txt'}")
        print(f"   🔗 Acompanhe em: https://hackerone.com/reports")
    
    print(f"{'='*60}\n")
    
    if failed > 0:
        sys.exit(1)


if __name__ == "__main__":
    main()
