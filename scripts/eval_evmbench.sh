#!/bin/bash
# Avalia o DeepSeek no EVMbench
# Uso: ./eval_evmbench.sh [--model deepseek-r1|deepseek-v3]
#
# Gera:
#   - results.txt (resultados brutos)
#   - performance_report.md (dashboard de métricas)
#   - logs/ (histórico de execuções)

set -e

MODEL="${1:-deepseek-r1}"
EVAL_SCRIPT="../knowledge_base/evmbench/evaluate.sh"
RESULTS_FILE="../knowledge_base/evmbench/results.txt"
LOGS_DIR="../knowledge_base/evmbench/logs"
REPORT_FILE="../knowledge_base/evmbench/performance_report.md"

if [ ! -f "$EVAL_SCRIPT" ]; then
    echo "❌ Erro: Script de avaliação não encontrado em $EVAL_SCRIPT"
    exit 1
fi

echo "=========================================="
echo "  EVMbench Evaluation - Stack DeepSeek"
echo "  Modelo: $MODEL"
echo "=========================================="
echo ""

# Verifica se o dataset existe
if [ ! -d "../knowledge_base/evmbench/dataset/contracts" ]; then
    echo "⚠️  Dataset EVMbench não encontrado."
    echo "   Para baixar:"
    echo "   git clone https://github.com/openai/evmbench.git ../knowledge_base/evmbench/dataset/"
    echo ""
    read -p "Deseja baixar agora? (s/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        echo "📥 Baixando EVMbench..."
        git clone https://github.com/openai/evmbench.git /tmp/evmbench
        cp -r /tmp/evmbench/data/* ../knowledge_base/evmbench/dataset/
        rm -rf /tmp/evmbench
        echo "✅ Dataset baixado!"
    else
        echo "❌ Abortando. Baixe manualmente e tente novamente."
        exit 1
    fi
fi

# Cria diretório de logs
mkdir -p "$LOGS_DIR"

# Executa a avaliação usando pushd/popd para preservar o diretório original
pushd "../knowledge_base/evmbench" > /dev/null
bash evaluate.sh --model "$MODEL"
popd > /dev/null

echo ""
echo "✅ Avaliação concluída!"

# ============================================================
# GERAR RELATÓRIO DE PERFORMANCE
# ============================================================

if [ ! -f "$RESULTS_FILE" ]; then
    echo "⚠️  results.txt não encontrado. Pulando geração do relatório."
    exit 0
fi

# Extrai métricas do results.txt
TOTAL_TESTS=$(grep -c "Test" "$RESULTS_FILE" 2>/dev/null || echo "0")
FOUND_COUNT=$(grep -c "✅ FOUND" "$RESULTS_FILE" 2>/dev/null || echo "0")
MISSED_COUNT=$(grep -c "❌ MISSED" "$RESULTS_FILE" 2>/dev/null || echo "0")
FP_COUNT=$(grep -c "⚠️  FP" "$RESULTS_FILE" 2>/dev/null || echo "0")

# Calcula percentuais (com proteção contra divisão por zero)
if [ "$TOTAL_TESTS" -gt 0 ]; then
    RECALL=$((FOUND_COUNT * 100 / TOTAL_TESTS))
else
    RECALL=0
fi

if [ $((FOUND_COUNT + FP_COUNT)) -gt 0 ]; then
    PRECISION=$((FOUND_COUNT * 100 / (FOUND_COUNT + FP_COUNT)))
else
    PRECISION=0
fi

if [ "$TOTAL_TESTS" -gt 0 ]; then
    FPR=$((FP_COUNT * 100 / TOTAL_TESTS))
else
    FPR=0
fi

# Gera relatório Markdown
cat > "$REPORT_FILE" << EOF
# Relatório de Performance — EVMbench ($(date +%Y-%m-%d))

**Modelo:** $MODEL

## Métricas

| Métrica | Valor |
|---------|-------|
| **Total de Testes** | $TOTAL_TESTS |
| **✅ Found** | $FOUND_COUNT |
| **❌ Missed** | $MISSED_COUNT |
| **⚠️  False Positives** | $FP_COUNT |
| **🎯 Recall** | ${RECALL}% |
| **🎯 Precision** | ${PRECISION}% |
| **📊 False Positive Rate** | ${FPR}% |

## Análise

$(if [ "$RECALL" -gt 80 ]; then echo "🟢 **Performance de elite** (Recall > 80%) — O modelo está calibrado para caça de bugs."; elif [ "$RECALL" -gt 60 ]; then echo "🟡 **Performance boa** (Recall 60-80%) — Ajustes finos podem melhorar."; else echo "🔴 **Performance abaixo do esperado** (Recall < 60%) — Revisar prompt e configuração do modelo."; fi)

$(if [ "$PRECISION" -gt 80 ]; then echo "🟢 **Alta precisão** — Poucos falsos positivos. Confiança alta nos findings."; elif [ "$PRECISION" -gt 50 ]; then echo "🟡 **Precisão moderada** — Revisar filtro de falsos positivos."; else echo "🔴 **Baixa precisão** — Muitos falsos positivos. Executar filter_noise.py."; fi)

## Tendência

$(if [ -f "$LOGS_DIR/previous_report.md" ]; then
    PREV_RECALL=$(grep "Recall" "$LOGS_DIR/previous_report.md" | grep -oP '\d+' | head -1)
    if [ -n "$PREV_RECALL" ] && [ "$PREV_RECALL" -gt 0 ]; then
        DIFF=$((RECALL - PREV_RECALL))
        if [ "$DIFF" -gt 0 ]; then
            echo "📈 Recall melhorou em ${DIFF}% desde a última execução."
        elif [ "$DIFF" -lt 0 ]; then
            echo "📉 Recall caiu em ${DIFF#-}% desde a última execução."
        else
            echo "➡️ Recall estável desde a última execução."
        fi
    else
        echo "📊 Primeira execução registrada. Histórico começando agora."
    fi
else
    echo "📊 Primeira execução registrada. Histórico começando agora."
fi)

## Histórico

Execute \`ls logs/\` para ver execuções anteriores.
EOF

echo "📊 Relatório de performance gerado: $REPORT_FILE"

# Salva cópia para histórico
cp "$REPORT_FILE" "$LOGS_DIR/report_$(date +%Y%m%d_%H%M%S).md"
cp "$REPORT_FILE" "$LOGS_DIR/previous_report.md"

echo "📁 Histórico salvo em: $LOGS_DIR"
echo ""
echo "📋 Resumo:"
echo "   Recall: ${RECALL}% | Precision: ${PRECISION}% | FPR: ${FPR}%"
echo "   Total: $TOTAL_TESTS | Found: $FOUND_COUNT | Missed: $MISSED_COUNT | FP: $FP_COUNT"
