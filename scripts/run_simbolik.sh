#!/bin/bash
# run_simbolik.sh — Debugging Simbólico com Simbolik (VSCode)
# Uso: ./run_simbolik.sh NomeDoProjeto [--install] [--open]
#
# Simbolik: Extensão VSCode para debugging simbólico de contratos EVM.
# Executa contratos simbolicamente, explorando TODOS os caminhos
# de execução possíveis de uma só vez.
#
# Encontra falhas sutis que ferramentas estáticas e fuzzers não
# detectam — condições de borda, divisões por zero, caminhos
# inalcançáveis.
#
# Visualiza o grafo de execução diretamente no VSCode, facilitando
# a depuração e a compreensão do fluxo do contrato.
#
# Diferente de ferramentas CLI, o Simbolik é uma extensão interativa.
# Este script serve como guia de referência e atalho.
#
# Instalação:
#   code --install-extension simbolik.simbolik
#
# Documentação: https://simbolik.io/docs

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"

PROJECT_NAME="$1"
shift || true
INSTALL=false
OPEN_VSCODE=false

# Parse argumentos opcionais
while [[ $# -gt 0 ]]; do
    case "$1" in
        --install)
            INSTALL=true
            shift
            ;;
        --open)
            OPEN_VSCODE=true
            shift
            ;;
        *)
            echo "❌ Argumento desconhecido: $1"
            echo "Uso: ./run_simbolik.sh NomeDoProjeto [--install] [--open]"
            exit 1
            ;;
    esac
done

if [ -z "$PROJECT_NAME" ]; then
    echo "Uso: ./run_simbolik.sh NomeDoProjeto [--install] [--open]"
    echo ""
    echo "Exemplos:"
    echo "  ./run_simbolik.sh MeuProtocolo"
    echo "  ./run_simbolik.sh MeuProtocolo --install"
    echo "  ./run_simbolik.sh MeuProtocolo --install --open"
    echo ""
    echo "Simbolik: Extensao VSCode para debugging simbolico de contratos EVM."
    echo "Explora TODOS os caminhos de execucao de uma vez."
    echo ""
    echo "Instalacao: code --install-extension simbolik.simbolik"
    echo "Documentacao: https://simbolik.io/docs"
    exit 1
fi

PROJECT_DIR="$WORKSPACE/audits/${PROJECT_NAME}"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Projeto não encontrado em $PROJECT_DIR"
    echo "   Certifique-se de que o diretório audits/${PROJECT_NAME}/ existe."
    exit 1
fi

echo "🧪 Simbolik — Debugging Simbólico"
echo "   Projeto: $PROJECT_NAME"
echo ""

# Instala a extensão se solicitado
if [ "$INSTALL" = true ]; then
    echo "📦 Instalando extensão Simbolik..."
    if command -v code &> /dev/null; then
        code --install-extension simbolik.simbolik 2>&1 || true
        echo "   ✅ Extensão instalada (ou já estava instalada)"
    else
        echo "⚠️  Comando 'code' não encontrado no PATH."
        echo "   Instale manualmente em:"
        echo "   https://marketplace.visualstudio.com/items?itemName=simbolik.simbolik"
    fi
    echo ""
fi

# Abre o VSCode no diretório do projeto se solicitado
if [ "$OPEN_VSCODE" = true ]; then
    echo "📂 Abrindo VSCode em: $PROJECT_DIR"
    if command -v code &> /dev/null; then
        code "$PROJECT_DIR" 2>&1 || true
    else
        echo "⚠️  Comando 'code' não encontrado. Abra manualmente."
    fi
    echo ""
fi

echo "📋 Passo a passo para usar o Simbolik:"
echo ""
echo "  1. Abra o arquivo de teste Foundry:"
echo "     ${PROJECT_DIR}/poc/test/"
echo ""
echo "  2. Pressione Ctrl+Shift+P e execute:"
echo "     'Simbolik: Start Symbolic Debugging'"
echo ""
echo "  3. O Simbolik abrirá o grafo de execução simbólica"
echo "     no painel lateral, mostrando todas as ramificações"
echo "     de condições (if, require, assert)."
echo ""
echo "  4. Caminhos que levam a erros (ex: divisão por zero)"
echo "     são destacados automaticamente em vermelho."
echo ""
echo "  5. Use o painel para inspecionar valores simbólicos"
echo "     e refinar seus exploits antes de submeter."
echo ""
echo "📖 Documentação completa: https://simbolik.io/docs"
echo ""
echo "💡 Dica: A configuração do Simbolik está em .simbolik.json"
echo "   na raiz do workspace. Ajuste conforme necessário."
