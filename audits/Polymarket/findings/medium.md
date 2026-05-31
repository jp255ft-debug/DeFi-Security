# Findings de Média Severidade

---

## [MED-01] Ausência de Validação de `_callbackReceiver` — Possível Chamada para Endereço Zero em wrap/unwrap

| Campo | Valor |
|---|---|
| **Severidade** | Medium |
| **CVSSv3** | 5.3 — AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:L |
| **Arquivo** | `src/collateral/CollateralToken.sol` |
| **Linha** | 156-173, 185-202 |
| **Função** | `wrap()`, `unwrap()` |
| **Status** | Aberto |

### Descrição

As funções `wrap()` e `unwrap()` aceitam `_callbackReceiver` como `address(0)` para pular o callback, mas não validam se o endereço é um contrato que implementa `ICollateralTokenCallbacks`. Se um endereço de contrato sem a interface for passado, a chamada externa reverterá, bloqueando a operação.

### Código Vulnerável

```solidity
if (_callbackReceiver != address(0)) {
    ICollateralTokenCallbacks(_callbackReceiver).wrapCallback(_asset, _to, _amount, _data);
}
```

### Impacto

- Operações de wrap/unwrap podem ser bloqueadas se um callback inválido for fornecido
- Usuários podem perder gas em transações que revertem

### Recomendação

Documentar claramente que `_callbackReceiver` deve implementar a interface, ou usar `try/catch` para ignorar falhas de callback não críticas.

---

## [MED-02] Aprovação Ilimitada de Token no Construtor do Assets

| Campo | Valor |
|---|---|
| **Severidade** | Medium |
| **CVSSv3** | 5.9 — AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:L/A:N |
| **Arquivo** | `src/exchange/mixins/Assets.sol` |
| **Linha** | 27-28 |
| **Função** | `constructor()` |
| **Status** | Aberto |

### Descrição

O construtor do `Assets` concede aprovação infinita (`type(uint256).max`) do colateral para o `outcomeTokenFactory` e `setApprovalForAll` do CTF para o `outcomeTokenFactory`. Isso significa que se o `outcomeTokenFactory` for comprometido ou atualizado para um endereço malicioso, ele pode drenar todo o colateral e todos os tokens CTF do exchange.

### Código Vulnerável

```solidity
constructor(address _collateral, address _ctf, address _ctfCollateral, address _outcomeTokenFactory) {
    collateral = _collateral;
    ctf = _ctf;
    ctfCollateral = _ctfCollateral;
    outcomeTokenFactory = _outcomeTokenFactory;
    ERC20(_collateral).approve(_outcomeTokenFactory, type(uint256).max);
    ERC1155(_ctf).setApprovalForAll(_outcomeTokenFactory, true);
}
```

### Impacto

- Se `outcomeTokenFactory` for comprometido, atacante pode drenar todo colateral e CTF tokens
- Sem mecanismo de revogação de aprovação no contrato
- Upgrade malicioso do `outcomeTokenFactory` pode explorar esta aprovação

### Recomendação

1. Usar aprovações com limite por transação em vez de `type(uint256).max`
2. Adicionar função `revokeApprovals()` onlyOwner para emergências
3. Implementar timelock em mudanças de `outcomeTokenFactory`

---

## [MED-03] Ausência de Verificação de `msg.sender` vs `order.signer` em Validação de Ordem

| Campo | Valor |
|---|---|
| **Severidade** | Medium |
| **CVSSv3** | 5.4 — AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:L/A:N |
| **Arquivo** | `src/exchange/mixins/Signatures.sol` |
| **Linha** | 45-70 |
| **Função** | `validateOrderSignature()` |
| **Status** | Aberto |

### Descrição

A validação de assinatura de ordem verifica que a assinatura corresponde ao `order.signer`, mas **não verifica se `order.signer == order.maker`** ou se o `msg.sender` (operador) tem permissão para submeter a ordem em nome do maker. Um operador malicioso poderia submeter ordens assinadas por qualquer signer, desde que a assinatura seja válida.

