# ⛽ Gas Optimizations

## Circle USDC Bridge (CCTP V2)

---

### G-01: Loop em `initialize()` — `++i` vs `i++`

**Arquivo:** `TokenMessengerV2.sol:136`
**Código:**
```solidity
for (uint256 i; i < _remoteDomainsLength; ++i) {
```

**Otimização:**
Usar `unchecked { ++i; }` para economizar gas em loops grandes.

---

### G-02: Variáveis Imutáveis Poderiam Ser `constant`

**Arquivo:** `BaseMessageTransmitter.sol:48-51`
**Código:**
```solidity
uint32 public immutable localDomain;
uint32 public immutable version;
```

**Otimização:**
Se esses valores são conhecidos em tempo de compilação, poderiam ser `constant` para economizar gas de leitura.

---

### G-03: `_validateReceivedMessage` — Múltiplas Leituras de Storage

**Arquivo:** `MessageTransmitterV2.sol:271-321`

**Otimização:**
As variáveis `localDomain`, `version` e `usedNonces` são lidas múltiplas vezes. Cachear em memória reduziria custos de gas.

---

### G-04: `_depositForBurn` — Cálculo de `_calcMinFeeAmount` Repetido

**Arquivo:** `TokenMessengerV2.sol:332-395`

**Otimização:**
`_calcMinFeeAmount(_amount)` é chamado dentro do `if (minFee > 0)`. O resultado poderia ser cacheado em uma variável local.
