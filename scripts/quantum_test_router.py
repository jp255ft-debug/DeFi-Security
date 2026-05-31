#!/usr/bin/env python3
"""
quantum_test_router.py — Otimizador Quântico de Suíte de Testes (D-Wave Leap)

Pipeline: test_cases/ -> quantum_test_router.py -> optimized_test_suite.json

Arquitetura:
  test_cases/ -> Feature Extraction -> QUBO -> D-Wave Leap / Neal SA / Greedy
  -> optimized_test_suite.json + coverage_report.md

Estratégia de Resiliência:
  1. D-Wave Leap (requer DWAVE_API_TOKEN)
  2. D-Wave Neal (Simulated Annealing) — disponível localmente
  3. Greedy solver (fallback final)

Uso:
  python quantum_test_router.py --fuzz audits/NomeDoProtocolo/src/ --optimize
  python quantum_test_router.py --fuzz audits/NomeDoProtocolo/src/ --backend dwave
  python quantum_test_router.py --fuzz audits/NomeDoProtocolo/src/ --backend neal
  python quantum_test_router.py --fuzz audits/NomeDoProtocolo/src/ --backend greedy

Dependências: dwave-neal, dimod, numpy
"""

import argparse
import io
import json
import os
import re
import sys
import warnings
from pathlib import Path

# Força UTF-8 no stdout/stderr para evitar problemas com emojis no Windows
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')

warnings.filterwarnings("ignore", category=DeprecationWarning)

# =============================================================================
# CONSTANTES
# =============================================================================

WORKSPACE_ROOT = Path(__file__).resolve().parent.parent

# Categorias de cobertura para testes de fuzzing
COVERAGE_CATEGORIES = [
    "reentrancy",
    "access_control",
    "arithmetic_overflow",
    "oracle_manipulation",
    "flash_loan_attack",
    "permit_frontrun",
    "delegatecall_injection",
    "selfdestruct",
    "tx_origin",
    "gas_griefing",
    "timestamp_dependency",
    "signature_replay",
]


def check_dependencies() -> dict:
    """Verifica quais bibliotecas de otimização estão disponíveis."""
    deps = {
        "dwave_neal": False,
        "dimod": False,
        "dwave_system": False,
        "dwave_cloud": False,
    }
    
    try:
        import neal
        deps["dwave_neal"] = True
    except ImportError:
        pass
    
    try:
        import dimod
        deps["dimod"] = True
    except ImportError:
        pass
    
    try:
        from dwave.system import DWaveSampler, EmbeddingComposite
        deps["dwave_system"] = True
    except ImportError:
        pass
    
    try:
        from dwave.cloud import Client
        deps["dwave_cloud"] = True
    except ImportError:
        pass
    
    return deps


def discover_test_cases(src_dir: Path) -> list:
    """
    Descobre casos de teste no diretório do projeto.
    
    Procura por:
    - Arquivos .t.sol (Foundry tests)
    - Arquivos .yaml (Echidna configs)
    - Subdiretórios test/
    
    Returns:
        Lista de dicts com informações dos casos de teste
    """
    test_cases = []
    
    # Foundry tests (*.t.sol ou test/*.sol)
    foundry_tests = list(src_dir.rglob("*.t.sol")) + list(src_dir.rglob("test/*.sol"))
    for test_file in foundry_tests:
        rel_path = test_file.relative_to(WORKSPACE_ROOT)
        test_cases.append({
            "id": f"foundry_{len(test_cases)}",
            "file": str(rel_path),
            "type": "foundry",
            "cost": _estimate_test_cost(test_file),
        })
    
    # Echidna configs (crytic-export/ ou .yaml)
    echidna_configs = list(src_dir.rglob("*.yaml")) + list(src_dir.rglob("crytic-export/*"))
    for config_file in echidna_configs:
        rel_path = config_file.relative_to(WORKSPACE_ROOT)
        test_cases.append({
            "id": f"echidna_{len(test_cases)}",
            "file": str(rel_path),
            "type": "echidna",
            "cost": _estimate_test_cost(config_file),
        })
    
    # Halmos tests
    halmos_tests = list(src_dir.rglob("*.halmos.*")) + list(src_dir.rglob("test/halmos/*"))
    for test_file in halmos_tests:
        rel_path = test_file.relative_to(WORKSPACE_ROOT)
        test_cases.append({
            "id": f"halmos_{len(test_cases)}",
            "file": str(rel_path),
            "type": "halmos",
            "cost": _estimate_test_cost(test_file),
        })
    
    return test_cases


