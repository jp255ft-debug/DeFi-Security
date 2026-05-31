# Autenticação via tx.origin

## Descrição
Usar `tx.origin` para autenticação é uma prática insegura, pois `tx.origin` retorna o endereço original que iniciou a transação, não o chamador direto (`msg.sender`). Isso permite ataques de phishing.

## Exemplo Vulnerável

```solidity
contract Wallet {
    address public owner;
    constructor() { owner = msg.sender; }

    function transfer(address payable to, uint256 amount) external {
        require(tx.origin == owner, "Not owner"); // ❌ phishing
        to.transfer(amount);
    }
}
```

Ataque: Um usuário chama um contrato malicioso que, por sua vez, chama `Wallet.transfer`. `tx.origin` será o usuário, e os fundos são roubados.

## Mitigação
```solidity
function transfer(address payable to, uint256 amount) external {
    require(msg.sender == owner, "Not owner"); // ✅ Correto
    to.transfer(amount);
}
```

**Regra de ouro:** Nunca usar `tx.origin` para autenticação. Use `msg.sender`.
