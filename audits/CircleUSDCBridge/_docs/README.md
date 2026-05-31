# Circle USDC Bridge (CCTP V2) — Documentação

## Visão Geral

O **Cross-Chain Transfer Protocol (CCTP)** da Circle é um mecanismo de bridge que permite a transferência de USDC entre diferentes blockchains através de um modelo **burn-and-mint**: o USDC é queimado na chain de origem e mintado na chain de destino.

## Contratos Principais

| Contrato | Endereço (Ethereum Mainnet) | Função |
|---|---|---|
| **TokenMessengerV2** | `0x28b5a0e9C621a5BadaA536219b3a228C8168cf5d` | Entrada para queima de USDC na source chain |
| **MessageTransmitterV2** | `0x81D40F21F12A8F0E3252Bccb954D722d4c464B64` | Camada de mensageria que recebe e valida atestações |
| **TokenMinterV2** | Endereço varia por chain | Responsável por cunhar USDC na chain de destino |
| **USDC (Ethereum)** | `0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48` | Token estável nativo da Circle |

## Fluxo de Funcionamento

1. Usuário chama `depositForBurn()` no `TokenMessengerV2` na chain de origem
2. O USDC é queimado (burn) e um evento `BurnMessage` é emitido
3. Um relayer coleta a mensagem e obtém uma atestação dos atestadores da Circle
4. A atestação é submetida ao `MessageTransmitterV2` na chain de destino via `receiveMessage()`
5. O `TokenMinterV2` cunha (mint) o USDC equivalente na chain de destino

## Invariante Central

```
total USDC queimado na source chain == total USDC mintado na destination chain
```

## Contexto de Segurança

- **Bridges são o alvo #1 em 2026**: US$ 1,0B+ em perdas no ano
- **KelpDAO (2026)**: US$ 292M — exploit em mecanismo burn-and-mint
- **Noble-CCTP (2024)**: Vulnerabilidade que permitia mintar US$ 35M falsos
- **Deploy determinístico**: Endereços são os mesmos em todas as chains EVM (CREATE2)

## Versão do Solidity

Os contratos CCTP V2 usam **Solidity ^0.8.16**.

## Repositório Oficial

https://github.com/circlefin/evm-cctp-contracts