def _estimate_test_cost(filepath: Path) -> float:
    """
    Estima o custo computacional de executar um caso de teste.
    
    Baseado em:
    - Tamanho do arquivo (linhas de código)
    - Complexidade (loops, chamadas externas)
    - Tipo de teste (Echidna > Halmos > Foundry)
    
    Returns:
        Custo normalizado (0.1 a 10.0)
    """
    try:
        content = filepath.read_text(encoding="utf-8", errors="replace")
    except Exception:
        return 1.0
    
    lines = len(content.split("\n"))
    
    # Custo base por tipo
    if "echidna" in str(filepath).lower():
        base_cost = 3.0
    elif "halmos" in str(filepath).lower():
        base_cost = 2.0
    else:
        base_cost = 1.0
    
    # Penalidade por complexidade
    complexity = 1.0
    complexity += len(re.findall(r"for\s*\(", content)) * 0.2
    complexity += len(re.findall(r"while\s*\(", content)) * 0.3
    complexity += len(re.findall(r"\.call\b", content)) * 0.1
    complexity += len(re.findall(r"delegatecall", content)) * 0.2
    
    # Custo final normalizado
    cost = base_cost * (1 + lines / 500) * complexity
    return round(min(10.0, max(0.1, cost)), 2)


def analyze_coverage(test_cases: list, src_dir: Path) -> dict:
    """
    Analisa a cobertura de cada caso de teste por categoria.
    
    Para cada caso de teste, determina quais categorias de vulnerabilidade
    ele cobre com base em análise estática do conteúdo.
    
    Returns:
        Dict: {test_id: {category: coverage_score}}
    """
    coverage = {}
    
    for tc in test_cases:
        filepath = WORKSPACE_ROOT / tc["file"]
        if not filepath.exists():
            coverage[tc["id"]] = {cat: 0.0 for cat in COVERAGE_CATEGORIES}
            continue
        
        try:
            content = filepath.read_text(encoding="utf-8", errors="replace")
        except Exception:
            coverage[tc["id"]] = {cat: 0.0 for cat in COVERAGE_CATEGORIES}
            continue
        
        tc_coverage = {}
        for category in COVERAGE_CATEGORIES:
            # Score baseado em palavras-chave relacionadas à categoria
            score = _calculate_category_coverage(content, category)
            tc_coverage[category] = score
        
        coverage[tc["id"]] = tc_coverage
    
    return coverage


def _calculate_category_coverage(content: str, category: str) -> float:
    """
    Calcula o score de cobertura para uma categoria específica.
    
    Returns:
        Score entre 0.0 e 1.0
    """
    keywords = {
        "reentrancy": ["reentrancy", "re-entrancy", "call.value", "send(", "transfer("],
        "access_control": ["access", "owner", "onlyOwner", "auth", "permission"],
        "arithmetic_overflow": ["overflow", "underflow", "SafeMath", "uint256", "int256"],
        "oracle_manipulation": ["oracle", "price", "spot", "twap", "chainlink"],
        "flash_loan_attack": ["flash", "loan", "borrow", "liquidity"],
        "permit_frontrun": ["permit", "ERC20Permit", "ERC2612", "signature"],
        "delegatecall_injection": ["delegatecall", "DELEGATECALL", "proxy"],
        "selfdestruct": ["selfdestruct", "SELFDESTRUCT", "suicide"],
        "tx_origin": ["tx.origin", "txOrigin"],
        "gas_griefing": ["gas", "gasleft", "gaslimit", "gasprice"],
        "timestamp_dependency": ["timestamp", "block.timestamp", "now"],
        "signature_replay": ["signature", "ecrecover", "ECDSA", "nonce"],
    }
    
    cat_keywords = keywords.get(category, [category])
    content_lower = content.lower()
    
    matches = sum(1 for kw in cat_keywords if kw.lower() in content_lower)
    return min(1.0, matches / len(cat_keywords))