### Código Vulnerável

```solidity
function validateOrderSignature(bytes32 orderHash, Order memory order) public view {
    address signer = order.signer;
    // Verifica que a assinatura corresponde ao signer
    // Mas não verifica se signer == maker ou se operator tem permissão
    _validateSignature(orderHash, order.signature, signer, order.signatureType);
}
```

### Impacto

- Operador pode submeter ordens de qualquer signer sem autorização explícita
- Possível execução de ordens não autorizadas se o operador for comprometido

### Recomendação

Adicionar verificação de que `order.signer == order.maker` ou que o signer delegou autoridade ao operador via EIP-1271.

---

## [MED-04] Ausência de Deadline em Ordens — Ordens Válidas Indefinidamente

| Campo | Valor |
|---|---|
| **Severidade** | Medium |
| **CVSSv3** | 5.3 — AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:L/A:N |
| **Arquivo** | `src/exchange/libraries/Structs.sol` |
| **Linha** | 30-57 |
| **Struct** | `Order` |
| **Status** | Aberto |

### Descrição

O struct `Order` contém um campo `timestamp` (Unix timestamp em ms), mas **não contém um campo `deadline`** ou `expiry`. A validação de ordem em `_validateOrder()` (Trading.sol:54-63) não verifica se a ordem expirou. Uma vez assinada, uma ordem pode ser executada a qualquer momento no futuro.

### Código Vulnerável

```solidity
// Trading.sol:54-63
function _validateOrder(bytes32 orderHash, Order memory order) internal view {
    require(order.makerAmount > 0, ZeroMakerAmount());
    validateOrderSignature(orderHash, order);
    require(!isUserPaused(order.maker), UserIsPaused());
    // ❌ NÃO verifica deadline/expiry
}
```

### Impacto

- Ordens assinadas permanecem válidas para sempre
- Se o preço de mercado mudar drasticamente, uma ordem antiga pode ser executada em termos desfavoráveis para o maker
- Ataque de "order book poisoning" com ordens antigas

### Recomendação

Adicionar campo `deadline` ao struct `Order` e validar na função `_validateOrder()`:

```solidity
require(order.deadline == 0 || block.timestamp <= order.deadline, OrderExpired());
```

---

## [MED-05] Possível Manipulação de Preço via Flash Loan em Ordens Complementares

| Campo | Valor |
|---|---|
| **Severidade** | Medium |
| **CVSSv3** | 5.9 — AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:L/A:N |
| **Arquivo** | `src/exchange/mixins/Trading.sol` |
| **Linha** | 640-674 |
| **Função** | `_validateOrdersMatch()` |
| **Status** | Aberto |

### Descrição

A validação de crossing de ordens usa multiplicação direta de `makerAmount` e `takerAmount` sem verificar overflow. Embora Solidity 0.8+ tenha proteção contra overflow, a lógica de validação pode ser manipulada se um atacante usar ordens com valores extremos (ex: `makerAmount` muito grande, `takerAmount` muito pequeno) para criar condições de crossing artificiais.

### Código Vulnerável

```solidity
// Trading.sol:654
if (takerOrder.makerAmount * makerOrder.makerAmount < takerOrder.takerAmount * makerOrder.takerAmount) {
    revert NotCrossing();
}
```

### Impacto

- Ordens com proporções extremas podem passar na validação de crossing
- Possível manipulação de preço via ordens de flash loan

### Recomendação

Adicionar validação de proporção máxima entre `makerAmount` e `takerAmount`:

```solidity
require(order.makerAmount <= order.takerAmount * MAX_RATIO, PriceSlippageTooHigh());
```

---

## [MED-06] Função `renounceOperatorRole` Pode Deixar o Sistema sem Operadores

| Campo | Valor |
|---|---|
| **Severidade** | Medium |
| **CVSSv3** | 5.9 — AV:N/AC:L/PR:L/UI:N/S:U/C:N/I:N/A:H |
| **Arquivo** | `src/exchange/mixins/Auth.sol` |
| **Linha** | 87-90 |
| **Função** | `renounceOperatorRole()` |
| **Status** | Aberto |

