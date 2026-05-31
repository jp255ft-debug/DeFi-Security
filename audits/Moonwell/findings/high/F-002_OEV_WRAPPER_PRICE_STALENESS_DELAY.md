# F-002: ChainlinkOEVWrapper — Mecanismo de Delay de Preço Pode Causar Liquidações Injustas

**Severidade:** HIGH
**Contrato:** `ChainlinkOEVWrapper.sol`
**Arquivo:** `audits/Moonwell/src/src/oracles/ChainlinkOEVWrapper.sol`
**Linhas:** 209-256

---

## Descrição

O `ChainlinkOEVWrapper.latestRoundData()` implementa um mecanismo que **atrasa a propagação de novos preços** para capturar OEV (Oracle Extractable Value). Quando um novo round está disponível mas não foi "pago" via `updatePriceEarlyAndLiquidate()`, o wrapper retorna dados de rounds anteriores:

```solidity
if (roundId != cachedRoundId && block.timestamp < updatedAt + maxRoundDelay) {
    uint256 currentRoundId = roundId - 1;
    for (uint256 i = 0; i < maxDecrements && currentRoundId > 0; i++) {
        try priceFeed.getRoundData(uint80(currentRoundId)) returns (...) {
            // retorna dados do round anterior
            break;
        } catch {
            currentRoundId--;
        }
    }
}
```

**Problema:** Este mecanismo pode atrasar a propagação de **quedas de preço**, permitindo que posições que deveriam ser liquidadas permaneçam abertas com colateral insuficiente. Se o preço cai drasticamente, o wrapper esconde essa queda até que alguém pague para atualizar.

## Impacto

1. **Atraso na liquidação:** Se o preço do colateral cai 50%, mas o wrapper continua retornando o preço antigo por até `maxRoundDelay` segundos, posições undercollateralized não são liquidadas.
2. **Perda para o protocolo:** Durante o atraso, um usuário pode sacar seu colateral subvalorizado ou um atacante pode manipular o mercado.
3. **Sequestro de liquidação:** Apenas quem paga a taxa OEV pode liquidar usando o preço real, criando um monopólio de liquidação.

## Cenário de Ataque

1. Preço do colateral cai 30% em 1 minuto
2. `ChainlinkOEVWrapper` continua retornando o preço antigo (pré-queda)
3. Nenhum liquidator paga para atualizar (`updatePriceEarlyAndLiquidate`)
4. Usuários com posições undercollateralized podem sacar fundos ou tomar mais empréstimos
5. Quando finalmente alguém atualiza, o prejuízo já é maior

## Recomendação

- Implementar um **fallback** que force a atualização se o preço cair abaixo de um limite (ex: >5% em relação ao round anterior)
- Ou limitar o `maxRoundDelay` a no máximo 30 segundos
- Adicionar um mecanismo de emergência que permita ao protocolo forçar a atualização sem taxa