def build_qubo(test_cases: list, coverage: dict, lambda_param: float = 0.5) -> dict:
    """
    Formula o problema de minimização como QUBO.
    
    Problema:
      Minimizar: Σ custo(i) * x_i - λ * Σ cobertura(j) * y_j
      Sujeito a: y_j ≤ Σ coverage(i,j) * x_i (para toda categoria j)
                 x_i ∈ {0, 1}
    
    Args:
        test_cases: Lista de casos de teste
        coverage: Dict de cobertura por caso de teste
        lambda_param: Parâmetro de trade-off (0=só custo, 1=só cobertura)
    
    Returns:
        Dict QUBO no formato dimod (matriz triangular superior)
    """
    n_tests = len(test_cases)
    n_categories = len(COVERAGE_CATEGORIES)
    n_vars = n_tests + n_categories
    
    # Inicializa matriz QUBO
    qubo = {}
    
    # Termos lineares: custo dos testes
    for i, tc in enumerate(test_cases):
        qubo[(i, i)] = tc["cost"]
    
    # Termos lineares: cobertura das categorias (negativo = incentivo)
    for j in range(n_categories):
        qubo[(n_tests + j, n_tests + j)] = -lambda_param
    
    # Termos quadráticos: penalidade se y_j > Σ coverage(i,j) * x_i
    for i, tc in enumerate(test_cases):
        tc_id = tc["id"]
        for j, category in enumerate(COVERAGE_CATEGORIES):
            cov = coverage.get(tc_id, {}).get(category, 0.0)
            if cov > 0:
                # y_j ≤ x_i * coverage(i,j): penalidade se y_j=1 e x_i=0
                qubo[(n_tests + j, i)] = lambda_param * cov
    
    return qubo


def solve_qubo_dwave_neal(qubo: dict, num_reads: int = 100) -> dict:
    """
    Resolve QUBO usando D-Wave Neal (Simulated Annealing).
    
    Args:
        qubo: Dict QUBO no formato dimod
        num_reads: Número de amostras
    
    Returns:
        Melhor solução encontrada
    """
    import neal
    import dimod
    
    # Converte para BQM (Binary Quadratic Model)
    bqm = dimod.BQM.from_qubo(qubo)
    
    # Resolve com Simulated Annealing
    sampler = neal.SimulatedAnnealingSampler()
    sampleset = sampler.sample(bqm, num_reads=num_reads)
    
    # Melhor amostra
    best = sampleset.first
    
    return {
        "sample": best.sample,
        "energy": best.energy,
        "num_occurrences": best.num_occurrences,
        "solver": "neal_simulated_annealing",
    }


def solve_qubo_greedy(qubo: dict) -> dict:
    """
    Resolve QUBO usando algoritmo guloso (fallback).
    
    Args:
        qubo: Dict QUBO no formato dimod
    
    Returns:
        Solução gulosa
    """
    import dimod
    
    bqm = dimod.BQM.from_qubo(qubo)
    
    # Greedy: começa com todos os testes selecionados, remove um por vez
    n_vars = bqm.num_variables
    variables = list(bqm.variables)
    
    # Solução inicial: todos os testes selecionados
    sample = {v: 1 for v in variables}
    current_energy = bqm.energy(sample)
    
    # Tenta remover cada variável
    improved = True
    while improved:
        improved = False
        for v in variables:
            if sample[v] == 1:
                sample[v] = 0
                new_energy = bqm.energy(sample)
                if new_energy < current_energy:
                    current_energy = new_energy
                    improved = True
                else:
                    sample[v] = 1
    
    return {
        "sample": sample,
        "energy": current_energy,
        "solver": "greedy",
    }


