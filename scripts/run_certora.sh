#!/bin/bash
# ============================================================
# Script: run_certora.sh
# Função: Verificação formal com Certora Prover
# Uso:    ./run_certora.sh NomeDoProjeto [--conf certora.conf]
# ============================================================
# Certora Prover: Verificação formal de contratos inteligentes.
# Converte Solidity/Yul para TAC (Term Algebra Core) e prova
# propriedades definidas em arquivos .spec.
#
# Instalação:
#   pip install certora-cli
#   # Ou via Docker (recomendado para Windows):
#   docker pull certora/prover
#
# Pré-requisitos:
#   - Java 11+ (para o Prover)
#   - Arquivo .spec com as propriedades a provar
#   - Arquivo .conf com a configuração do Certora
# ============================================================

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"

PROJECT_NAME="$1"
shift || true
CONF_FILE=""
SPEC_FILE=""

# Parse argumentos opcionais
while [[ $# -gt 0 ]]; do
    case "$1" in
        --conf)
            CONF_FILE="$2"
            shift 2
            ;;
        --spec)
            SPEC_FILE="$2"
            shift 2
            ;;
        *)
            echo "❌ Argumento desconhecido: $1"
            echo "Uso: ./run_certora.sh NomeDoProjeto [--conf certora.conf] [--spec invariants.spec]"
            exit 1
            ;;
    esac
done

if [ -z "$PROJECT_NAME" ]; then
    echo "Uso: ./run_certora.sh NomeDoProjeto [--conf certora.conf] [--spec invariants.spec]"
    echo ""
    echo "Exemplos:"
    echo "  ./run_certora.sh MeuProtocolo"
    echo "  ./run_certora.sh MeuProtocolo --conf certora.conf"
    echo "  ./run_certora.sh MeuProtocolo --spec invariants.spec"
    echo ""
    echo "Certora Prover: Verificacao formal de contratos inteligentes."
    echo "Usa arquivos .spec para definir propriedades a provar."
    echo ""
    echo "Instalacao: pip install certora-cli"
    echo "Documentacao: https://docs.certora.com/"
    exit 1
fi

POC_DIR="$WORKSPACE/audits/${PROJECT_NAME}/poc"
OUTPUT_DIR="$WORKSPACE/audits/${PROJECT_NAME}/findings/automated"
CERTORA_DIR="$POC_DIR/certora"

mkdir -p "$OUTPUT_DIR"

echo "🧪 Certora Prover — Verificação Formal"
echo "   Projeto: $PROJECT_NAME"
echo ""

# Verifica se o diretório certora existe
if [ ! -d "$CERTORA_DIR" ]; then
    echo "⚠️  Diretório certora não encontrado em: $CERTORA_DIR"
    echo "   O template de auditoria inclui exemplos em:"
    echo "   audits/00_Template_Audit/poc/certora/"
    echo ""
    echo "   Para criar, copie do template:"
    echo "   cp -r audits/00_Template_Audit/poc/certora $POC_DIR/"
    echo ""
    echo "   Ou crie manualmente:"
    echo "   mkdir -p $CERTORA_DIR/conf $CERTORA_DIR/specs"
    echo ""
    exit 1
fi

# Determina arquivo de configuração
if [ -z "$CONF_FILE" ]; then
    # Procura por .conf no diretório certora/conf/
    CONF_PATH=$(find "$CERTORA_DIR/conf" -name "*.conf" 2>/dev/null | head -1)
    if [ -n "$CONF_PATH" ]; then
        CONF_FILE=$(basename "$CONF_PATH")
        echo "   Usando config: $CONF_PATH"
    else
        echo "❌ Nenhum arquivo .conf encontrado em $CERTORA_DIR/conf/"
        echo "   Crie um arquivo de configuração ou use --conf"
        exit 1
    fi
else
    CONF_PATH="$CERTORA_DIR/conf/$CONF_FILE"
    if [ ! -f "$CONF_PATH" ]; then
        echo "❌ Arquivo de configuração não encontrado: $CONF_PATH"
        exit 1
    fi
fi

# Determina arquivo de especificação
if [ -z "$SPEC_FILE" ]; then
    # Procura por .spec no diretório certora/specs/
    SPEC_PATH=$(find "$CERTORA_DIR/specs" -name "*.spec" 2>/dev/null | head -1)
    if [ -n "$SPEC_PATH" ]; then
        SPEC_FILE=$(basename "$SPEC_PATH")
        echo "   Usando spec: $SPEC_PATH"
    else
        echo "⚠️  Nenhum arquivo .spec encontrado em $CERTORA_DIR/specs/"
        echo "   O Certora precisa de um arquivo .spec para executar."
        echo "   Use --spec para especificar um."
        exit 1
    fi
else
    SPEC_PATH="$CERTORA_DIR/specs/$SPEC_FILE"
    if [ ! -f "$SPEC_PATH" ]; then
        echo "❌ Arquivo .spec não encontrado: $SPEC_PATH"
        exit 1
    fi
fi

echo ""
echo "📋 Configuração:"
echo "   Config: $CONF_PATH"
echo "   Spec:   $SPEC_PATH"
echo ""

# Verifica se o Certora CLI está instalado
if ! command -v certoraRun &> /dev/null; then
    echo "⚠️  Certora CLI não encontrado. Tentando via Docker..."
    echo ""
    
    if ! command -v docker &> /dev/null; then
        echo "❌ Docker também não encontrado."
        echo "   Instale o Certora CLI: pip install certora-cli"
        echo "   Ou instale o Docker: https://docs.docker.com/get-docker/"
        exit 1
    fi
    
    echo "🐳 Executando via Docker..."
    echo "   Nota: Certora via Docker requer Java 11+ no container."
    echo "   Consulte: https://docs.certora.com/en/latest/docs/user-guide/install.html"
    echo ""
    
    # Tenta executar via Docker (pode não funcionar perfeitamente)
    docker run --rm \
        -v "$WORKSPACE:/workspace" \
        -v "$CERTORA_DIR:/certora" \
        certora/prover \
        certoraRun "$CONF_PATH" \
        2>&1 | tee "$OUTPUT_DIR/certora_report.txt"
else
    echo "🖥️  Executando Certora Prover..."
    echo "   (Isso pode levar vários minutos dependendo da complexidade)"
    echo ""
    
    # Executa Certora com o arquivo de configuração
    # O arquivo .conf já referencia o .spec internamente
    cd "$POC_DIR"
    certoraRun "$CONF_PATH" \
        2>&1 | tee "$OUTPUT_DIR/certora_report.txt"
    
    cd "$WORKSPACE"
fi

echo ""
echo "✅ Certora concluído!"
echo "   Relatório: $OUTPUT_DIR/certora_report.txt"
echo ""

# Extrai resumo
echo "📊 Resumo:"
grep -E "(PASS|FAIL|Rule|Violated|Verified|Error|Warning)" "$OUTPUT_DIR/certora_report.txt" 2>/dev/null | head -20 || echo "   (sem dados estruturados)"
echo ""

# Se encontrou violações, avisa
if grep -qi "Violated\|FAIL\|Error" "$OUTPUT_DIR/certora_report.txt" 2>/dev/null; then
    echo "⚠️  ATENÇÃO: Certora encontrou violações de propriedades!"
    echo "   Revise o relatório completo em: $OUTPUT_DIR/certora_report.txt"
    echo "   Propriedades violadas indicam potenciais vulnerabilidades."
fi

echo ""
echo "💡 Dica: Para visualizar o relatório completo no navegador:"
echo "   https://prover.certora.com/output/[job-id]/"
echo "   (O job-id aparece no output do Certora)"
