# Falta de Modificador em Função Crítica

## Descrição
Funções que alteram parâmetros críticos do protocolo (taxas, donos, limites) não possuem modificadores de acesso, permitindo que qualquer usuário as execute.

## Exemplo

```solidity
contract Staking {
    address public owner;
    uint256 public rewardRate;

    function setRewardRate(uint256 _rate) external { // ❌ sem onlyOwner
        rewardRate = _rate;
    }
}
```

Ataque: Qualquer um pode chamar `setRewardRate` e alterar para 0 ou um valor extremo, quebrando o staking.

## Mitigação
```solidity
modifier onlyOwner {
    require(msg.sender == owner, "Not owner");
    _;
}

function setRewardRate(uint256 _rate) external onlyOwner {
    rewardRate = _rate;
}
```
