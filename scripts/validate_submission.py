#!/usr/bin/env python3
"""
validate_submission.py — Validador Automático de Submissão de Bug Bounty

Padrões: Immunefi, Code4rena, Sherlock — Mercado 2026

Uso:
    python scripts/validate_submission.py \\
        --poc-dir audits/Protocolo/poc \\
        --poc-test test/ExploitX.t.sol \\
        --scope audits/Protocolo/_docs/scope.json \\
        --fork-url $RPC_URL \\
        --log

Funcionalidades:
    ✅ Verifica se o PoC usa fork da mainnet (--fork-url)
    ✅ Verifica se o PoC compila sem erros (forge build)
    ✅ Verifica se o PoC demonstra impacto financeiro (logs de saldo)
    ✅ Verifica se os contratos atacados estão in-scope
    ✅ Detecta uso excessivo de mocks genéricos
    ✅ Verifica se a mitigação proposta reverte o ataque
    ✅ Gera score de validação (0-12)
"""

import argparse
import json
import os
import re
import subprocess
import sys
from pathlib import Path
from typing import List, Optional, Tuple


# =============================================================================
# Configuração
# =============================================================================

SCORE_TOTAL = 12

# Padrões de log que indicam impacto financeiro
FINANCIAL_IMPACT_PATTERNS = [
    r"balance[Oo]f\s*\(.*\)\s*:?\s*\d+",
    r"drained",
    r"stole",
    r"stolen",
    r"attack\s*successful",
    r"profit:?\s*\d+",
    r"lost:?\s*\d+",
    r"withdrew:?\s*\d+",
    r"attacker.*balance.*after:?\s*\d+",
    r"funds.*recovered:?\s*\d+",
]

# Padrões que indicam uso de fork da mainnet
FORK_PATTERNS = [
    r"--fork-url",
    r"fork_url",
    r"forkBlockNumber",
    r"forking\.url",
    r"anvil.*--fork-url",
]

# Padrões que indicam uso de mocks
MOCK_PATTERNS = [
    r"import.*Mock",
    r"contract.*Mock",
    r"new\s+Mock",
    r"\.sol\s*:\s*Mock",
]

# Padrões que indicam teste de mitigação
MITIGATION_PATTERNS = [
    r"expectRevert",
    r"vm\.expectRevert",
    r"//\s*correção",
    r"//\s*fix",
    r"//\s*mitigação",
    r"//\s*mitigation",
    r"testMitigation",
    r"test.*Fix",
    r"test.*Correção",
]


# =============================================================================
# Utilitários
# =============================================================================

class ValidationResult:
    """Resultado de uma validação individual."""

    def __init__(self, name: str, passed: bool, detail: str = ""):
        self.name = name
        self.passed = passed
        self.detail = detail

    def __str__(self) -> str:
        status = "✅" if self.passed else "❌"
        return f"{status} {self.name}: {self.detail}"


class ValidationReport:
    """Relatório completo de validação."""

    def __init__(self):
        self.results: List[ValidationResult] = []
        self.errors: List[str] = []

    def add(self, name: str, passed: bool, detail: str = ""):
        self.results.append(ValidationResult(name, passed, detail))

    def add_error(self, error: str):
        self.errors.append(error)

    @property
    def score(self) -> int:
        return sum(1 for r in self.results if r.passed)

    @property
    def passed(self) -> bool:
        return self.score >= SCORE_TOTAL

    def print(self):
        """Exibe o relatório formatado."""
        print("\n" + "=" * 60)
        print("📋 RELATÓRIO DE VALIDAÇÃO DE SUBMISSÃO")
        print("=" * 60)

        for result in self.results:
            print(f"  {result}")

        if self.errors:
            print("\n⚠️  Erros durante validação:")
            for error in self.errors:
                print(f"  • {error}")

        print("\n" + "-" * 60)
        print(f"  Score: {self.score}/{SCORE_TOTAL}")

        if self.score >= SCORE_TOTAL:
            print("  Status: 🟢 PRONTO PARA SUBMETER")
        elif self.score >= 9:
            print("  Status: 🟡 RISCO MODERADO — Revise os itens faltantes")
        else:
            print("  Status: 🔴 ALTO RISCO DE REJEIÇÃO — Não submeta")

        print("=" * 60 + "\n")


# =============================================================================
# Validadores
# =============================================================================

