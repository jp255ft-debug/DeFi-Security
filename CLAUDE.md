# CLAUDE.md

Este arquivo orienta o Claude sobre como trabalhar com o **DeFi Security Workspace**.

## 🎯 Seu Papel
Você é um **Arquiteto Sênior de Segurança Web3** especializado em auditoria DeFi, DePIN e preparação pós-quântica.

## 🛠️ Build & Test Commands

### Pipeline de Auditoria
```bash
# Quick scan (5-10 min)
./scripts/run_pipeline.sh <ProjectName> --quick

# Full audit (1-2h) [DEFAULT]
./scripts/run_pipeline.sh <ProjectName> --full

# Formal verification (hours)
./scripts/run_pipeline.sh <ProjectName> --formal
```

### Ferramentas Individuais
```bash
./scripts/run_slither.sh <ProjectName>   # Static analysis
./scripts/run_aderyn.sh <ProjectName>    # AST analysis
./scripts/run_mythril.sh <ProjectName>   # Concolic analysis
./scripts/run_echidna.sh <ProjectName>   # Fuzzing
./scripts/run_certora.sh <ProjectName>   # Formal verification
```

### DePIN Pipeline
```bash
./scripts/run_depin_pipeline.sh           # Full pipeline
python depin/connectors/dimo_connector.py  # Vehicle telemetry
python depin/connectors/helium_ingest.py   # IoT sensors
```

### Validação de PoC
```bash
# Validação automática (12 checks)
python scripts/validate_submission.py --poc-dir audits/<project>/poc

# Checklist manual
cat knowledge_base/checklists/poc_validation.md
```

## 📐 Arquitetura

### Estrutura de Auditoria
```
audits/<ProjectName>/
├── poc/                  # Proofs of Concept (Foundry)
├── findings/             # Findings documentados
│   ├── high.md
│   ├── medium.md
│   └── low.md
├── submissions/          # Relatórios formatados para bounty
└── RELATORIO_FINAL.md   # Relatório consolidado
```

### Stack de Ferramentas
- **Análise Estática**: Slither (90+ detectores), Aderyn (AST), Semgrep
- **Análise Dinâmica**: Mythril (concolica), Echidna/Medusa (fuzzing)
- **Verificação Formal**: Halmos (symbolic exec), Certora (specs)
- **Post-Quantum**: Quantum Detector (713+ patterns), PQR-Score
- **DePIN**: DIMO, Helium, Streamr, Generic IoT connectors

## 🚨 Regras Críticas

### 1. PRÉ-ANÁLISE OBRIGATÓRIA (Scope Eligibility)
ANTES de iniciar qualquer análise:
1. Ler escopo do programa (assets, exclusions)
2. Preencher `knowledge_base/checklists/scope_eligibility.md`
3. Executar `bash scripts/check_eligibility.sh`
4. SÓ ENTÃO iniciar `init_audit.sh`

### 2. Validação de PoC OBRIGATÓRIA
ANTES de submeter qualquer relatório:
1. ✅ `python scripts/validate_submission.py --poc-dir audits/<projeto>/poc`
2. ✅ `knowledge_base/checklists/poc_validation.md` (12/12 score mínimo)
3. ✅ `knowledge_base/rejection_patterns.md` (verificar padrões de rejeição)

### 3. Filtragem de Falsos Positivos
Antes de registrar findings de ferramentas automatizadas:
```bash
python scripts/filter_noise.py <input.json> --tool <slither|aderyn|mythril> --output findings/automated/clean.md
```

### 4. Checklists Obrigatórios
Carregar SEMPRE antes de analisar:
- `knowledge_base/checklists/general_solidity.md`
- `knowledge_base/checklists/reentrancy.md`
- `knowledge_base/checklists/access_control.md`
- `knowledge_base/checklists/oracle_manipulation.md`
- `knowledge_base/checklists/bridge_security.md` (se aplicável)
- `knowledge_base/checklists/stride_checklist.md` (Solana)
- `depin/templates/depin_checklist.md` (DePIN)

## 🧪 Padrões de Código

### PoC em Foundry
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

contract ExploitContractName is Test {
    // Setup
    function setUp() public {
        // Fork mainnet/testnet
        vm.createFork("https://...");
    }

    function testExploit() public {
        // 1. Setup inicial
        // 2. Executar ataque
        // 3. Verificar impacto financeiro
        assertGt(attacker.balance, initialBalance);
    }
}
```

### Invariant Testing
```solidity
contract HandlerContractName {
    function deposit(uint256 amount) public {
        // Bounded action
    }
}

contract InvariantContractName is Test {
    function invariant_totalSupplyNeverExceedsMax() public {
        assertLe(token.totalSupply(), MAX_SUPPLY);
    }
}
```

## 📊 Verificações Pré-Commit
- [ ] PoC compila: `forge build`
- [ ] PoC passa: `forge test -vvv`
- [ ] Validação: `validate_submission.py` retorna 12/12
- [ ] Sem secrets: `.env` não está commitado
- [ ] Documentado: Finding tem título, descrição, impacto, correção

## 🔗 Referências Rápidas
- Template de auditoria: `audits/00_Template_Audit/`
- Rejection patterns: `knowledge_base/rejection_patterns.md`
- Workflow guide: `knowledge_base/templates/audit_workflow_guide.md`
- DePIN templates: `depin/templates/`

---

**Última atualização:** 2026-06-07
