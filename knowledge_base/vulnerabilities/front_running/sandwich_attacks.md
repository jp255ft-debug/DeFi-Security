# Sandwich Attacks (Ataques Sanduíche)

## Descrição
Um atacante observa uma transação pendente na mempool, insere sua própria transação antes (front-run) e depois (back-run) para lucrar com o deslizamento de preço causado pela transação da vítima.

## Como Funciona
1. **Vítima** envia uma transação de swap grande (ex: comprar Token A com ETH).
2. **Atacante** (bot) vê a transação na mempool.
3. **Front-run:** Atacante compra Token A antes da vítima, elevando o preço.
4. **Vítima** compra Token A a um preço inflado (sofre slippage).
5. **Back-run:** Atacante vende Token A após a vítima, lucrando com a diferença.

## Mitigação
- Usar slippage protection (`minAmountOut`)
- Implementar commit-reveal schemes
- Usar private mempools (Flashbots, MEV Blocker)
- Usar AMMs com proteção contra MEV (ex: CowSwap)

## Código de Exemplo (Atacante)

```solidity
contract SandwichBot {
    IUniswapV2Router router;
    
    function sandwich(address tokenIn, address tokenOut, uint256 amountIn) external {
        // Front-run: comprar antes
        router.swapExactTokensForTokens(amountIn, 0, path, address(this), block.timestamp);
        
        // Aguardar transação da vítima (no mesmo bloco)
        
        // Back-run: vender depois
        router.swapExactTokensForTokens(amountOut, 0, reversePath, address(this), block.timestamp);
    }
}
```