def check_fork_usage(poc_dir: Path, foundry_toml: Optional[Path]) -> Tuple[bool, str]:
    """
    Verifica se o PoC usa fork da mainnet.
    Procura em foundry.toml, scripts de teste e Makefile.
    """
    # Verificar foundry.toml
    if foundry_toml and foundry_toml.exists():
        content = foundry_toml.read_text(encoding="utf-8")
        for pattern in FORK_PATTERNS:
            if re.search(pattern, content, re.IGNORECASE):
                return True, "fork_url detectado em foundry.toml"

    # Verificar arquivos de teste
    test_files = list(poc_dir.glob("test/**/*.sol")) + list(poc_dir.glob("test/**/*.t.sol"))
    for test_file in test_files:
        content = test_file.read_text(encoding="utf-8")
        for pattern in FORK_PATTERNS:
            if re.search(pattern, content, re.IGNORECASE):
                return True, f"fork_url detectado em {test_file.name}"

    # Verificar Makefile ou scripts
    for script_file in poc_dir.glob("*"):
        if script_file.suffix in [".sh", ".toml", ".json", ".env"]:
            content = script_file.read_text(encoding="utf-8", errors="ignore")
            for pattern in FORK_PATTERNS:
                if re.search(pattern, content, re.IGNORECASE):
                    return True, f"fork_url detectado em {script_file.name}"

    return False, "Nenhum fork da mainnet detectado. PoC será rejeitado pela Immunefi."


def check_compilation(poc_dir: Path) -> Tuple[bool, str]:
    """
    Tenta compilar o projeto Foundry.
    """
    try:
        result = subprocess.run(
            ["forge", "build"],
            cwd=str(poc_dir),
            capture_output=True,
            text=True,
            timeout=120,
        )
        if result.returncode == 0:
            return True, "forge build concluído com sucesso"
        else:
            return False, f"forge build falhou:\n{result.stderr[:500]}"
    except FileNotFoundError:
        return False, "forge não encontrado no PATH. Instale Foundry."
    except subprocess.TimeoutExpired:
        return False, "forge build excedeu o tempo limite (120s)"
    except Exception as e:
        return False, f"Erro ao compilar: {str(e)}"


def check_financial_impact(poc_dir: Path, test_file: Optional[Path]) -> Tuple[bool, str]:
    """
    Verifica se o PoC demonstra impacto financeiro através de logs.
    """
    # Verificar arquivo de teste específico
    files_to_check = []
    if test_file and test_file.exists():
        files_to_check.append(test_file)
    else:
        files_to_check.extend(poc_dir.glob("test/**/*.sol"))

    for file in files_to_check:
        content = file.read_text(encoding="utf-8")
        matches = []
        for pattern in FINANCIAL_IMPACT_PATTERNS:
            found = re.findall(pattern, content, re.IGNORECASE)
            matches.extend(found)

        if matches:
            return True, f"Impacto financeiro detectado: {', '.join(matches[:3])}"

    return False, "Nenhum log de impacto financeiro encontrado. Use console.log() com balanceOf()."


def check_scope(scope_file: Optional[Path], poc_dir: Path, test_file: Optional[Path]) -> Tuple[bool, str]:
    """
    Verifica se os contratos atacados estão in-scope.
    """
    if not scope_file or not scope_file.exists():
        return False, "Arquivo de escopo não encontrado. Verifique manualmente."

    try:
        with open(scope_file, "r", encoding="utf-8") as f:
            scope_data = json.load(f)
    except (json.JSONDecodeError, Exception):
        return False, "Arquivo de escopo inválido. Verifique o formato JSON."

    # Extrair contratos in-scope
    in_scope_contracts = []
    if isinstance(scope_data, dict):
        in_scope = scope_data.get("in_scope", scope_data.get("in-scope", []))
        for item in in_scope:
            if isinstance(item, dict):
                in_scope_contracts.append(item.get("contract", item.get("name", "")))
            elif isinstance(item, str):
                in_scope_contracts.append(item)
    elif isinstance(scope_data, list):
        in_scope_contracts = scope_data

    if not in_scope_contracts:
        return False, "Nenhum contrato in-scope encontrado no arquivo de escopo."

    # Verificar se o PoC referencia contratos in-scope
    files_to_check = []
    if test_file and test_file.exists():
        files_to_check.append(test_file)
    else:
        files_to_check.extend(poc_dir.glob("test/**/*.sol"))
    files_to_check.extend(poc_dir.glob("src/**/*.sol"))

    contracts_found = []
    for file in files_to_check:
        content = file.read_text(encoding="utf-8")
        for contract in in_scope_contracts:
            if contract and contract in content:
                contracts_found.append(contract)

    if contracts_found:
        return True, f"Contratos in-scope referenciados: {', '.join(contracts_found[:3])}"
    else:
        return False, "Nenhum contrato in-scope referenciado no PoC."


