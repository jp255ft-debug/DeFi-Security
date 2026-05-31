#!/bin/bash
# Análise baseada em AST com Aderyn
# Uso: ./run_aderyn.sh NomeDoProjeto

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"

if [ -z "$1" ]; then
    echo "Uso: ./run_aderyn.sh NomeDoProjeto"
    echo "Exemplo: ./run_aderyn.sh MeuProtocolo"
    exit 1
fi

PROJECT_NAME="$1"
SRC_DIR="$WORKSPACE/audits/${PROJECT_NAME}/src"
OUTPUT_DIR="$WORKSPACE/audits/${PROJECT_NAME}/findings/automated"

if [ ! -d "$SRC_DIR" ]; then
    echo "❌ Erro: Diretório $SRC_DIR não encontrado."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "🔍 Executando Aderyn em: $PROJECT_NAME"
echo "   Origem: $SRC_DIR"
echo ""

# Executa Aderyn
aderyn --root "$SRC_DIR" --output "$OUTPUT_DIR/aderyn_report.md"

echo ""
echo "✅ Aderyn concluído!"
echo "   Relatório: $OUTPUT_DIR/aderyn_report.md"
