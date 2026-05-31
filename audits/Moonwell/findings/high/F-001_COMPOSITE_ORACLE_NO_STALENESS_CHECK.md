# F-001: ChainlinkCompositeOracle — Ausência de Verificação de Staleness (Obsolecência)

**Severidade:** HIGH
**Contrato:** `ChainlinkCompositeOracle.sol`
**Arquivo:** `audits/Moonwell/src/src/oracles/ChainlinkCompositeOracle.sol`
**Linhas:** 180-195

---

## Descrição

O `ChainlinkCompositeOracle.getPriceAndDecimals()` não verifica se o preço retornado pela Chainlink está obsoleto (stale). Ele apenas valida:

```solidity
bool valid = price > 0 && answeredInRound == roundId;
require(valid, "CLCOracle: Oracle data is invalid");
```

**Problema:** A função **não verifica `updatedAt`** (timestamp da última atualização). Um feed Chainlink que não é atualizado há horas/dias retornará um preço antigo, e o oráculo composto aceitará esse preço como válido.

## Comparação com ChainlinkOracle.sol

O `ChainlinkOracle.sol` (contrato irmão) **faz** a verificação de staleness corretamente:

```solidity
// ChainlinkOracle.sol linha 101-104
(, int256 answer, , uint256 updatedAt, ) = AggregatorV3Interface(feed).latestRoundData();
require(answer > 0, "Chainlink price cannot be lower than 0");
require(updatedAt != 0, "Round is in incompleted state");
```

O `ChainlinkCompositeOracle` **omite** essa verificação, criando uma inconsistência entre os dois oráculos.

## Impacto

- Se um feed Chainlink parar de ser atualizado (ex: cbETH/ETH feed congelar), o `ChainlinkCompositeOracle` continuará retornando o último preço conhecido como se fosse atual.
- Um atacante pode explorar isso em cenários de alta volatilidade, onde o preço real do ativo se move, mas o oráculo composto retorna um preço desatualizado.
- **Contexto MIP-X43:** O ataque de fevereiro/2026 que causou perda de US$ 1.78M foi exatamente sobre configuração incorreta do oráculo cbETH. Uma verificação de staleness adicional teria mitigado o impacto.

## Prova de Conceito

```solidity
// O ChainlinkCompositeOracle não rejeita preços stale
// Enquanto o ChainlinkOracle rejeitaria
function testStalePriceNotDetected() public {
    // Simular um feed que retorna preço mas com updatedAt = 0
    // ChainlinkCompositeOracle.getPriceAndDecimals() aceitaria
    // ChainlinkOracle.getChainlinkPrice() rejeitaria com "Round is in incompleted state"
}
```

## Recomendação

Adicionar verificação de staleness em `getPriceAndDecimals()`:

```solidity
function getPriceAndDecimals(address oracleAddress) public view returns (int256, uint8) {
    (
        uint80 roundId,
        int256 price,
        ,
        uint256 updatedAt,
        uint80 answeredInRound
    ) = AggregatorV3Interface(oracleAddress).latestRoundData();
    bool valid = price > 0 && answeredInRound == roundId && updatedAt != 0;
    require(valid, "CLCOracle: Oracle data is invalid");
    uint8 oracleDecimals = AggregatorV3Interface(oracleAddress).decimals();
    return (price, oracleDecimals);
}
```
