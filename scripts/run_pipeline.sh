#!/bin/bash
# ============================================================
# Script: run_pipeline.sh
# Função: Orquestrador completo do pipeline de auditoria
# Uso:    ./run_pipeline.sh NomeDoProjeto [--quick|--full|--formal]
# ============================================================
# Modos:
#   --quick  : Slither + Aderyn + Semgrep (5-10 min)
#   --full   : + Mythril + Medusa + Echidna (1-2h) [PADRÃO]
#   --formal : + Halmos + Certora (lento, horas)
# ============================================================

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"
cd "$WORKSPACE"

PROJECT_NAME="$1"
MODE="${2:---full}"

if [ -z "$PROJECT_NAME" ]; then
    echo "Uso: ./run_pipeline.sh NomeDoProjeto [--quick|--full|--formal]"
    echo ""
    echo "Modos:"
    echo "  --quick   : Slither + Aderyn + Semgrep (5-10 min)"
    echo "  --full    : + Mythril + Medusa + Echidna (1-2h) [PADRÃO]"
    echo "  --formal  : + Halmos + Certora (lento, horas)"
    exit 1
fi

AUDIT_DIR="$WORKSPACE/audits/$PROJECT_NAME"
if [ ! -d "$AUDIT_DIR" ]; then
    echo "❌ Projeto não encontrado em $AUDIT_DIR"
    echo "   Execute primeiro: ./init_audit.sh $PROJECT_NAME"
    exit 1
fi

START_TIME=$(date +%s)

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║     🛡️  Pipeline de Auditoria DeFi              ║"
echo "║     Projeto: $PROJECT_NAME"
echo "║     Modo:    $MODE"
echo "╚══════════════════════════════════════════════════╝"
echo ""

# =============================================================================
# CAMADA 1 — Análise Estática (sempre executa)
# =============================================================================
echo ""
echo "═══════════════════════════════════════════════════"
echo "  📦 CAMADA 1 — Análise Estática"
echo "═══════════════════════════════════════════════════"

echo ""
echo "▶ 1/3 — Slither..."
bash "$WORKSPACE/scripts/run_slither.sh" "$PROJECT_NAME" 2>&1 | tail -5 || echo "   ⚠️  Slither falhou (continuando)"

echo ""
echo "▶ 2/3 — Aderyn..."
bash "$WORKSPACE/scripts/run_aderyn.sh" "$PROJECT_NAME" 2>&1 | tail -3 || echo "   ⚠️  Aderyn falhou (continuando)"

echo ""
echo "▶ 3/3 — Semgrep..."
bash "$WORKSPACE/scripts/run_semgrep.sh" "$PROJECT_NAME" 2>&1 | tail -5 || echo "   ⚠️  Semgrep falhou (continuando)"

# =============================================================================
# CAMADA 2 — Análise Concolica (quick+)
# =============================================================================
if [ "$MODE" != "--quick" ]; then
    echo ""
    echo "═══════════════════════════════════════════════════"
    echo "  📦 CAMADA 2 — Análise Concolica + Fuzzing"
    echo "═══════════════════════════════════════════════════"

    echo ""
    echo "▶ 4/6 — Mythril..."
    bash "$WORKSPACE/scripts/run_mythril.sh" "$PROJECT_NAME" 2>&1 | tail -3 || echo "   ⚠️  Mythril falhou (continuando)"

    echo ""
    echo "▶ 5/6 — Echidna..."
    bash "$WORKSPACE/scripts/run_echidna.sh" "$PROJECT_NAME" --test-limit 50000 2>&1 | tail -5 || echo "   ⚠️  Echidna falhou (continuando)"

    echo ""
    echo "▶ 6/6 — Medusa..."
    bash "$WORKSPACE/scripts/run_medusa.sh" "$PROJECT_NAME" --timeout 1800 2>&1 | tail -5 || echo "   ⚠️  Medusa falhou (continuando)"
fi

# =============================================================================
# CAMADA 3 — Verificação Formal (--formal apenas)
# =============================================================================
if [ "$MODE" = "--formal" ]; then
    echo ""
    echo "═══════════════════════════════════════════════════"
    echo "  📦 CAMADA 3 — Verificação Formal"
    echo "═══════════════════════════════════════════════════"

    echo ""
    echo "▶ 7/8 — Halmos..."
    bash "$WORKSPACE/scripts/run_halmos.sh" "$PROJECT_NAME" 2>&1 | tail -5 || echo "   ⚠️  Halmos falhou (continuando)"

    echo ""
    echo "▶ 8/8 — Certora..."
    bash "$WORKSPACE/scripts/run_certora.sh" "$PROJECT_NAME" 2>&1 | tail -5 || echo "   ⚠️  Certora falhou (continuando)"
fi

# =============================================================================
# RESUMO FINAL
# =============================================================================
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
MINUTES=$((DURATION / 60))
SECONDS=$((DURATION % 60))

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║     ✅ Pipeline Concluído!                       ║"
echo "║     Projeto: $PROJECT_NAME"
echo "║     Modo:    $MODE"
echo "║     Tempo:   ${MINUTES}m ${SECONDS}s"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "📁 Relatórios em: audits/$PROJECT_NAME/findings/automated/"
echo ""
echo "📊 Arquivos gerados:"
ls -1 "$AUDIT_DIR/findings/automated/" 2>/dev/null | sed 's/^/   • /' || echo "   (vazios)"
echo ""

# Alerta se encontrou algo grave
if grep -rqi "CRITICAL\|critical\|HIGH\|high.*severity" "$AUDIT_DIR/findings/automated/" 2>/dev/null; then
    echo "⚠️  ATENÇÃO: Foram encontrados findings de alta severidade!"
    echo "   Revise os relatórios antes de prosseguir."
    echo ""
fi

echo "💡 Próximos passos:"
echo "   1. Revise os relatórios em audits/$PROJECT_NAME/findings/automated/"
echo "   2. Execute filter_noise.py para remover falsos positivos"
echo "   3. Inicie a análise com IA via Cline"
echo "   4. Gere PoCs para os findings confirmados"
echo "   5. Valide com validate_submission.py antes de submeter"
echo ""
