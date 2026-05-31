# 🔍 Relatório de Análise Inicial — LayerZero V2 (Immunefi)

**Data:** 03/05/2026
**Alvo:** LayerZero V2 (EVM)
**Repositório:** `layerzero-v2/packages/layerzero-v2/evm/`
**Escopo:** Protocol, MessageLib, OApp

---

## 📊 Mapa de Calor — Top 5 Pontos de Risco

| # | Contrato | Risco | Justificativa |
|---|---|---|---|
| 1 | **SimpleMessageLib.sol** | 🔴 **CRÍTICO** | `validatePacket()` explicitamente comentado como "no validation logic at all" |
| 2 | **DVN.sol** | 🔴 **ALTO** | `execute()` com `usedHashes` manipulável e `_shouldCheckHash()` com exceções perigosas |
| 3 | **LzExecutor.sol** | 🟠 **ALTO** | `commitAndExecute()` pode pular verificação e executar diretamente |
| 4 | **MultiSig.sol** | 🟠 **MÉDIO-ALTO** | Assinaturas ECDSA sem proteção contra malleability |
| 5 | **MessagingChannel.sol** | 🟡 **MÉDIO** | Nonce tracking pode ser manipulado via `skip()` / `nilify()` |

---

## 🚨 ACHADO #1 — SimpleMessageLib: Validação Zero (CRÍTICO)

**Arquivo:** `protocol/contracts/messagelib/SimpleMessageLib.sol`

```solidity
// Linha 62-68
// no validation logic at all
function validatePacket(bytes calldata packetBytes) external {
    if (whitelistCaller != address(0x0) && msg.sender != whitelistCaller) {
        revert OnlyWhitelistCaller();
    }
    Origin memory origin = Origin(packetBytes.srcEid(), packetBytes.sender(), packetBytes.nonce());
    ILayerZeroEndpointV2(endpoint).verify(origin, packetBytes.receiverB20(), keccak256(packetBytes.payload()));
}
```

**Problema:** O próprio código admite que não há validação. Qualquer whitelistCaller pode chamar `verify()` no endpoint com dados arbitrários. Se o whitelistCaller for comprometido ou configurado como `address(0)`, qualquer um pode verificar pacotes falsos.

**Impacto:** Injeção de mensagens falsificadas no protocolo.

---

## 🚨 ACHADO #2 — DVN.execute(): Replay e Controle de Acesso (ALTO)

**Arquivo:** `messagelib/contracts/uln/dvn/DVN.sol`

```solidity
// Linha 200-208
bool shouldCheckHash = _shouldCheckHash(bytes4(param.callData));
if (shouldCheckHash) {
    if (usedHashes[hash]) {
        emit HashAlreadyUsed(param, hash);
        continue;
    } else {
        usedHashes[hash] = true; // prevent reentry and replay attack
    }
}
```

**Problema:** A função `_shouldCheckHash()` (linha 386-392) **explicitamente NÃO verifica hash** para:
- `IReceiveUlnE2.verify` (0x0223536e)
- `ReadLib1002.verify` (0xab750e75)
- `ILayerZeroUltraLightNodeV2.updateHash` (0x704316e5)

Isso significa que chamadas `verify()` podem ser **repetidas infinitamente** via `execute()` sem proteção contra replay.

```solidity
// Linha 386-392
function _shouldCheckHash(bytes4 _functionSig) internal pure returns (bool) {
    return
        _functionSig != IReceiveUlnE2.verify.selector &&
        _functionSig != ReadLib1002.verify.selector &&
        _functionSig != ILayerZeroUltraLightNodeV2.updateHash.selector;
}
```

**Impacto:** Replay de verificações de mensagens, potencialmente permitindo que um DVN malicioso confirme mensagens múltiplas vezes.

---

## 🚨 ACHADO #3 — LzExecutor: Execução sem Verificação (ALTO)

**Arquivo:** `messagelib/contracts/uln/LzExecutor.sol`

```solidity
// Linha 80-128
function commitAndExecute(
    address _receiveLib,
    LzReceiveParam calldata _lzReceiveParam,
    NativeDropParam[] calldata _nativeDropParams
) external payable {
    // 1. check if executable, revert if executed
    ExecutionState executionState = executable(_lzReceiveParam.origin, _lzReceiveParam.receiver);
    if (executionState == ExecutionState.Executed) revert LzExecutor_Executed();

    // 2. if not executable, check if verifiable, revert if verifying, commit if verifiable
    if (executionState != ExecutionState.Executable) {
        // ... commit verification ...
    }

    // 4. try execute, will revert if not executable
    endpoint.lzReceive{ gas: _lzReceiveParam.gas, value: _lzReceiveParam.value }(
        _lzReceiveParam.origin, _lzReceiveParam.receiver,
        _lzReceiveParam.guid, _lzReceiveParam.message, _lzReceiveParam.extraData
    );
}
```

