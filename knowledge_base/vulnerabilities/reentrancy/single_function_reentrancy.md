# Reentrância de Função Única

## Descrição
Uma função chama um contrato externo (ex: transferência de ETH) e depois atualiza o estado. O contrato malicioso pode reexecutar a função antes da atualização, drenando fundos.

## Exemplo Clássico

```solidity
pragma solidity ^0.8.0;

contract VulnerableBank {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 amount = balances[msg.sender];
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        // ⚠️ Saldo atualizado após a chamada externa
        balances[msg.sender] = 0;
    }
}
```

Ataque: Um contrato malicioso chama `withdraw` e, dentro da função `receive`, chama novamente `withdraw`, drenando múltiplas vezes o saldo.

## Mitigação
- Usar o padrão Checks-Effects-Interactions
- Usar `ReentrancyGuard` do OpenZeppelin
