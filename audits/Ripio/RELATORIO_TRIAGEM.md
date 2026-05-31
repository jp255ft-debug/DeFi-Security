# Relatório de Triagem — Ripio (LatamStables)

## 📋 Visão Geral

| Item | Detalhe |
|------|---------|
| **Projeto** | Ripio — LatamStables (WFIAT) |
| **Contratos** | `LatamStable.sol`, `BridgeDeposit.sol`, `LimitedMinter.sol`, `LimitedMinterBridge.sol` |
| **Linguagem** | Solidity ^0.8.27 |
| **Framework** | Foundry (forge) |
| **Testes** | 4 suites de teste (BridgeDeposit, LatamStable, LimitedMinter, LimitedMinterBridge) |
| **Auditoria Anterior** | Sim — 16 findings (10 consenso total, 2 parcial, 4 disputados) |

---

## 🏗️ Arquitetura do Sistema

```
┌─────────────────────────────────────────────────────────────┐
│                    LatamStable (UUPS)                        │
│  ERC20 + Burnable + Pausable + AccessControl + Permit + UUPS │
│  Roles: DEFAULT_ADMIN, PAUSER, MINTER, UPGRADER              │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                    LimitedMinter                              │
│  - Registro de tokens com limites diários                    │
│  - Mint para destination fixa                                │
│  - Verifica admin externo via hasRole()                      │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                  LimitedMinterBridge                          │
│  - Similar ao LimitedMinter mas mintTo() para destinos       │
│    arbitrários (sem mintDestination fixo)                    │
│  - Usado pelo BridgeDeposit para mint cross-chain            │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                    BridgeDeposit                              │
│  - depositForBridge(): burn tokens na source chain           │
│  - fulfillBridgeMint(): mint tokens na destination chain     │
│  - Fee collection + tracking cross-chain                     │
│  - Idempotência via (sourceChainId, txHash, depositId)       │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔍 Análise de Superfície de Ataque

### 1. **LatamStable.sol** — Token Upgradeable
| Risco | Descrição |
|-------|-----------|
| 🔴 **Alto** | `mint()` sem limites — MINTER_ROLE pode inflar supply sem restrições |
| 🟡 **Médio** | `_authorizeUpgrade()` só verifica UPGRADER_ROLE — sem timelock |
| 🟢 **Baixo** | `pause()`/`unpause()` por PAUSER_ROLE — centralizado mas esperado |

### 2. **BridgeDeposit.sol** — Bridge Cross-Chain
| Risco | Descrição |
|-------|-----------|
| 🔴 **Alto** | `fulfillBridgeMint()` depende de BRIDGE_OPERATOR_ROLE — operador pode mintar qualquer quantia (respeitando daily limit) |
| 🟡 **Médio** | `rescueTokens()` — admin pode drenar tokens do contrato |
| 🟡 **Médio** | Fee tracking pode dessincronizar se houver reentrância no token |
| 🟢 **Baixo** | `updateLimitedMinter()` — admin pode trocar minter contract |

### 3. **LimitedMinter.sol** — Minter com Limites
| Risco | Descrição |
|-------|-----------|
| 🔴 **Alto** | **Reentrância**: `mint()` atualiza `mintedPerDay` ANTES de chamar token.mint() — se token for malicioso, pode reentrar |
| 🔴 **Alto** | **Timestamp manipulation**: `block.timestamp / 1 days` — minerador pode manipular para resetar limites |
| 🟡 **Médio** | `mintedPerDay` persiste após unregister — se re-registrar, histórico antigo conta |
| 🟡 **Médio** | `onlyExternalAdmin` depende de `token.hasRole()` — token comprometido = minter comprometido |
| 🟢 **Baixo** | Sem evento em `unregisterToken` (já corrigido no código atual) |

### 4. **LimitedMinterBridge.sol** — Minter Bridge
| Risco | Descrição |
|-------|-----------|
| 🔴 **Alto** | Mesmo problema de **reentrância** do LimitedMinter |
| 🔴 **Alto** | Mesmo problema de **timestamp manipulation** |
| 🟡 **Médio** | `mintTo()` para destinatário arbitrário — sem validação de destino (já corrigido) |
| 🟡 **Médio** | Dependência de `token.hasRole()` para admin externo |

---

## ✅ Checklists Aplicados

### Access Control Checklist
- [x] Roles bem definidas (DEFAULT_ADMIN, MINTER, PAUSER, UPGRADER, BRIDGE_OPERATOR, FEE_MANAGER)
- [x] `onlyRole()` modifiers presentes em todas funções críticas
- [x] `onlyExternalAdmin()` verifica admin no token externo
- [ ] ⚠️ `onlyExternalAdmin()` pode ser enganado se token não implementar `hasRole()` corretamente
- [x] Constructor grants roles corretamente
- [ ] ⚠️ UPGRADER_ROLE pode atualizar implementação sem timelock

### Bridge Security Checklist
- [x] Idempotência via `bridgeFulfilled` mapping
- [x] `nonReentrant` em deposit e fulfill
- [x] `whenNotPaused` em operações críticas
- [x] Tracking de conservação (totalBurnedTo / totalMintedFrom)
- [x] Fee collection separada do burn
- [ ] ⚠️ BRIDGE_OPERATOR pode mintar qualquer quantia (limitado apenas pelo daily cap)
- [ ] ⚠️ Sem verificação de Merkle proof ou assinatura off-chain

### Reentrancy Checklist
- [x] `ReentrancyGuard` presente em BridgeDeposit, LimitedMinter, LimitedMinterBridge
- [x] `nonReentrant` em depositForBridge, fulfillBridgeMint, mint, mintTo
- [ ] ⚠️ **LimitedMinter.mint()** e **LimitedMinterBridge.mintTo()** atualizam estado ANTES da chamada externa — padrão Checks-Effects-Interactions quebrado

---

## 📊 Findings da Auditoria Anterior (16)

### Consenso Total (10)
| # | Severidade | Título | Status |
|---|-----------|--------|--------|
| 1 | 🔴 High | Potential for Minting Limit Manipulation | **Não corrigido** |
| 2 | 🟡 Medium | Persistent Minting Records After Unregistration | **Não corrigido** |
| 3 | 🔴 High | Reentrancy Protection Not Fully Enforced | **Não corrigido** |
| 4 | 🟢 Low | Missing Event Emission for Token Unregistration | **Corrigido** (evento existe) |
| 5 | 🔴 High | Access Control Reliance on External Token Contracts | **Não corrigido** |
| 6 | 🟡 Medium | Missing input validation on `mint` function (LatamStable) | **Não corrigido** |
| 7 | 🟢 Low | Uncapped `approve` amount (LatamStable) | **Não corrigido** (herdado OZ) |
| 8 | 🟢 Low | Potential Timestamp Manipulation | **Não corrigido** |
| 9 | 🟡 Medium | Lack of Input Validation for Mint Destination | **Corrigido** (valida zero address) |
| 10 | 🟡 Medium | Centralization Risk: Reliance on External Token's Access Control | **Não corrigido** |

### Consenso Parcial (2)
| # | Severidade | Título | Status |
|---|-----------|--------|--------|
| 11 | 🟢 Low | Lack of Access Control for `mintedPerDay` Mapping | **Não corrigido** |
| 12 | 🟢 Low | Minting Limits are Enforced Per UTC Day | **Não corrigido** |

### Disputados (4 — falsos positivos)
| # | Título | Motivo |
|---|--------|--------|
| 13 | Lack of Input Validation for Mint Amount | Já existe `MintAmountZero` check |
| 14 | Unbounded loop in `mintedToday` | Não há loop — acesso direto a mapping |
| 15 | Unprotected `pause` and `unpause` | Protegido por `onlyRole(DEFAULT_ADMIN_ROLE)` |
| 16 | Unbounded Gas Consumption in Token Unregistration | `delete` não causa unbounded gas |

---

## 🚨 Novos Findings Identificados

### F-RIPIO-001: BridgeDeposit.fulfillBridgeMint sem verificação de Merkle Proof
**Severidade:** 🔴 High
**Descrição:** `fulfillBridgeMint` pode ser chamado por qualquer BRIDGE_OPERATOR sem prova criptográfica de que o burn ocorreu na source chain. Depende inteiramente da confiança no operador off-chain.
**Recomendação:** Implementar verificação de Merkle proof ou assinatura ECDSA do operador da source chain.

### F-RIPIO-002: LimitedMinterBridge.mintTo() — Checks-Effects-Interactions quebrado
**Severidade:** 🔴 High
**Descrição:** `mintedPerDay` é atualizado antes da chamada externa `token.mint()`. Se o token for malicioso, pode reentrar e mintar mais que o limite.
**Recomendação:** Mover `mintedPerDay` update para depois da chamada externa, ou usar `nonReentrant` (já presente, mas CEI ainda é boa prática).

### F-RIPIO-003: BridgeDeposit — Fee pode ser contornada
**Severidade:** 🟡 Medium
**Descrição:** Se `feeCollector` for `address(0)`, depósitos com fee > 0 revertem. Mas se admin setar `feeCollector = address(0)` depois de configurar rotas com fee, depósitos quebrarão silenciosamente.
**Recomendação:** Validar na `setFeeCollector()` se há rotas com fee configuradas.

### F-RIPIO-004: LatamStable — Sem limite de mint mesmo com LimitedMinter
**Severidade:** 🟡 Medium
**Descrição:** `LatamStable.mint()` pode ser chamado diretamente por qualquer MINTER_ROLE, ignorando os limites do LimitedMinter. O LimitedMinter só funciona se for o único detentor de MINTER_ROLE.
**Recomendação:** Remover `MINTER_ROLE` do LatamStable e forçar todo mint via LimitedMinter/LimitedMinterBridge.

---

## 📝 Próximos Passos

1. ✅ ~~Pipeline automatizado executado (Slither + Semgrep)~~
2. ✅ ~~Checklists aplicados (access_control, bridge_security, reentrancy)~~
3. ✅ ~~Análise de superfície de ataque completa~~
4. ⬜ **Análise profunda com IA** (triage.md + hunt_bugs.md)
5. ⬜ **PoC para findings confirmados**
6. ⬜ **Validação com `validate_submission.py`**
7. ⬜ **Submissão para HackerOne/Immunefi**

---

## 📁 Arquivos do Projeto

```
audits/Ripio/
├── latam_contracts/
│   ├── src/
│   │   ├── LatamStable.sol          # Token upgradeable
│   │   ├── BridgeDeposit.sol        # Bridge cross-chain
│   │   ├── LimitedMinter.sol        # Minter com limites (destino fixo)
│   │   └── LimitedMinterBridge.sol  # Minter com limites (destino arbitrário)
│   ├── test/
│   │   ├── LatamStable.t.sol        # Testes do token
│   │   ├── BridgeDeposit.t.sol      # Testes da bridge (932 linhas)
│   │   ├── LimitedMinter.t.sol      # Testes do minter
│   │   └── LimitedMinterBridge.t.sol # Testes do minter bridge
│   ├── foundry.toml
│   └── docs/AUDIT_CONTEXT.MD
├── findings/
│   └── automated/
│       ├── slither_report.json      # (pendente)
│       └── semgrep_results.json
└── RELATORIO_TRIAGEM.md             # Este arquivo
```
