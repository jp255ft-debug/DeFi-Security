#!/bin/bash
# Inicializa a estrutura de um novo projeto de auditoria
# Uso: ./init_audit.sh NomeDoProjeto

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"

if [ -z "$1" ]; then
    echo "Uso: ./init_audit.sh NomeDoProjeto"
    echo "Exemplo: ./init_audit.sh MeuProtocoloDeFi"
    exit 1
fi

PROJECT_NAME="$1"
TEMPLATE_DIR="$WORKSPACE/audits/00_Template_Audit"
TARGET_DIR="$WORKSPACE/audits/${PROJECT_NAME}"

if [ -d "$TARGET_DIR" ]; then
    echo "❌ Erro: O diretório $TARGET_DIR já existe."
    exit 1
fi

echo "🚀 Inicializando auditoria: $PROJECT_NAME"
cp -r "$TEMPLATE_DIR" "$TARGET_DIR"
echo "✅ Projeto criado em: $TARGET_DIR"
echo ""
echo "Próximos passos:"
echo "  1. Copie os contratos para audits/${PROJECT_NAME}/src/"
echo "  2. Adicione a documentação em audits/${PROJECT_NAME}/_docs/"
echo "  3. Execute: ./run_slither.sh ${PROJECT_NAME}"
echo "  4. Execute: ./run_aderyn.sh ${PROJECT_NAME}"
echo "  5. Execute: ./run_mythril.sh ${PROJECT_NAME}"
echo "  6. Execute: ./run_echidna.sh ${PROJECT_NAME}"
echo "  7. Execute: ./run_medusa.sh ${PROJECT_NAME}"
echo "  8. Execute: ./run_simbolik.sh ${PROJECT_NAME} --install --open"
echo "  9. Configure o CI: adicione ${PROJECT_NAME} em .github/workflows/aderyn_ci.yml"
echo " 10. Inicie a análise com IA via Cline"
