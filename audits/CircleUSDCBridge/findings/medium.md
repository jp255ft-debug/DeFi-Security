# 🟡 Findings — Medium Severity

## Circle USDC Bridge (CCTP V2)

---

### M-01: `handleReceiveUnfinalizedMessage` — Falta de Validação de `finalityThresholdExecuted`

**Severity:** Medium (CVSSv3: 5.5)
**Contract:** `TokenMessengerV2.sol`
**Function:** `handleReceiveUnfinalizedMessage()`

**Descrição:**
A função `handleReceiveUnfinalizedMessage` valida que `finalityThresholdExecuted >= TOKEN_MESSENGER_MIN_FINALITY_THRESHOLD` (500), mas não valida que seja **menor** que `FINALITY_THRESHOLD_FINALIZED` (2000). Isso significa que mensagens com finalidade "finalized" podem ser roteadas para o handler de mensagens "unfinalized".

**Código Vulnerável:**
```solidity
function handleReceiveUnfinalizedMessage(...) external override
    onlyLocalMessageTransmitter
    onlyRemoteTokenMessenger(remoteDomain, sender)
    returns (bool)
{
    require(
        finalityThresholdExecuted >= TOKEN_MESSENGER_MIN_FINALITY_THRESHOLD,
        "Unsupported finality threshold"
    );
    // ← Não verifica se é < FINALITY_THRESHOLD_FINALIZED
    return _handleReceiveMessage(messageBody.ref(0), remoteDomain);
}
```

**Impacto:**
- Mensagens finalizadas podem ser processadas como não-finalizadas
- Potencial de processamento duplicado se ambas as funções forem chamadas

**Mitigação:**
- Adicionar `require(finalityThresholdExecuted < FINALITY_THRESHOLD_FINALIZED, "...")`

---

### M-02: `initialize()` — Sem Verificação de `initializer` no `TokenMinterV2`

**Severity:** Medium (CVSSv3: 5.0)
**Contract:** `TokenMinterV2.sol`

**Descrição:**
O `TokenMinterV2` herda de `TokenMinter` que por sua vez herda de `Initializable`. No entanto, o `TokenMinterV2` não tem uma função `initialize()` própria, delegando toda a inicialização ao contrato base. Se o `TokenMinter` base não proteger adequadamente a inicialização, um atacante pode reinitializar o contrato.

**Impacto:**
- Reinitialization attack
- Modificação de parâmetros críticos como `tokenController`

**Mitigação:**
- Implementar `initialize()` explícito no `TokenMinterV2` com `initializer` modifier

---

### M-03: `usedNonces` Mapping — Sem Limpeza de Nonces Antigos

**Severity:** Medium (CVSSv3: 4.5)
**Contract:** `BaseMessageTransmitter.sol`
**Storage:** `mapping(bytes32 => uint256) public usedNonces`

**Descrição:**
O mapping `usedNonces` nunca é limpo. Com o tempo, isso pode levar a:
1. Acúmulo de storage (custo de gas para o operador)
2. Potencial de colisão de nonces se o espaço de nonces for reutilizado

**Impacto:**
- Degradação de performance ao longo do tempo
- Risco teórico de colisão de nonces

**Mitigação:**
- Implementar mecanismo de expiração de nonces
- Usar nonces baseados em timestamp em vez de incrementais
