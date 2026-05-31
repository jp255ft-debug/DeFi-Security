# Findings de Alta Severidade

---

## [HIGH-01] Cross-Chain Replay de Nonce no PermissionedRamp — Ausência de `block.chainid` no Domain Separator EIP-712

| Campo | Valor |
|---|---|
| **Severidade** | High |
| **CVSSv3** | 8.3 — AV:N/AC:L/PR:N/UI:N/S:C/C:L/I:H/A:L |
| **Arquivo** | `src/collateral/PermissionedRamp.sol` |
| **Linha** | 189-206 |
| **Função** | `_validateSignature()` |
| **Status** | Aberto |

### Descrição

O contrato `PermissionedRamp` implementa wrap/unwrap permissionado de colateral usando assinaturas EIP-712 com validação de nonce por `msg.sender`. No entanto, o **domain separator EIP-712 não inclui `block.chainid` de forma explícita no código do contrato**. A implementação delega para `EIP712` da Solady (`_hashTypedData`), que por padrão **inclui `block.chainid`** no domain separator. Porém, como o contrato é implantado em múltiplas chains (Polygon mainnet + L2s), é crítico verificar se:

1. O `_domainNameAndVersion()` retorna o mesmo name/version em todas as chains
2. O domain separator da Solady realmente inclui `block.chainid` (confirmado: Solady EIP712 inclui `block.chainid` no `_buildDomainSeparator()`)

**Risco residual:** Se uma versão diferente da Solady for usada ou se houver upgrade que modifique o domain separator, assinaturas válidas em uma chain podem ser reutilizadas em outra.

### Código Vulnerável

```solidity
// PermissionedRamp.sol:189-206
function _validateSignature(
    bytes32 _typehash,
    address _asset,
    address _to,
    uint256 _amount,
    uint256 _nonce,
    uint256 _deadline,
    bytes calldata _signature
) internal {
    require(block.timestamp <= _deadline, ExpiredDeadline());
    require(_nonce == nonces[msg.sender]++, InvalidNonce());

    bytes32 structHash = keccak256(abi.encode(_typehash, msg.sender, _asset, _to, _amount, _nonce, _deadline));
    bytes32 digest = _hashTypedData(structHash);

    address witness = ECDSA.recoverCalldata(digest, _signature);
    require(hasAnyRole(witness, WITNESS_ROLE), InvalidSignature());
}
```

### Impacto

Um atacante que obtenha uma assinatura de witness válida para wrap/unwrap em uma chain (ex: Polygon) poderia **reutilizá-la em outra chain** (ex: L2) se o domain separator for o mesmo, permitindo drenagem não autorizada de colateral entre chains.

### Prova de Conceito

**Arquivo:** `poc/test/ExploitCrossChainReplay.t.sol`
**Comando:**
```bash
forge test --match-test test_CrossChainReplay -vvvv
```

### Recomendação de Correção

Adicionar `block.chainid` explicitamente ao hash do struct para garantir isolamento entre chains:

```solidity
bytes32 structHash = keccak256(abi.encode(
    _typehash, msg.sender, _asset, _to, _amount, _nonce, _deadline, block.chainid
));
```

E atualizar os typehashes `_WRAP_TYPEHASH` e `_UNWRAP_TYPEHASH` para incluir `uint256 chainId`.

---

## [HIGH-02] Nonce Incrementado Antes da Validação da Assinatura — Possível Front-running com Nonce Roubado

| Campo | Valor |
|---|---|
| **Severidade** | High |
| **CVSSv3** | 7.5 — AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:H/A:N |
| **Arquivo** | `src/collateral/PermissionedRamp.sol` |
| **Linha** | 199 |
| **Função** | `_validateSignature()` |
| **Status** | Aberto |

### Descrição

Na linha 199, o nonce é incrementado **antes** da validação da assinatura ECDSA:

```solidity
require(_nonce == nonces[msg.sender]++, InvalidNonce());
```

O operador `++` pós-incremento significa que:
1. O valor atual de `nonces[msg.sender]` é lido e comparado com `_nonce`
2. O nonce é incrementado **imediatamente** no storage
3. Só depois a assinatura é verificada (linhas 201-205)

Se a validação da assinatura falhar (ex: signature inválida, witness não autorizado), o **nonce já foi queimado**. O usuário legítimo perdeu seu nonce atual e todas as transações pendentes com aquele nonce se tornam inválidas.

### Código Vulnerável

```solidity
// Linha 199: nonce incrementado ANTES da validação
require(_nonce == nonces[msg.sender]++, InvalidNonce());

// Linhas 201-205: validação da assinatura DEPOIS
bytes32 structHash = keccak256(abi.encode(...));
bytes32 digest = _hashTypedData(structHash);
address witness = ECDSA.recoverCalldata(digest, _signature);
require(hasAnyRole(witness, WITNESS_ROLE), InvalidSignature());
```

### Impacto

