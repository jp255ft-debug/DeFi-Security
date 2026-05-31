# F-003: ChainlinkCompositeOEVWrapper — Cache Poisoning via Composite Oracle Staleness

**Severidade:** HIGH
**Contrato:** `ChainlinkCompositeOEVWrapper.sol`
**Arquivo:** `audits/Moonwell/src/src/oracles/ChainlinkCompositeOEVWrapper.sol`
**Linhas:** 224-266, 365-497

---

## Descrição

O `ChainlinkCompositeOEVWrapper` usa o **round ID do feed base** (ex: ETH/USD) como proxy para determinar se o preço composto está desatualizado. No entanto, o **ChainlinkCompositeOracle** (que ele envolve) **não verifica staleness** (conforme F-001). Isso cria uma vulnerabilidade composta:

1. O `ChainlinkCompositeOracle` retorna preços sem verificar `updatedAt` (F-001)
2. O `ChainlinkCompositeOEVWrapper` confia no round ID do feed base para decidir se deve usar o cache
3. Se o feed base tem um novo round, mas o feed multiplicador (ex: cbETH/ETH) está stale, o wrapper atualiza o cache com um preço composto **incorreto**

## Fluxo do Ataque

```
1. Feed ETH/USD é atualizado (novo roundId)
2. Feed cbETH/ETH está stale (não atualizado há horas)
3. ChainlinkCompositeOracle retorna: ETH/USD_novo × cbETH/ETH_stale = preço composto INCORRETO
4. ChainlinkCompositeOEVWrapper detecta novo roundId no feed base
5. Wrapper atualiza cachedCompositePrice com o preço composto incorreto
6. Liquidators usam este preço incorreto para liquidações
```

## Impacto

- **Preço composto pode ser manipulado** se qualquer um dos feeds componentes estiver stale
- O wrapper não valida se **todos** os feeds componentes estão atualizados — apenas verifica o feed base
- Pode causar liquidações injustas ou perda de fundos

## Prova de Conceito

```solidity
// ChainlinkCompositeOEVWrapper só verifica roundId do baseFeed
// Mas o compositeOracle pode ter 2 ou 3 feeds internos
// Se multiplier/secondMultiplier estiverem stale, o preço composto é inválido

// No constructor (linha 162):
(uint80 initBaseRoundId, , , , ) = baseFeed.latestRoundData();
// Só verifica baseFeed, não os outros feeds

// No latestRoundData (linha 237-238):
(uint80 baseRoundId, , , uint256 baseUpdatedAt, ) = baseFeed.latestRoundData();
// Só verifica baseFeed para decidir se o cache é válido
```

## Recomendação

O `ChainlinkCompositeOEVWrapper` deve verificar se **todos** os feeds do `ChainlinkCompositeOracle` estão atualizados, não apenas o feed base. Uma abordagem seria:

1. Armazenar os endereços de `multiplier` e `secondMultiplier` no wrapper
2. Verificar `updatedAt` de cada feed antes de atualizar o cache
3. Se qualquer feed estiver stale, rejeitar a atualização do cache
