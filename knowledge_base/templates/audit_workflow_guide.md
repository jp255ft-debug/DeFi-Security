# 🛡️ Guia Completo do Pipeline de Auditoria DeFi

**Workspace:** `defi-security-workspace`  
**Versão:** 2.0 — Junho/2026  
**Ferramentas:** 11 ferramentas integradas (6 estáticas, 2 fuzzing, 2 formais, 1 simbólica)

---

## Índice

1. [Setup Inicial](#1-setup-inicial)
2. [Varredura Automatizada — 5 Camadas](#2-varredura-automatizada--5-camadas)
3. [Triagem com IA](#3-triagem-com-ia)
4. [Análise Profunda com IA](#4-análise-profunda-com-ia)
5. [Verificação Formal](#5-verificação-formal)
6. [Geração de PoCs](#6-geração-de-pocs)
7. [Validação Pré-Submissão](#7-validação-pré-submissão)
8. [Submissão](#8-submissão)

---

## 1. Setup Inicial

### 1.1 Criar estrutura do projeto

```bash
# A partir da raiz do workspace
cd /mnt/c/Source/Repos/defi-security-workspace

# Cria a estrutura de diretórios a partir do template
bash scripts/init_audit.sh NomeDoProtocolo
```

**O que acontece:**  
Copia o template `audits/00_Template_Audit/` para `audits/NomeDoProtocolo/`, criando:

```
audits/NomeDoProtocolo/
├── src/                    # ← Coloque os contratos .sol aqui
├── _docs/                  # Documentação, escopo, KNOWN_ISSUES
├── findings/               # Relatórios de vulnerabilidade
├── submissions/            # Submissões formatadas
├── poc/                    # Proof of Concept (Foundry)
│   ├── foundry.toml
│   ├── src/
│   │   ├── interfaces/     # Interfaces dos contratos atacados
│   │   └── mocks/          # Mocks auxiliares (apenas se necessário)
│   ├── test/               # Testes de exploração
│   └── certora/            # Verificação formal (Certora)
│       ├── conf/certora.conf
│       └── specs/invariants.spec
└── relatorios/             # Relatórios gerados
```

### 1.2 Clonar repositório do cliente (se aplicável)

```bash
# Se o cliente forneceu um repositório
git clone <url-do-repositorio> repo_temp/NomeDoProtocolo

# Copiar contratos para a estrutura de auditoria
cp repo_temp/NomeDoProtocolo/src/*.sol audits/NomeDoProtocolo/src/
```

### 1.3 Configurar dependências

```bash
# Se o projeto usa Foundry
cd audits/NomeDoProtocolo/poc
forge install

# Se o projeto usa npm
cd audits/NomeDoProtocolo/poc
npm install
```

---

## 2. Varredura Automatizada — 5 Camadas

Execute **todas as camadas** em sequência. Cada uma detecta uma classe diferente de vulnerabilidades.

### 🥇 Camada 1 — Slither (Análise Estática)

```bash
bash scripts/run_slither.sh NomeDoProtocolo
```

**O que faz:**  
Analisador estático da Trail of Bits com 90+ detectores. Varre o bytecode intermediário (SlithIR) procurando padrões como:
- Reentrância (violação CEI)
- Uso de `tx.origin`
- Controle de acesso ausente
- Operações matemáticas inseguras
- Shadowing de variáveis de estado

**Saída:** Relatório no terminal + arquivo em `audits/NomeDoProtocolo/findings/`

---

### 🥇 Camada 2 — Aderyn (Análise AST)

```bash
bash scripts/run_aderyn.sh NomeDoProtocolo
```

**O que faz:**  
Analisador de AST (Abstract Syntax Tree) escrito em Rust, extremamente rápido. Detecta:
- Funções sem visibilidade explícita
- Erros de nomenclatura
- Práticas inseguras de codificação
- Vulnerabilidades estruturais no código-fonte

**Saída:** Relatório em `aderyn_report.md` na raiz do projeto

---

### 🥇 Camada 3 — Semgrep (Padrões Multi-linguagem)

```bash
bash scripts/run_semgrep.sh NomeDoProtocolo
```

**O que faz:**  
Motor de análise de padrões que permite criar regras customizadas. Diferente do Slither (que entende semântica EVM), o Semgrep busca **padrões textuais** no código-fonte:
- Uso de `block.timestamp` para aleatoriedade
- `delegatecall` sem verificação de endereço
- Loops não limitados sobre arrays dinâmicos
- Padrões de oráculo manipuláveis

**Por que foi adicionado:** Complementa o Slither com regras customizáveis que podemos escrever para cada tipo de vulnerabilidade.

**Saída:** Relatório em formato SARIF + terminal

---

### 🥇 Camada 4 — Mythril (Análise Concolica)

```bash
bash scripts/run_mythril.sh NomeDoProtocolo
```

**O que faz:**  
Combina execução concreta e simbólica para explorar todos os caminhos de execução possíveis. Detecta:
- Integer overflow/underflow
- Chamadas externas sem proteção
- Problemas de gás (gas-guzzling)
- Falhas de validação de entrada

**Saída:** Relatório no terminal com contraexemplos

---

### 🥈 Camada 5 — Fuzzing Duplo (Echidna + Medusa)

#### Echidna (Fuzzing de Propriedades)

```bash
bash scripts/run_echidna.sh NomeDoProtocolo
```

**O que faz:**  
Fuzzer de invariantes da Trail of Bits. Você define propriedades que **devem** ser verdadeiras (ex: "totalSupply nunca diminui"), e o Echidna gera milhares de transações aleatórias tentando quebrá-las.

**Quando usar:** Quando você tem invariantes claros para testar (soma de saldos, colateralização, limites de oferta).

**Saída:** Relatório com sequências de transações que quebram invariantes

#### Medusa (Fuzzing de Cobertura EVM)

```bash
bash scripts/run_medusa.sh NomeDoProtocolo
```

**O que faz:**  
Fuzzer EVM de alta performance, também da Trail of Bits. Diferente do Echidna (que foca em propriedades), o Medusa:
- **Bombardeia contratos com milhares de transações aleatórias**
- **Busca maximizar cobertura de código** (linhas, branches, paths)
- **Encontra bugs que ferramentas estáticas não detectam** — como falhas de lógica complexa, reentrância sutil, manipulação de estado e condições de corrida
- **Complementa o Foundry**, fornecendo uma camada adicional de testes dinâmicos agressivos

**Por que foi adicionado:** Enquanto o Echidna é excelente para propriedades específicas, o Medusa é melhor para exploração cega de código — ele encontra bugs que você nem sabia que existiam.

**Saída:** Relatório com sequências de transações que causam falhas

---

### 🤖 CI Automatizado (Aderyn CI)

```bash
bash scripts/run_aderyn_ci.sh NomeDoProtocolo
```

**O que faz:**  
Executa o Aderyn em modo CI (GitHub Actions). Configurado em `.github/workflows/aderyn_ci.yml`. Ideal para:
- Rodar automaticamente em cada push
- Bloquear PRs que introduzem vulnerabilidades
- Manter histórico de qualidade do código

---

### 📊 Resumo das 5 Camadas

| Camada | Ferramenta | Tipo | O que detecta |
|:------|:-----------|:-----|:--------------|
| 🥇 1 | Slither | Estática | 90+ padrões de vulnerabilidade |
| 🥇 2 | Aderyn | Estática (AST) | Práticas inseguras, estrutura |
| 🥇 3 | Semgrep | Estática (padrões) | Regras customizadas |
| 🥇 4 | Mythril | Concolica | Todos os caminhos de execução |
| 🥈 5a | Echidna | Fuzzing | Quebra de invariantes |
| 🥈 5b | Medusa | Fuzzing | Exploração de cobertura |
| 🤖 | Aderyn CI | CI/CD | Automação contínua |

---

## 3. Triagem com IA

Após a varredura automatizada, use o **DeepSeek-R1** para gerar um mapa de calor do código.

### Prompt de Triagem

```markdown
🤖 "Cline, carregue o prompt triagem em .cline/prompts/triage.md e analise o código em audits/NomeDoProtocolo/src/"
```

**O que o prompt faz:**  
O DeepSeek-R1 analisa o código-fonte e identifica os **5 pontos de maior risco**, classificando-os por severidade (🔴 🟡 🟢):

```markdown
# Mapa de Calor — NomeDoContrato

## 🔴 Ponto 1: [Mecanismo] em [Contrato.função():linha]
**Suspeita:** [descrição]
**Justificativa:** [1-2 frases]

## 🟡 Ponto 2: ...
## 🟢 Ponto 3: ...
```

**Saída:** `audits/NomeDoProtocolo/RELATORIO_ANALISE_INICIAL.md`

---

## 4. Análise Profunda com IA

Com o mapa de calor em mãos, mergulhe nos pontos identificados.

### 4.1 Caça de Bugs (DeepSeek)

```markdown
🤖 "Cline, carregue o prompt hunt_bugs em .cline/prompts/hunt_bugs.md e analise o código em audits/NomeDoProtocolo/src/"
```

**O que faz:**  
Revisão linha a linha com checklists carregados:
- `knowledge_base/checklists/reentrancy.md`
- `knowledge_base/checklists/access_control.md`
- `knowledge_base/checklists/oracle_manipulation.md`
- `knowledge_base/checklists/general_solidity.md`
- `knowledge_base/checklists/erc20_checklist.md` (se houver tokens)

**Saída:** Findings registrados em `audits/NomeDoProtocolo/findings/<severidade>.md`

### 4.2 Análise de Invariantes (DeepSeek)

```markdown
🤖 "Cline, carregue o prompt analyze_invariants em .cline/prompts/analyze_invariants.md e analise os invariantes em audits/NomeDoProtocolo/src/"
```

**O que faz:**  
Identifica invariantes financeiros e de estado que podem ser quebrados. Esses invariantes serão usados:
- Pelo Echidna (fuzzing de propriedades)
- Pelo Certora (verificação formal)
- Pelos testes unitários do Foundry

### 4.3 Debugging Simbólico (Simbolik)

```bash
# Instalar extensão Simbolik no VSCode
bash scripts/run_simbolik.sh NomeDoProtocolo --install

# Abrir o projeto no Simbolik
bash scripts/run_simbolik.sh NomeDoProtocolo --open
```

**O que faz:**  
O Simbolik é uma extensão do VSCode que permite **debugging simbólico** de contratos Solidity. Diferente do Mythril (que é automático), o Simbolik é interativo:
- Execute contratos passo a passo simbolicamente
- Explore todos os caminhos de execução possíveis
- Visualize constraints e branch conditions
- Ideal para entender vulnerabilidades complexas

**Por que foi adicionado:** Para debugging de vulnerabilidades sutis que ferramentas automáticas não conseguem explicar claramente.

---

## 5. Verificação Formal

Para contratos **críticos** (bridges, oráculos, mecanismos de consenso), use verificação formal para provar matematicamente que os invariantes são verdadeiros.

### 5.1 Certora Prover

```bash
# Configurar (já feito no template)
# audits/NomeDoProtocolo/poc/certora/conf/certora.conf
# audits/NomeDoProtocolo/poc/certora/specs/invariants.spec

# Executar verificação formal
certoraRun certora/conf/certora.conf
```

**O que faz:**  
O Certora Prover converte contratos Solidity e especificações (`.spec`) em **fórmulas lógicas** e usa SMT solvers para provar ou refutar cada regra.

**Invariantes de exemplo (do template):**

| Invariante | Descrição |
|:-----------|:----------|
| `totalSupplyEqualsSumOfBalances` | totalSupply == soma dos saldos |
| `minimumCollateralRatio` | Colateral >= dívida * ratio mínimo |
| `exchangeRateMonotonicallyIncreasing` | Taxa de câmbio nunca diminui |
| `onlyAuthorizedCanBurn` | Apenas endereços autorizados queimam tokens |
| `maxSupplyNotExceeded` | totalSupply <= MAX_SUPPLY |
| `cannotOperateWhenPaused` | Operações críticas revertem quando pausado |
| `onlyOwnerCanCallRestrictedFunctions` | Apenas owner chama funções restritas |

**Resultados possíveis:**
- ✅ **Proved** — Invariante provado matematicamente
- ❌ **Violated** — Contraexemplo encontrado (gera PoC automática)

### 5.2 Kontrol KEVM (Docker)

```bash
# Executar Kontrol via Docker
docker run -v $(pwd):/workspace runtimeverification/kontrol \
  prove --match-test "testInvariant" --mt NomeDoProtocolo
```

**O que faz:**  
O Kontrol (da Runtime Verification) usa o **KEVM** (semântica formal da EVM em K Framework) para verificar propriedades no nível de bytecode. Diferente do Certora (que trabalha no nível Solidity), o Kontrol:
- Opera no **bytecode real** que será implantado
- Considera o comportamento exato da EVM (incluindo gás, storage, logs)
- Detecta discrepâncias entre a intenção do Solidity e o comportamento real na EVM

**Por que foi adicionado:** Para verificação formal de contratos onde o bytecode precisa ser analisado (upgradeable proxies, contratos com assembly, otimizações do compilador).

---

## 6. Geração de PoCs

### 6.1 Escrever PoC com IA

```markdown
🤖 "Cline, carregue o prompt write_poc em .cline/prompts/write_poc.md e gere um PoC para o finding em audits/NomeDoProtocolo/findings/high/F-001_TITULO.md"
```

**O que faz:**  
O DeepSeek gera um contrato de ataque Foundry completo:

```solidity
// audits/NomeDoProtocolo/poc/test/ExploitNome.t.sol
contract ExploitNome is Test {
    function setUp() public {
        // Fork da mainnet
        vm.createSelectFork(vm.envString("RPC_URL"));
        
        // Setup do ataque
    }
    
    function testExploit() public {
        // Executa o ataque
        // Demonstra impacto financeiro
        console.log("Attacker balance after:", attacker.balance);
    }
}
```

### 6.2 Validar PoC Automaticamente

```bash
python scripts/validate_submission.py \
    --poc-dir audits/NomeDoProtocolo/poc \
    --poc-test test/ExploitNome.t.sol \
    --scope audits/NomeDoProtocolo/_docs/scope.json \
    --known-issues audits/NomeDoProtocolo/_docs/KNOWN_ISSUES.md \
    --finding "Título do Finding" \
    --fork-url $RPC_URL \
    --log
```

**O que valida (8 verificações, score 0-12):**

| # | Verificação | O que detecta |
|:--|:------------|:--------------|
| 1 | Uso de fork da mainnet | ❌ PoC sem `--fork-url` é rejeitado |
| 2 | Compilação (`forge build`) | ❌ PoC que não compila |
| 3 | Impacto financeiro | ❌ Sem logs de `balanceOf()` |
| 4 | Contratos in-scope | ❌ Ataca contrato fora do escopo |
| 5 | Uso de mocks | ❌ Mock do contrato alvo (deve ser real) |
| 6 | Teste de mitigação | ❌ Sem `vm.expectRevert()` com correção |
| 7 | Known issues | ❌ Finding já conhecido |
| 8 | Bibliotecas verificadas | ⚠️ Biblioteca já implementa a proteção |

**Score:**
- 🟢 **12/12** — Pronto para submeter
- 🟡 **9-11/12** — Risco moderado, revise
- 🔴 **< 9/12** — Alto risco de rejeição

---

## 7. Validação Pré-Submissão

### 7.1 Checklist de Validação

Revise manualmente o checklist em `knowledge_base/checklists/poc_validation.md`:

```markdown
## 🔬 1. Ambiente de Execução
- [ ] PoC executado com `forge test --fork-url <RPC> -vvvv`?
- [ ] PoC compila sem erros?
- [ ] PoC usa Foundry ou Hardhat?
- [ ] PoC não depende de mocks genéricos para o contrato alvo?

## 💰 2. Impacto Financeiro
- [ ] PoC demonstra alteração no saldo de tokens/ETH?
- [ ] PoC quantifica o valor perdido?
- [ ] PoC mostra estado antes e depois do ataque?

## 🛡️ 3. Mitigação
- [ ] PoC inclui teste que aplica correção e reverte?
- [ ] Correção proposta é específica e implementável?

## 🎯 4. Escopo
- [ ] Contrato atacado está in-scope?
- [ ] Vetor de ataque não está excluído?
- [ ] Finding não está listado como known issue?

## 📚 5. Bibliotecas e Dependências
- [ ] Bibliotecas herdadas foram verificadas?
- [ ] Versão do Solidity e dependências atualizada?

## 📝 6. Formatação
- [ ] PoC auto-contido em um único comando?
- [ ] Relatório inclui comando exato para reproduzir?
- [ ] Relatório inclui saída esperada dos logs?
- [ ] Relatório referencia fontes externas?
```

### 7.2 Verificar Padrões de Rejeição

Consulte `knowledge_base/rejection_patterns.md` para evitar erros já documentados:

| Padrão | Causa | Prevenção |
|:-------|:------|:----------|
| P-001 | PoC com mock do contrato alvo | ✅ `validate_submission.py` detecta |
| P-002 | PoC textual sem transações reais | ✅ Verificação de logs financeiros |
| P-003 | Escopo não verificado | ✅ Verificação de contratos in-scope |
| P-004 | Biblioteca já mitiga o risco | ✅ Verificação de bibliotecas |
| P-005 | PoC sem fork da mainnet | ✅ Verificação de `--fork-url` |

---

## 8. Submissão

### 8.1 Submissão Automática (HackerOne)

```bash
# Dry-run (testar sem enviar)
python scripts/submit_to_hackerone.py \
    --project NomeDoProtocolo \
    --program handle-do-programa \
    --token $HACKERONE_TOKEN \
    --username $HACKERONE_USERNAME \
    --dry-run

# Enviar todos os findings
python scripts/submit_to_hackerone.py \
    --project NomeDoProtocolo \
    --program handle-do-programa \
    --token $HACKERONE_TOKEN \
    --username $HACKERONE_USERNAME

# Enviar apenas High e Critical
python scripts/submit_to_hackerone.py \
    --project NomeDoProtocolo \
    --program handle-do-programa \
    --token $HACKERONE_TOKEN \
    --username $HACKERONE_USERNAME \
    --severity high

# Enviar em inglês com PoCs
python scripts/submit_to_hackerone.py \
    --project NomeDoProtocolo \
    --program handle-do-programa \
    --token $HACKERONE_TOKEN \
    --username $HACKERONE_USERNAME \
    --language en \
    --with-pocs
```

**O que faz:**  
Lê os arquivos de `audits/NomeDoProtocolo/findings/`, extrai cada finding estruturado, e envia via API do HackerOne com:
- Título, severidade, CVSS, CWE
- Descrição, código vulnerável, impacto, mitigação
- Asset identifier (URL do repositório)
- Tags para categorização

### 8.2 Submissão Manual (Immunefi / Code4rena / Sherlock)

Para plataformas sem API automatizada:

1. **Immunefi:** Submeta via formulário web em [immunefi.com](https://immunefi.com/)
2. **Code4rena:** Submeta via GitHub Issues no repositório do concurso
3. **Sherlock:** Submeta via [app.sherlock.xyz](https://app.sherlock.xyz/)

Em todos os casos, use o relatório gerado em `audits/NomeDoProtocolo/submissions/` como base.

---

## 🔄 Fluxo Completo (Resumo)

```
1. Setup
   ├── bash scripts/init_audit.sh NomeDoProtocolo
   └── git clone <repo> repo_temp/NomeDoProtocolo

2. Varredura (5 camadas)
   ├── bash scripts/run_slither.sh NomeDoProtocolo
   ├── bash scripts/run_aderyn.sh NomeDoProtocolo
   ├── bash scripts/run_semgrep.sh NomeDoProtocolo
   ├── bash scripts/run_mythril.sh NomeDoProtocolo
   ├── bash scripts/run_echidna.sh NomeDoProtocolo
   └── bash scripts/run_medusa.sh NomeDoProtocolo

3. Triagem IA
   └── 🤖 "Carregue triagem.md e analise audits/NomeDoProtocolo/src/"

4. Análise Profunda
   ├── 🤖 "Carregue hunt_bugs.md e analise audits/NomeDoProtocolo/src/"
   ├── 🤖 "Carregue analyze_invariants.md"
   └── bash scripts/run_simbolik.sh NomeDoProtocolo --open

5. Verificação Formal
   ├── certoraRun certora/conf/certora.conf
   └── docker run runtimeverification/kontrol prove ...

6. PoCs
   ├── 🤖 "Carregue write_poc.md para o finding F-001"
   └── python scripts/validate_submission.py --poc-dir ...

7. Validação
   ├── Revise knowledge_base/checklists/poc_validation.md
   └── Consulte knowledge_base/rejection_patterns.md

8. Submissão
   ├── python scripts/submit_to_hackerone.py --project NomeDoProtocolo ...
   └── Ou submeta manualmente na plataforma alvo
```

---

## 📚 Referências

- [Slither — Trail of Bits](https://github.com/crytic/slither)
- [Aderyn — Cyfrin](https://github.com/Cyfrin/aderyn)
- [Semgrep — r2c](https://semgrep.dev/)
- [Mythril — Consensys](https://github.com/Consensys/mythril)
- [Echidna — Trail of Bits](https://github.com/crytic/echidna)
- [Medusa — Trail of Bits](https://github.com/crytic/medusa)
- [Certora Prover](https://www.certora.com/)
- [Kontrol KEVM — Runtime Verification](https://github.com/runtimeverification/kontrol)
- [Simbolik — VSCode Extension](https://marketplace.visualstudio.com/items?itemName=TrailofBits.simbolik)
- [Foundry — Paradigm](https://book.getfoundry.sh/)
- [Immunefi Submission Standards](https://immunefi.com/)
- [HackerOne API](https://api.hackerone.com/)
