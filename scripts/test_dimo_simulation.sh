#!/bin/bash
# =============================================================================
# Teste de Simulação do DIMO MVP Connector
# =============================================================================
# Este script testa o pipeline DIMO → Sign → Streamr em modo simulação,
# sem necessidade de veículo real ou credenciais DIMO.
#
# Uso:
#   ./scripts/test_dimo_simulation.sh
#   ./scripts/test_dimo_simulation.sh --output meu_teste.json
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONNECTOR_DIR="$PROJECT_DIR/depin/connectors"
OUTPUT_FILE="${1:-dimo_test_output.json}"

echo "============================================"
echo "🚗 DIMO MVP Connector — Teste de Simulação"
echo "============================================"
echo ""

# Verifica se Python está disponível
if ! command -v python &> /dev/null; then
    echo "❌ Python não encontrado. Instale Python 3.10+."
    exit 1
fi

# Verifica se web3 está instalado
if ! python -c "import web3" 2>/dev/null; then
    echo "⚠️  web3.py não encontrado. Instalando dependências..."
    pip install -r "$PROJECT_DIR/requirements_depin.txt"
    echo ""
fi

# Verifica se o .env existe
if [ ! -f "$PROJECT_DIR/.env" ]; then
    echo "⚠️  Arquivo .env não encontrado."
    echo "   Copiando de .env.example..."
    echo "   ⚠️  Você precisa editar o .env com suas credenciais reais!"
    cp "$PROJECT_DIR/.env.example" "$PROJECT_DIR/.env"
    echo ""
fi

echo "📋 Configuração:"
echo "   Conector:  $CONNECTOR_DIR/dimo_mvp.py"
echo "   Output:    $OUTPUT_FILE"
echo "   Modo:      Simulação (sem veículo real)"
echo ""

# Executa o conector em modo simulação
echo "🚀 Executando pipeline DIMO → Sign → Streamr..."
echo ""

cd "$CONNECTOR_DIR"
python dimo_mvp.py --simulate --output "$OUTPUT_FILE"

echo ""
echo "============================================"
echo "✅ Teste concluído!"
echo "============================================"
echo ""
echo "📄 Resultado salvo em: $OUTPUT_FILE"
echo ""
echo "Para visualizar:"
echo "  cat $OUTPUT_FILE | python -m json.tool"
echo ""
echo "Para modo produção (com veículo real):"
echo "  python dimo_mvp.py --production"
echo ""