**Problema:** Se `executionState == ExecutionState.Executable`, o `commitAndExecute()` **pula completamente a verificação** e vai direto para a execução. Isso é intencional (mensagem já verificada anteriormente), mas qualquer falha no tracking de estado pode permitir execução sem verificação.

---

## 🚨 ACHADO #4 — MultiSig: Sem Proteção contra Signature Malleability (MÉDIO)

**Arquivo:** `messagelib/contracts/uln/dvn/MultiSig.sol`

```solidity
// Linha 93-112
function verifySignatures(bytes32 _hash, bytes calldata _signatures) public view returns (bool, Errors) {
    if (_signatures.length != uint256(quorum) * 65) {
        return (false, Errors.SignatureError);
    }
    bytes32 messageDigest = _getEthSignedMessageHash(_hash);
    address lastSigner = address(0);
    for (uint256 i = 0; i < quorum; i++) {
        bytes calldata signature = _signatures[i * 65:(i + 1) * 65];
        (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
        if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
        if (currentSigner <= lastSigner) return (false, Errors.DuplicatedSigner);
        if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
        lastSigner = currentSigner;
    }
    return (true, Errors.NoError);
}
```

**Problema:** O OpenZeppelin `ECDSA.tryRecover()` é suscetível a **signature malleability** (múltiplas assinaturas válidas para a mesma mensagem). Embora o `usedHashes` no DVN mitigue isso, o MultiSig em si não valida o `v` component (apenas `s` < `secp256k1n/2` não é verificado).

---

## 🚨 ACHADO #5 — GUID sem chainId do destino no hash (MÉDIO)

**Arquivo:** `protocol/contracts/libs/GUID.sol`

```solidity
function generate(
    uint64 _nonce, uint32 _srcEid, address _sender,
    uint32 _dstEid, bytes32 _receiver
) internal pure returns (bytes32) {
    return keccak256(abi.encodePacked(_nonce, _srcEid, _sender.toBytes32(), _dstEid, _receiver));
}
```

**Problema:** O GUID inclui `_srcEid` e `_dstEid`, mas o `_receiver` é um `bytes32` que pode ser um endereço ou um identificador não-EVM. Se duas chains diferentes tiverem o mesmo `eid` configurado (erro de configuração), o GUID seria colidente.

**Impacto:** Potencial confusão de mensagens entre chains com configuração incorreta.

---

## 📋 Checklist de Segurança Aplicado

### Validação de Mensagens Cross-Chain
- [x] `verify()` no EndpointV2 valida `isValidReceiveLibrary()` ✅
- [x] `SimpleMessageLib.validatePacket()` **NÃO valida nada** ❌
- [ ] `ReceiveUln302.commitVerification()` delega para `_verifyAndReclaimStorage()` ⚠️

### Nonce e Proteção contra Replay
- [x] Nonce tracking por `(receiver, srcEid, sender)` ✅
- [x] GUID inclui `nonce, srcEid, sender, dstEid, receiver` ✅
- [ ] `DVN._shouldCheckHash()` exclui `verify()` do hash check ❌

### Controle de Acesso
- [x] Endpoint: `onlyOwner` para `setLzToken()` ✅
- [x] DVN: `onlySelfOrAdmin()` com roles granulares ✅
- [x] `SimpleMessageLib`: `onlyOwner` para `setWhitelistCaller()` ✅
- [ ] `LzExecutor.commitAndExecute()` é pública sem autenticação ❌

### Reentrância
- [x] `lzReceive()` limpa payload antes de chamar receiver ✅ (CEI pattern)
- [x] `DVN.execute()` usa `usedHashes` para prevenir reentrância ✅

---

## 🎯 Próximos Passos Recomendados

1. **PoC #1:** Demonstrar que `SimpleMessageLib.validatePacket()` pode ser chamado para verificar pacotes arbitrários
2. **PoC #2:** Demonstrar replay de `verify()` via `DVN.execute()` sem hash check
3. **PoC #3:** Analisar `LzExecutor.commitAndExecute()` para execução sem verificação
4. **Análise aprofundada:** Contratos OApp (OFT, ONFT) para vulnerabilidades de mensageria
5. **Ferramentas automatizadas:** Rodar Slither, Aderyn, Semgrep nos contratos

---

*Relatório gerado em 03/05/2026 como parte do programa de Bug Bounty da LayerZero na Immunefi (até US$ 15.000.000)*