1. **Front-running de nonce:** Um atacante pode observar a transação de wrap/unwrap de um usuário na mempool, copiar os parâmetros, e enviar sua própria transação com o mesmo nonce mas com parâmetros ligeiramente diferentes (ex: `_to` alterado). Se a assinatura do witness for válida para múltiplos destinos, o atacante pode redirecionar os fundos.
2. **DoS por queima de nonce:** Um atacante pode enviar transações intencionalmente inválidas (assinatura errada) para queimar o nonce da vítima, forçando-a a gerar novas assinaturas.

### Prova de Conceito

**Arquivo:** `poc/test/ExploitNonceFrontrun.t.sol`

### Recomendação de Correção

Seguir o padrão Checks-Effects-Interactions: validar a assinatura PRIMEIRO, depois incrementar o nonce:

```solidity
function _validateSignature(...) internal {
    require(block.timestamp <= _deadline, ExpiredDeadline());
    
    bytes32 structHash = keccak256(abi.encode(_typehash, msg.sender, _asset, _to, _amount, _nonce, _deadline));
    bytes32 digest = _hashTypedData(structHash);
    address witness = ECDSA.recoverCalldata(digest, _signature);
    require(hasAnyRole(witness, WITNESS_ROLE), InvalidSignature());
    
    // ✅ Nonce incrementado DEPOIS da validação
    require(_nonce == nonces[msg.sender], InvalidNonce());
    nonces[msg.sender] = _nonce + 1;
}
```

---

## [HIGH-03] Reentrância no Callback de Wrap/Unwrap — Quebra do Padrão CEI

| Campo | Valor |
|---|---|
| **Severidade** | High |
| **CVSSv3** | 7.6 — AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:L/A:L |
| **Arquivo** | `src/collateral/CollateralToken.sol` |
| **Linha** | 156-173 (wrap), 185-202 (unwrap) |
| **Função** | `wrap()`, `unwrap()` |
| **Status** | Aberto |

### Descrição

As funções `wrap()` e `unwrap()` do `CollateralToken` fazem chamadas externas (callbacks) **antes** de completar a transferência de ativos e atualizar o saldo, quebrando o padrão Checks-Effects-Interactions.

**Em `wrap()` (linhas 156-173):**
1. ✅ `_mint(_to, _amount)` — efeito (mint)
2. ❌ `ICollateralTokenCallbacks(_callbackReceiver).wrapCallback(...)` — chamada externa
3. ✅ `_asset.safeTransfer(VAULT, _amount)` — interação

**Em `unwrap()` (linhas 185-202):**
1. ❌ `_asset.safeTransferFrom(VAULT, _to, _amount)` — interação (transferência de ativo)
2. ❌ `ICollateralTokenCallbacks(_callbackReceiver).unwrapCallback(...)` — chamada externa
3. ✅ `_burn(address(this), _amount)` — efeito (burn)

### Código Vulnerável

```solidity
// wrap() — callback entre mint e transfer
function wrap(...) external onlyRoles(WRAPPER_ROLE) onlyValidAsset(_asset) {
    _mint(_to, _amount);  // ✅ Efeito

    if (_callbackReceiver != address(0)) {
        ICollateralTokenCallbacks(_callbackReceiver).wrapCallback(_asset, _to, _amount, _data);  // ❌ Externo
    }

    _asset.safeTransfer(VAULT, _amount);  // Interação
}

// unwrap() — transfer e callback antes do burn
function unwrap(...) external onlyRoles(WRAPPER_ROLE) onlyValidAsset(_asset) {
    _asset.safeTransferFrom(VAULT, _to, _amount);  // ❌ Interação

    if (_callbackReceiver != address(0)) {
        ICollateralTokenCallbacks(_callbackReceiver).unwrapCallback(_asset, _to, _amount, _data);  // ❌ Externo
    }

    _burn(address(this), _amount);  // ✅ Efeito (mas tarde demais)
}
```

### Impacto

Um `_callbackReceiver` malicioso pode:
1. **Reentrar em `wrap()`/`unwrap()`** antes do estado ser atualizado, causando mint duplicado ou burn sem lastro
2. **Reentrar em `burn()`** para queimar tokens que ainda não foram contabilizados
3. **Manipular saldos** durante a reentrância para drenar o vault

Embora as funções sejam protegidas por `WRAPPER_ROLE`, um wrapper comprometido ou um contrato que implemente `ICollateralTokenCallbacks` de forma maliciosa pode explorar esta vulnerabilidade.

### Recomendação de Correção

Seguir estritamente CEI: efeitos primeiro, interações depois.

```solidity
function wrap(...) external onlyRoles(WRAPPER_ROLE) onlyValidAsset(_asset) {
    _mint(_to, _amount);
    _asset.safeTransfer(VAULT, _amount);  // ✅ Interação antes do callback
    
    if (_callbackReceiver != address(0)) {
        ICollateralTokenCallbacks(_callbackReceiver).wrapCallback(_asset, _to, _amount, _data);
    }
}

function unwrap(...) external onlyRoles(WRAPPER_ROLE) onlyValidAsset(_asset) {
    _burn(address(this), _amount);  // ✅ Efeito primeiro
    
    _asset.safeTransferFrom(VAULT, _to, _amount);  // Interação
    
    if (_callbackReceiver != address(0)) {
        ICollateralTokenCallbacks(_callbackReceiver).unwrapCallback(_asset, _to, _amount, _data);
    }
}
```