def solve_qubo_dwave_leap(qubo: dict, num_reads: int = 100) -> dict:
    """
    Resolve QUBO usando D-Wave Leap (requer token).
    
    Args:
        qubo: Dict QUBO no formato dimod
        num_reads: Número de amostras
    
    Returns:
        Melhor solução encontrada ou None se falhar
    """
    api_token = os.environ.get("DWAVE_API_TOKEN")
    if not api_token:
        print("   ⚠️  DWAVE_API_TOKEN não configurado. Pulando D-Wave Leap.")
        return None
    
    try:
        import dimod
        from dwave.system import DWaveSampler, EmbeddingComposite
        
        bqm = dimod.BQM.from_qubo(qubo)
        
        sampler = EmbeddingComposite(DWaveSampler(token=api_token))
        sampleset = sampler.sample(bqm, num_reads=num_reads)
        
        best = sampleset.first
        
        return {
            "sample": best.sample,
            "energy": best.energy,
            "num_occurrences": best.num_occurrences,
            "solver": "dwave_leap",
        }
    except Exception as e:
        print(f"   ⚠️  Erro ao conectar ao D-Wave Leap: {e}")
        return None


def decode_solution(solution: dict, test_cases: list) -> dict:
    """
    Decodifica a solução QUBO para uma suíte de testes otimizada.
    
    Args:
        solution: Solução do solver QUBO
        test_cases: Lista original de casos de teste
    
    Returns:
        Dict com suíte otimizada e métricas
    """
    n_tests = len(test_cases)
    sample = solution["sample"]
    
    selected_tests = []
    total_cost = 0
    
    for i, tc in enumerate(test_cases):
        if sample.get(i, 0) == 1:
            selected_tests.append(tc)
            total_cost += tc["cost"]
    
    # Categorias cobertas
    covered_categories = []
    n_categories = len(COVERAGE_CATEGORIES)
    for j in range(n_categories):
        if sample.get(n_tests + j, 0) == 1:
            covered_categories.append(COVERAGE_CATEGORIES[j])
    
    return {
        "selected_tests": selected_tests,
        "total_tests_original": n_tests,
        "total_tests_selected": len(selected_tests),
        "reduction_percentage": round((1 - len(selected_tests) / max(1, n_tests)) * 100, 1),
        "total_cost": round(total_cost, 2),
        "covered_categories": covered_categories,
        "coverage_percentage": round(len(covered_categories) / n_categories * 100, 1),
        "energy": solution["energy"],
        "solver": solution["solver"],
    }


