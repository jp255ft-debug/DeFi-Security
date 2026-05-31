#!/bin/bash
# run_semgrep.sh — Quarta Camada de Detecção Estática
# Uso: ./run_semgrep.sh NomeDoProjeto
#
# Semgrep: Motor de análise estática multi-linguagem.
# Usa regras da comunidade para detectar vulnerabilidades em Solidity.
#
# Instalação:
#   pip install semgrep
#
# Regras utilizadas:
#   --config=auto (regras automáticas do Semgrep Registry)
#   --config=devexpress/solidity-security (regras específicas para Solidity)
#
# Saída: JSON em findings/automated/semgrep_results.json
# Pode ser processado pelo filter_noise.py posteriormente.

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"

PROJECT="$1"

if [ -z "$PROJECT" ]; then
    echo "Uso: ./run_semgrep.sh NomeDoProjeto"
    echo "Exemplo: ./run_semgrep.sh CircleUSDCBridge"
    echo ""
    echo "Semgrep: Quarta camada de detecção estática."
    echo "Complementa Slither, Aderyn e Mythril."
    exit 1
fi

AUDIT_DIR="$WORKSPACE/audits/$PROJECT"
SRC_DIR="$AUDIT_DIR/src"
OUTPUT_DIR="$AUDIT_DIR/findings/automated"
OUTPUT_FILE="$OUTPUT_DIR/semgrep_results.json"

if [ ! -d "$SRC_DIR" ]; then
    echo "❌ Erro: Diretório $SRC_DIR não encontrado."
    echo "   Certifique-se de que o projeto '$PROJECT' existe em audits/"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "🔍 Executando Semgrep em: $PROJECT"
echo "   Origem: $SRC_DIR"
echo ""

# Verifica se o Semgrep está instalado
if ! command -v semgrep &> /dev/null; then
    echo "⚠️  Semgrep não encontrado."
    echo "   Instale com: pip install semgrep"
    echo ""
    echo "   O Semgrep é opcional — as outras 3 camadas (Slither, Aderyn, Mythril)"
    echo "   continuam funcionando sem ele."
    exit 0
fi

# Executa Semgrep com regras para Solidity
# --config=auto: regras automáticas do Semgrep Registry
# --config=devexpress/solidity-security: regras específicas para Solidity
# --json: saída estruturada para processamento posterior
semgrep \
    --config=auto \
    --config=devexpress/solidity-security \
    --json \
    --output="$OUTPUT_FILE" \
    "$SRC_DIR" 2>&1

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo ""
    echo "✅ Semgrep concluído!"
    echo "   Resultados: $OUTPUT_FILE"
    echo ""
    echo "📊 Resumo rápido:"
    python3 -c "
import json
with open('$OUTPUT_FILE') as f:
    data = json.load(f)
results = data.get('results', [])
print(f'   Total de findings: {len(results)}')
severities = {}
for r in results:
    sev = r.get('extra', {}).get('severity', 'unknown')
    severities[sev] = severities.get(sev, 0) + 1
for sev, count in sorted(severities.items()):
    print(f'   {sev}: {count}')
" 2>/dev/null || echo "   (use filter_noise.py para análise detalhada)"
elif [ $EXIT_CODE -eq 1 ]; then
    echo ""
    echo "⚠️  Semgrep encontrou possíveis issues."
    echo "   Resultados salvos em: $OUTPUT_FILE"
    echo ""
    echo "💡 Dica: Processe com filter_noise.py:"
    echo "   python scripts/filter_noise.py $OUTPUT_FILE --tool semgrep --output $OUTPUT_DIR/semgrep_clean.md"
else
    echo ""
    echo "❌ Erro na execução do Semgrep (código: $EXIT_CODE)."
    echo "   Verifique o arquivo de saída para detalhes: $OUTPUT_FILE"
fi
