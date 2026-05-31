#!/bin/bash
# Varredura de vulnerabilidades quânticas com pqaudit
# Uso: ./run_pqaudit.sh NomeDoProjeto
# Requer: Node.js + npx (instala pqaudit automaticamente)

set -e

if [ -z "$1" ]; then
    echo "Uso: ./run_pqaudit.sh NomeDoProjeto"
    echo "Exemplo: ./run_pqaudit.sh MeuProtocolo"
    echo ""
    echo "Escaneia contratos em busca de algoritmos vulneráveis à computação quântica:"
    echo "  - RSA, ECDSA, Ed25519"
    echo "  - Gera CBOMs no padrão CycloneDX"
    exit 1
fi

PROJECT_NAME="$1"
SRC_DIR="../audits/${PROJECT_NAME}/src"
OUTPUT_DIR="../audits/${PROJECT_NAME}/findings/automated"

if [ ! -d "$SRC_DIR" ]; then
    echo "❌ Erro: Diretório $SRC_DIR não encontrado."
    echo "   Certifique-se de que o projeto existe e tem contratos em src/"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "🔍 Escaneando algoritmos pós-quânticos vulneráveis em: $PROJECT_NAME"
echo "   Origem: $SRC_DIR"
echo ""

# Executa pqaudit (baixado via npx, sem instalação global)
npx pqaudit "$SRC_DIR" \
    --format json \
    --output "$OUTPUT_DIR/pqaudit_results.json" \
    --severity high \
    --ci

EXIT_CODE=$?

echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ Nenhuma vulnerabilidade quântica crítica encontrada."
else
    echo "🚨 Vulnerabilidades quânticas detectadas. Verifique os resultados."
fi
echo "   Relatório: $OUTPUT_DIR/pqaudit_results.json"
exit $EXIT_CODE