### Descrição

A função `renounceOperatorRole()` permite que qualquer operador remova seu próprio papel sem verificar se há pelo menos um operador restante. Se o último operador renunciar, o sistema fica sem operadores, impedindo qualquer operação de trading (matchOrders, preapproveOrder, etc.).

### Código Vulnerável

```solidity
function renounceOperatorRole() external onlyOperator {
    operators[msg.sender] = false;
    emit RemovedOperator(msg.sender, msg.sender);
}
```

### Impacto

- Se o último operador renunciar, o exchange fica permanentemente paralisado
- Nenhuma ordem pode ser executada
- Fundos ficam presos no exchange

### Recomendação

Adicionar verificação similar à de `removeAdmin`:

```solidity
function renounceOperatorRole() external onlyOperator {
    require(operatorCount > 1, LastOperator());
    operators[msg.sender] = false;
    operatorCount--;
    emit RemovedOperator(msg.sender, msg.sender);
}
```

---

## [MED-07] Ausência de Eventos em Funções Críticas de Role Management

| Campo | Valor |
|---|---|
| **Severidade** | Medium |
| **CVSSv3** | 5.3 — AV:N/AC:L/PR:L/UI:N/S:U/C:N/I:L/A:N |
| **Arquivo** | `src/collateral/CollateralToken.sol` |
| **Linha** | 210-230 |
| **Função** | `addMinter()`, `removeMinter()`, `addWrapper()`, `removeWrapper()` |
| **Status** | Aberto |

### Descrição

As funções de gerenciamento de roles no `CollateralToken` delegam para `_grantRoles` e `_removeRoles` da Solady, que emitem eventos `RolesUpdated`. No entanto, não há eventos específicos para `addMinter`, `removeMinter`, `addWrapper`, `removeWrapper`, dificultando o monitoramento off-chain de mudanças de permissão.

### Código Vulnerável

```solidity
function addMinter(address _minter) external onlyOwner {
    _grantRoles(_minter, MINTER_ROLE);
    // ❌ Sem evento específico
}
```

### Impacto

- Dificuldade de auditoria off-chain de mudanças de permissão
- Possível escalada de privilégio não detectada

### Recomendação

Adicionar eventos específicos:

```solidity
event MinterAdded(address indexed minter, address indexed owner);
event MinterRemoved(address indexed minter, address indexed owner);
event WrapperAdded(address indexed wrapper, address indexed owner);
event WrapperRemoved(address indexed wrapper, address indexed owner);
```

---

## [MED-08] Ausência de Validação de `_amount` Zero em wrap/unwrap

| Campo | Valor |
|---|---|
| **Severidade** | Medium |
| **CVSSv3** | 5.3 — AV:N/AC:L/PR:L/UI:N/S:U/C:N/I:N/A:L |
| **Arquivo** | `src/collateral/CollateralToken.sol` |
| **Linha** | 156, 185 |
| **Função** | `wrap()`, `unwrap()` |
| **Status** | Aberto |

### Descrição

As funções `wrap()` e `unwrap()` não validam se `_amount > 0`. Chamar `wrap()` com `_amount = 0` resulta em mint de 0 tokens e transferência de 0 ativos, consumindo gas desnecessário e emitindo eventos enganosos.

### Código Vulnerável

```solidity
function wrap(address _asset, address _to, uint256 _amount, ...) external onlyRoles(WRAPPER_ROLE) onlyValidAsset(_asset) {
    _mint(_to, _amount);  // Mint de 0
    // ...
    _asset.safeTransfer(VAULT, _amount);  // Transfer de 0
}
```

### Impacto

- Consumo desnecessário de gas
- Eventos enganosos para sistemas off-chain
- Possível manipulação de métricas on-chain

### Recomendação

Adicionar validação:

```solidity
require(_amount > 0, ZeroAmount());
```
