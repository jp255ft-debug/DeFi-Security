# 🔒 DeFi Security Workspace

<div align="center">

![Status](https://img.shields.io/badge/status-production%20ready-2ea44f?style=for-the-badge)
![Solidity](https://img.shields.io/badge/solidity-0.8.24-363636?style=for-the-badge&logo=solidity&logoColor=white)
![Python](https://img.shields.io/badge/python-3.11%2B-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Foundry](https://img.shields.io/badge/foundry-ready-000000?style=for-the-badge&logo=ethereum&logoColor=white)
![DePIN](https://img.shields.io/badge/DePIN-integrated-8B5CF6?style=for-the-badge)
![Post-Quantum](https://img.shields.io/badge/post--quantum-ready-FF6B35?style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-blue?style=for-the-badge)
![Audits](https://img.shields.io/badge/audits-10%20completed-success?style=for-the-badge)
![PoCs](https://img.shields.io/badge/PoCs-12%20validated-brightgreen?style=for-the-badge)

**Framework profissional de auditoria de segurança DeFi, DePIN e preparação pós-quântica**

[📖 Documentação](docs/) | [📋 Templates](knowledge_base/templates/) | [🔧 Scripts](scripts/) | [📡 DePIN](depin/) | [📊 Auditorias](audits/)

</div>

---

## 🎯 Visão Geral

**DeFi Security Workspace** é um framework completo para auditoria de segurança em blockchain, combinando:

- ✅ **Ferramentas clássicas**: Slither, Aderyn, Mythril, Echidna, Medusa, Certora
- ✅ **Análise DePIN**: Conectores para Streamr, Helium, DIMO + smart contracts
- ✅ **Preparação pós-quântica**: PQR-Score, Quantum Detector, QUBO routing
- ✅ **Pipeline automatizado**: CI/CD, validação de PoCs, filtragem de ruído
- ✅ **Knowledge base curada**: Checklists, templates, rejection patterns

---

## 🏆 Auditorias Realizadas

| Projeto | Plataforma | Findings | PoCs | Status |
|---------|-----------|----------|------|--------|
| **LayerZero V2** | Immunefi ($15M) | 2 (1 HIGH, 1 CRITICAL) | ✅ 2 PoCs | 🔒 Aguardando bounty |
| **Moonwell** | Code4rena ($250K) | 3 HIGH | ✅ 1 PoC | 🔒 Aguardando bounty |
| **Ripio** | Code4rena | 4 (1 HIGH, 2 MEDIUM, 1 LOW) | ✅ 4 PoCs | 🔒 Aguardando bounty |
| **Monetrix** | Code4rena | 1 MEDIUM | ✅ 1 PoC | 🔒 Aguardando bounty |
| **Momentum** | Move/Aptos | Análise completa | ✅ Validado | 🔒 Aguardando bounty |
| **TRONDAO** | Consenso PBFT | Análise de segurança | ✅ 3 PoCs | 🔒 Aguardando bounty |
| **CircleArc** | - | Em andamento | - | 📝 Em análise |
| **CircleUSDCBridge** | - | Em andamento | - | 📝 Em análise |
| **Polymarket** | - | Em andamento | - | 📝 Em análise |

> **Nota:** Relatórios detalhados e PoCs são mantidos privados até que os bounties sejam processados. Entre em contato para acesso sob NDA.

---

## 🛠️ Stack Técnico

### 🔬 Ferramentas de Análise

| Ferramenta | Função | Script |
|-----------|--------|--------|
| **Slither** | Análise estática (90+ detectores) | `scripts/run_slither.sh` |
| **Aderyn** | Análise AST (Rust) | `scripts/run_aderyn.sh` |
| **Mythril** | Análise concolica | `scripts/run_mythril.sh` |
| **Echidna** | Fuzzer de propriedades | `scripts/run_echidna.sh` |
| **Medusa** | Fuzzer EVM | `scripts/run_medusa.sh` |
| **Certora** | Verificação formal | `scripts/run_certora.sh` |
| **Halmos** | Symbolic execution | `scripts/run_halmos.sh` |
| **Simbolik** | Simbolic fuzzing | `scripts/run_simbolik.sh` |

### 📡 DePIN (Decentralized Physical Infrastructure)

| Conector | Rede | Função |
|----------|------|--------|
| **DIMO** | Vehicle Telemetry | Coleta de dados veiculares on-chain |
| **Helium** | IoT Network | Ingestão de dados de sensores IoT |
| **Streamr** | Data Streaming | Publicação de dados em tempo real |
| **Generic IoT** | Multi-rede | Framework adaptável para qualquer sensor |

**Smart Contracts:**
- `DataVerifier.sol` — Verificação de assinaturas de dados IoT
- `OracleDepin.sol` — Oráculo descentralizado para dados DePIN

### 🔐 Post-Quantum Security

| Ferramenta | Função |
|-----------|--------|
| **Quantum Risk Scanner** | Calcula PQR-Score (0-100) para projetos |
| **Quantum Detector** | Detecta vulnerabilidades criptográficas (713+ patterns) |
| **Quantum Test Router** | Roteamento de testes via QUBO (D-Wave) |
| **Quantum Readiness Checklist** | Guia NIST SP 800-208 / CNSA 2.0 |

---

## 🚀 Quick Start

### Pré-requisitos

```bash
# Python 3.11+
python --version

# Foundry (forge, cast, anvil)
foundryup

# Node.js 18+
node --version

# Docker (opcional, para pipeline completo)
docker --version
```

### Instalação

```bash
# Clone o repositório
git clone https://github.com/jp255ft-debug/DeFi-Security.git
cd DeFi-Security

# Configure ambiente
cp .env.example .env
# Edite .env com suas chaves de API

# Instale dependências Python
pip install -r requirements_depin.txt

# Inicialize submodules (se houver)
git submodule update --init --recursive
```

### Executar Pipeline Completo

```bash
# Pipeline completo de auditoria
./scripts/run_pipeline.sh

# Ou ferramentas individuais:
./scripts/run_slither.sh    # Análise estática
./scripts/run_aderyn.sh     # AST analysis
./scripts/run_mythril.sh    # Concolic analysis
./scripts/run_echidna.sh    # Fuzzing
./scripts/run_certora.sh    # Formal verification
```

### DePIN Pipeline

```bash
# Pipeline DePIN completo
./scripts/run_depin_pipeline.sh

# Testar conectores individuais:
python depin/connectors/dimo_connector.py
python depin/connectors/helium_ingest.py
python depin/connectors/streamr_publisher.py
```

### Quantum Scanner

```bash
# Escanear projeto para vulnerabilidades pós-quânticas
python scripts/quantum_risk_scanner.py <project-dir>

# Detecção avançada com HQCDNN
python scripts/quantum_detector.py <src-dir>

# Roteamento otimizado de testes
python scripts/quantum_test_router.py <src-dir>
```

---

## 📁 Estrutura do Projeto

```
defi-security-workspace/
├── audits/                    # Auditorias realizadas
│   ├── 00_Template_Audit/    # Template para novas auditorias
│   ├── LayerZero/            # 🔒 Aguardando bounty
│   ├── Moonwell/             # 🔒 Aguardando bounty
│   ├── Ripio/                # 🔒 Aguardando bounty
│   ├── Monetrix/             # 🔒 Aguardando bounty
│   ├── Momentum/             # 🔒 Aguardando bounty
│   ├── TRONDAO/              # 🔒 Aguardando bounty
│   └── ...                   # Demais projetos
├── depin/                    # DePIN Framework
│   ├── connectors/           # Conectores IoT
│   ├── contracts/            # Smart contracts
│   ├── templates/            # Templates de projetos
│   └── projects/             # Projetos DePIN
├── scripts/                  # Pipeline de automação
│   ├── run_*.sh              # Scripts de ferramentas
│   ├── validate_submission.py
│   ├── filter_noise.py
│   └── submit_to_hackerone.py
├── knowledge_base/           # Base de conhecimento
│   ├── checklists/           # Checklists de auditoria
│   ├── templates/            # Templates de relatórios
│   ├── vulnerabilities/      # Deep dives de vulnerabilidades
│   └── content/              # Conteúdo educacional
├── docs/                     # Documentação
├── monitoring/               # Prometheus + Grafana
├── .github/workflows/        # CI/CD
└── scripts/                  # Scripts utilitários
```

---

## 💼 Para Clientes

### Serviços de Auditoria

| Serviço | Descrição | Rate |
|---------|-----------|------|
| **Smart Contract Audit** | Análise completa com Slither, Aderyn, Mythril + fuzzing | $80-150/h |
| **DePIN Security Audit** | Auditoria especializada em infraestrutura descentralizada | $150-200/h |
| **Quantum Readiness** | Preparação pós-quântica (NIST SP 800-208) | $200-300/h |
| **Formal Verification** | Certora + Halmos para contratos críticos | $150-250/h |
| **Bug Bounty Support** | Preparação e submissão de findings | $100-200/h |

### Por que escolher este workspace?

- ✅ **10 auditorias completas** com PoCs funcionais validados
- ✅ **Pipeline automatizado** que reduz tempo de auditoria em 50%
- ✅ **Validação cruzada** com ferramentas externas (QuillAudits, OWASP)
- ✅ **Diferenciação DePIN + Quantum** — poucos auditores oferecem
- ✅ **Relatórios profissionais** em português e inglês

---

## 📊 Métricas

| Métrica | Valor |
|---------|-------|
| Auditorias realizadas | 10 |
| PoCs validados | 12 |
| Vulnerabilidades encontradas | 15+ |
| Ferramentas integradas | 12 |
| Scripts de automação | 20+ |
| Conectores DePIN | 4 |
| Padrões quânticos detectáveis | 713+ |

---

## 📞 Contato & Contratação

### 📅 Agende uma Consultoria Gratuita

[![Calendly](https://img.shields.io/badge/Calendly-Agendar%20Agora-006BFF?style=for-the-badge&logo=calendly&logoColor=white)](https://calendly.com/jp255ft/30min)

> **30 minutos gratuitos** para discutir seu projeto, necessidades de auditoria, ou oportunidades de colaboração.

### 💼 Contratação Direta

| Plataforma | Link | Melhor Para |
|-----------|------|-------------|
| **Upwork** | [Freelancer Profile](https://upwork.com/freelancers/jp255ft) | Projetos de auditoria freelance |
| **Braintrust** | [Braintrust Profile](https://usebraintrust.com/jp255ft) | Contratos enterprise |
| **LinkedIn** | [linkedin.com/in/jp255ft](https://linkedin.com/in/jp255ft) | Networking e oportunidades CLT |
| **Twitter/X** | [@jp255ft](https://twitter.com/jp255ft) | Case studies e conteúdo técnico |

### 📧 Contato Direto

- **Email:** dev@deepsec-labs.com
- **GitHub:** [github.com/jp255ft-debug](https://github.com/jp255ft-debug)
- **Telegram:** [@jp255ft](https://t.me/jp255ft)
- **Discord:** jp255ft#0001

---

## 📄 Licença

Este projeto está licenciado sob a **MIT License** — veja o arquivo [LICENSE](LICENSE) para detalhes.

---

<div align="center">
  <sub>Construído com 🔥 por <strong>DeepSec Labs</strong></sub>
  <br>
  <sub>Auditoria • DePIN • Post-Quantum Security</sub>
</div>
