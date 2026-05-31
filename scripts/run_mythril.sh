#!/bin/bash
# Análise concolica com Mythril
# Uso: ./run_mythril.sh NomeDoProjeto

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"

if [ -z "$1" ]; then
    echo "Uso: ./run_mythril.sh NomeDoProjeto"
    echo "Exemplo: ./run_mythril.sh MeuProtocolo"
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

echo "🔍 Executando Mythril em: $PROJECT_NAME"
echo "   Origem: $SRC_DIR"
echo ""

# Executa Mythril em cada arquivo .sol
for contract in "$SRC_DIR"/*.sol; do
    if [ -f "$contract" ]; then
        basename=$(basename "$contract" .sol)
        echo "   Analisando: $basename"
        mythril analyze "$contract" \
            --solc-json "$OUTPUT_DIR/mythril_${basename}.json" \
            --execution-timeout 120 \
            2>&1 | tee "$OUTPUT_DIR/mythril_${basename}.txt"
    fi
done

echo ""
echo "✅ Mythril concluído!"
echo "   Resultados em: $OUTPUT_DIR/"
