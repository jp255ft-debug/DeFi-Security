#!/bin/bash
# run_medusa.sh — Fuzzing com Medusa (Trail of Bits)
# Uso: ./run_medusa.sh NomeDoProjeto [--timeout 3600] [--config medusa.yaml] [--contract Contrato.sol]
#
# Medusa: Fuzzer de contratos inteligentes EVM de alta performance.
# Bombardeia contratos com milhares de transações aleatórias,
# tentando quebrar invariantes e encontrar bugs de lógica complexa,
# reentrância sutil, manipulação de estado e condições de corrida.
#
# Complementa o Foundry com testes dinâmicos agressivos.
# Encontra bugs que ferramentas estáticas (Slither, Aderyn) não detectam.
#
# Instalação:
#   go install github.com/crytic/medusa/cmd/medusa@latest
#
# Ou via Docker:
#   docker pull trailofbits/medusa
#
# Funciona com projetos Foundry (foundry.toml).
# Medusa gera e executa transações aleatórias contra os contratos,
# monitorando cobertura e detectando falhas.

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"

PROJECT_NAME="$1"
shift || true
TIMEOUT=3600
CONFIG_FILE=""
CONTRACT_FILTER=""

# Parse argumentos opcionais
while [[ $# -gt 0 ]]; do
    case "$1" in
        --timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        --config)
            CONFIG_FILE="$2"
            shift 2
            ;;
        --contract)
            CONTRACT_FILTER="$2"
            shift 2
            ;;
        *)
            echo "❌ Argumento desconhecido: $1"
            echo "Uso: ./run_medusa.sh NomeDoProjeto [--timeout 3600] [--config medusa.yaml] [--contract Contrato.sol]"
            exit 1
            ;;
    esac
done

if [ -z "$PROJECT_NAME" ]; then
    echo "Uso: ./run_medusa.sh NomeDoProjeto [--timeout 3600] [--config medusa.yaml] [--contract Contrato.sol]"
    echo ""
    echo "Exemplos:"
    echo "  ./run_medusa.sh MeuProtocolo"
    echo "  ./run_medusa.sh MeuProtocolo --timeout 7200"
    echo "  ./run_medusa.sh MeuProtocolo --config medusa.yaml"
    echo "  ./run_medusa.sh MeuProtocolo --contract LendingPool"
    echo ""
    echo "Medusa: Fuzzer EVM da Trail of Bits."
    echo "Gera transacoes aleatorias para encontrar bugs de logica complexa."
    echo ""
    echo "Instalacao: go install github.com/crytic/medusa/cmd/medusa@latest"
    exit 1
fi

POC_DIR="$WORKSPACE/audits/${PROJECT_NAME}/poc"
OUTPUT_DIR="$WORKSPACE/audits/${PROJECT_NAME}/findings/automated"

if [ ! -d "$POC_DIR" ]; then
    echo "❌ Projeto não encontrado em $POC_DIR"
    echo "   Certifique-se de que o diretório audits/${PROJECT_NAME}/poc/ existe."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "🦠 Executando Medusa em: $PROJECT_NAME"
echo "   Diretório: $POC_DIR"
echo "   Timeout: ${TIMEOUT}s"
[ -n "$CONTRACT_FILTER" ] && echo "   Contrato: $CONTRACT_FILTER"
[ -n "$CONFIG_FILE" ] && echo "   Config: $CONFIG_FILE"
echo ""

# Verifica se o Medusa está instalado
if ! command -v medusa &> /dev/null; then
    echo "⚠️  Medusa não encontrado. Tentando via Docker..."
    echo ""
    
    if ! command -v docker &> /dev/null; then
        echo "❌ Docker também não encontrado."
        echo "   Instale o Medusa: go install github.com/crytic/medusa/cmd/medusa@latest"
        echo "   Ou baixe o binário: https://github.com/crytic/medusa/releases"
        exit 1
    fi
    
    # Monta argumentos para Docker
    DOCKER_ARGS="fuzz --target /poc --timeout $TIMEOUT"
    [ -n "$CONTRACT_FILTER" ] && DOCKER_ARGS="$DOCKER_ARGS --contract $CONTRACT_FILTER"
    [ -n "$CONFIG_FILE" ] && DOCKER_ARGS="$DOCKER_ARGS --config /poc/$CONFIG_FILE"
    
    echo "🐳 Executando via Docker..."
    docker run --rm -v "$(pwd)/${POC_DIR}:/poc" trailofbits/medusa \
        $DOCKER_ARGS \
        2>&1 | tee "$OUTPUT_DIR/medusa_report.txt"
else
    # Monta argumentos para execução local
    MEDUSA_ARGS="fuzz --target \"$POC_DIR\" --timeout $TIMEOUT"
    [ -n "$CONTRACT_FILTER" ] && MEDUSA_ARGS="$MEDUSA_ARGS --contract $CONTRACT_FILTER"
    [ -n "$CONFIG_FILE" ] && MEDUSA_ARGS="$MEDUSA_ARGS --config \"$POC_DIR/$CONFIG_FILE\""
    
    echo "🖥️  Executando localmente..."
    echo "   Comando: medusa $MEDUSA_ARGS"
    echo ""
    
    # Executa localmente
    eval medusa $MEDUSA_ARGS \
        2>&1 | tee "$OUTPUT_DIR/medusa_report.txt"
fi

echo ""
echo "✅ Medusa concluído!"
echo "   Relatório: $OUTPUT_DIR/medusa_report.txt"
echo ""

# Extrai resumo
echo "📊 Resumo:"
grep -E "(crashes|coverage|transactions|sequences|FAIL|PASS|Unique|Total|completed)" "$OUTPUT_DIR/medusa_report.txt" 2>/dev/null || echo "   (sem dados estruturados)"
echo ""

# Se encontrou crashes, avisa
if grep -qi "crash\|fail\|error" "$OUTPUT_DIR/medusa_report.txt" 2>/dev/null; then
    echo "⚠️  ATENÇÃO: Medusa detectou possíveis problemas!"
    echo "   Revise o relatório completo em: $OUTPUT_DIR/medusa_report.txt"
    echo "   Crashes/erros indicam potenciais vulnerabilidades."
fi
