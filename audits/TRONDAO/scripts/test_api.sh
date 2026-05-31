#!/bin/bash
# ============================================================
# Script: test_api.sh
# Função: Testar endpoints da API TRON para validação manual
# Uso:    bash scripts/test_api.sh <endpoint>
# Exemplo: bash scripts/test_api.sh wallet/getaccount
# ============================================================

TRON_NODE="https://api.trongrid.io"
ENDPOINT="${1:-wallet/getaccount}"

echo "🔍 Testando endpoint: $ENDPOINT"
echo "=========================================="

case "$ENDPOINT" in
    "wallet/getaccount")
        echo "Testando consulta de conta..."
        curl -s -X POST "${TRON_NODE}/wallet/getaccount" \
            -H "Content-Type: application/json" \
            -d '{"address": "T9yD14Nj9j7xAB4dbGeiX9h8unkKHxuWwb"}' | python -m json.tool
        ;;
    "wallet/getnowblock")
        echo "Obtendo bloco atual..."
        curl -s -X POST "${TRON_NODE}/wallet/getnowblock" \
            -H "Content-Type: application/json" | python -m json.tool
        ;;
    "wallet/createtransaction")
        echo "Testando criação de transação (validação de entrada)..."
        curl -s -X POST "${TRON_NODE}/wallet/createtransaction" \
            -H "Content-Type: application/json" \
            -d '{"owner_address": "41e552f6487585c2b58bc2c9bb4492bc1f17132cd0", "to_address": "41e552f6487585c2b58bc2c9bb4492bc1f17132cd0", "amount": 0}' | python -m json.tool
        ;;
    "wallet/broadcasttransaction")
        echo "Testando broadcast de transação (validação de assinatura)..."
        curl -s -X POST "${TRON_NODE}/wallet/broadcasttransaction" \
            -H "Content-Type: application/json" \
            -d '{"transaction": {"raw_data": {"contract": []}}}' | python -m json.tool
        ;;
    *)
        echo "Enviando requisição genérica para: $ENDPOINT"
        curl -s -X POST "${TRON_NODE}/${ENDPOINT}" \
            -H "Content-Type: application/json" \
            -d '{}' | python -m json.tool
        ;;
esac

echo ""
echo "✅ Teste concluído para: $ENDPOINT"