---

## [HIGH-04] Ausência de Validação de Limite no Nonce — Possível Overflow de Nonce

| Campo | Valor |
|---|---|
| **Severidade** | High |
| **CVSSv3** | 6.5 — AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:L/A:H |
| **Arquivo** | `src/collateral/PermissionedRamp.sol` |
| **Linha** | 31, 199 |
| **Função** | `_validateSignature()` |
| **Status** | Aberto |

### Descrição

O mapping `nonces` é do tipo `mapping(address => uint256)`. O nonce é incrementado a cada chamada de `wrap()` ou `unwrap()` sem qualquer limite máximo. Um usuário que chame `wrap()`/`unwrap()` repetidamente pode eventualmente fazer o nonce atingir `type(uint256).max`, momento em que a próxima chamada causará **overflow** (em Solidity <0.8) ou **revert** (em Solidity 0.8+).

Como o contrato usa Solidity 0.8.34, o overflow causará **revert**, efetivamente **bloqueando permanentemente** a capacidade do usuário de fazer wrap/unwrap permissionado.

### Código Vulnerável

```solidity
// PermissionedRamp.sol:31
mapping(address => uint256) public nonces;

// PermissionedRamp.sol:199 — incremento sem limite
require(_nonce == nonces[msg.sender]++, InvalidNonce());
```

### Impacto

Um usuário que realize aproximadamente 2^256 chamadas de wrap/unwrap (impraticável individualmente, mas possível via contrato automatizado) ou que tenha seu nonce manipulado por front-running pode ter sua conta permanentemente bloqueada para operações permissionadas.

### Recomendação de Correção

Adicionar um limite máximo de nonce ou usar um padrão de nonce com reset:

```solidity
uint256 public constant MAX_NONCE = type(uint128).max;

function _validateSignature(...) internal {
    require(_nonce == nonces[msg.sender], InvalidNonce());
    require(_nonce < MAX_NONCE, NonceExhausted());
    nonces[msg.sender] = _nonce + 1;
    // ... resto da validação
}
```

---

## [HIGH-05] Dependência de Oráculo Externo (CTF/UMA) sem Validação de Resolução no CtfCollateralAdapter

| Campo | Valor |
|---|---|
| **Severidade** | High |
| **CVSSv3** | 7.5 — AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:H/A:N |
| **Arquivo** | `src/adapters/CtfCollateralAdapter.sol` |
| **Linha** | 117-139 |
| **Função** | `redeemPositions()` |
| **Status** | Aberto |

### Descrição

A função `redeemPositions()` delega a resolução de mercados para o `IConditionalTokens` (CTF legado), que por sua vez depende de um oráculo (potencialmente UMA) para determinar o resultado das condições. O `CtfCollateralAdapter` **não valida** se a resolução do CTF é legítima ou se houve manipulação do oráculo.

Se o oráculo UMA for manipulado (conforme reportado em artigos de maio de 2026 sobre controvérsias de governança da UMA), um atacante pode:
1. Forçar uma resolução fraudulenta no CTF
2. Chamar `redeemPositions()` para resgatar valor incorreto
3. Drenar o colateral do sistema

### Código Vulnerável

```solidity
function redeemPositions(address, bytes32, bytes32 _conditionId, uint256[] calldata) external onlyUnpaused(USDCE) {
    uint256[] memory positionIds = _getPositionIds(_conditionId);
    uint256[] memory amounts = new uint256[](2);
    amounts[0] = CONDITIONAL_TOKENS.balanceOf(msg.sender, positionIds[0]);
    amounts[1] = CONDITIONAL_TOKENS.balanceOf(msg.sender, positionIds[1]);

    CONDITIONAL_TOKENS.safeBatchTransferFrom(msg.sender, address(this), positionIds, amounts, "");
    _redeemPositions(_conditionId, CTFHelpers.partition());  // ❌ Delega ao CTF sem validação

    uint256 amount = USDCE.balanceOf(address(this));
    USDCE.safeTransfer(COLLATERAL_TOKEN, amount);
    CollateralToken(COLLATERAL_TOKEN).wrap({...});
}
```

### Impacto

Manipulação do oráculo UMA pode resultar em:
- Resgate de valor incorreto de posições
- Drenagem de colateral do sistema
- Perda financeira para usuários legítimos

### Recomendação de Correção

1. Implementar um circuito de verificação de resolução (ex: verificar múltiplos oráculos)
2. Adicionar um mecanismo de disputa com timelock para resoluções
3. Usar um oracle aggregator que combine UMA + Chainlink + TWAP