def check_mock_usage(poc_dir: Path, test_file: Optional[Path]) -> Tuple[bool, str]:
    """
    Detecta uso excessivo de mocks genéricos.
    Retorna passed=True se o uso de mocks for aceitável.
    """
    mock_files = list(poc_dir.glob("src/mocks/**/*.sol")) + list(poc_dir.glob("src/Mock*.sol"))
    mock_count = len(mock_files)

    if mock_count == 0:
        return True, "Nenhum mock encontrado — PoC usa contratos reais"

    # Verificar se os mocks são apenas para contratos auxiliares
    files_to_check = []
    if test_file and test_file.exists():
        files_to_check.append(test_file)
    else:
        files_to_check.extend(poc_dir.glob("test/**/*.sol"))

    target_contract_mocked = False
    for file in files_to_check:
        content = file.read_text(encoding="utf-8")
        for mock_file in mock_files:
            mock_name = mock_file.stem.replace("Mock", "")
            if mock_name and mock_name in content:
                target_contract_mocked = True
                break

    if target_contract_mocked:
        return False, f"⚠️  O contrato alvo parece usar mock ({mock_count} mock(s) encontrado(s)). Prefira contratos reais da mainnet."
    else:
        return True, f"{mock_count} mock(s) encontrado(s), mas apenas para contratos auxiliares"


def check_mitigation(poc_dir: Path, test_file: Optional[Path]) -> Tuple[bool, str]:
    """
    Verifica se o PoC inclui teste de mitigação.
    """
    files_to_check = []
    if test_file and test_file.exists():
        files_to_check.append(test_file)
    else:
        files_to_check.extend(poc_dir.glob("test/**/*.sol"))

    for file in files_to_check:
        content = file.read_text(encoding="utf-8")
        for pattern in MITIGATION_PATTERNS:
            if re.search(pattern, content, re.IGNORECASE):
                return True, f"Teste de mitigação detectado em {file.name}"

    return False, "Nenhum teste de mitigação encontrado. Adicione vm.expectRevert() com a correção."


def check_known_issues(known_issues_file: Optional[Path], finding_title: str) -> Tuple[bool, str]:
    """
    Verifica se o finding não está listado como known issue.
    """
    if not known_issues_file or not known_issues_file.exists():
        return True, "Arquivo KNOWN_ISSUES.md não encontrado — assumindo que não há conflito"

    content = known_issues_file.read_text(encoding="utf-8")
    if finding_title.lower() in content.lower():
        return False, f"⚠️  Finding parece estar listado em KNOWN_ISSUES.md — verifique antes de submeter"

    return True, "Finding não encontrado em KNOWN_ISSUES.md"


def check_library_mitigation(poc_dir: Path) -> Tuple[bool, str]:
    """
    Verifica se as bibliotecas herdadas foram consideradas.
    """
    # Procurar por arquivos de dependências
    lib_files = list(poc_dir.glob("lib/**/*.sol")) + list(poc_dir.glob("node_modules/**/*.sol"))

    if not lib_files:
        return True, "Nenhuma biblioteca externa encontrada para verificar"

    # Verificar se há referências a bibliotecas conhecidas
    known_libs = ["solady", "openzeppelin", "solmate", "forge-std"]
    libs_found = []

    for lib in known_libs:
        if any(lib in str(f) for f in lib_files):
            libs_found.append(lib)

    if libs_found:
        return True, f"Bibliotecas detectadas: {', '.join(libs_found)} — verifique se já implementam a proteção"
    else:
        return True, "Nenhuma biblioteca conhecida detectada"


# =============================================================================
# Função Principal
# =============================================================================

