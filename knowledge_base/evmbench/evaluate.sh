#!/bin/bash
# EVMbench Evaluation Script
# Testa o DeepSeek contra todo o benchmark EVMbench
# Uso: ./evaluate.sh [--model deepseek-r1|deepseek-v3]

set -e

MODEL="${1:-deepseek-r1}"
DATASET_DIR="./dataset"
RESULTS_DIR="./results"
API_ENDPOINT="${DEEPSEEK_API_ENDPOINT:-https://api.deepseek.com/v1}"
API_KEY="${DEEPSEEK_API_KEY}"

if [ -z "$API_KEY" ]; then
    echo "❌ Erro: DEEPSEEK_API_KEY não configurada."
    echo "   Exporte a variável: export DEEPSEEK_API_KEY='sua-chave'"
    exit 1
fi

mkdir -p "$RESULTS_DIR"

echo "=========================================="
echo "  EVMbench Evaluation - Modelo: $MODEL"
echo "=========================================="

total=0
passed=0
failed=0

for contract in "$DATASET_DIR"/contracts/*.sol; do
    total=$((total + 1))
    basename=$(basename "$contract" .sol)
    echo ""
    echo "[$total] Analisando: $basename"
    
    # Lê o contrato e envia para o DeepSeek
    response=$(curl -s -X POST "$API_ENDPOINT/chat/completions" \
        -H "Authorization: Bearer $API_KEY" \
        -H "Content-Type: application/json" \
        -d @- <<EOF
{
    "model": "$MODEL",
    "messages": [
        {"role": "system", "content": "Você é um auditor de segurança DeFi. Analise o contrato abaixo e liste todas as vulnerabilidades encontradas, com severidade e localização."},
        {"role": "user", "content": $(cat "$contract" | jq -Rs .)}
    ],
    "temperature": 0.1
}
EOF
    )
    
    # Salva a resposta
    echo "$response" > "$RESULTS_DIR/${basename}_response.json"
    
    # Compara com o gabarito (simplificado)
    if echo "$response" | grep -qi "vulnerability\|critical\|high\|reentrancy\|access control"; then
        passed=$((passed + 1))
        echo "   ✅ Vulnerabilidade detectada"
    else
        failed=$((failed + 1))
        echo "   ❌ Nenhuma vulnerabilidade detectada"
    fi
done

echo ""
echo "=========================================="
echo "  Resultados Finais"
echo "=========================================="
echo "  Total:    $total"
echo "  Passed:   $passed"
echo "  Failed:   $failed"
echo "  Acurácia: $(echo "scale=2; $passed * 100 / $total" | bc)%"
echo ""
echo "Resultados salvos em: $RESULTS_DIR/"
