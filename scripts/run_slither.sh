#!/bin/bash
# Varredura estática com Slither
# Uso: ./run_slither.sh NomeDoProjeto [opcoes]

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"

if [ -z "$1" ]; then
    echo "Uso: ./run_slither.sh NomeDoProjeto [opcoes]"
    echo "Exemplo: ./run_slither.sh MeuProtocolo --print human-summary"
    exit 1
fi

PROJECT_NAME="$1"
shift
SRC_DIR="$WORKSPACE/audits/${PROJECT_NAME}/src"
OUTPUT_DIR="$WORKSPACE/audits/${PROJECT_NAME}/findings/automated"

if [ ! -d "$SRC_DIR" ]; then
    echo "❌ Erro: Diretório $SRC_DIR não encontrado."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "🔍 Executando Slither em: $PROJECT_NAME"
echo "   Origem: $SRC_DIR"
echo ""

# Executa Slither com opções padrão
slither "$SRC_DIR" \
    --print human-summary \
    --print contract-summary \
    --print call-graph \
    --json "$OUTPUT_DIR/slither_report.json" \
    --markdown "$OUTPUT_DIR/slither_report.md" \
    "$@"

echo ""
echo "✅ Slither concluído!"
echo "   Relatório: $OUTPUT_DIR/slither_report.md"
echo "   JSON:      $OUTPUT_DIR/slither_report.json"