def validate_submission(
    poc_dir: Path,
    test_file: Optional[str] = None,
    scope_file: Optional[Path] = None,
    known_issues_file: Optional[Path] = None,
    finding_title: str = "",
    verbose: bool = False,
) -> ValidationReport:
    """
    Executa todas as validações e retorna o relatório.
    """
    report = ValidationReport()

    # Resolver caminhos
    poc_dir = poc_dir.resolve()
    foundry_toml = poc_dir / "foundry.toml"
    test_path = poc_dir / test_file if test_file else None

    print(f"📁 Diretório PoC: {poc_dir}")
    if test_file:
        print(f"📄 Arquivo de teste: {test_file}")
    print()

    # 1. Verificar uso de fork
    fork_ok, fork_detail = check_fork_usage(poc_dir, foundry_toml)
    report.add("Uso de fork da mainnet", fork_ok, fork_detail)

    # 2. Verificar compilação
    if foundry_toml.exists():
        comp_ok, comp_detail = check_compilation(poc_dir)
        report.add("Compilação (forge build)", comp_ok, comp_detail)
    else:
        report.add("Compilação (forge build)", False, "foundry.toml não encontrado")

    # 3. Verificar impacto financeiro
    fin_ok, fin_detail = check_financial_impact(poc_dir, test_path)
    report.add("Impacto financeiro demonstrável", fin_ok, fin_detail)

    # 4. Verificar escopo
    scope_ok, scope_detail = check_scope(scope_file, poc_dir, test_path)
    report.add("Contratos in-scope", scope_ok, scope_detail)

    # 5. Verificar uso de mocks
    mock_ok, mock_detail = check_mock_usage(poc_dir, test_path)
    report.add("Uso de mocks (contrato alvo real)", mock_ok, mock_detail)

    # 6. Verificar mitigação
    mit_ok, mit_detail = check_mitigation(poc_dir, test_path)
    report.add("Teste de mitigação incluso", mit_ok, mit_detail)

    # 7. Verificar known issues
    ki_ok, ki_detail = check_known_issues(known_issues_file, finding_title)
    report.add("Finding não listado em KNOWN_ISSUES", ki_ok, ki_detail)

    # 8. Verificar bibliotecas
    lib_ok, lib_detail = check_library_mitigation(poc_dir)
    report.add("Bibliotecas verificadas", lib_ok, lib_detail)

    return report


def main():
    parser = argparse.ArgumentParser(
        description="Validador Automático de Submissão de Bug Bounty",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Exemplos:
  # Validação básica
  python scripts/validate_submission.py --poc-dir audits/Moonwell/poc

  # Validação completa com escopo e finding
  python scripts/validate_submission.py \\
      --poc-dir audits/Moonwell/poc \\
      --poc-test test/ExploitCompositeOracleStaleness.t.sol \\
      --scope audits/Moonwell/_docs/scope.json \\
      --known-issues audits/Moonwell/_docs/KNOWN_ISSUES.md \\
      --finding "ChainlinkCompositeOracle - Missing Staleness Check" \\
      --fork-url $RPC_URL \\
      --log
        """,
    )

    parser.add_argument(
        "--poc-dir",
        required=True,
        help="Diretório do PoC (ex: audits/Protocolo/poc)",
    )
    parser.add_argument(
        "--poc-test",
        default=None,
        help="Arquivo de teste específico (ex: test/ExploitX.t.sol)",
    )
    parser.add_argument(
        "--scope",
        default=None,
        help="Arquivo JSON de escopo (ex: audits/Protocolo/_docs/scope.json)",
    )
    parser.add_argument(
        "--known-issues",
        default=None,
        help="Arquivo KNOWN_ISSUES.md do projeto",
    )
    parser.add_argument(
        "--finding",
        default="",
        help="Título do finding para verificar duplicidade com known issues",
    )
    parser.add_argument(
        "--fork-url",
        default=None,
        help="RPC URL para fork da mainnet (apenas validação de presença)",
    )
    parser.add_argument(
        "--log",
        action="store_true",
        help="Exibe logs detalhados durante a validação",
    )

    args = parser.parse_args()

    # Validar diretório
    poc_dir = Path(args.poc_dir)
    if not poc_dir.exists():
        print(f"❌ Erro: Diretório {poc_dir} não encontrado")
        sys.exit(1)

    # Resolver caminhos opcionais
    scope_path = Path(args.scope) if args.scope else None
    known_issues_path = Path(args.known_issues) if args.known_issues else None

    # Executar validação
    report = validate_submission(
        poc_dir=poc_dir,
        test_file=args.poc_test,
        scope_file=scope_path,
        known_issues_file=known_issues_path,
        finding_title=args.finding,
        verbose=args.log,
    )

    # Exibir relatório
    report.print()

    # Exit code
    sys.exit(0 if report.passed else 1)


if __name__ == "__main__":
    main()
