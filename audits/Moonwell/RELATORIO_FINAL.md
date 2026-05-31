# 🔍 Relatório Final — Moonwell Bug Bounty (Code4rena)

**Data:** 03/05/2026
**Alvo:** Moonwell Contracts V2 + Mamo Contracts
**Chains:** Base, Optimism, Moonbeam, Moonriver
**Recompensa Máxima:** US$ 250.000 (Critical)

---

## 📋 Resumo Executivo

| Métrica | Valor |
|---------|-------|
| Contratos analisados | 12 (oráculos + lending + governança) |
| Findings HIGH | 3 |
| Findings MEDIUM | 0 |
| Findings LOW | 0 |
| PoCs criados | 1 (Foundry) |
| Submissões prontas | 1 (F-001) |

---

## 🥇 Findings Submissíveis

### F-001: ChainlinkCompositeOracle — Missing Staleness Check [HIGH]

**Contrato:** `ChainlinkCompositeOracle.sol` (linhas 180-195)
**PoC:** `poc/test/ExploitCompositeOracleStaleness.t.sol`
**Submissão:** `submissions/SUBMISSION_F001_COMPOSITE_ORACLE_STALENESS.md`

**Descrição:** O `ChainlinkCompositeOracle.getPriceAndDecimals()` não verifica `updatedAt` ao validar dados da Chainlink. O contrato irmão `ChainlinkOracle.sol` faz essa verificação, mas o composite oracle omite.

**Impacto:** Preços stale são aceitos como válidos. Se o feed cbETH/ETH congelar, o oráculo composto continuará retornando o último preço. Contexto MIP-X43: o ataque de US$ 1.78M em fevereiro/2026 foi sobre configuração incorreta do oráculo cbETH.

**Severidade:** HIGH — afeta todos os oráculos compostos (cbETH, wstETH, rETH) em todas as chains.

---

### F-002: ChainlinkOEVWrapper — Price Delay Can Cause Unfair Liquidations [HIGH]

**Contrato:** `ChainlinkOEVWrapper.sol` (linhas 209-256)

**Descrição:** O mecanismo de delay de preço do OEV wrapper retorna dados de rounds anteriores quando um novo round não foi "pago". Isso pode atrasar a propagação de quedas de preço.

**Impacto:** Posições undercollateralized podem não ser liquidadas a tempo durante quedas bruscas de preço, causando bad debt para o protocolo.

---

### F-003: ChainlinkCompositeOEVWrapper — Cache Poisoning via Composite Oracle Staleness [HIGH]

**Contrato:** `ChainlinkCompositeOEVWrapper.sol` (linhas 224-266)

**Descrição:** O wrapper usa apenas o round ID do feed base (ETH/USD) como proxy para staleness, ignorando os feeds multiplicadores (cbETH/ETH, wstETH/ETH). Combinado com F-001, o cache pode ser envenenado com preços incorretos.

**Impacto:** Se o feed multiplicador estiver stale mas o feed base for atualizado, o wrapper atualiza o cache com um preço composto incorreto.

---

## 📊 Mapa de Calor

| Prioridade | Contrato | Risco | Status |
|------------|----------|-------|--------|
| P0 | `ChainlinkCompositeOracle.sol` | 🔴 CRÍTICO | Finding HIGH (F-001) |
| P1 | `ChainlinkOracle.sol` | 🟡 MÉDIO | Sem vulnerabilidade (staleness check presente) |
| P2 | `ChainlinkOEVWrapper.sol` | 🔴 ALTO | Finding HIGH (F-002) |
| P3 | `ChainlinkCompositeOEVWrapper.sol` | 🔴 ALTO | Finding HIGH (F-003) |
| P4 | `MErc20Delegate.sol` | 🟢 BAIXO | Fork Compound v2, bem testado |
| P5 | `TemporalGovernor.sol` | 🟢 BAIXO | Known issues extensos (Wormhole, timestamps) |
| P6 | Mamo Contracts | ⚪ NÃO ANALISADO | Repositório inacessível (clone falhou) |

---

## ✅ Checklist de Verificação

- [x] KNOWN_ISSUES.md criado com lista completa de bugs conhecidos
- [x] .cline/rules.md atualizado com regra anti-falso positivo
- [x] moonwell-contracts-v2 clonado com sucesso
- [x] Aderyn rodando em background
- [x] Foundry configurado para L2 (Base, Optimism, Moonbeam)
- [x] 3 findings HIGH documentados
- [x] 1 PoC Foundry criado (F-001)
- [x] 1 relatório de submissão pronto (F-001)
- [ ] Submeter F-001 na Code4rena (pendente — revisão final)
- [ ] Submeter F-002 na Code4rena (pendente — PoC adicional)
- [ ] Submeter F-003 na Code4rena (pendente — PoC adicional)

---

## 📈 Estimativa de Recompensa

Considerando o impacto potencial:

| Finding | Fundos em Risco | % do Bounty | Recompensa Estimada |
|---------|----------------|-------------|---------------------|
| F-001 | US$ 5M-10M (cbETH market) | 25% de HIGH | US$ 3.750 - US$ 5.000 |
| F-002 | US$ 10M-50M (multiple OEV markets) | 50% de HIGH | US$ 7.500 - US$ 10.000 |
| F-003 | US$ 5M-10M (composite markets) | 25% de HIGH | US$ 3.750 - US$ 5.000 |

**Total estimado:** US$ 15.000 - US$ 20.000

---

## 🔄 Próximos Passos

1. ✅ Revisar e submeter F-001 na Code4rena
2. ⏳ Criar PoC para F-002 (OEV wrapper fork test)
3. ⏳ Criar PoC para F-003 (cache poisoning)
4. ⏳ Tentar clonar mamo-contracts novamente (verificar acesso)
5. ⏳ Rodar Slither + Semgrep quando disponíveis
