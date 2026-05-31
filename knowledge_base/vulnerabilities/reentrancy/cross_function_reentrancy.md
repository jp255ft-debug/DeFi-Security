# Reentrância Cruzada de Funções

## Descrição
Duas funções compartilham estado. Uma delas faz uma chamada externa enquanto a outra depende do estado que ainda não foi atualizado, permitindo reentrada via função diferente.

## Exemplo

```solidity
contract Lending {
    mapping(address => uint256) public collateral;
    mapping(address => uint256) public debt;

    function borrow(uint256 amount) external {
        require(collateral[msg.sender] * 2 >= debt[msg.sender] + amount, "Undercollateralized");
        debt[msg.sender] += amount;
        IERC20(token).transfer(msg.sender, amount); // chamada externa
    }

    function withdrawCollateral() external {
        require(debt[msg.sender] == 0, "Debt not zero");
        uint256 amount = collateral[msg.sender];
        collateral[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
```

Ataque: Se `borrow` fizer a transferência antes de atualizar a dívida, um atacante pode usar reentrada para chamar `withdrawCollateral` enquanto a dívida ainda é 0.

## Mitigação
- Usar `ReentrancyGuard` em todas as funções que interagem externamente
- Seguir estritamente CEI (Checks-Effects-Interactions)
