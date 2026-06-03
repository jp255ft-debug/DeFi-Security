#!/bin/bash
# =============================================================================
# pre_commit_security_check.sh
# Validação de segurança antes de commits no GitHub
# Verifica se há credenciais, chaves ou dados sensíveis sendo commitados
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=========================================="
echo "🔒 PRE-COMMIT SECURITY CHECK"
echo "=========================================="
echo ""

# ── Configuração ─────────────────────────────────────────────────────────────
# Arquivos que NUNCA devem ser commitados
FORBIDDEN_PATTERNS=(
    ".env$"
    ".env.local"
    ".env.production"
    ".env.development"
    "*.pem"
    "*.key"
    "*.p12"
    "*.pfx"
    "keystore"
    "mnemonic"
    "private.key"
    "private_key"
    "wallet.json"
    "secrets.yml"
    "secrets.yaml"
    "credentials.json"
    "config.local"
)

# Padrões de conteúdo suspeito (verifica dentro dos arquivos)
SUSPICIOUS_CONTENT=(
    "PRIVATE_KEY"
    "private_key"
    "mnemonic"
    "MNEMONIC"
    "INFURA_API_KEY"
    "ALCHEMY_API_KEY"
    "ETHERSCAN_API_KEY"
    "0x[0-9a-fA-F]{64}"  # Chave privada Ethereum
    "-----BEGIN RSA PRIVATE KEY-----"
    "-----BEGIN EC PRIVATE KEY-----"
    "-----BEGIN OPENSSH PRIVATE KEY-----"
)

# ── Funções ──────────────────────────────────────────────────────────────────

check_forbidden_files() {
    local has_issues=false
    echo "📁 Verificando arquivos proibidos..."
    
    for pattern in "${FORBIDDEN_PATTERNS[@]}"; do
        # Verifica arquivos staged
        local files=$(git diff --cached --name-only --diff-filter=ACM | grep -E "$pattern" 2>/dev/null || true)
        if [ -n "$files" ]; then
            echo -e "${RED}❌ ARQUIVO PROIBIDO ENCONTRADO:${NC}"
            echo "$files" | while read -r file; do
                echo "   - $file"
            done
            has_issues=true
        fi
    done
    
    if [ "$has_issues" = false ]; then
        echo -e "${GREEN}✅ Nenhum arquivo proibido encontrado${NC}"
    fi
    
    echo "$has_issues"
}

check_suspicious_content() {
    local has_issues=false
    echo ""
    echo "🔍 Verificando conteúdo suspeito em arquivos staged..."
    
    # Pega lista de arquivos staged (exceto binários)
    local staged_files=$(git diff --cached --name-only --diff-filter=ACM | grep -v -E '\.(png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot|pdf|docx|xlsx|zip|tar|gz|bin|exe|dmg|iso)$' 2>/dev/null || true)
    
    if [ -z "$staged_files" ]; then
        echo -e "${GREEN}✅ Nenhum arquivo para verificar${NC}"
        return 0
    fi
    
    for file in $staged_files; do
        if [ ! -f "$file" ]; then
            continue
        fi
        
        for pattern in "${SUSPICIOUS_CONTENT[@]}"; do
            if git show :"$file" 2>/dev/null | grep -q -E "$pattern"; then
                echo -e "${RED}❌ CONTEÚDO SUSPEITO em $file:${NC}"
                echo "   Padrão: $pattern"
                has_issues=true
            fi
        done
    done
    
    if [ "$has_issues" = false ]; then
        echo -e "${GREEN}✅ Nenhum conteúdo suspeito encontrado${NC}"
    fi
    
    echo "$has_issues"
}

check_git_history() {
    echo ""
    echo "📜 Verificando histórico do git por credenciais..."
    
    local has_issues=false
    for pattern in "${SUSPICIOUS_CONTENT[@]}"; do
        local result=$(git log --all --oneline --diff-filter=A --name-only -n 1 -S "$pattern" 2>/dev/null || true)
        if [ -n "$result" ]; then
            echo -e "${YELLOW}⚠️  Histórico contém: $pattern${NC}"
            has_issues=true
        fi
    done
    
    if [ "$has_issues" = false ]; then
        echo -e "${GREEN}✅ Histórico parece limpo${NC}"
    fi
    
    echo "$has_issues"
}

check_large_files() {
    echo ""
    echo "📦 Verificando arquivos grandes (>10MB)..."
    
    local has_issues=false
    local staged_files=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null || true)
    
    for file in $staged_files; do
        if [ -f "$file" ]; then
            local size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null || echo 0)
            if [ "$size" -gt 10485760 ]; then  # 10MB
                echo -e "${YELLOW}⚠️  Arquivo grande: $file ($(echo "scale=2; $size/1048576" | bc)MB)${NC}"
                has_issues=true
            fi
        fi
    done
    
    if [ "$has_issues" = false ]; then
        echo -e "${GREEN}✅ Nenhum arquivo grande encontrado${NC}"
    fi
    
    echo "$has_issues"
}

check_node_modules() {
    echo ""
    echo "📦 Verificando node_modules no staging..."
    
    local has_issues=false
    local node_files=$(git diff --cached --name-only --diff-filter=ACM | grep -E "node_modules" 2>/dev/null || true)
    
    if [ -n "$node_files" ]; then
        echo -e "${RED}❌ node_modules detectado no staging!${NC}"
        echo "   Adicione ao .gitignore e remova do tracking:"
        echo "   git rm -r --cached node_modules/"
        has_issues=true
    else
        echo -e "${GREEN}✅ node_modules não está no staging${NC}"
    fi
    
    echo "$has_issues"
}

# ── Execução Principal ───────────────────────────────────────────────────────

echo "🔐 Iniciando verificação de segurança..."
echo ""

# Verifica se há arquivos staged
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo -e "${RED}❌ Não está em um repositório git${NC}"
    exit 1
fi

STAGED_COUNT=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null | wc -l)
if [ "$STAGED_COUNT" -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Nenhum arquivo staged para commit${NC}"
    echo "   Use 'git add <arquivos>' primeiro"
    exit 0
fi

echo "📊 Arquivos staged: $STAGED_COUNT"
echo ""

# Executa verificações
FORBIDDEN_RESULT=$(check_forbidden_files)
CONTENT_RESULT=$(check_suspicious_content)
HISTORY_RESULT=$(check_git_history)
LARGE_RESULT=$(check_large_files)
NODE_RESULT=$(check_node_modules)

echo ""
echo "=========================================="

# Verifica se alguma verificação falhou
if [[ "$FORBIDDEN_RESULT" == *"true"* ]] || [[ "$CONTENT_RESULT" == *"true"* ]] || [[ "$NODE_RESULT" == *"true"* ]]; then
    echo -e "${RED}❌ VERIFICAÇÃO DE SEGURANÇA FALHOU${NC}"
    echo ""
    echo "Corrija os problemas acima antes de commitar:"
    echo "  1. Remova arquivos sensíveis do staging: git reset HEAD <arquivo>"
    echo "  2. Adicione ao .gitignore se necessário"
    echo "  3. Use git filter-branch se histórico precisa ser limpo"
    echo ""
    echo "Para forçar o commit (NÃO RECOMENDADO):"
    echo "  git commit --no-verify"
    exit 1
else
    echo -e "${GREEN}✅ TODAS AS VERIFICAÇÕES PASSARAM${NC}"
    echo -e "${GREEN}✅ Pronto para commit seguro!${NC}"
    echo ""
    echo "Comando sugerido:"
    echo "  git commit -m \"seu commit message\""
fi

echo "=========================================="
