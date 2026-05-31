# DoS por Loops Não Limitados

## Descrição
Um contrato itera sobre um array que pode crescer indefinidamente. Um atacante pode inflar o array (ex: criando muitas posições) até que a função iteradora exceda o limite de gas do bloco, tornando-a impossível de executar.

## Exemplo Vulnerável

```solidity
contract Staking {
    address[] public stakers;
    mapping(address => uint256) public balances;

    function distributeRewards() external {
        for (uint256 i = 0; i < stakers.length; i++) {
            // ❌ Loop sobre array dinâmico
            uint256 reward = calculateReward(stakers[i]);
            IERC20(token).transfer(stakers[i], reward);
        }
    }

    function stake(uint256 amount) external {
        if (balances[msg.sender] == 0) {
            stakers.push(msg.sender); // Array cresce indefinidamente
        }
        balances[msg.sender] += amount;
    }
}
```

## Mitigação
- Evitar loops sobre arrays dinâmicos
- Usar paginação (processar em lotes)
- Usar pull over push (cada usuário saca suas recompensas individualmente)
