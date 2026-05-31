#!/bin/bash
# run_echidna.sh — Fuzzing com Echidna (Trail of Bits)
# Uso: ./run_echidna.sh NomeDoProjeto [--contract Invariants] [--config echidna.yaml] [--test-limit 100000] [--corpus-dir corpus]
#
# Echidna: Fuzzer baseado em propriedades da Trail of Bits.
# Bombardeia contratos com sequências aleatórias de chamadas,
# tentando violar invariantes definidos em funções "echidna_*".
#
# Encontra falhas de lógica de negócio que ferramentas estáticas
# não detectam — manipulação de estado, condições de corrida,
# cenários de borda.
#
# Trabalha em conjunto com o Medusa: Echidna é baseado em
# propriedades, Medusa foca em cobertura de ramificações.
#
# Instalação:
#   cargo install echidna
#
# Ou via Docker:
#   docker pull trailofbits/echidna
#
# Funciona com contratos Solidity que herdam de Test do Foundry.
# Echidna procura por funções que começam com "echidna_" que retornam bool.
# Se alguma retornar false, o Echidna reporta um bug.

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"

PROJECT_NAME="$1"
shift || true
CONTRACT_FILTER="Invariants"
CONFIG_FILE=""
TEST_LIMIT=100000
CORPUS_DIR=""

# Parse argumentos opcionais
while [[ $# -gt 0 ]]; do
    case "$1" in
        --contract)
            CONTRACT_FILTER="$2"
            shift 2
            ;;
        --config)
            CONFIG_FILE="$2"
            shift 2
            ;;
        --test-limit)
            TEST_LIMIT="$2"
            shift 2
            ;;
        --corpus-dir)
            CORPUS_DIR="$2"
            shift 2
            ;;
        *)
            echo "❌ Argumento desconhecido: $1"
            echo "Uso: ./run_echidna.sh NomeDoProjeto [--contract Invariants] [--config echidna.yaml] [--test-limit 100000] [--corpus-dir corpus]"
            exit 1
            ;;
    esac
done

if [ -z "$PROJECT_NAME" ]; then
    echo "Uso: ./run_echidna.sh NomeDoProjeto [--contract Invariants] [--config echidna.yaml] [--test-limit 100000] [--corpus-dir corpus]"
    echo ""
    echo "Exemplos:"
    echo "  ./run_echidna.sh MeuProtocolo"
    echo "  ./run_echidna.sh MeuProtocolo --contract Invariants --test-limit 50000"
    echo "  ./run_echidna.sh MeuProtocolo --config echidna.yaml --corpus-dir corpus"
    echo ""
    echo "Echidna: Fuzzer baseado em propriedades da Trail of Bits."
    echo "Procura por funcoes 'echidna_*' que retornam bool."
    echo "Se alguma retornar false, um bug foi encontrado."
    echo ""
    echo "Instalacao: cargo install echidna"
    exit 1
fi

POC_DIR="$WORKSPACE/audits/${PROJECT_NAME}/poc"
OUTPUT_DIR="$WORKSPACE/audits/${PROJECT_NAME}/findings/automated"
CONFIG_PATH="${POC_DIR}/echidna.yaml"

if [ ! -d "$POC_DIR" ]; then
    echo "❌ Projeto não encontrado em $POC_DIR"
    echo "   Certifique-se de que o diretório audits/${PROJECT_NAME}/poc/ existe."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "🦔 Executando Echidna em: $PROJECT_NAME"
echo "   Diretório: $POC_DIR"
echo "   Contrato: ${CONTRACT_FILTER}"
echo "   Test limit: ${TEST_LIMIT}"
[ -n "$CONFIG_FILE" ] && echo "   Config: $CONFIG_FILE"
[ -n "$CORPUS_DIR" ] && echo "   Corpus: $CORPUS_DIR"
echo ""

# Monta argumentos comuns
ARGS="--contract \"$CONTRACT_FILTER\" --test-limit $TEST_LIMIT"

# Config YAML (usa o argumento --config se fornecido, senão busca o padrão)
if [ -n "$CONFIG_FILE" ]; then
    ARGS="$ARGS --config \"$POC_DIR/$CONFIG_FILE\""
elif [ -f "$CONFIG_PATH" ]; then
    ARGS="$ARGS --config \"$CONFIG_PATH\""
    echo "   Usando config padrão: $CONFIG_PATH"
fi

# Corpus directory
if [ -n "$CORPUS_DIR" ]; then
    ARGS="$ARGS --corpus-dir \"$POC_DIR/$CORPUS_DIR\""
fi

echo ""

# Verifica se o Echidna está instalado
if ! command -v echidna-test &> /dev/null; then
    echo "⚠️  Echidna não encontrado. Tentando via Docker..."
    echo ""
    
    if ! command -v docker &> /dev/null; then
        echo "❌ Docker também não encontrado."
        echo "   Instale o Echidna: cargo install echidna"
        echo "   Ou baixe o binário: https://github.com/crytic/echidna/releases"
        exit 1
    fi
    
    echo "🐳 Executando via Docker..."
    docker run --rm -v "$(pwd)/${POC_DIR}:/poc" trailofbits/echidna \
        echidna-test /poc $ARGS \
        2>&1 | tee "$OUTPUT_DIR/echidna_report.txt"
else
    echo "🖥️  Executando localmente..."
    echo "   Comando: echidna-test \"$POC_DIR\" $ARGS"
    echo ""
    
    # Executa localmente
    eval echidna-test "\"$POC_DIR\"" $ARGS \
        2>&1 | tee "$OUTPUT_DIR/echidna_report.txt"
fi

echo ""
echo "✅ Echidna concluído!"
echo "   Relatório: $OUTPUT_DIR/echidna_report.txt"
echo ""

# Extrai resumo
echo "📊 Resumo:"
grep -E "(FAIL|PASS|Unique|Total|test limit|sequences|calls)" "$OUTPUT_DIR/echidna_report.txt" 2>/dev/null || echo "   (sem dados estruturados)"
echo ""

# Se encontrou falhas, avisa
if grep -qi "FAIL\|error\|assert" "$OUTPUT_DIR/echidna_report.txt" 2>/dev/null; then
    echo "⚠️  ATENÇÃO: Echidna encontrou possíveis violações de invariantes!"
    echo "   Revise o relatório completo em: $OUTPUT_DIR/echidna_report.txt"
    echo "   Invariantes quebrados indicam potenciais vulnerabilidades."
fi
