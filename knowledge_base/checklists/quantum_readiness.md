# ⚛️ Quantum Readiness Checklist — PQC Readiness

**Foco:** Preparação pós-quântica para contratos inteligentes DeFi
**Alinhamento:** NIST SP 800-208, CNSA 2.0, ETSI QKD

---

## 🎯 Invariante Central

- [ ] Nenhum algoritmo de chave pública clássico (ECDSA, RSA, Ed25519) é usado sem alternativa PQC
- [ ] Hash functions com segurança reduzida por Grover não comprometem invariantes críticas
- [ ] Plano de migração PQC documentado e aprovado pela governança

---

## 🔐 Algoritmos de Assinatura (Ataque de Shor)

### ECDSA (ecrecover / OpenZeppelin ECDSA.sol)

- [ ] `ecrecover()` é usado para verificar assinaturas de mensagens?
- [ ] `ECDSA.sol` do OpenZeppelin está presente no código?
- [ ] Assinaturas EIP-712 dependem de ECDSA?
- [ ] `permit()` (ERC-20 Permit) usa ECDSA?
- [ ] `ERC-2612` (permit via signature) está implementado?
- [ ] Meta-transactions (ERC-2771) usam ECDSA?

**Mitigação PQC:** Migrar para ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205)

### Ed25519

- [ ] Verificação de assinatura Ed25519 está presente?
- [ ] O contrato depende de oráculos que usam Ed25519 (ex: Solana bridge)?
- [ ] Assinaturas de validadores usam Ed25519?

**Mitigação PQC:** Migrar para SLH-DSA (FIPS 205)

### BLS

- [ ] Agregação de assinaturas BLS é usada?
- [ ] O contrato depende de BLS para consenso ou validação?
- [ ] BLS12-381 está presente?

**Mitigação PQC:** Substituir por esquemas de agregação baseados em ML-DSA

---

## 🧮 Hash Functions (Ataque de Grover)

### SHA-256 / Keccak-256

- [ ] `keccak256()` é usado para compromissos (commitments)?
- [ ] `sha256()` precompile é usado?
- [ ] Merkle proofs dependem de SHA-256?
- [ ] O contrato usa `keccak256(abi.encode(...))` para identificadores únicos?

**Análise:** Grover reduz segurança de 256→128 bits. Avaliar se 128 bits de segurança pós-quântica são suficientes para o caso de uso.

### RIPEMD-160

- [ ] Endereços Ethereum são derivados de RIPEMD-160?
- [ ] O contrato depende de endereços como identificadores únicos?

**Análise:** RIPEMD-160 tem segurança reduzida para 80 bits pós-quântica. Risco baixo para a maioria dos casos, mas monitorar.

---

## 🔑 Gerenciamento de Chaves

- [ ] Chaves privadas são armazenadas ou derivadas on-chain?
- [ ] `CREATE2` com `salt` previsível pode ser explorado?
- [ ] O contrato tem `owner` ou `admin` que usa EOA (ECDSA)?
- [ ] Multi-sig wallets (Gnosis Safe) dependem de ECDSA?
- [ ] Timelock controllers usam assinaturas ECDSA?
- [ ] Upgradeability proxies (UUPS, Transparent) dependem de EOA admin?

**Mitigação PQC:** Migrar admins para contratos multisig com suporte a ML-DSA ou usar DAO governance

---

## 🌉 Cross-Chain e Bridges

- [ ] A bridge usa verificação de assinatura ECDSA/Ed25519?
- [ ] Validadores/atestadores usam chaves clássicas?
- [ ] Mensagens cross-chain são assinadas com ECDSA?
- [ ] Wormhole, LayerZero, CCIP dependem de assinaturas clássicas?

**Mitigação PQC:** Exigir assinaturas híbridas (clássica + PQC) durante período de transição

---

## 📊 PQR-Score (Quantum Risk Score)

Calcule o PQR-Score após aplicar o checklist:

| Componente | Peso | Score (0-100) | Ponderado |
|-----------|------|---------------|-----------|
| Algoritmos vulneráveis | 40% | | |
| Dependência de chave pública | 30% | | |
| Exposição a Grover | 20% | | |
| Maturidade de governança | 10% | | |
| **PQR-Score Total** | **100%** | | **/100** |

### Classificação

| PQR-Score | Classificação | Ação |
|-----------|--------------|------|
| 0-20 | 🟢 Baixo Risco | Monitorar padrões NIST anualmente |
| 21-50 | 🟡 Risco Moderado | Planejar migração em 12-24 meses |
| 51-80 | 🟠 Alto Risco | Iniciar migração em 6-12 meses |
| 81-100 | 🔴 Crítico | Migração imediata (0-6 meses) |

---

## 🛡️ Mitigações Recomendadas

1. **Assinaturas Híbridas**: Implementar ML-DSA + ECDSA simultaneamente durante transição
2. **Hash Extension**: Usar SHA-512 ou SHAKE256 onde 128 bits de segurança pós-quântica são insuficientes
3. **Contract Upgrade**: Preparar contratos para upgrade de algoritmo criptográfico via proxy pattern
4. **DAO Governance**: Migrar controle de admin para DAO (reduz dependência de EOA)
5. **Quantum-Safe RNG**: Substituir `block.timestamp` + `block.difficulty` por fontes de entropia pós-quântica
6. **Audit Trail**: Manter registro de todas as assinaturas para verificação retroativa pós-quântica

---

## 📚 Referências

| Padrão | Descrição | Status |
|--------|-----------|--------|
| **FIPS 204** | ML-DSA (Dilithium) — Assinatura digital pós-quântica | Final (2024) |
| **FIPS 205** | SLH-DSA (SPHINCS+) — Assinatura digital baseada em hash | Final (2024) |
| **FIPS 206** | FN-DSA (FALCON) — Assinatura digital compacta | Draft (2025) |
| **CNSA 2.0** | Commercial National Security Algorithm Suite 2.0 | NSA (2025) |
| **NIST SP 800-208** | Recomendações para migração PQC | NIST (2024) |
| **ETSI QKD** | Quantum Key Distribution standards | ETSI |

---

## 🧪 Testes Específicos

- [ ] Executar `pqaudit` no código-fonte (via `scripts/run_pqaudit.sh`)
- [ ] Verificar se `ecrecover` pode ser substituído por verificação ML-DSA
- [ ] Testar se assinaturas EIP-712 funcionam com ML-DSA
- [ ] Validar que Merkle proofs com SHA-256 mantêm segurança com 128 bits
- [ ] Simular ataque Grover em hash commitments (força bruta com 2^128 operações)
- [ ] Verificar se upgrade de algoritmo criptográfico é possível via proxy
