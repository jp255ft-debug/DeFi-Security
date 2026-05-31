#!/bin/bash
# ============================================================
# Script: check_eligibility.sh
# Função: Verificar se um programa de bug bounty é elegível
#         para o vetor de ataque que vamos auditar.
# Uso:    bash scripts/check_eligibility.sh
# ============================================================

echo "🔍 Verificação de Elegibilidade do Programa"
echo "=========================================="
echo ""

read -p "O programa lista o contrato alvo no escopo? (s/n): " in_scope
if [ "$in_scope" = "n" ]; then
    echo "❌ Contrato fora do escopo. NÃO auditar."
    exit 1
fi

read -p "O bug depende de admin/owner/role comprometida? (s/n): " depends_on_admin
if [ "$depends_on_admin" = "s" ]; then
    echo "⚠️  Bug depende de admin/role comprometida."
    read -p "O programa exclui EXPLICITAMENTE centralização? (s/n): " excludes_centralization
    if [ "$excludes_centralization" = "s" ]; then
        echo "❌ Programa exclui centralização. NÃO auditar este vetor."
        exit 1
    fi
fi

read -p "O bug é puramente teórico (ex: 'se o modifier for removido')? (s/n): " is_theoretical
if [ "$is_theoretical" = "s" ]; then
    echo "❌ Bug teórico sem PoC explorável no código atual. NÃO auditar."
    exit 1
fi

read -p "O impacto é apenas Denial of Service (DoS)? (s/n): " is_dos
if [ "$is_dos" = "s" ]; then
    echo "⚠️  Impacto é DoS."
    read -p "O programa exclui EXPLICITAMENTE DoS? (s/n): " excludes_dos
    if [ "$excludes_dos" = "s" ]; then
        echo "❌ Programa exclui DoS. NÃO auditar este vetor."
        exit 1
    fi
fi

read -p "O bug depende de oráculo de terceiros? (s/n): " depends_on_oracle
if [ "$depends_on_oracle" = "s" ]; then
    echo "⚠️  Bug depende de oráculo de terceiros."
    read -p "O programa exclui EXPLICITAMENTE dados de oráculos de terceiros? (s/n): " excludes_oracle
    if [ "$excludes_oracle" = "s" ]; then
        echo "❌ Programa exclui oráculos de terceiros. NÃO auditar este vetor."
        exit 1
    fi
fi

echo ""
echo "✅ Programa elegível para este vetor. Prosseguir com a auditoria."
echo "   Comando: bash scripts/init_audit.sh NomeDoPrograma"
