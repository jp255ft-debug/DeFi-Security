# 🏗️ Bridge Security Checklist — CCTP & Cross-Chain

**Foco:** Circle CCTP (Cross-Chain Transfer Protocol) e bridges burn-and-mint

---

## 🎯 Invariante Central

- [ ] `totalBurned == totalMinted` — verificar se há gaps entre chains
- [ ] Nonce uniqueness — verificar se nonces podem ser reutilizados (replay attack)
- [ ] Message ID uniqueness — cada mensagem deve ter ID único globalmente

---

## 📨 Validação de Mensagens

- [ ] `receiveMessage()` valida remetente (sourceDomain + sender address)
- [ ] Attestation signature verification é à prova de replay
- [ ] `usedNonces` mapping previne double-claim de mensagens
- [ ] Message body parsing não tem overflow/underflow
- [ ] Source domain não pode ser spoofado (ex: enviar msg como se fosse Ethereum)
- [ ] Destination domain é validado contra whitelist
- [ ] Gas limits para mensagens longas (evitar DoS)

---

## 🔐 Controle de Acesso

- [ ] `mint()` tem `onlyLocalTokenMessenger`?
- [ ] `burn()` tem `onlyLocalTokenMessenger`?
- [ ] `onlyOwner` cobre funções críticas (setAttester, setMaxMessageBodySize)?
- [ ] `initialize()` tem `initializer` modifier (OpenZeppelin)?
- [ ] `rescueTokens()` ou `emergencyWithdraw()` tem proteção?
- [ ] `pausable` functions estão corretamente implementadas?

---

## 🔄 Reentrância e CEI (Checks-Effects-Interactions)

- [ ] `burn()` segue CEI? (burn antes de emitir evento)
- [ ] `mint()` atualiza estado antes de transfer?
- [ ] Tokens com hooks (ERC-777, ERC-1155) podem causar reentrância?
- [ ] `depositForBurn()` atualiza nonce antes de chamada externa?
- [ ] `receiveMessage()` atualiza `usedNonces` antes de chamar `mint()`?

---

## ✍️ Manipulação de Atestações

- [ ] ECDSA recovery é feito corretamente (ecrecover)?
- [ ] Signer address é imutável após deploy?
- [ ] Timelock ou delay em updates de atestadores?
- [ ] Threshold de assinaturas (multisig) é respeitado?
- [ ] Attestation expiry é verificado?
- [ ] Attestation signature malleability (s, v values)?

---

## 🌉 Cross-Chain

- [ ] Source domain não pode ser spoofado?
- [ ] Destination domain é validado contra whitelist?
- [ ] Gas limits para mensagens longas?
- [ ] Relayer pode ser qualquer um? (permissão vs permissionless)
- [ ] Taxas de bridge são calculadas corretamente?
- [ ] Blacklisted addresses são respeitados em todas as chains?

---

## 💰 Token Economics

- [ ] USDC queimado na source == USDC mintado na destination?
- [ ] Taxas de mint/burn são corretas?
- [ ] Decimal handling entre chains (USDC tem 6 decimais em algumas chains)?
- [ ] Flash loan + bridge attack vectors?
- [ ] `maxMessageBodySize` evita DoS por mensagens gigantes?

---

## 🧪 Testes Específicos para CCTP V2

- [ ] `MessageTransmitterV2.receiveMessage()` — tentar enviar mensagem falsa
- [ ] `TokenMessengerV2.depositForBurn()` — tentar reentrância via callback
- [ ] `TokenMinterV2.mint()` — tentar mint sem permissão
- [ ] Replay attack: capturar mensagem válida e reenviar em outra chain
- [ ] Nonce manipulation: tentar forçar nonce collision
- [ ] Attestation forgery: tentar criar assinatura falsa

---

## 📚 Referências Históricas

| Incidente | Data | Perda | Lição |
|---|---|---|---|
| **Noble-CCTP Vulnerability** | 2024 | US$ 35M (potencial) | Validação de mensagens insuficiente |
| **KelpDAO Exploit** | 2026 | US$ 292M | Burn-and-mint sem validação cross-chain |
| **Wormhole Exploit** | 2022 | US$ 326M | Assinatura de validador comprometida |
| **Nomad Bridge** | 2022 | US$ 190M | Merkle root validation flaw |
| **Ronin Bridge** | 2022 | US$ 620M | Validadores comprometidos |

---

## 🛡️ Mitigações Recomendadas

1. **Nonce estrito**: usar nonce incremental + mapping `usedNonces`
2. **Assinaturas EIP-712**: estrutura tipada para mensagens
3. **Timelock**: delay em mudanças de atestadores
4. **Rate limiting**: limite de mint por período
5. **Circuit breaker**: pausar bridge em caso de anomalia
6. **Multi-sig**: múltiplos atestadores com threshold
