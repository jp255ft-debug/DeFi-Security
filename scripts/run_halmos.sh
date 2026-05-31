#!/bin/bash
# run_halmos.sh — Prova Formal com Halmos
# Uso: ./run_halmos.sh NomeDoProjeto [--contract Contrato.sol]
#
# Halmos: Provador simbólico da a16z que usa sintaxe Foundry.
# Prova MATEMATICAMENTE que NÃO EXISTEM certas classes de bugs.
#
# Diferente de fuzzing (que encontra bugs existentes),
# Halmos prova a AUSÊNCIA de bugs em caminhos específicos.
#
# Instalação:
#   pip install halmos
#
# Funciona com testes Foundry existentes (test_*).
# Halmos executa os testes SIMBOLICAMENTE, explorando TODOS os
# caminhos possíveis dentro de limites configuráveis.

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"

PROJECT_NAME="$1"
CONTRACT_FILTER="${2:-*}"

if [ -z "$PROJECT_NAME" ]; then
    echo "Uso: ./run_halmos.sh NomeDoProjeto [--contract Contrato.sol]"
    echo "Exemplo: ./run_halmos.sh MeuProtocolo --contract LendingPool"
    echo ""
    echo "Halmos: Provador simbólico que usa sintaxe Foundry."
    echo "Prova matematicamente que NÃO EXISTEM certas classes de bugs."
    echo ""
    echo "Pré-requisitos:"
    echo "  pip install halmos"
    echo ""
    echo "O Halmos executa testes Foundry SIMBOLICAMENTE,"
    echo "explorando TODOS os caminhos possíveis."
    exit 1
fi

POC_DIR="$WORKSPACE/audits/${PROJECT_NAME}/poc"
OUTPUT_DIR="$WORKSPACE/audits/${PROJECT_NAME}/findings/automated"

mkdir -p "$OUTPUT_DIR"

echo "🧮 Executando Halmos em: $PROJECT_NAME"
echo "   Contrato: ${CONTRACT_FILTER:-todos}"
echo ""

# Verifica se o Halmos está instalado
if ! command -v halmos &> /dev/null; then
    echo "⚠️  Halmos não encontrado."
    echo "   Instale com: pip install halmos"
    echo ""
    echo "   Ou via源码:"
    echo "   git clone https://github.com/a16z/halmos"
    echo "   cd halmos && pip install -e ."
    exit 1
fi

cd "$POC_DIR"

# Halmos executa testes simbólicos baseados nos Foundry tests
# Opções:
#   --match-contract: Filtro de contrato
#   --symbolic-storage: Número de slots de storage simbólicos
#   --number-of-transactions: Número de transações simbólicas
#   --loop: Número máximo de iterações de loop
#   --print-steps: Mostra passos da execução simbólica

echo "🧮 Configuração:"
echo "   - symbolic-storage: 1"
echo "   - number-of-transactions: 5"
echo "   - match-contract: ${CONTRACT_FILTER}"
echo ""

halmos \
    --match-contract "$CONTRACT_FILTER" \
    --symbolic-storage 1 \
    --number-of-transactions 5 \
    --loop 2 \
    2>&1 | tee "$OUTPUT_DIR/halmos_report.txt"

echo ""
echo "✅ Halmos concluído!"
echo "   Relatório: $OUTPUT_DIR/halmos_report.txt"
echo ""

# Extrai resumo
echo "📊 Resumo:"
grep -E "(PASS|FAIL|Counterexample|paths|bounds)" "$OUTPUT_DIR/halmos_report.txt" 2>/dev/null || echo "   (sem dados estruturados)"
echo ""

# Se encontrou contra-exemplos, avisa
if grep -q "FAIL" "$OUTPUT_DIR/halmos_report.txt" 2>/dev/null; then
    echo "⚠️  ATENÇÃO: Halmos encontrou contra-exemplos!"
    echo "   Revise o relatório completo em: $OUTPUT_DIR/halmos_report.txt"
    echo "   Contra-exemplos indicam que a propriedade NÃO é válida."
fi