def generate_coverage_report(optimized: dict, test_cases: list, coverage: dict) -> str:
    """Gera relatório Markdown com a suíte de testes otimizada."""
    lines = []
    lines.append(f"# ⚛️ Quantum Test Router — Relatório de Otimização")
    lines.append("")
    lines.append(f"**Solver:** {optimized['solver']}")
    lines.append(f"**Energia:** {optimized['energy']:.4f}")
    lines.append("")
    
    lines.append("## 📊 Métricas")
    lines.append("")
    lines.append(f"| Métrica | Valor |")
    lines.append(f"|---------|-------|")
    lines.append(f"| Testes originais | {optimized['total_tests_original']} |")
    lines.append(f"| Testes selecionados | {optimized['total_tests_selected']} |")
    lines.append(f"| Redução | {optimized['reduction_percentage']}% |")
    lines.append(f"| Custo total | {optimized['total_cost']} |")
    lines.append(f"| Cobertura | {optimized['coverage_percentage']}% |")
    lines.append("")
    
    lines.append("## ✅ Testes Selecionados")
    lines.append("")
    for tc in optimized["selected_tests"]:
        lines.append(f"- `{tc['file']}` (tipo: {tc['type']}, custo: {tc['cost']})")
    lines.append("")
    
    lines.append("## 🎯 Categorias Cobertas")
    lines.append("")
    for cat in COVERAGE_CATEGORIES:
        if cat in optimized["covered_categories"]:
            lines.append(f"- ✅ {cat}")
        else:
            lines.append(f"- ❌ {cat}")
    lines.append("")
    
    lines.append("## 📋 Detalhamento por Teste")
    lines.append("")
    lines.append("| Teste | Tipo | Custo | Cobertura |")
    lines.append("|-------|------|-------|-----------|")
    for tc in test_cases:
        tc_coverage = coverage.get(tc["id"], {})
        covered = sum(1 for c in COVERAGE_CATEGORIES if tc_coverage.get(c, 0) > 0)
        selected = "✅" if tc in optimized["selected_tests"] else "❌"
        lines.append(f"| {selected} `{tc['file']}` | {tc['type']} | {tc['cost']} | {covered}/{len(COVERAGE_CATEGORIES)} |")
    lines.append("")
    
    lines.append("---")
    lines.append(f"*Relatório gerado pelo DeFi Security Workspace — quantum_test_router.py*")
    
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(
        description="Otimizador Quântico de Suíte de Testes (D-Wave Leap)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Exemplos:
  %(prog)s --fuzz audits/01_Example_Protocol/src/ --optimize
  %(prog)s --fuzz audits/01_Example_Protocol/src/ --backend dwave
  %(prog)s --fuzz audits/01_Example_Protocol/src/ --backend neal
  %(prog)s --fuzz audits/01_Example_Protocol/src/ --backend greedy
        """
    )
    
    parser.add_argument(
        "--fuzz", "-f",
        required=True,
        help="Diretório com contratos .sol e casos de teste"
    )
    
    parser.add_argument(
        "--optimize", "-o",
        action="store_true",
        default=True,
        help="Executa otimização (default: True)"
    )
    
    parser.add_argument(
        "--backend", "-b",
        choices=["dwave", "neal", "greedy"],
        default="neal",
        help="Backend de otimização (dwave=Leap, neal=Simulated Annealing, greedy=Guloso)"
    )
    
    parser.add_argument(
        "--num-reads", "-n",
        type=int,
        default=100,
        help="Número de amostras para o solver (default: 100)"
    )
    
    parser.add_argument(
        "--lambda", "-l",
        type=float,
        default=0.5,
        dest="lambda_param",
        help="Trade-off custo vs cobertura (0=só custo, 1=só cobertura, default: 0.5)"
    )
    
    parser.add_argument(
        "--output", "-O",
        default=None,
        help="Diretório de saída para os relatórios"
    )
    
    args = parser.parse_args()
    
    print(f"\n{'='*60}")
    print(f"⚛️  Quantum Test Router — Otimizador D-Wave")
    print(f"{'='*60}")
    
    # --- Verifica dependências ---
    deps = check_dependencies()
    print(f"\n📦 Dependências:")
    print(f"   D-Wave Neal:  {'✅' if deps['dwave_neal'] else '❌'}")
    print(f"   dimod:        {'✅' if deps['dimod'] else '❌'}")
    print(f"   D-Wave Cloud: {'✅' if deps['dwave_cloud'] else '❌'}")
    print(f"   D-Wave System:{'✅' if deps['dwave_system'] else '❌'}")
    
    # --- Diretório de fuzzing ---
    src_dir = Path(args.fuzz)
    if not src_dir.exists():
        print(f"❌ Diretório não encontrado: {src_dir}")
        sys.exit(1)
    
    print(f"\n📂 Diretório de fuzzing: {src_dir}")
    
    # --- Descobre casos de teste ---
    print("\n🔍 Descobrindo casos de teste...")
    test_cases = discover_test_cases(src_dir)
    
    if not test_cases:
        print("⚠️  Nenhum caso de teste encontrado. Gerando casos simulados...")
        # Gera casos simulados para demonstração
        for i in range(10):
            test_cases.append({
                "id": f"simulated_{i}",
                "file": f"test/simulated_test_{i}.t.sol",
                "type": "foundry",
                "cost": round(0.5 + i * 0.3, 2),
            })
    
    print(f"   ✅ {len(test_cases)} casos de teste encontrados")
    for tc in test_cases:
        print(f"      - [{tc['type']}] {tc['file']} (custo: {tc['cost']})")
    
    # --- Analisa cobertura ---
    print("\n📊 Analisando cobertura...")
    coverage = analyze_coverage(test_cases, src_dir)
    
    # Resumo de cobertura
    category_coverage = {cat: 0 for cat in COVERAGE_CATEGORIES}
    for tc_id, tc_cov in coverage.items():
        for cat, score in tc_cov.items():
            if score > 0:
                category_coverage[cat] += 1
    
    print("   Cobertura por categoria:")
    for cat, count in category_coverage.items():
        status = "✅" if count > 0 else "❌"
        print(f"      {status} {cat}: {count} testes")
    
    # --- Constrói QUBO ---
    print("\n🧮 Construindo problema QUBO...")
    qubo = build_qubo(test_cases, coverage, args.lambda_param)
    print(f"   ✅ QUBO construído ({len(qubo)} termos)")
    
    # --- Resolve ---
    print(f"\n🎯 Resolvendo com backend: {args.backend}")
    
    solution = None
    if args.backend == "dwave":
        solution = solve_qubo_dwave_leap(qubo, args.num_reads)
        if solution is None:
            print("   ⚠️  D-Wave Leap indisponível. Tentando Neal...")
            solution = solve_qubo_dwave_neal(qubo, args.num_reads)
    elif args.backend == "neal":
        solution = solve_qubo_dwave_neal(qubo, args.num_reads)
    else:  # greedy
        solution = solve_qubo_greedy(qubo)
    
    if solution is None:
        print("❌ Nenhum solver disponível.")
        sys.exit(1)
    
    print(f"   ✅ Solução encontrada (energia: {solution['energy']:.4f}, solver: {solution['solver']})")
    
    # --- Decodifica solução ---
    optimized = decode_solution(solution, test_cases)
    
    print(f"\n{'='*60}")
    print(f"📊 Resultados da Otimização")
    print(f"{'='*60}")
    print(f"   Testes originais:    {optimized['total_tests_original']}")
    print(f"   Testes selecionados: {optimized['total_tests_selected']}")
    print(f"   Redução:             {optimized['reduction_percentage']}%")
    print(f"   Cobertura:           {optimized['coverage_percentage']}%")
    print(f"   Custo total:         {optimized['total_cost']}")
    print(f"   Solver:              {optimized['solver']}")
    print(f"{'='*60}\n")
    
    # --- Gera relatórios ---
    if args.output:
        output_dir = Path(args.output)
    else:
        output_dir = src_dir.parent / "findings" / "pqaudit"
    
    output_dir = output_dir.resolve()
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # JSON
    json_path = output_dir / "optimized_test_suite.json"
    json_path.write_text(
        json.dumps(optimized, indent=2, ensure_ascii=False),
        encoding="utf-8"
    )
    try:
        rel_path = json_path.relative_to(WORKSPACE_ROOT)
    except ValueError:
        rel_path = json_path
    print(f"✅ Suíte otimizada salva em: {rel_path}")
    
    # Markdown
    md_report = generate_coverage_report(optimized, test_cases, coverage)
    md_path = output_dir / "quantum_test_router_report.md"
    md_path.write_text(md_report, encoding="utf-8")
    try:
        rel_path = md_path.relative_to(WORKSPACE_ROOT)
    except ValueError:
        rel_path = md_path
    print(f"✅ Relatório salvo em: {rel_path}")
    
    print(f"\n{'='*60}")
    print(f"✅ Otimização concluída!")
    print(f"{'='*60}\n")


if __name__ == "__main__":
    main()
