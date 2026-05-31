# Checklist de Primitivos DeFi

## AMM (Automated Market Maker)
- Invariante: `x * y >= k` (ou similar).
- Funções de swap devem aplicar taxa e proteger contra desvio de fundos.
- Verificar que a função `sync()` não pode ser usada para manipular preços sem custo.

## Lending (Empréstimos)
- Colateralização: `colateral * preço / dívida >= ratio mínimo`.
- Liquidações: líquidador deve poder executar mesmo em congestionamento de rede.
- Manipulação de oráculo pode subvalorizar colateral e permitir saque de fundos.

## Staking / Yield Farming
- Recompensas: verificar que não é possível drenar recompensas via "flash staking" (depositar e sacar no mesmo bloco).
- `emergencyWithdraw` não deve permitir bypass de penalidades.

## Bridges (Pontes)
- Validação de assinaturas de oráculos/validadores: verificar ataques de replay (nonce, chainId).
- Se um lado valida depósito e libera tokens no outro, validar atomicidade.

## Estratégia Geral
- Sempre modelar o fluxo de fundos: de onde vem o dinheiro, para onde vai, quem pode interromper.
