# Reentrância Somente-Leitura (Read-Only Reentrancy)

## Descrição
Uma função `view` é chamada durante uma execução de transação no mesmo bloco e retorna um estado inconsistente porque o contrato malicioso reentrou e alterou o estado antes que a operação original fosse finalizada. Impacta principalmente oráculos e pools de liquidez.

## Exemplo com AMM (simplificado)

```solidity
contract DEX {
    mapping(address => uint256) public reserves;

    function swap(address tokenIn, address tokenOut, uint256 amountIn) external {
        // ... lógica de swap
        IERC20(tokenOut).transfer(msg.sender, amountOut); // chamada externa
        // reservas atualizadas DEPOIS
    }

    function getPrice(address token) external view returns (uint256) {
        return reserves[token] / totalSupply;
    }
}
```

Um atacante pode iniciar um swap, e durante a transferência do callback, chamar `getPrice`, obtendo um preço antes de as reservas serem atualizadas, usando esse preço para outra operação no mesmo bloco.

## Mitigação
- Usar `nonReentrant` mesmo em funções que não parecem críticas
- Implementar snapshots de estado para leituras consistentes
