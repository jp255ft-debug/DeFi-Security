# 🔴 Findings — High Severity

## Circle USDC Bridge (CCTP V2)

---

### H-01: Attestation Signature Verification — Potential Replay Attack via Nonce Reuse

**Severity:** High (CVSSv3: 8.5)
**Contract:** `MessageTransmitterV2.sol`
**Function:** `receiveMessage()` → `_validateReceivedMessage()`

**Descrição:**
O contrato `MessageTransmitterV2` usa um mapping `usedNonces` para prevenir replay attacks. No entanto, a validação do nonce ocorre **após** a verificação das assinaturas da atestação. Se um atacante conseguir forjar uma atestação válida (ou capturar uma mensagem legítima antes dela ser processada), ele pode tentar reutilizar o nonce.

**Código Vulnerável:**
```solidity
// MessageTransmitterV2.sol:271-321
function _validateReceivedMessage(...) internal view {
    _verifyAttestationSignatures(_message, _attestation);  // ← assinaturas verificadas primeiro
    ...
    _nonce = _msg._getNonce();
    require(usedNonces[_nonce] == 0, "Nonce already used");  // ← nonce verificado depois
    ...
}
```

**Impacto:**
- Replay de mensagens legítimas entre chains
- Mintagem duplicada de USDC na chain de destino
- Potencial de drenagem de liquidez da bridge

**Mitigação:**
- Verificar o nonce **antes** de verificar as assinaturas
- Implementar nonce monotônico incremental em vez de mapping

---

### H-02: Solidity 0.7.6 — Sem Proteção Nativa Contra Overflow

**Severity:** High (CVSSv3: 7.5)
**Contract:** `TokenMessengerV2.sol`, `MessageTransmitterV2.sol`, `TokenMinterV2.sol`

**Descrição:**
Todos os contratos CCTP V2 usam **Solidity 0.7.6**, que **não** tem proteção nativa contra overflow/underflow (introduzida apenas no Solidity 0.8.0). Embora o `TokenMessengerV2` importe `SafeMath`, operações aritméticas em outros contratos podem ser vulneráveis.

**Código Vulnerável (TokenMessengerV2.sol:422):**
```solidity
_mintAndWithdraw(
    _remoteDomain,
    _burnToken,
    _mintRecipient,
    _amount - _fee,  // ← possível underflow se _fee > _amount
    _fee
);
```

**Impacto:**
- Underflow em `_amount - _fee` pode resultar em mintagem de quantidades massivas de USDC
- Overflow em cálculos de fee pode permitir taxas negativas

**Mitigação:**
- Upgrade para Solidity ^0.8.0
- Ou garantir que todas as operações aritméticas usem SafeMath

---

### H-03: `_depositAndBurn` — Transferência Seguida de Burn sem Verificação de Resultado

**Severity:** High (CVSSv3: 7.0)
**Contract:** `BaseTokenMessenger.sol`
**Function:** `_depositAndBurn()`

**Descrição:**
A função `_depositAndBurn` faz `transferFrom` seguido de `burn` no TokenMinter. Se o `transferFrom` for bem-sucedido mas o `burn` falhar (por exemplo, se o token não for suportado pelo minter), os tokens do usuário ficam presos no contrato do minter.

**Código Vulnerável:**
```solidity
function _depositAndBurn(address _burnToken, address _from, uint256 _amount) internal {
    ITokenMinterV2 _localMinter = _getLocalMinter();
    IMintBurnToken _mintBurnToken = IMintBurnToken(_burnToken);
    require(
        _mintBurnToken.transferFrom(_from, address(_localMinter), _amount),
        "Transfer operation failed"
    );
    _localMinter.burn(_burnToken, _amount);  // ← se falhar, tokens presos no minter
}
```

**Impacto:**
- Perda permanente de fundos do usuário se o burn falhar
- Tokens acumulados no contrato do minter sem possibilidade de resgate

**Mitigação:**
- Verificar o resultado do burn antes de considerar a operação completa
- Implementar `rescueTokens()` no TokenMinter para emergências
