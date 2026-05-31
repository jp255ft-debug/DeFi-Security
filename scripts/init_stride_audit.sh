#!/bin/bash
# ============================================================
# Script: init_stride_audit.sh
# Função: Inicializa a estrutura de uma avaliação STRIDE
#         para projetos Solana (Anchor/Sealevel)
# Uso:    ./init_stride_audit.sh NomeDoProjeto
# Exemplo: ./init_stride_audit.sh MeuProtocoloSolana
# ============================================================

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"

if [ -z "$1" ]; then
    echo "❌ Uso: ./init_stride_audit.sh NomeDoProjeto"
    echo "   Exemplo: ./init_stride_audit.sh MeuProtocoloSolana"
    exit 1
fi

PROJECT_NAME="$1"
TARGET_DIR="$WORKSPACE/audits/STRIDE_${PROJECT_NAME}"

if [ -d "$TARGET_DIR" ]; then
    echo "❌ Erro: O diretório $TARGET_DIR já existe."
    exit 1
fi

echo "🌐 Inicializando avaliação STRIDE: $PROJECT_NAME"
echo ""

# Criar estrutura de diretórios
mkdir -p "$TARGET_DIR"/{programs,src,_docs,findings/{critical,high,medium,low,informational,automated},poc/tests,scripts}

echo "✅ Estrutura criada em: $TARGET_DIR"
echo ""

# Criar README do projeto
cat > "$TARGET_DIR/README.md" << README_EOF
# 🌐 Avaliação STRIDE — ${PROJECT_NAME}

**Rede:** Solana
**Tipo:** Avaliação Contínua de Segurança (STRIDE — Solana Foundation)
**Data de Início:** $(date +%Y-%m-%d)
**Status:** Em andamento

## Estrutura

\`\`\`
STRIDE_${PROJECT_NAME}/
├── programs/          # Código fonte dos programas (Anchor/Sealevel)
├── src/               # Código fonte adicional (se houver)
├── _docs/             # Documentação do projeto
├── findings/          # Vulnerabilidades encontradas
│   ├── critical/      # 🔴 Crítico
│   ├── high/          # 🔴 Alto
│   ├── medium/        # 🟡 Médio
│   ├── low/           # 🟢 Baixo
│   ├── informational/ # 🔵 Informativo
│   └── automated/     # 🤖 Relatórios de ferramentas automáticas
├── poc/               # Provas de conceito (Anchor tests)
│   └── tests/         # Testes Rust/TypeScript
└── scripts/           # Scripts auxiliares
\`\`\`

## Pilares STRIDE

| # | Pilar | Status |
|:--|:------|:-------|
| P1 | Segurança do Programa | ⬜ Pendente |
| P2 | Governança e Controle de Acesso | ⬜ Pendente |
| P3 | Risco de Oráculo | ⬜ Pendente |
| P4 | Infraestrutura | ⬜ Pendente |
| P5 | Supply Chain | ⬜ Pendente |
| P6 | Segurança Operacional | ⬜ Pendente |
| P7 | Monitoramento e Resposta a Incidentes | ⬜ Pendente |
| P8 | Gerenciamento de Logs e Análise Forense | ⬜ Pendente |

## Ferramentas

- Soteria: \`soteria -target programs/\`
- Anchor Lint: \`anchor lint\`
- Trident: \`trident audit\`
- Cargo Audit: \`cargo audit\`
- Anchor Test: \`anchor test\`
README_EOF

echo "📄 README.md criado"

# Criar template de finding
cat > "$TARGET_DIR/findings/TEMPLATE_FINDING.md" << FINDING_EOF
# [SC-XX] Título do Finding

**Pilar:** P1 — Segurança do Programa / P2 — Governança / P3 — Oráculo / P4 — Infraestrutura / P5 — Supply Chain / P6 — Segurança Operacional / P7 — Monitoramento / P8 — Logs
**Severidade:** Crítico / Alto / Médio / Baixo / Informativo
**Arquivo:** \`programs/[nome]/src/instructions/[arquivo].rs\` linha XX
**Data:** $(date +%Y-%m-%d)

## Descrição

[Descrição detalhada da vulnerabilidade]

## Impacto

[Impacto financeiro/operacional]

## Recomendação

[Código de correção ou descrição da mitigação]

## PoC

\`poc/tests/[exploit_test].rs\`

## Referências

- [Solana STRIDE Checklist](knowledge_base/checklists/stride_checklist.md)
- [OWASP Solana Top 10](https://owasp.org/)
FINDING_EOF

echo "📄 Template de finding criado"

# Criar script de varredura automatizada
cat > "$TARGET_DIR/scripts/run_scan.sh" << SCAN_EOF
#!/bin/bash
# ============================================================
# Script: run_scan.sh
# Função: Executa varredura automatizada no programa Solana
# Uso:    bash scripts/run_scan.sh
# ============================================================

echo "🔍 Iniciando varredura STRIDE..."
echo ""

# 1. Soteria
echo "=== Soteria ==="
if command -v soteria &> /dev/null; then
    soteria -target programs/ 2>&1 | tee findings/automated/soteria_report.txt
else
    echo "⚠️  Soteria não encontrado. Instale com: cargo install soteria"
fi
echo ""

# 2. Anchor Lint
echo "=== Anchor Lint ==="
if command -v anchor &> /dev/null; then
    anchor lint 2>&1 | tee findings/automated/anchor_lint_report.txt
else
    echo "⚠️  Anchor não encontrado. Instale com: https://www.anchor-lang.com/"
fi
echo ""

# 3. Cargo Audit
echo "=== Cargo Audit ==="
if command -v cargo &> /dev/null; then
    cargo audit 2>&1 | tee findings/automated/cargo_audit_report.txt
else
    echo "⚠️  Cargo não encontrado."
fi
echo ""

# 4. Trident (se aplicável)
echo "=== Trident ==="
if command -v trident &> /dev/null; then
    trident audit 2>&1 | tee findings/automated/trident_report.txt
else
    echo "⚠️  Trident não encontrado. Opcional para fuzzing."
fi
echo ""

echo "✅ Varredura concluída. Relatórios em findings/automated/"
SCAN_EOF

chmod +x "$TARGET_DIR/scripts/run_scan.sh"
echo "📄 Script de varredura criado"

echo ""
echo "============================================"
echo "✅ Avaliação STRIDE inicializada com sucesso!"
echo "============================================"
echo ""
echo "Próximos passos:"
echo "  1. Copie os programas para STRIDE_${PROJECT_NAME}/programs/"
echo "  2. Adicione a documentação em STRIDE_${PROJECT_NAME}/_docs/"
echo "  3. Execute: bash STRIDE_${PROJECT_NAME}/scripts/run_scan.sh"
echo "  4. Use o checklist: knowledge_base/checklists/stride_checklist.md"
echo "  5. Use o template: knowledge_base/templates/stride_report_template.md"
echo "  6. Execute: ./run_soteria.sh ${PROJECT_NAME} (se disponível)"
echo "  7. Inicie a análise com IA via Cline"
echo "  8. Gere o relatório STRIDE final"
