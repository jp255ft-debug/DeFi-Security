#!/bin/bash
# run_aderyn_ci.sh — Referência para o Aderyn CI (GitHub Actions)
# Uso: ./run_aderyn_ci.sh NomeDoProjeto
#
# O Aderyn CI executa análise estática AUTOMATICAMENTE a cada
# push ou pull request na branch main, via GitHub Actions.
#
# Este script é apenas uma referência — a execução real acontece
# no GitHub. Use-o para consultar resultados e status.
#
# Diferente do run_aderyn.sh (execução manual local),
# o Aderyn CI roda 24/7 sem intervenção do auditor.
#
# Instalação:
#   Basta fazer push do arquivo .github/workflows/aderyn_ci.yml
#   para o repositório remoto. O GitHub Actions ativa sozinho.
#
# Pré-requisitos:
#   - Repositório hospedado no GitHub
#   - GitHub Actions habilitado no repositório

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"

PROJECT_NAME="$1"

if [ -z "$PROJECT_NAME" ]; then
    echo "Uso: ./run_aderyn_ci.sh NomeDoProjeto"
    echo ""
    echo "Exemplos:"
    echo "  ./run_aderyn_ci.sh MeuProtocolo"
    echo ""
    echo "Aderyn CI: Analise estatica automatizada via GitHub Actions."
    echo "Executa automaticamente a cada push e pull request."
    echo ""
    echo "Para execucao manual local, use:"
    echo "  ./run_aderyn.sh MeuProtocolo"
    exit 1
fi

PROJECT_DIR="$WORKSPACE/audits/${PROJECT_NAME}"
REPORT_PATH="${PROJECT_DIR}/findings/automated/aderyn_ci_report.md"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Projeto não encontrado em $PROJECT_DIR"
    exit 1
fi

echo "🔍 Aderyn CI — Análise Estática Automatizada"
echo "   Projeto: $PROJECT_NAME"
echo ""

# Verifica se o diretório .github/workflows existe
if [ -f "../.github/workflows/aderyn_ci.yml" ]; then
    echo "✅ Workflow do Aderyn CI está configurado:"
    echo "   .github/workflows/aderyn_ci.yml"
else
    echo "⚠️  Workflow do Aderyn CI NÃO encontrado."
    echo "   Execute na raiz do workspace:"
    echo "   mkdir -p .github/workflows"
    echo "   # Crie .github/workflows/aderyn_ci.yml"
    echo ""
fi

echo ""
echo "📋 Status do Aderyn CI para $PROJECT_NAME:"
echo ""

# Verifica se o relatório CI já foi gerado
if [ -f "$REPORT_PATH" ]; then
    echo "✅ Relatório CI encontrado:"
    echo "   $REPORT_PATH"
    echo ""

    # Mostra resumo do relatório
    echo "📊 Resumo do último scan CI:"
    echo "   Gerado em: $(stat -c '%y' "$REPORT_PATH" 2>/dev/null || date -r "$REPORT_PATH" 2>/dev/null || echo 'data desconhecida')"
    echo "   Tamanho: $(wc -c < "$REPORT_PATH") bytes"
    echo ""

    # Extrai número de findings
    FINDINGS_COUNT=$(grep -cE "^- \[" "$REPORT_PATH" 2>/dev/null || echo "0")
    echo "   Findings encontrados: $FINDINGS_COUNT"
    echo ""

    # Mostra os findings se houver
    if [ "$FINDINGS_COUNT" -gt 0 ]; then
        echo "   🔴 ATENÇÃO: $FINDINGS_COUNT finding(s) encontrado(s)!"
        echo "   Revise o relatório completo para detalhes."
    else
        echo "   🟢 Nenhum finding crítico encontrado no último scan."
    fi
else
    echo "⚠️  Relatório CI ainda não foi gerado."
    echo "   O Aderyn CI gera o relatório automaticamente após"
    echo "   o primeiro push ou pull request na branch main."
    echo ""
    echo "   Para forçar uma execução manual:"
    echo "   1. Acesse: https://github.com/<seu-repo>/actions"
    echo "   2. Selecione 'Aderyn Security Audit'"
    echo "   3. Clique em 'Run workflow'"
    echo ""
    echo "   Ou execute localmente com:"
    echo "   ./run_aderyn.sh ${PROJECT_NAME}"
fi

echo ""
echo "💡 Dica: O Aderyn CI é complementar ao run_aderyn.sh"
echo "   - CI: Automático, 24/7, via GitHub Actions"
echo "   - Manual: Sob demanda, execução local imediata"
echo "   Ambos geram relatórios no mesmo formato."
