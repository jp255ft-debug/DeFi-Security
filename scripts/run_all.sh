#!/bin/bash
# ============================================================
# Script: run_all.sh
# Função: Atalho rápido — executa pipeline completo no modo --full
# Uso:    ./run_all.sh NomeDoProjeto
# Equivalente a: ./run_pipeline.sh NomeDoProjeto --full
# ============================================================

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"

if [ -z "$1" ]; then
    echo "Uso: ./run_all.sh NomeDoProjeto"
    echo ""
    echo "Atalho para: ./run_pipeline.sh NomeDoProjeto --full"
    echo ""
    echo "Executa todas as ferramentas:"
    echo "  Slither + Aderyn + Semgrep + Mythril + Echidna + Medusa"
    echo ""
    echo "Para modo rápido:  ./run_pipeline.sh NomeDoProjeto --quick"
    echo "Para modo formal:  ./run_pipeline.sh NomeDoProjeto --formal"
    exit 1
fi

echo "🚀 run_all.sh — Pipeline Completo"
echo "   Projeto: $1"
echo ""

bash "$WORKSPACE/scripts/run_pipeline.sh" "$1" --full
