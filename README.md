# 🛡️ DeFi Security Workspace

**Framework de Auditoria de Segurança DeFi — Stack Exclusivamente DeepSeek**

[![Status](https://img.shields.io/badge/Status-Ativo-brightgreen)]()
[![Licença](https://img.shields.io/badge/Licença-MIT-blue)]()
[![DeepSeek](https://img.shields.io/badge/IA-DeepSeek%20R1%2FV3-orange)]()
[![Foundry](https://img.shields.io/badge/Testes-Foundry-red)]()

---

## 📋 Sobre

Este workspace é um ambiente completo para auditoria de contratos inteligentes **DeFi** e desenvolvimento de infraestrutura **DePIN** (Decentralized Physical Infrastructure Networks), combinando:

- **🤖 DeepSeek-R1 / V3** — Análise lógica, caça de bugs e geração de PoCs
- **🔧 Ferramentas Clássicas** — Slither, Aderyn, Mythril
- **📚 Base de Conhecimento Curada** — Checklists, exploits reais, templates
- **📋 Pipeline Estruturado** — Do escopo ao relatório final

---

## 💰 Para Clientes Pagantes

### 🔒 Serviços de Auditoria DeFi

| Benefício | Detalhe |
|---|---|
| 🧠 **IA especializada** | DeepSeek R1 para invariantes + V3 para caça de bugs |
| 🔧 **Multi-ferramenta** | Slither (90+ detectores) + Aderyn (AST) + Mythril (concolico) |
| 🧪 **PoCs funcionais** | Provas de conceito executáveis em Foundry |
| 📊 **Relatório profissional** | Findings com CVSS, código de correção, cronograma |
| ⏱️ **Rápido** | Relatório em 48h para contratos de até 500 linhas |

### 🌐 Serviços de Infraestrutura DePIN

| Serviço | Inclui | Prazo |
|:--------|:-------|:------|
| 🟢 **DePIN Quick Start** | Projeto configurado + pipeline funcional | 1 dia |
| 🟡 **DePIN Standard** | Quick Start + contratos customizados + auditoria | 1 semana |
| 🔴 **DePIN Enterprise** | Standard + PoCs + monitoramento + suporte | 2 semanas |

> 📖 Veja detalhes técnicos em [🌐 Infraestrutura DePIN](#-infraestrutura-depin-decentralized-physical-infrastructure-networks)

### 📈 O Mercado

- Mercado de auditoria: **US$ 1,8 bilhão** (2026) → **US$ 9,6 bilhões** (2034)
- **US$ 620M+** roubados em abril/2026 (aumento de 68%)
- ROI típico de auditoria: **2.000x a 20.000x**

### 📞 Contato

> Precisa auditar seu protocolo ou construir infraestrutura DePIN? Me chame!
>
> 📧 [seu-email@exemplo.com]
> 🐦 [@seuTwitter]

---

## 🚀 Setup Rápido

### Pré-requisitos

```bash
# Essencial
winget install --id=Foundry.Foundry    # forge + anvil
pip install slither-analyzer            # Análise estática
pip install mythril                     # Análise concolica

# Opcional
winget install --id=GitHub.cli          # gh CLI
cargo install aderyn                    # Análise AST (Rust)
```

### Dependências DePIN (Python)

```bash
pip install -r requirements_depin.txt
```

### Configuração da API DeepSeek

```bash
export DEEPSEEK_API_KEY='sua-chave-aqui'
```

---

## 📁 Estrutura do Projeto

```
defi-security-workspace/
├── .cline/                    # 🧠 Orquestração DeepSeek
│   ├── rules.md               # Regras mestras
│   └── prompts/               # Prompts especializados
├── depin/                     # 🌐 Camada DePIN (NOVO)
│   ├── connectors/            # Conectores Python (Streamr, Helium, DIMO, IoT)
│   ├── contracts/             # Smart contracts Solidity
│   │   └── test/              # Testes Foundry
│   ├── templates/             # Checklists, vulnerabilidades, relatórios
│   │   └── 00_Template_Project/  # Template de projeto clonável
│   └── projects/              # Projetos DePIN ativos
├── knowledge_base/            # 📚 Cérebro externo
│   ├── checklists/            # Roteiros de auditoria
│   ├── vulnerabilities/       # Deep dives + exploits reais
│   ├── evmbench/              # Benchmark de vulnerabilidades
│   └── templates/             # Templates de relatório + vendas
├── scripts/                   # ⚙️ Automação
│   ├── init_depin_project.sh  # 🌐 Inicializa projeto DePIN (NOVO)
│   ├── deploy_verifier.sh     # 🌐 Deploy do DataVerifier (NOVO)
│   └── run_depin_pipeline.sh  # 🌐 Pipeline completo DePIN (NOVO)
├── audits/                    # 🔬 Projetos auditados
│   ├── 00_Template_Audit/     # Template clonável
│   └── 01_Example_Protocol/   # Exemplo real (case study)
├── requirements_depin.txt     # 🌐 Dependências Python DePIN (NOVO)
├── CASE_STUDY_GUIDE.md        # 📢 Guia de publicação
├── .gitignore
└── README.md
```

---

## 🔄 Fluxo de Trabalho

### 1. Iniciar Nova Auditoria

```bash
cd scripts
./init_audit.sh NomeDoProtocolo
```

### 2. Copiar Contratos

Copie os contratos alvo para `audits/NomeDoProtocolo/src/`

### 3. Varredura Automatizada

```bash
./run_slither.sh NomeDoProtocolo
./run_aderyn.sh NomeDoProtocolo
./run_mythril.sh NomeDoProtocolo
./run_echidna.sh NomeDoProtocolo         # Fuzzer de propriedades (Trail of Bits)
./run_medusa.sh NomeDoProtocolo          # Fuzzer EVM (Trail of Bits)
./run_simbolik.sh NomeDoProtocolo        # Debugging simbólico VSCode
./run_aderyn_ci.sh NomeDoProtocolo       # CI automatizado (GitHub Actions)
```

> 💡 O **Aderyn CI** (`.github/workflows/aderyn_ci.yml`) executa automaticamente a cada push/pull request na `main`, gerando relatórios em `audits/*/findings/automated/aderyn_ci_report.md`.

### 4. Análise com IA (via Cline)

```bash
# No Cline, use os prompts:
# - "Analise invariantes do contrato Oracle.sol"
# - "Cace bugs no LendingPool.sol"
# - "Escreva PoC para a reentrância encontrada"
```

### 5. Gerar Relatório Final

Consolide os findings em `final_report.md`

---

## 🌐 Avaliação STRIDE — Solana

**Programa oficial da Solana Foundation** — Avaliação Contínua de Segurança baseada em 8 pilares.

> Lançado em abril de 2026, o STRIDE é um programa de avaliação contínua de segurança para o ecossistema Solana, cobrindo desde segurança de programas Anchor/Sealevel até governança, oráculos, infraestrutura e resposta a incidentes.

### 📊 Os 8 Pilares STRIDE

| # | Pilar | Foco |
|:--|:------|:-----|
| P1 | 🔐 Segurança do Programa | Anchor/Sealevel, Account Validation, CPI Safety, PDAs |
| P2 | 🏛️ Governança e Controle de Acesso | Multi-sig, Timelock, Role-Based Access, Key Rotation |
| P3 | 📡 Risco de Oráculo | Pyth, Switchboard, Staleness, TWAP, Circuit Breaker |
| P4 | 🖥️ Infraestrutura | RPC, Validadores, DDoS Protection, Gas Management |
| P5 | 🔗 Supply Chain | Dependências, Reproducible Build, CI/CD Security |
| P6 | 🔑 Segurança Operacional | Key Storage, Upgrade Authority, Incident Response |
| P7 | 📊 Monitoramento e Resposta | On-Chain Monitoring, Alerting, Emergency Upgrade |
| P8 | 📝 Logs e Análise Forense | Event Emission, Transaction Tracing, Compliance |

### 🚀 Iniciar uma Avaliação STRIDE

```bash
cd scripts
./init_stride_audit.sh NomeDoProtocolo
```

### 📋 Fluxo STRIDE Recomendado

1. **Inicie** com `init_stride_audit.sh` (cria estrutura de diretórios)
2. **Copie** os programas para `programs/`
3. **Escaneie** com `bash STRIDE_NomeDoProtocolo/scripts/run_scan.sh` (Soteria + Anchor Lint + Cargo Audit)
4. **Avalie** cada pilar com o checklist `knowledge_base/checklists/stride_checklist.md`
5. **Documente** findings no template `knowledge_base/templates/stride_report_template.md`
6. **Reporte** ao cliente com pontuação por pilar (0-10) e score geral (/80)

### 🛠️ Ferramentas Solana

| Ferramenta | Uso | Instalação |
|:-----------|:----|:-----------|
| **Soteria** | Análise estática de programas Solana | `cargo install soteria` |
| **Anchor Lint** | Linter para projetos Anchor | Incluso no Anchor CLI |
| **Trident** | Fuzzing de programas Solana | `cargo install trident` |
| **Cargo Audit** | Varredura de dependências | `cargo install cargo-audit` |

### 📈 Serviço Premium

Oferecemos avaliações STRIDE completas como serviço premium para clientes Solana:

| Serviço | Inclui | Prazo |
|:--------|:-------|:------|
| 🟢 **STRIDE Quick Scan** | Varredura automatizada + checklist | 24h |
| 🟡 **STRIDE Standard** | Quick Scan + análise manual dos 8 pilares | 1 semana |
| 🔴 **STRIDE Premium** | Standard + PoCs + relatório executivo + reavaliação | 2 semanas |

---

## ⚛️ Preparação Pós-Quântica (PQC)

Prepare seus protocolos para a era da computação quântica com nosso pipeline de 3 ondas:

### 🥇 Onda 1 — Scanner PQC (Imediata)

```bash
# Escaneia contratos em busca de algoritmos vulneráveis (ECDSA, RSA, Ed25519)
./scripts/run_pqaudit.sh NomeDoProtocolo

# Gera relatório executivo alinhado ao NIST/CNSA 2.0
# Use o template: knowledge_base/templates/post_quantum_audit_report.md
```

### 🥈 Onda 2 — PQR-Score (Curto Prazo)

```bash
# Automatiza o checklist quantum_readiness.md e calcula o índice de risco
./scripts/quantum_risk_scanner.py NomeDoProtocolo
```

### 🥉 Onda 3 — Motor QML + Otimizador (Longo Prazo)

```bash
# Detecção de vulnerabilidades com HQCDNN (F1-score ~96.6%)
./scripts/quantum_detector.py --model hqcdnn --dataset audits/NomeDoProtocolo/src/

# Otimização quântica da suíte de testes via D-Wave Leap
./scripts/quantum_test_router.py --fuzz audits/NomeDoProtocolo/src/ --optimize
```

### 📋 Fluxo PQC Recomendado

1. **Escaneie** com `run_pqaudit.sh` (detecta algoritmos vulneráveis)
2. **Trie** com o prompt `quantum_triage.md` via DeepSeek-R1
3. **Avalie** com o checklist `quantum_readiness.md`
4. **Reporte** usando o template `knowledge_base/templates/post_quantum_audit_report.md`

---

---

## 🌐 Infraestrutura DePIN (Decentralized Physical Infrastructure Networks)

**Nova camada de conectividade com o mundo real** — Construa pontes entre dispositivos IoT, veículos, sensores e a blockchain.

### 🏗️ Arquitetura

```
[Dispositivo/Sensor] → [Conector Python] → [Assinatura Web3] → [Rede DePIN] → [Smart Contract]
                                                                                      ↓
                                                                              [Verificação On-Chain]
```

### 🔌 Conectores Disponíveis

| Conector | Descrição | SDK |
|:---------|:----------|:----|
| **Streamr** | Publica dados em tempo real na rede Streamr | `streamr-client` |
| **Helium** | Consome dados IoT da rede Helium | `helium-api-wrapper` |
| **DIMO** | Obtém telemetria de veículos conectados | `dimo-python-sdk` |
| **Generic IoT** | Template para qualquer dispositivo/sensor | `requests` + `paho-mqtt` |
| **Sign & Send** | Assina dados com ECDSA e envia on-chain | `web3.py` + `eth-account` |

### 📦 Smart Contracts

| Contrato | Descrição |
|:---------|:----------|
| **DataVerifier.sol** | Verifica assinaturas ECDSA on-chain via `ecrecover` |
| **OracleDepin.sol** | Oracle descentralizado com sistema de disputas (optimistic) |

### 🚀 Iniciar um Projeto DePIN

```bash
# 1. Crie um novo projeto
./scripts/init_depin_project.sh MeuProjeto --streamr

# 2. Instale dependências
pip install -r requirements_depin.txt

# 3. Compile contratos
cd depin/contracts && forge build

# 4. Execute o pipeline (dry-run)
./scripts/run_depin_pipeline.sh MeuProjeto --dry-run

# 5. Faça deploy do contrato
./scripts/deploy_verifier.sh --rpc <RPC_URL> --private-key <KEY>
```

### 🔄 Pipeline DePIN

O pipeline completo executa 4 etapas:

```bash
./scripts/run_depin_pipeline.sh MeuProjeto
```

1. **Coleta** — Conector obtém dados do dispositivo/API
2. **Assinatura** — Dados são assinados com wallet Ethereum
3. **Publicação** — Dados assinados vão para Streamr/blockchain
4. **Verificação** — Smart contract valida a assinatura on-chain

### 📋 Templates e Checklists

| Recurso | Descrição |
|:--------|:----------|
| `depin/templates/depin_checklist.md` | ✅ Checklist completo de projeto DePIN |
| `depin/templates/depin_vulnerabilities.md` | 🚫 Base de vulnerabilidades DePIN |
| `depin/templates/depin_report_template.md` | 📊 Template de relatório DePIN |
| `depin/templates/00_Template_Project/` | 📁 Template de projeto clonável |

### 🔒 Segurança DePIN

- **Assinatura EIP-191**: Dados assinados com prefixo Ethereum padrão
- **Anti-replay**: Nonce/timestamp na mensagem assinada
- **ecrecover**: Verificação on-chain da assinatura
- **Authorized Signers**: Apenas wallets autorizadas podem submeter dados
- **Challenge Period**: Sistema de disputas para dados incorretos

### 📈 Serviço Premium DePIN

| Serviço | Inclui | Prazo |
|:--------|:-------|:------|
| 🟢 **DePIN Quick Start** | Projeto configurado + pipeline funcional | 1 dia |
| 🟡 **DePIN Standard** | Quick Start + contratos customizados + auditoria | 1 semana |
| 🔴 **DePIN Enterprise** | Standard + PoCs + monitoramento + suporte | 2 semanas |

---

## 🧠 Entendendo os Prompts

| Prompt | Modelo | Uso |
|---|---|---|
| `analyze_invariants.md` | DeepSeek-R1 | Análise lógica profunda |
| `hunt_bugs.md` | DeepSeek-R1/V3 | Caça de vulnerabilidades |
| `write_poc.md` | DeepSeek | Geração de PoCs |
| `quantum_triage.md` | DeepSeek-R1 | ⚛️ Triagem de risco quântico |

---

## 📊 Avaliação (EVMbench)

Teste a performance do DeepSeek contra 120 vulnerabilidades reais:

```bash
./scripts/eval_evmbench.sh --model deepseek-r1
```

---

## 📢 Case Study

Veja o relatório completo do **Example Protocol** — um protocolo de lending pool com 6 vulnerabilidades encontradas (3 High, 2 Medium, 1 Gas):

📄 [`audits/01_Example_Protocol/final_report.md`](audits/01_Example_Protocol/final_report.md)

Para publicar seu próprio case study, siga o guia:
📄 [`CASE_STUDY_GUIDE.md`](CASE_STUDY_GUIDE.md)

---

## 💼 Assets de Vendas

| Arquivo | Descrição |
|---|---|
| `knowledge_base/templates/sales_pitch_template.md` | Template de proposta comercial |
| `knowledge_base/templates/immunefi_report_template.md` | Template para bug bounty |
| `knowledge_base/templates/audit_report_template.md` | Template de relatório completo |
| `knowledge_base/templates/finding_template.md` | Template de finding individual |
| `knowledge_base/templates/post_quantum_audit_report.md` | ⚛️ Template de relatório de auditoria PQC |
| `depin/templates/depin_report_template.md` | 🌐 Template de relatório DePIN |
| `depin/templates/depin_checklist.md` | ✅ Checklist de projeto DePIN |
| `depin/templates/depin_vulnerabilities.md` | 🚫 Base de vulnerabilidades DePIN |
| `CASE_STUDY_GUIDE.md` | Guia de publicação e marketing |

## ✅ Validação de Submissão (Mercado 2026)

Pipeline de validação obrigatório antes de qualquer submissão para bug bounty:

```bash
# 1. Validação automática (8 verificações)
python scripts/validate_submission.py --poc-dir audits/Protocolo/poc

# 2. Validação completa com escopo e known issues
python scripts/validate_submission.py \
    --poc-dir audits/Protocolo/poc \
    --poc-test test/ExploitX.t.sol \
    --scope audits/Protocolo/_docs/scope.json \
    --known-issues audits/Protocolo/_docs/KNOWN_ISSUES.md \
    --finding "Título do Finding" \
    --log
```

### 📋 Recursos de Validação

| Recurso | Descrição |
|---|---|
| `knowledge_base/checklists/poc_validation.md` | ✅ Checklist manual de 12 itens (Immunefi/Code4rena/Sherlock) |
| `scripts/validate_submission.py` | 🤖 Validador automático (fork, compilação, impacto financeiro, escopo, mocks, mitigação) |
| `knowledge_base/rejection_patterns.md` | 🚫 Base de conhecimento de padrões de rejeição (5 documentados) |

### 🎯 Score de Validação

| Score | Status | Ação |
|:---|:---|:---|
| 12/12 | 🟢 Pronto para submeter | Submeta o relatório |
| 9-11/12 | 🟡 Risco moderado | Revise os itens faltantes |
| < 9/12 | 🔴 Alto risco de rejeição | Não submeta — corrija primeiro |


---

## 🤝 Contribuindo

1. Adicione novos checklists em `knowledge_base/checklists/`
2. Documente exploits reais em `knowledge_base/vulnerabilities/`
3. Melhore os prompts em `.cline/prompts/`
4. Crie novos conectores DePIN em `depin/connectors/`
5. Contribua com templates DePIN em `depin/templates/`

---

## ⚠️ Aviso

Este workspace é para **fins educacionais e de auditoria profissional**. Os contratos vulneráveis no `01_Example_Protocol` são propositalmente inseguros para demonstração. Não use em produção.

---

**Feito com ☕ por auditores DeFi**
