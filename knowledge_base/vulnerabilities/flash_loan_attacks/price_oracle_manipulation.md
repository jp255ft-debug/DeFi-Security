# Manipulação de Oráculo de Preço via Flash Loan

## Descrição
Um atacante usa um flash loan para obter uma grande quantidade de tokens, manipula o preço em um AMM (via swap), e então executa uma operação que depende desse preço manipulado (como empréstimo, liquidação, etc.), tudo no mesmo bloco.

## Exemplo de Código Vulnerável

```solidity
contract Lending {
    IUniswapV2Pair public pair;
    
    function getPrice() public view returns (uint256) {
        (uint256 reserve0, uint256 reserve1,) = pair.getReserves();
        return reserve0 * 1e18 / reserve1; // preço spot manipulável
    }

    function borrow() external {
        uint256 price = getPrice();
        uint256 collateral = IERC20(collateralToken).balanceOf(address(this));
        require(collateral * price >= debt * 1.5e18, "Undercollateralized");
        // ... lógica de empréstimo
    }
}
```

## Ataque Passo a Passo
1. Pegue flash loan de token0.
2. Venda token0 no par, desbalanceando reservas e elevando temporariamente o preço de token1.
3. Chame `borrow` — o `getPrice()` retornará valor inflado, fazendo o contrato acreditar que há colateral suficiente.
4. Pegue empréstimo de token1, pague flash loan e lucre.

## Mitigação
- Usar TWAP (Time-Weighted Average Price) em vez de preço spot
- Usar Chainlink Price Feeds
- Implementar verificações de sanidade nos preços
