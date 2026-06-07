# 🤝 Contribuindo para o DeFi Security Workspace

Obrigado pelo interesse em contribuir! Este guia estabelece os padrões e processos para manter a qualidade e consistência do projeto.

## 📋 Índice

- [Código de Conduta](#código-de-conduta)
- [Como Contribuir](#como-contribuir)
- [Reportando Bugs](#reportando-bugs)
- [Submetendo Findings de Auditoria](#submetendo-findings-de-auditoria)
- [Padrões de Código](#padrões-de-código)
- [Convenção de Commits](#convenção-de-commits)
- [Pull Requests](#pull-requests)
- [Ambiente de Desenvolvimento](#ambiente-de-desenvolvimento)

## 📜 Código de Conduta

- Seja respeitoso e profissional
- Críticas construtivas são bem-vindas; ataques pessoais não
- Respeite a privacidade de projetos auditados (NDAs)
- Não publique PoCs de vulnerabilidades não divulgadas

## 🐛 Reportando Bugs

1. **Verifique se o bug já foi reportado** nas [Issues](https://github.com/jp255ft-debug/DeFi-Security/issues)
2. **Crie uma nova issue** usando o template de bug
3. **Inclua**:
   - Descrição clara do problema
   - Passos para reproduzir
   - Comportamento esperado vs. real
   - Logs ou screenshots (se aplicável)
   - Ambiente (OS, versão Python/Foundry)

## 🔍 Submetendo Findings de Auditoria

### Estrutura Obrigatória

Todo finding deve seguir esta estrutura dentro de `audits/<ProjectName>/findings/`:

```
audits/<ProjectName>/
├── findings/
│   ├── high/
│   │   └── F-001_TITULO_DO_FINDING.md
│   ├── medium/
│   │   └── F-002_TITULO_DO_FINDING.md
│   └── low/
│       └── F-003_TITULO_DO_FINDING.md
├── poc/
│   ├── test/
│   │   └── ExploitNomeDoContrato.t.sol
│   └── src/
│       └── mocks/
├── submissions/
│   └── SUBMISSION_1_TITULO.md
└── RELATORIO_FINAL.md
```

### Template de Finding

```markdown
# F-001: [Título da Vulnerabilidade]

## Descrição
[Explicação clara do problema]

## Código Vulnerável
```solidity
// Linhas do contrato vulnerável
```

## Impacto
- **Severidade:** [Critical/High/Medium/Low]
- **Impacto Financeiro:** $X.XXX (deve exceder 2% do TVL para Critical)
- **Condições:** [Pré-requisitos para exploração]

## PoC
```solidity
function testExploit() public {
    // Código do ataque
}
```

## Mitigação
```solidity
// Código corrigido
```

## Referências
- [CWE-XX](https://cwe.mitre.org/)
```

### Validação Obrigatória

Antes de submeter qualquer finding:

```bash
# 1. Validação automática (12 checks)
python scripts/validate_submission.py --poc-dir audits/<projeto>/poc

# 2. Checklist manual
cat knowledge_base/checklists/poc_validation.md

# 3. Verificar rejection patterns
cat knowledge_base/rejection_patterns.md
```

**Score mínimo para submissão: 12/12**

## 💻 Padrões de Código

### Solidity

- **Versão:** ^0.8.24
- **Formatação:** `forge fmt`
- **Naming:** `camelCase` para funções, `UpperCamelCase` para contratos
- **Custom Errors:** Use `error NomeDoErro()` em vez de `require` com strings
- **Testes:** Use `forge-std/Test.sol` como base
- **PoCs:** Nomeie como `Exploit<NomeDoContrato>.t.sol`

### Python

- **Versão:** 3.11+
- **Formatação:** `black` (line-length=100)
- **Imports:** `isort` (profile=black)
- **Type Hints:** Obrigatórios em funções públicas
- **Docstrings:** Google-style

### Shell Scripts

- **Shebang:** `#!/bin/bash`
- **Flags:** `set -euo pipefail`
- **Verificação:** `shellcheck` (severity=warning)

## 📝 Convenção de Commits

Usamos [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]
```

### Tipos

| Tipo | Uso |
|------|-----|
| `feat` | Nova funcionalidade |
| `fix` | Correção de bug |
| `audit` | Adição de finding/PoC de auditoria |
| `docs` | Documentação |
| `style` | Formatação, estilo |
| `refactor` | Refatoração |
| `test` | Testes |
| `chore` | Manutenção, build, CI |
| `security` | Correção de segurança |

### Exemplos

```
feat(depin): add Helium IoT data ingestion
fix(oracle): correct staleness check threshold
audit(moonwell): add F-001 composite oracle PoC
docs(readme): update audit count to 10
security(gitignore): block sensitive directories
```

## 🔄 Pull Requests

### Template

```markdown
## Descrição
[O que este PR faz]

## Tipo de Mudança
- [ ] Bug fix
- [ ] Nova funcionalidade
- [ ] Finding de auditoria
- [ ] Documentação
- [ ] Refatoração

## Checklist
- [ ] Código segue os padrões do projeto
- [ ] Testes passam (`forge test -vvv`)
- [ ] PoC validado (`validate_submission.py` score 12/12)
- [ ] Documentação atualizada
- [ ] Sem secrets no código
- [ ] Commits seguem Conventional Commits

## PoC Testado
```
forge test --match-test testExploit -vvv
[output]
```

## Impacto Financeiro
$X.XXX (se aplicável)
```

### Processo

1. **Fork** o repositório
2. **Crie uma branch**: `git checkout -b tipo/descricao-curta`
3. **Faça commits** seguindo a convenção
4. **Push** para sua branch: `git push origin tipo/descricao-curta`
5. **Abra um Pull Request** contra `main`

## 🛠️ Ambiente de Desenvolvimento

### Setup Rápido

```bash
# Clone
git clone https://github.com/jp255ft-debug/DeFi-Security.git
cd DeFi-Security

# Instalar dependências
make install

# Configurar pre-commit hooks
pre-commit install

# Verificar setup
make build && make test
```

### Comandos Úteis

```bash
make help              # Lista todos os comandos
make audit-quick       # Análise rápida (5-10 min)
make audit-full        # Análise completa (1-2h)
make validate-poc      # Valida PoCs
make lint              # Verifica estilo
make format            # Formata código
make security-scan     # Escaneia secrets
```

---

**Dúvidas?** Abra uma [issue](https://github.com/jp255ft-debug/DeFi-Security/issues) ou envie email para dev@deepsec-labs.com
