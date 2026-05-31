# ⚛️ PQR-Score Report — LayerZero

**PQR-Score:** 100/100 — 🔴 Crítico
**Ação Recomendada:** Migração imediata (0-6 meses)

## 📊 Componentes do PQR-Score

| Componente | Score | Peso | Findings |
|------------|-------|------|----------|
| 🔐 Algoritmos | 100/100 | 40% | 264 |
| 🔑 Chave Pública | 100/100 | 30% | 1638 |
| 🧮 Exposição Grover | 100/100 | 20% | 351 |
| 🏛️ Governança | 100/100 | 10% | 1638 |

## 🔐 Algoritmos Vulneráveis (Ataque de Shor)

| Localização | Algoritmo | Severidade | Mitigação |
|------------|-----------|------------|-----------|
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:5` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:104` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:106` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:5` | ECDSA (OpenZeppelin) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:604` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:621` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:8` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:31` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:92` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\metatx\ERC2771ForwarderUpgradeable.sol:7` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\metatx\ERC2771ForwarderUpgradeable.sol:230` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\metatx\ERC2771ForwarderUpgradeable.sol:245` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\metatx\ERC2771ForwarderUpgradeable.sol:7` | ECDSA (OpenZeppelin) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\metatx\ERC2771ForwarderUpgradeable.sol:53` | ECDSA (OpenZeppelin) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\metatx\ERC2771ForwarderUpgradeable.sol:230` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\metatx\ERC2771ForwarderUpgradeable.sol:8` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\metatx\ERC2771ForwarderUpgradeable.sol:52` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\metatx\ERC2771ForwarderUpgradeable.sol:103` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\metatx\ERC2771ForwarderUpgradeable.sol:106` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\metatx\ERC2771ForwarderUpgradeable.sol:222` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:98` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:20` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:93` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:101` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:2` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:31` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:33` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:35` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:36` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:44` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:45` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:47` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:49` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:65` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:66` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:69` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:70` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:83` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:88` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:106` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:122` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:123` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:132` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:137` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:138` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:143` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:148` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:149` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:154` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:156` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:158` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:159` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:163` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:165` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:167` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:168` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\draft-ERC7739Upgradeable.sol:7` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\draft-ERC7739Upgradeable.sol:14` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\draft-ERC7739Upgradeable.sol:22` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\draft-ERC7739Upgradeable.sol:27` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\draft-ERC7739Upgradeable.sol:86` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerECDSAUpgradeable.sol:2` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerECDSAUpgradeable.sol:7` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerECDSAUpgradeable.sol:72` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerECDSAUpgradeable.sol:73` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerECDSAUpgradeable.sol:7` | ECDSA (OpenZeppelin) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerECDSAUpgradeable.sol:11` | ECDSA (OpenZeppelin) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerRSAUpgradeable.sol:7` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerRSAUpgradeable.sol:11` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerRSAUpgradeable.sol:54` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerRSAUpgradeable.sol:63` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerRSAUpgradeable.sol:71` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerRSAUpgradeable.sol:82` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerRSAUpgradeable.sol:2` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerRSAUpgradeable.sol:19` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerRSAUpgradeable.sol:30` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerRSAUpgradeable.sol:36` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:8` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:64` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:8` | ECDSA (OpenZeppelin) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:62` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:9` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:21` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:36` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:41` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:79` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:14` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:17` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:23` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:26` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:47` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:2` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:6` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:21` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:40` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:44` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:46` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:72` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:73` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:77` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:15` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:28` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:33` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:57` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:66` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorCountingOverridableUpgradeable.sol:227` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorNoncesKeyedUpgradeable.sol:43` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorNoncesKeyedUpgradeable.sol:75` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\utils\VotesUpgradeable.sol:12` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\utils\VotesUpgradeable.sol:178` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\utils\VotesUpgradeable.sol:12` | ECDSA (OpenZeppelin) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\utils\VotesUpgradeable.sol:179` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\utils\VotesUpgradeable.sol:9` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\utils\VotesUpgradeable.sol:34` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\account\Account.sol:22` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:572` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:589` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:8` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:28` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:76` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC2612.sol:6` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC2612.sol:8` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC2612.sol:2` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC5267.sol:10` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC5267.sol:16` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\metatx\ERC2771Forwarder.sol:7` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\metatx\ERC2771Forwarder.sol:222` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\metatx\ERC2771Forwarder.sol:237` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\metatx\ERC2771Forwarder.sol:7` | ECDSA (OpenZeppelin) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\metatx\ERC2771Forwarder.sol:52` | ECDSA (OpenZeppelin) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\metatx\ERC2771Forwarder.sol:222` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\metatx\ERC2771Forwarder.sol:8` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\metatx\ERC2771Forwarder.sol:51` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\metatx\ERC2771Forwarder.sol:99` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\metatx\ERC2771Forwarder.sol:101` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\metatx\ERC2771Forwarder.sol:214` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\draft-ERC7739Utils.sol:14` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\draft-ERC7739Utils.sol:26` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\draft-ERC7739Utils.sol:59` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\draft-ERC7739Utils.sol:55` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\draft-ERC7739Utils.sol:76` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\ECDSA.sol:42` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\ECDSA.sol:69` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\ECDSA.sol:93` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\ECDSA.sol:110` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\ECDSA.sol:176` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\ECDSA.sol:190` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\ECDSA.sol:213` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\ECDSA.sol:2` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\ECDSA.sol:183` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:106` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:20` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:101` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:109` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:2` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:34` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:38` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:96` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:114` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:130` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:131` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:140` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:146` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:151` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:157` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MessageHashUtils.sol:103` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MessageHashUtils.sol:191` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\RSA.sol:2` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\RSA.sol:8` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\RSA.sol:12` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\RSA.sol:18` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\SignatureChecker.sol:6` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\SignatureChecker.sol:12` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\SignatureChecker.sol:25` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\SignatureChecker.sol:34` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\SignatureChecker.sol:35` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\SignatureChecker.sol:50` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\SignatureChecker.sol:51` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\SignatureChecker.sol:6` | ECDSA (OpenZeppelin) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\SignatureChecker.sol:25` | ECDSA (OpenZeppelin) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\AbstractSigner.sol:19` | ECDSA (OpenZeppelin) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\AbstractSigner.sol:20` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\draft-ERC7739.sol:7` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\draft-ERC7739.sol:13` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\draft-ERC7739.sol:21` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\draft-ERC7739.sol:26` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\draft-ERC7739.sol:80` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerECDSA.sol:2` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerECDSA.sol:7` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerECDSA.sol:53` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerECDSA.sol:54` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerECDSA.sol:7` | ECDSA (OpenZeppelin) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerECDSA.sol:10` | ECDSA (OpenZeppelin) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerEIP7702.sol:7` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerEIP7702.sol:22` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerEIP7702.sol:23` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerEIP7702.sol:7` | ECDSA (OpenZeppelin) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerRSA.sol:7` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerRSA.sol:10` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerRSA.sol:37` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerRSA.sol:45` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerRSA.sol:52` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerRSA.sol:63` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerRSA.sol:2` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerRSA.sol:18` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerRSA.sol:28` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\verifiers\ERC7913RSAVerifier.sol:6` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\verifiers\ERC7913RSAVerifier.sol:10` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\verifiers\ERC7913RSAVerifier.sol:19` | RSA | 🔴 Critical | ML-DSA (FIPS 204) ou SLH-DSA (FIPS 205) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:8` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:59` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:8` | ECDSA (OpenZeppelin) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:57` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:9` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:20` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:35` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:39` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:74` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:13` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:16` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:22` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:25` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:42` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:2` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:6` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:20` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:41` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:67` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:68` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:72` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:14` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:27` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:32` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:52` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:61` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:57` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:86` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:89` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:7` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:10` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:16` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:20` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:25` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:36` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:39` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:40` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:66` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:78` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:80` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:86` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:2` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:42` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:8` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\Initializable.sol:26` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\Initializable.sol:28` | ERC-20 Permit (ECDSA) | 🟠 High | ML-DSA (FIPS 204) para permit signatures |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorCountingOverridable.sol:201` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorNoncesKeyed.sol:37` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorNoncesKeyed.sol:69` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\utils\Votes.sol:12` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\utils\Votes.sol:155` | ECDSA (ecrecover) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\utils\Votes.sol:12` | ECDSA (OpenZeppelin) | 🔴 Critical | ML-DSA (FIPS 204) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\utils\Votes.sol:156` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\utils\Votes.sol:9` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\utils\Votes.sol:33` | EIP-712 (ECDSA) | 🟠 High | ML-DSA (FIPS 204) com EIP-712 adaptado |

## 🧮 Hash Functions (Ataque de Grover)

| Localização | Hash | Bits (Clássico) | Bits (Pós-Quântico) | Risco |
|------------|------|-----------------|--------------------|-------|
| `audits\LayerZero\src\MessagingChannel.sol:145` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\MessagingComposer.sol:26` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\MessagingComposer.sol:49` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\Worker.sol:14` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\Worker.sol:15` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\Worker.sol:16` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\Worker.sol:17` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\libs\GUID.sol:17` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\messagelib\SimpleMessageLib.sol:67` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\uln\LzExecutor.sol:100` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\uln\ReceiveUlnBase.sol:44` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\uln\SendUlnBase.sol:39` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\upgradeable\WorkerUpgradeable.sol:15` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\upgradeable\WorkerUpgradeable.sol:16` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\upgradeable\WorkerUpgradeable.sol:17` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\upgradeable\WorkerUpgradeable.sol:18` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\upgradeable\proxy\ProxyAdmin.sol:34` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\upgradeable\proxy\ProxyAdmin.sol:51` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\upgradeable\proxy\TransparentUpgradeableProxy.sol:43` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\uln\dvn\DVN.sol:376` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:115` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\uln\readlib\ReadLib1002.sol:116` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\uln\readlib\ReadLib1002.sol:155` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\uln\readlib\ReadLib1002.sol:165` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\uln\readlib\ReadLib1002View.sol:73` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\uln\uln301\ReceiveLibBaseE1.sol:93` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\uln\uln301\ReceiveUln301.sol:58` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\uln\uln301\ReceiveUln301View.sol:71` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\uln\uln302\ReceiveUln302.sol:56` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\uln\uln302\ReceiveUln302View.sol:64` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\uln\dvn\adapters\axelar\AxelarDVNAdapter.sol:148` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\uln\dvn\adapters\CCIP\CCIPDVNAdapter.sol:147` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\solidity-bytes-utils\contracts\AssertBytes.sol:234` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\solidity-bytes-utils\contracts\BytesLib.sol:147` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\solidity-bytes-utils\contracts\BytesLib.sol:195` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\solidity-bytes-utils\contracts\BytesLib.sol:486` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\solidity-bytes-utils\test\TestBytesLib1.sol:42` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\solidity-bytes-utils\test\TestBytesLib1.sol:43` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\solidity-bytes-utils\test\TestBytesLib1.sol:49` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\solidity-bytes-utils\test\TestBytesLib1.sol:50` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\solidity-bytes-utils\test\TestBytesLib1.sol:57` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\solidity-bytes-utils\test\TestBytesLib1.sol:62` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\solidity-bytes-utils\test\TestBytesLib2.sol:35` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\solidity-bytes-utils\test\TestBytesLib2.sol:36` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\solidity-bytes-utils\test\TestBytesLib2.sol:42` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\solidity-bytes-utils\test\TestBytesLib2.sol:43` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\solidity-bytes-utils\test\TestBytesLib2.sol:50` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\proxy\OptimizedTransparentUpgradeableProxy.sol:41` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\Clones.sol:69` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\Clones.sol:70` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\beacon\BeaconProxy.sol:13` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\beacon\BeaconProxy.sol:31` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\ERC1967\ERC1967Proxy.sol:23` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\ERC1967\ERC1967Upgrade.sol:140` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\ProxyAdmin.sol:26` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\ProxyAdmin.sol:41` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\TransparentUpgradeableProxy.sol:39` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\diamond\libraries\LibDiamond.sol:11` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.7\diamond\libraries\LibDiamond.sol:13` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\AccessControlUpgradeable.sol:23` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\AccessControlUpgradeable.sol:64` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:32` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:27` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\crosschain\CrosschainLinkedUpgradeable.sol:36` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\finance\VestingWalletCliffUpgradeable.sol:23` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\finance\VestingWalletUpgradeable.sol:49` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:35` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:37` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:64` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:134` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:149` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:248` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:340` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:441` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:604` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:622` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:629` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:630` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:26` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:27` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:28` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:37` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:261` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:275` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\metatx\ERC2771ForwarderUpgradeable.sol:66` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\metatx\ERC2771ForwarderUpgradeable.sol:231` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\metatx\ERC2771ForwarderUpgradeable.sol:240` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesKeyedUpgradeable.sol:23` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesUpgradeable.sol:20` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\PausableUpgradeable.sol:24` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:16` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:33` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:44` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:83` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:93` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:94` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:96` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:159` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\EIP712Upgradeable.sol:168` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\draft-ERC7739Upgradeable.sol:98` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:56` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:223` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:257` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:61` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerECDSAUpgradeable.sol:35` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerERC7913Upgradeable.sol:43` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerP256Upgradeable.sol:36` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerRSAUpgradeable.sol:36` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerRSAUpgradeable.sol:74` | sha256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerRSAUpgradeable.sol:71` | sha256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\SignerRSAUpgradeable.sol:82` | sha256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\common\ERC2981Upgradeable.sol:36` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC1155\ERC1155Upgradeable.sol:35` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:43` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:26` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:41` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721ConsecutiveUpgradeable.sol:41` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721EnumerableUpgradeable.sol:28` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721URIStorageUpgradeable.sol:26` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721WrapperUpgradeable.sol:24` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\extensions\ERC6909ContentURIUpgradeable.sol:21` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\extensions\ERC6909MetadataUpgradeable.sol:26` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\extensions\ERC6909TokenSupplyUpgradeable.sol:21` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\draft-ERC20TemporaryApprovalUpgradeable.sol:26` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20CappedUpgradeable.sol:18` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20FlashMintUpgradeable.sol:23` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:23` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:60` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20WrapperUpgradeable.sol:30` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:82` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC1155\extensions\ERC1155SupplyUpgradeable.sol:32` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC1155\extensions\ERC1155URIStorageUpgradeable.sol:23` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorCountingFractionalUpgradeable.sol:56` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorCountingOverridableUpgradeable.sol:20` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorCountingOverridableUpgradeable.sol:55` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorCountingOverridableUpgradeable.sol:228` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorCountingOverridableUpgradeable.sol:235` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorCountingSimpleUpgradeable.sol:35` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorNoncesKeyedUpgradeable.sol:44` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorNoncesKeyedUpgradeable.sol:76` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorNoncesKeyedUpgradeable.sol:83` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorNoncesKeyedUpgradeable.sol:84` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorPreventLateQuorumUpgradeable.sol:27` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorProposalGuardianUpgradeable.sol:20` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorSequentialProposalIdUpgradeable.sol:21` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorSequentialProposalIdUpgradeable.sol:77` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorSettingsUpgradeable.sol:24` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorStorageUpgradeable.sol:32` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorStorageUpgradeable.sol:65` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:72` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:29` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:96` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:33` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorVotesQuorumFractionUpgradeable.sol:24` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorVotesSuperQuorumFractionUpgradeable.sol:27` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorVotesUpgradeable.sol:22` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\utils\VotesExtendedUpgradeable.sol:46` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\utils\VotesUpgradeable.sol:38` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\utils\VotesUpgradeable.sol:49` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\utils\VotesUpgradeable.sol:179` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\crosschain\bridges\BridgeERC20Upgradeable.sol:24` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\crosschain\bridges\BridgeERC7802Upgradeable.sol:20` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\account\extensions\draft-AccountERC7579HookedUpgradeable.sol:29` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\account\extensions\draft-AccountERC7579Upgradeable.sol:63` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\extensions\AccessControlDefaultAdminRulesUpgradeable.sol:58` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\extensions\AccessControlEnumerableUpgradeable.sol:23` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\manager\AccessManagedUpgradeable.sol:28` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\manager\AccessManagerUpgradeable.sol:124` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\manager\AccessManagerUpgradeable.sol:626` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\manager\AccessManagerUpgradeable.sol:782` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\AccessControl.sol:22` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:32` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:34` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:112` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:127` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:220` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:311` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:410` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:572` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:590` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:597` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:598` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:25` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:26` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:27` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:238` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:252` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC1363.sol:20` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC1363.sol:21` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC1363.sol:22` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC1363.sol:23` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC1363.sol:24` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC1363.sol:25` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC1363Receiver.sol:17` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC1363Receiver.sol:24` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC1363Spender.sol:17` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC1363Spender.sol:23` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC3156FlashBorrower.sol:18` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\metatx\ERC2771Forwarder.sol:65` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\metatx\ERC2771Forwarder.sol:223` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\metatx\ERC2771Forwarder.sol:232` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\Clones.sol:126` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\Clones.sol:127` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\Clones.sol:236` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Bytes.sol:251` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Create2.sol:88` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Memory.sol:116` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\ReentrancyGuard.sol:35` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\ReentrancyGuardTransient.sol:20` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\RelayedCall.sol:116` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\RelayedCall.sol:123` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\SlotDerivation.sol:47` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\SlotDerivation.sol:48` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\SlotDerivation.sol:67` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\SlotDerivation.sol:78` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\SlotDerivation.sol:89` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\SlotDerivation.sol:100` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\SlotDerivation.sol:111` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\SlotDerivation.sol:122` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\SlotDerivation.sol:136` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\SlotDerivation.sol:151` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Strings.sol:114` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\draft-ERC7739Utils.sol:33` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\draft-ERC7739Utils.sol:104` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\draft-ERC7739Utils.sol:121` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\draft-ERC7739Utils.sol:148` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:16` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:38` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:71` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:72` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:91` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:101` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:102` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\EIP712.sol:104` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\Hashes.sol:13` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\Hashes.sol:17` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\Hashes.sol:18` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\Hashes.sol:22` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\Hashes.sol:24` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\Hashes.sol:28` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MerkleProof.sol:17` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MerkleProof.sol:60` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MerkleProof.sol:125` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MerkleProof.sol:237` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MerkleProof.sol:409` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MessageHashUtils.sol:19` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MessageHashUtils.sol:27` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MessageHashUtils.sol:36` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MessageHashUtils.sol:41` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MessageHashUtils.sol:52` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MessageHashUtils.sol:56` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MessageHashUtils.sol:65` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MessageHashUtils.sol:79` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MessageHashUtils.sol:84` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MessageHashUtils.sol:98` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MessageHashUtils.sol:128` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MessageHashUtils.sol:129` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MessageHashUtils.sol:177` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\MessageHashUtils.sol:225` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\P256.sol:100` | sha256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\P256.sol:98` | sha256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\RSA.sol:20` | sha256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\RSA.sol:28` | sha256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\RSA.sol:109` | sha256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\RSA.sol:115` | sha256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\RSA.sol:22` | sha256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\RSA.sol:52` | sha256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\RSA.sol:149` | sha256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\SignatureChecker.sol:155` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\SignatureChecker.sol:176` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\SignatureChecker.sol:184` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\TrieProof.sol:119` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\TrieProof.sol:122` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\WebAuthn.sol:113` | sha256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\WebAuthn.sol:116` | sha256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\structs\Checkpoints.sol:221` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\structs\Checkpoints.sol:424` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\structs\Checkpoints.sol:627` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\structs\Checkpoints.sol:830` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\structs\MerkleTree.sol:22` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\structs\MerkleTree.sol:59` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\structs\MerkleTree.sol:71` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\structs\MerkleTree.sol:116` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\structs\MerkleTree.sol:121` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\structs\MerkleTree.sol:185` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\structs\MerkleTree.sol:196` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\draft-ERC7739.sol:92` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:198` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:232` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerRSA.sol:55` | sha256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerRSA.sol:52` | sha256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\SignerRSA.sol:63` | sha256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\verifiers\ERC7913RSAVerifier.sol:19` | sha256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC1155\IERC1155Receiver.sol:18` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC1155\IERC1155Receiver.sol:26` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC1155\IERC1155Receiver.sol:42` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC1155\IERC1155Receiver.sol:50` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\draft-ERC20TemporaryApproval.sol:24` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20FlashMint.sol:22` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:22` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:55` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\Initializable.sol:76` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorCountingOverridable.sol:18` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorCountingOverridable.sol:202` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorCountingOverridable.sol:209` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorNoncesKeyed.sol:38` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorNoncesKeyed.sol:70` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorNoncesKeyed.sol:77` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorNoncesKeyed.sol:78` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorSequentialProposalId.sol:55` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorStorage.sol:46` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:75` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\utils\Votes.sol:37` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\utils\Votes.sol:156` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\account\utils\draft-ERC4337Utils.sol:40` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\manager\AccessManager.sol:584` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\manager\AccessManager.sol:739` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Endpoint.sol:155` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Endpoint.sol:169` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\EndpointLite.sol:152` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\EndpointLite.sol:166` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2.sol:129` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2.sol:140` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2AltToken.sol:137` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2AltToken.sol:148` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2Radar.sol:209` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2Radar.sol:220` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\OmniCounter.sol:52` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\OmniCounter.sol:53` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\OmniCounter.sol:243` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\precrime\PreCrime.sol:10` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proof\FPValidator.sol:47` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proof\MPTValidator.sol:51` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proof\MPTValidator01.sol:171` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proof\MPTValidatorStgV3.sol:183` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proof\MPTValidatorV2.sol:54` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proof\MPTValidatorV4.sol:236` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proof\MPTValidatorV5.sol:245` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\DefaultProxyAdmin.sol:26` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\DefaultProxyAdmin.sol:41` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\TransparentUpgradeableProxy.sol:34` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\MessagingChannel.sol:145` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\MessagingComposer.sol:26` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\MessagingComposer.sol:49` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\libs\GUID.sol:17` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\messagelib\SimpleMessageLib.sol:67` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\proxy\TransparentUpgradeableProxy.sol:43` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\messagelib\libs\PacketV1Codec.sol:25` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\messagelib\libs\PacketV1Codec.sol:106` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\messagelib\libs\PacketV1Codec.sol:25` | keccak256 | 256 | 128 | 🟡 Moderate |
| `audits\LayerZero\src\messagelib\libs\PacketV1Codec.sol:106` | keccak256 | 256 | 128 | 🟡 Moderate |

## 🔑 Gerenciamento de Chaves

| Localização | Padrão | Risco | Nota |
|------------|--------|-------|------|
| `audits\LayerZero\src\EndpointV2.sol:222` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\EndpointV2.sol:230` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\EndpointV2.sol:224` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\EndpointV2.sol:234` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\EndpointV2Alt.sol:44` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\ExecutorFeeLib.sol:25` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\ExecutorFeeLib.sol:26` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\ExecutorFeeLib.sol:5` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\ExecutorFeeLib.sol:14` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\MessageLibManager.sol:137` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\MessageLibManager.sol:139` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\MessageLibManager.sol:153` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\MessageLibManager.sol:156` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\MessageLibManager.sol:167` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\MessageLibManager.sol:170` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\MessageLibManager.sol:196` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\MessageLibManager.sol:140` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\MessageLibManager.sol:160` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\MessageLibManager.sol:175` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\MessageLibManager.sol:204` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\MessageLibManager.sol:6` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\MessageLibManager.sol:13` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\PriceFeed.sol:56` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\PriceFeed.sol:58` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\PriceFeed.sol:66` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\PriceFeed.sol:68` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\PriceFeed.sol:72` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\PriceFeed.sol:76` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\PriceFeed.sol:81` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\PriceFeed.sol:87` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\PriceFeed.sol:91` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\PriceFeed.sol:5` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\PriceFeed.sol:26` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\PriceFeed.sol:48` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\SendLibBase.sol:177` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\SendLibBase.sol:67` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\SendLibBase.sol:80` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\SendLibBase.sol:5` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\SendLibBase.sol:29` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\SendLibBaseE2.sol:59` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\SendLibBaseE2.sol:60` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\Treasury.sol:37` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\Treasury.sol:41` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\Treasury.sol:45` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\Treasury.sol:49` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\Treasury.sol:53` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\Treasury.sol:59` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\Treasury.sol:5` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\Treasury.sol:12` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\messagelib\SimpleMessageLib.sol:84` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\messagelib\SimpleMessageLib.sol:85` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\messagelib\SimpleMessageLib.sol:89` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\messagelib\SimpleMessageLib.sol:94` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\messagelib\SimpleMessageLib.sol:98` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\messagelib\SimpleMessageLib.sol:109` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\messagelib\SimpleMessageLib.sol:8` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\messagelib\SimpleMessageLib.sol:17` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\LzExecutor.sol:61` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\LzExecutor.sol:63` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\LzExecutor.sol:68` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\LzExecutor.sol:5` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\LzExecutor.sol:35` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\LzExecutor.sol:53` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\UlnBase.sol:47` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\UlnBase.sol:55` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\UlnBase.sol:5` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\UlnBase.sol:24` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\upgradeable\proxy\ProxyAdmin.sol:66` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\upgradeable\proxy\ProxyAdmin.sol:77` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\upgradeable\proxy\ProxyAdmin.sol:93` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\upgradeable\proxy\ProxyAdmin.sol:7` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\upgradeable\proxy\ProxyAdmin.sol:17` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\upgradeable\proxy\ProxyAdmin.sol:9` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\upgradeable\proxy\ProxyAdmin.sol:14` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\upgradeable\proxy\ProxyAdmin.sol:15` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\upgradeable\proxy\ProxyAdmin.sol:32` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\upgradeable\proxy\ProxyAdmin.sol:49` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\upgradeable\proxy\ProxyAdmin.sol:66` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\upgradeable\proxy\ProxyAdmin.sol:71` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\upgradeable\proxy\ProxyAdmin.sol:77` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\upgradeable\proxy\ProxyAdmin.sol:83` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\upgradeable\proxy\ProxyAdmin.sol:90` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\upgradeable\proxy\TransparentUpgradeableProxy.sol:3` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\upgradeable\proxy\TransparentUpgradeableProxy.sol:10` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\upgradeable\proxy\TransparentUpgradeableProxy.sol:32` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\upgradeable\proxy\TransparentUpgradeableProxy.sol:7` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\upgradeable\proxy\TransparentUpgradeableProxy.sol:40` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\upgradeable\proxy\TransparentUpgradeableProxy.sol:42` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\uln\dvn\DVN.sol:8` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\DVN.sol:22` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\DVN.sol:53` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\DVN.sol:54` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\DVN.sol:64` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\DVN.sol:100` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\DVN.sol:108` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\DVNFeeLib.sol:62` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\DVNFeeLib.sol:63` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\DVNFeeLib.sol:76` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\DVNFeeLib.sol:83` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\DVNFeeLib.sol:92` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\DVNFeeLib.sol:5` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\DVNFeeLib.sol:15` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:8` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:21` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:22` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:23` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:24` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:25` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:26` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:27` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:34` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:41` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:46` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:53` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:62` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:65` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:69` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:76` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:83` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\dvn\MultiSig.sol:87` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\uln\readlib\ReadLib1002.sol:382` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\readlib\ReadLib1002.sol:79` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\readlib\ReadLib1002.sol:81` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\readlib\ReadLib1002.sol:87` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\readlib\ReadLibBase.sol:45` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\readlib\ReadLibBase.sol:53` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\readlib\ReadLibBase.sol:5` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\readlib\ReadLibBase.sol:23` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\uln301\AddressSizeConfig.sol:16` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\uln301\AddressSizeConfig.sol:5` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\uln301\AddressSizeConfig.sol:7` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\uln301\ReceiveLibBaseE1.sol:57` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\uln301\SendLibBaseE1.sol:89` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\uln301\SendLibBaseE1.sol:90` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\uln301\SendLibBaseE1.sol:95` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\adapters\axelar\AxelarDVNAdapterFeeLib.sol:37` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\adapters\axelar\AxelarDVNAdapterFeeLib.sol:38` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\adapters\axelar\AxelarDVNAdapterFeeLib.sol:44` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\adapters\axelar\AxelarDVNAdapterFeeLib.sol:49` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\adapters\axelar\AxelarDVNAdapterFeeLib.sol:54` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\adapters\axelar\AxelarDVNAdapterFeeLib.sol:62` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\adapters\axelar\AxelarDVNAdapterFeeLib.sol:6` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\adapters\axelar\AxelarDVNAdapterFeeLib.sol:14` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\adapters\axelar\AxelarDVNAdapterFeeLib.sol:31` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\adapters\CCIP\CCIPDVNAdapterFeeLib.sol:22` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\adapters\CCIP\CCIPDVNAdapterFeeLib.sol:23` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\adapters\CCIP\CCIPDVNAdapterFeeLib.sol:6` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\adapters\CCIP\CCIPDVNAdapterFeeLib.sol:13` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\uln\dvn\adapters\CCIP\CCIPDVNAdapterFeeLib.sol:19` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\diamond\Diamond.sol:21` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\diamond\Diamond.sol:52` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\diamond\Diamond.sol:57` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\diamond\UsingDiamondOwner.sol:9` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\diamond\UsingDiamondOwner.sol:7` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\proxy\EIP173Proxy.sol:29` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\proxy\EIP173Proxy.sol:57` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\proxy\EIP173Proxy.sol:61` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\proxy\EIP173Proxy.sol:65` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\proxy\EIP173Proxy.sol:71` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\proxy\OptimizedTransparentUpgradeableProxy.sol:2` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\proxy\OptimizedTransparentUpgradeableProxy.sol:29` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\proxy\OptimizedTransparentUpgradeableProxy.sol:121` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\proxy\OptimizedTransparentUpgradeableProxy.sol:6` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\proxy\OptimizedTransparentUpgradeableProxy.sol:34` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\proxy\OptimizedTransparentUpgradeableProxy.sol:40` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\proxy\Proxy.sol:27` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\proxy\Proxy.sol:55` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\access\Ownable.sol:10` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\access\Ownable.sol:13` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\access\Ownable.sol:18` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\access\Ownable.sol:26` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\access\Ownable.sol:33` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\access\Ownable.sol:35` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\access\Ownable.sol:40` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\access\Ownable.sol:43` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\access\Ownable.sol:48` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\access\Ownable.sol:49` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\access\Ownable.sol:51` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\access\Ownable.sol:52` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\access\Ownable.sol:60` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\access\Ownable.sol:63` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\access\Ownable.sol:17` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\access\Ownable.sol:42` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\access\Ownable.sol:54` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\access\Ownable.sol:62` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\access\Ownable.sol:2` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\access\Ownable.sol:20` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\interfaces\draft-IERC1822.sol:7` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\Clones.sol:13` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\Clones.sol:39` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\Clones.sol:49` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\Clones.sol:51` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\Proxy.sol:8` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\Proxy.sol:31` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\Proxy.sol:37` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\utils\Address.sol:174` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\utils\Address.sol:175` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\utils\Address.sol:184` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\utils\Address.sol:191` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\beacon\UpgradeableBeacon.sol:14` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\beacon\UpgradeableBeacon.sol:25` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\beacon\UpgradeableBeacon.sol:47` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\beacon\UpgradeableBeacon.sol:50` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\beacon\UpgradeableBeacon.sol:7` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\beacon\UpgradeableBeacon.sol:16` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\beacon\UpgradeableBeacon.sol:29` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\ERC1967\ERC1967Proxy.sol:2` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\ERC1967\ERC1967Proxy.sol:15` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\ERC1967\ERC1967Upgrade.sol:77` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\ERC1967\ERC1967Upgrade.sol:81` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\ERC1967\ERC1967Upgrade.sol:88` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\ERC1967\ERC1967Upgrade.sol:95` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\ERC1967\ERC1967Upgrade.sol:17` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\ERC1967\ERC1967Upgrade.sol:72` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\ERC1967\ERC1967Upgrade.sol:179` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\ProxyAdmin.sol:54` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\ProxyAdmin.sol:65` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\ProxyAdmin.sol:81` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\ProxyAdmin.sol:7` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\ProxyAdmin.sol:13` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\ProxyAdmin.sol:15` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\ProxyAdmin.sol:6` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\ProxyAdmin.sol:10` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\ProxyAdmin.sol:11` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\ProxyAdmin.sol:24` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\ProxyAdmin.sol:39` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\ProxyAdmin.sol:54` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\ProxyAdmin.sol:59` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\ProxyAdmin.sol:65` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\ProxyAdmin.sol:71` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\ProxyAdmin.sol:78` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\TransparentUpgradeableProxy.sol:2` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\TransparentUpgradeableProxy.sol:29` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\TransparentUpgradeableProxy.sol:122` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\TransparentUpgradeableProxy.sol:6` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\TransparentUpgradeableProxy.sol:32` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\transparent\TransparentUpgradeableProxy.sol:38` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\utils\Initializable.sol:15` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\utils\UUPSUpgradeable.sol:88` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\utils\UUPSUpgradeable.sol:91` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\utils\UUPSUpgradeable.sol:2` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\utils\UUPSUpgradeable.sol:10` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\utils\UUPSUpgradeable.sol:15` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\utils\UUPSUpgradeable.sol:21` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\utils\UUPSUpgradeable.sol:28` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\utils\UUPSUpgradeable.sol:43` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\utils\UUPSUpgradeable.sol:68` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\utils\UUPSUpgradeable.sol:81` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\utils\UUPSUpgradeable.sol:11` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\utils\UUPSUpgradeable.sol:26` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\openzeppelin\proxy\utils\UUPSUpgradeable.sol:33` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\diamond\facets\DiamondCutFacet.sol:14` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\diamond\facets\DiamondCutFacet.sol:18` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\diamond\facets\OwnershipFacet.sol:13` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\diamond\interfaces\IDiamondCut.sol:20` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\diamond\interfaces\IDiamondCut.sol:24` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\diamond\interfaces\IERC173.sol:11` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\diamond\interfaces\IERC173.sol:12` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\diamond\interfaces\IERC173.sol:13` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\diamond\interfaces\IERC173.sol:15` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\diamond\interfaces\IERC173.sol:17` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\diamond\libraries\LibDiamond.sol:34` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\diamond\libraries\LibDiamond.sol:59` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.8\diamond\libraries\LibDiamond.sol:188` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.7\diamond\UsingDiamondOwner.sol:9` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.7\diamond\UsingDiamondOwner.sol:7` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.7\diamond\interfaces\IDiamondCut.sol:21` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.7\diamond\interfaces\IDiamondCut.sol:25` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.7\diamond\libraries\LibDiamond.sol:36` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.7\diamond\libraries\LibDiamond.sol:61` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\hardhat-deploy\solc_0.7\diamond\libraries\LibDiamond.sol:188` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:11` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:15` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:20` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:49` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:58` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:65` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:69` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:79` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:62` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:2` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:6` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:14` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:24` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:26` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:27` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:28` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:32` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:33` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:35` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:37` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:43` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:46` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:52` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:63` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:73` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\Ownable2StepUpgradeable.sol:84` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:11` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:14` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:19` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:42` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:44` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:49` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:63` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:71` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:73` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:79` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:82` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:88` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:89` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:91` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:92` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:100` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:18` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:65` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:94` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:102` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:2` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:21` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:22` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:23` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:27` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:28` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:30` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:32` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:39` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:51` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:52` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:55` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:57` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:74` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:83` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:104` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\OwnableUpgradeable.sol:114` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\finance\VestingWalletUpgradeable.sol:15` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\finance\VestingWalletUpgradeable.sol:62` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\finance\VestingWalletUpgradeable.sol:145` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\finance\VestingWalletUpgradeable.sol:158` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\finance\VestingWalletUpgradeable.sol:10` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\finance\VestingWalletUpgradeable.sol:14` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\finance\VestingWalletUpgradeable.sol:24` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\finance\VestingWalletUpgradeable.sol:37` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\finance\VestingWalletUpgradeable.sol:66` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\finance\VestingWalletUpgradeable.sol:21` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:78` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:80` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:398` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:460` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:684` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:695` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:703` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:714` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\GovernorUpgradeable.sol:725` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:14` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:22` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:15` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:23` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:2` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:13` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:14` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:20` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:22` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:25` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:31` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:32` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:37` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:38` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:40` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:42` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:56` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:61` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:70` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:75` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:80` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:116` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:128` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:131` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:132` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:135` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:136` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:220` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:246` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:321` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:338` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:340` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:344` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:357` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:359` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:416` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:445` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:448` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:456` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:458` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:464` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:470` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:471` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:474` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\TimelockControllerUpgradeable.sol:477` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\metatx\ERC2771ContextUpgradeable.sol:18` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\metatx\ERC2771ContextUpgradeable.sol:19` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\MulticallUpgradeable.sol:18` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\MulticallUpgradeable.sol:30` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\MulticallUpgradeable.sol:39` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesKeyedUpgradeable.sol:20` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesKeyedUpgradeable.sol:38` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesKeyedUpgradeable.sol:40` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesKeyedUpgradeable.sol:49` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesKeyedUpgradeable.sol:55` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesKeyedUpgradeable.sol:60` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesKeyedUpgradeable.sol:66` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesKeyedUpgradeable.sol:69` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesKeyedUpgradeable.sol:71` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesKeyedUpgradeable.sol:72` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesKeyedUpgradeable.sol:77` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesKeyedUpgradeable.sol:81` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesKeyedUpgradeable.sol:82` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesUpgradeable.sol:37` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesUpgradeable.sol:39` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesUpgradeable.sol:47` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesUpgradeable.sol:53` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesUpgradeable.sol:58` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesUpgradeable.sol:60` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesUpgradeable.sol:61` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\NoncesUpgradeable.sol:63` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\draft-ERC7739Upgradeable.sol:17` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:2` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:22` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:46` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:50` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:51` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:56` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:57` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:59` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:61` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:75` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:78` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:81` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:84` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:87` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:89` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:90` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:93` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:108` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:114` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:120` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:124` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:126` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:136` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:137` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:141` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:147` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:150` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:151` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:161` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:165` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:168` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:175` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:183` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:184` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:196` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:199` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913Upgradeable.sol:204` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:2` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:7` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:11` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:20` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:49` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:52` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:53` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:54` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:61` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:62` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:64` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:66` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:79` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:82` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:84` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:85` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:86` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:89` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:96` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:105` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:114` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:115` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:116` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:122` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:123` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:129` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:132` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:155` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:169` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:172` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:175` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:195` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:199` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\signers\MultiSignerERC7913WeightedUpgradeable.sol:209` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC1155\ERC1155Upgradeable.sol:137` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC1155\ERC1155Upgradeable.sol:138` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC1155\ERC1155Upgradeable.sol:139` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC1155\ERC1155Upgradeable.sol:140` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC1155\ERC1155Upgradeable.sol:396` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC1155\ERC1155Upgradeable.sol:402` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC1155\ERC1155Upgradeable.sol:405` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC1155\ERC1155Upgradeable.sol:407` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC1155\ERC1155Upgradeable.sol:413` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC1155\ERC1155Upgradeable.sol:414` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:122` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:123` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:128` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:130` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:144` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:145` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:261` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:270` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:275` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:276` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:290` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:291` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:297` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:299` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:305` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:307` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:312` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:319` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:320` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol:326` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:19` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:21` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:23` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:53` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:55` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:59` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:61` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:65` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:67` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:181` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:190` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:193` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:195` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:201` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:202` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:206` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:215` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:218` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:220` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:226` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:227` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:231` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:238` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:240` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC6909\ERC6909Upgradeable.sol:246` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:34` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:38` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:72` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:74` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:77` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:132` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:134` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:162` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:183` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:184` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:186` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:189` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:192` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:196` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:198` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:199` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:201` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:204` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:205` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:206` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:232` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:233` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:236` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:396` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:412` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:414` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:417` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:422` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:430` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:437` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:439` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:445` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:446` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:450` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:451` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:456` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:457` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol:460` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721ConsecutiveUpgradeable.sol:95` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721ConsecutiveUpgradeable.sol:98` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721ConsecutiveUpgradeable.sol:99` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721EnumerableUpgradeable.sol:21` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721EnumerableUpgradeable.sol:38` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721EnumerableUpgradeable.sol:40` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721EnumerableUpgradeable.sol:42` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721EnumerableUpgradeable.sol:60` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721EnumerableUpgradeable.sol:62` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721EnumerableUpgradeable.sol:63` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721EnumerableUpgradeable.sol:65` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721EnumerableUpgradeable.sol:103` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721EnumerableUpgradeable.sol:125` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721EnumerableUpgradeable.sol:128` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721PausableUpgradeable.sol:20` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721WrapperUpgradeable.sol:107` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721WrapperUpgradeable.sol:108` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721WrapperUpgradeable.sol:109` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\draft-ERC20TemporaryApprovalUpgradeable.sol:39` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\draft-ERC20TemporaryApprovalUpgradeable.sol:41` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\draft-ERC20TemporaryApprovalUpgradeable.sol:42` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\draft-ERC20TemporaryApprovalUpgradeable.sol:48` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\draft-ERC20TemporaryApprovalUpgradeable.sol:50` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\draft-ERC20TemporaryApprovalUpgradeable.sol:51` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\draft-ERC20TemporaryApprovalUpgradeable.sol:71` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\draft-ERC20TemporaryApprovalUpgradeable.sol:77` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\draft-ERC20TemporaryApprovalUpgradeable.sol:82` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\draft-ERC20TemporaryApprovalUpgradeable.sol:83` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\draft-ERC20TemporaryApprovalUpgradeable.sol:89` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\draft-ERC20TemporaryApprovalUpgradeable.sol:98` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\draft-ERC20TemporaryApprovalUpgradeable.sol:100` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\draft-ERC20TemporaryApprovalUpgradeable.sol:112` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\draft-ERC20TemporaryApprovalUpgradeable.sol:119` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\draft-ERC20TemporaryApprovalUpgradeable.sol:123` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\draft-ERC20TemporaryApprovalUpgradeable.sol:124` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PausableUpgradeable.sol:20` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:23` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:33` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:48` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:60` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:65` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:66` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:69` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:73` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20PermitUpgradeable.sol:74` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:102` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:104` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:107` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:109` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:186` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:187` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:191` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:192` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:242` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:243` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:245` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:249` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:255` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:256` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:258` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:262` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:304` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:308` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:309` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:318` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC4626Upgradeable.sol:321` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\token\ERC1155\extensions\ERC1155PausableUpgradeable.sol:20` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\proxy\utils\UUPSUpgradeable.sol:5` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorNoncesKeyedUpgradeable.sol:24` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorNoncesKeyedUpgradeable.sol:25` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:2` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:22` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:23` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:44` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:58` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:59` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:72` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:73` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:75` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:77` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:91` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:92` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:95` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:96` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:105` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:118` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:133` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:144` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:167` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:185` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:201` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:212` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:257` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:285` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockAccessUpgradeable.sol:314` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:2` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:8` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:14` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:15` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:16` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:17` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:19` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:20` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:23` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:24` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:25` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:26` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:29` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:30` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:32` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:34` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:39` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:41` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:44` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:46` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:47` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:50` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:51` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:58` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:63` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:69` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:71` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:72` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:73` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:82` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:91` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:92` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:96` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:100` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:108` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:117` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:122` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:124` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:129` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:138` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:145` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:153` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:156` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:157` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:161` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:165` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:166` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:170` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:173` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:174` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:176` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:177` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:180` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:182` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:183` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:186` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:187` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:188` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockCompoundUpgradeable.sol:189` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:2` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:8` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:13` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:14` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:17` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:18` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:21` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:22` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:26` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:27` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:28` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:29` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:30` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:33` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:34` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:36` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:38` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:43` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:45` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:48` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:50` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:51` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:54` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:55` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:59` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:62` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:69` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:70` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:72` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:73` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:76` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:82` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:84` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:85` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:86` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:95` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:104` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:105` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:107` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:108` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:109` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:116` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:125` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:127` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:129` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:133` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:136` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:137` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:145` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:148` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:149` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:151` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:153` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:160` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:163` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:164` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:168` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:171` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:173` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:174` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:177` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:178` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:179` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:180` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:184` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:187` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\governance\extensions\GovernorTimelockControlUpgradeable.sol:189` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\account\extensions\draft-AccountERC7579Upgradeable.sol:117` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\account\extensions\draft-AccountERC7579Upgradeable.sol:245` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\extensions\AccessControlDefaultAdminRulesUpgradeable.sol:89` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\manager\AccessManagerUpgradeable.sol:53` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\manager\AccessManagerUpgradeable.sol:54` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\manager\AccessManagerUpgradeable.sol:59` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\manager\AccessManagerUpgradeable.sol:60` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts-upgradeable\access\manager\AccessManagerUpgradeable.sol:47` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:10` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:13` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:18` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:29` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:31` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:36` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:46` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:54` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:56` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:61` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:64` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:70` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:71` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:73` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:74` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:82` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:17` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:48` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:76` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:84` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:2` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:20` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:26` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:40` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:65` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable.sol:86` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable2Step.sol:10` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable2Step.sol:14` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable2Step.sol:19` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable2Step.sol:31` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable2Step.sol:39` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable2Step.sol:45` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable2Step.sol:49` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable2Step.sol:58` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable2Step.sol:43` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable2Step.sol:2` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable2Step.sol:6` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable2Step.sol:13` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable2Step.sol:23` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable2Step.sol:25` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\Ownable2Step.sol:63` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\finance\VestingWallet.sol:14` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\finance\VestingWallet.sol:46` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\finance\VestingWallet.sol:118` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\finance\VestingWallet.sol:130` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\finance\VestingWallet.sol:10` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\finance\VestingWallet.sol:13` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\finance\VestingWallet.sol:23` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\finance\VestingWallet.sol:36` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\finance\VestingWallet.sol:49` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\finance\VestingWallet.sol:20` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:63` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:65` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:368` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:429` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:652` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:663` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:671` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:682` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\Governor.sol:693` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\IGovernor.sol:376` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:13` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:21` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:14` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:22` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:2` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:12` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:13` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:19` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:21` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:24` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:43` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:48` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:57` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:62` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:67` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:112` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:298` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:316` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:320` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:334` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:391` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:420` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:423` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:432` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:438` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:444` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:445` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\TimelockController.sol:450` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\draft-IERC1822.sol:7` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\draft-IERC6093.sol:33` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\draft-IERC6093.sol:47` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\draft-IERC6093.sol:58` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\draft-IERC6093.sol:60` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\draft-IERC6093.sol:62` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\draft-IERC6093.sol:65` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\draft-IERC6093.sol:74` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\draft-IERC6093.sol:76` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\draft-IERC6093.sol:92` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\draft-IERC6093.sol:105` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\draft-IERC6093.sol:138` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\draft-IERC6093.sol:139` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\draft-IERC6093.sol:141` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\draft-IERC6093.sol:151` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC1363Spender.sol:13` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC1363Spender.sol:20` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC1363Spender.sol:25` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC4626.sol:14` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC4626.sol:19` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC4626.sol:150` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC4626.sol:153` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC4626.sol:156` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC4626.sol:177` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC4626.sol:182` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC4626.sol:188` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC4626.sol:191` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC4626.sol:194` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC4626.sol:195` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC4626.sol:198` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC4626.sol:218` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC4626.sol:223` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC4626.sol:229` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC4626.sol:153` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC4626.sol:194` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC4626.sol:195` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC5313.sol:13` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC5313.sol:15` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC6909.sol:14` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC6909.sol:17` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC6909.sol:20` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC6909.sol:22` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC6909.sol:36` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC6909.sol:38` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC6909.sol:41` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC6909.sol:45` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC6909.sol:48` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC6909.sol:50` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC777.sol:66` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\interfaces\IERC777.sol:68` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\metatx\ERC2771Context.sol:17` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\metatx\ERC2771Context.sol:18` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\Clones.sol:6` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\Clones.sol:16` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\Clones.sol:67` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\Clones.sol:104` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\Clones.sol:189` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\Clones.sol:223` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\Clones.sol:236` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\Proxy.sol:8` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\Proxy.sol:31` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\Proxy.sol:37` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Address.sol:116` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Address.sol:117` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Create2.sol:2` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Create2.sol:10` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Create2.sol:11` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Create2.sol:18` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Create2.sol:22` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Create2.sol:25` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Create2.sol:43` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Create2.sol:46` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\LowLevelCall.sol:73` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\LowLevelCall.sol:74` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\LowLevelCall.sol:76` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\LowLevelCall.sol:80` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\LowLevelCall.sol:85` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\LowLevelCall.sol:90` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Multicall.sol:17` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Multicall.sol:24` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Multicall.sol:33` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Nonces.sol:19` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Nonces.sol:20` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Nonces.sol:28` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Nonces.sol:33` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Nonces.sol:38` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Nonces.sol:40` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Nonces.sol:41` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\Nonces.sol:43` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\NoncesKeyed.sol:17` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\NoncesKeyed.sol:20` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\NoncesKeyed.sol:21` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\NoncesKeyed.sol:30` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\NoncesKeyed.sol:35` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\NoncesKeyed.sol:40` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\NoncesKeyed.sol:46` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\NoncesKeyed.sol:49` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\NoncesKeyed.sol:51` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\NoncesKeyed.sol:52` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\NoncesKeyed.sol:57` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\NoncesKeyed.sol:61` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\NoncesKeyed.sol:62` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\RelayedCall.sol:118` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\RelayedCall.sol:127` | create2 | 🟢 Low | CREATE2 com salt previsível pode ser explorado |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\vendor\compound\ICompoundTimelock.sol:2` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\vendor\compound\ICompoundTimelock.sol:7` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\vendor\compound\ICompoundTimelock.sol:9` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\draft-ERC7739.sol:16` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:2` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:21` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:45` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:62` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:65` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:68` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:71` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:74` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:104` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:115` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:116` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:120` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:128` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:129` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:139` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:145` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:152` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:160` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:172` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913.sol:179` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:2` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:7` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:10` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:19` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:48` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:51` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:66` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:69` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:71` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:94` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:95` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:96` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:102` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:108` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:111` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:134` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:148` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:151` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:173` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:177` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\utils\cryptography\signers\MultiSignerERC7913Weighted.sol:187` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC1155\ERC1155.sol:116` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC1155\ERC1155.sol:117` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC1155\ERC1155.sol:118` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC1155\ERC1155.sol:119` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC1155\ERC1155.sol:373` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC1155\ERC1155.sol:379` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC1155\ERC1155.sol:382` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC1155\ERC1155.sol:383` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC1155\ERC1155.sol:389` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC1155\ERC1155.sol:390` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol:100` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol:101` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol:106` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol:107` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol:121` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol:122` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol:237` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol:246` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol:251` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol:252` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol:266` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol:267` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol:273` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol:274` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol:280` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol:282` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol:287` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol:294` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol:295` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol:301` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol:19` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol:22` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol:45` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol:50` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:15` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:17` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:19` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:34` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:35` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:39` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:40` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:44` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:45` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:158` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:167` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:170` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:171` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:177` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:178` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:182` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:191` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:194` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:195` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:201` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:202` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:206` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:213` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:214` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC6909\ERC6909.sol:220` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:30` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:34` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:53` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:54` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:57` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:110` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:111` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:139` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:158` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:159` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:161` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:164` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:167` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:171` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:173` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:174` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:176` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:179` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:180` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:181` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:206` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:207` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:210` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:369` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:384` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:386` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:389` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:394` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:402` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:409` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:410` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:416` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:417` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:421` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:422` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:427` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:428` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol:431` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol:18` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol:20` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol:23` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol:25` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol:28` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol:30` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol:33` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol:39` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol:130` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol:134` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\ERC721Consecutive.sol:76` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\ERC721Consecutive.sol:79` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\ERC721Consecutive.sol:80` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\ERC721Enumerable.sol:18` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\ERC721Enumerable.sol:25` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\ERC721Enumerable.sol:27` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\ERC721Enumerable.sol:29` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\ERC721Enumerable.sol:42` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\ERC721Enumerable.sol:43` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\ERC721Enumerable.sol:44` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\ERC721Enumerable.sol:46` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\ERC721Enumerable.sol:82` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\ERC721Enumerable.sol:102` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\ERC721Enumerable.sol:105` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\ERC721Pausable.sol:19` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\ERC721Wrapper.sol:88` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\ERC721Wrapper.sol:89` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\ERC721Wrapper.sol:90` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\IERC721Enumerable.sol:19` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\IERC721Enumerable.sol:20` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC721\extensions\IERC721Enumerable.sol:22` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\draft-ERC20TemporaryApproval.sol:32` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\draft-ERC20TemporaryApproval.sol:34` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\draft-ERC20TemporaryApproval.sol:35` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\draft-ERC20TemporaryApproval.sol:41` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\draft-ERC20TemporaryApproval.sol:43` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\draft-ERC20TemporaryApproval.sol:44` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\draft-ERC20TemporaryApproval.sol:64` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\draft-ERC20TemporaryApproval.sol:70` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\draft-ERC20TemporaryApproval.sol:75` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\draft-ERC20TemporaryApproval.sol:76` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\draft-ERC20TemporaryApproval.sol:82` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\draft-ERC20TemporaryApproval.sol:91` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\draft-ERC20TemporaryApproval.sol:93` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\draft-ERC20TemporaryApproval.sol:105` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\draft-ERC20TemporaryApproval.sol:112` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\draft-ERC20TemporaryApproval.sol:116` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\draft-ERC20TemporaryApproval.sol:117` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Pausable.sol:19` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:22` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:32` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:43` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:55` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:60` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:61` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:64` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:68` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC20Permit.sol:69` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:87` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:89` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:92` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:94` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:164` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:165` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:169` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:170` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:220` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:221` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:223` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:227` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:233` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:234` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:236` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:240` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:282` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:286` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:287` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:296` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\ERC4626.sol:299` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:35` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:44` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:45` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:56` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:58` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:67` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:77` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:80` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Permit.sol:83` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\utils\ERC1363Utils.sol:23` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\utils\SafeERC20.sol:70` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC20\utils\SafeERC20.sol:84` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\token\ERC1155\extensions\ERC1155Pausable.sol:19` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\beacon\UpgradeableBeacon.sol:13` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\beacon\UpgradeableBeacon.sol:29` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\beacon\UpgradeableBeacon.sol:49` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\beacon\UpgradeableBeacon.sol:52` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\beacon\UpgradeableBeacon.sol:7` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\beacon\UpgradeableBeacon.sol:15` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\beacon\UpgradeableBeacon.sol:31` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\ERC1967\ERC1967Proxy.sol:2` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\ERC1967\ERC1967Proxy.sol:15` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\ERC1967\ERC1967Proxy.sol:19` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\ERC1967\ERC1967Proxy.sol:36` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\ERC1967\ERC1967Utils.sol:72` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\ERC1967\ERC1967Utils.sol:162` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\ProxyAdmin.sol:25` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\ProxyAdmin.sol:42` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\ProxyAdmin.sol:7` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\ProxyAdmin.sol:13` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\ProxyAdmin.sol:27` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\ProxyAdmin.sol:6` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\ProxyAdmin.sol:10` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\ProxyAdmin.sol:11` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\ProxyAdmin.sol:31` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\ProxyAdmin.sol:39` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\TransparentUpgradeableProxy.sol:18` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\TransparentUpgradeableProxy.sol:2` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\TransparentUpgradeableProxy.sol:12` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\TransparentUpgradeableProxy.sol:14` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\TransparentUpgradeableProxy.sol:17` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\TransparentUpgradeableProxy.sol:31` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\TransparentUpgradeableProxy.sol:42` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\TransparentUpgradeableProxy.sol:59` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\TransparentUpgradeableProxy.sol:62` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\TransparentUpgradeableProxy.sol:97` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\TransparentUpgradeableProxy.sol:7` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\TransparentUpgradeableProxy.sol:77` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\transparent\TransparentUpgradeableProxy.sol:79` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\Initializable.sol:34` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:121` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:124` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:2` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:10` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:15` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:21` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:38` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:43` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:48` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:90` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:102` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:113` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:130` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:137` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:140` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:144` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:11` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:46` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:86` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:94` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:99` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:107` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\proxy\utils\UUPSUpgradeable.sol:112` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorNoncesKeyed.sol:18` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorNoncesKeyed.sol:19` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockAccess.sol:2` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockAccess.sol:20` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockAccess.sol:21` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockAccess.sol:42` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:2` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:7` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:12` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:13` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:14` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:15` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:17` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:18` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:21` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:22` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:25` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:27` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:30` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:32` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:33` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:44` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:50` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:52` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:53` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:62` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:71` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:75` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:79` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:87` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:100` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:102` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:107` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:122` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:130` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:133` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:137` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:141` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:145` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:148` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:149` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:151` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:152` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:155` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:157` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:158` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:161` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:162` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockCompound.sol:163` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:2` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:7` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:11` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:12` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:15` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:16` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:19` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:20` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:24` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:25` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:26` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:29` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:31` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:34` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:36` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:37` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:41` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:50` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:51` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:53` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:54` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:57` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:63` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:65` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:66` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:75` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:84` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:86` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:87` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:88` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:95` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:105` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:107` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:111` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:114` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:115` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:125` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:126` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:128` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:130` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:137` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:140` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:144` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:147` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:149` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:150` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:153` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:154` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:155` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:159` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:162` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\governance\extensions\GovernorTimelockControl.sol:164` | timelock | 🟢 Low | Timelock controllers podem usar EOA admin |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\account\extensions\draft-AccountERC7579.sol:108` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\account\extensions\draft-AccountERC7579.sol:235` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\account\utils\draft-ERC7579Utils.sol:31` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\account\utils\draft-ERC7579Utils.sol:32` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\account\utils\draft-ERC7579Utils.sol:97` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\account\utils\draft-ERC7579Utils.sol:103` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\account\utils\draft-ERC7579Utils.sol:227` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\account\utils\draft-ERC7579Utils.sol:228` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\account\utils\draft-ERC7579Utils.sol:234` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\extensions\AccessControlDefaultAdminRules.sol:70` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\manager\AccessManager.sol:52` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\manager\AccessManager.sol:53` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\manager\AccessManager.sol:58` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\manager\AccessManager.sol:59` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@openzeppelin\contracts\access\manager\AccessManager.sol:46` | multisig | 🟡 Moderate | Multisig wallets dependem de ECDSA para assinaturas |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Endpoint.sol:186` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Endpoint.sol:190` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Endpoint.sol:201` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Endpoint.sol:211` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Endpoint.sol:9` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Endpoint.sol:11` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\EndpointLite.sol:183` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\EndpointLite.sol:187` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\EndpointLite.sol:198` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\EndpointLite.sol:208` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\EndpointLite.sol:9` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\EndpointLite.sol:11` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\FeeHandler.sol:17` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\FeeHandler.sol:22` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\FeeHandler.sol:7` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\FeeHandler.sol:9` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\PriceFeed.sol:44` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\PriceFeed.sol:46` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\PriceFeed.sol:52` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\PriceFeed.sol:54` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\PriceFeed.sol:58` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\PriceFeed.sol:62` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\PriceFeed.sol:7` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\PriceFeed.sol:11` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\PriceFeed.sol:31` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Relayer.sol:60` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Relayer.sol:62` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Relayer.sol:123` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Relayer.sol:125` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Relayer.sol:130` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Relayer.sol:5` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Relayer.sol:11` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Relayer.sol:17` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Relayer.sol:69` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\RelayerV2.sol:108` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\RelayerV2.sol:110` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\RelayerV2.sol:117` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\RelayerV2.sol:201` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\RelayerV2.sol:202` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\RelayerV2.sol:209` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\RelayerV2.sol:214` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\RelayerV2.sol:219` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\RelayerV2.sol:10` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\RelayerV2.sol:22` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\RelayerV2.sol:130` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\RelayerV2Radar.sol:83` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\RelayerV2Radar.sol:85` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\RelayerV2Radar.sol:166` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\RelayerV2Radar.sol:168` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\RelayerV2Radar.sol:173` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\RelayerV2Radar.sol:11` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\RelayerV2Radar.sol:24` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\RelayerV2Radar.sol:92` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Treasury.sol:41` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Treasury.sol:46` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Treasury.sol:51` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Treasury.sol:56` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Treasury.sol:62` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Treasury.sol:67` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Treasury.sol:6` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\Treasury.sol:10` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\TreasuryV2.sol:45` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\TreasuryV2.sol:50` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\TreasuryV2.sol:55` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\TreasuryV2.sol:60` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\TreasuryV2.sol:65` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\TreasuryV2.sol:69` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\TreasuryV2.sol:73` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\TreasuryV2.sol:7` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\TreasuryV2.sol:13` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\TreasuryV2Radar.sol:41` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\TreasuryV2Radar.sol:46` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\TreasuryV2Radar.sol:51` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\TreasuryV2Radar.sol:56` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\TreasuryV2Radar.sol:61` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\TreasuryV2Radar.sol:65` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\TreasuryV2Radar.sol:6` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\TreasuryV2Radar.sol:10` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNode.sol:513` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNode.sol:514` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNode.sol:520` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNode.sol:526` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNode.sol:534` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNode.sol:547` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNode.sol:580` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNode.sol:585` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNode.sol:591` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNode.sol:6` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNode.sol:21` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2.sol:485` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2.sol:486` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2.sol:492` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2.sol:498` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2.sol:507` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2.sol:520` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2.sol:553` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2.sol:558` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2.sol:564` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2.sol:6` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2.sol:23` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2AltToken.sol:480` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2AltToken.sol:481` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2AltToken.sol:487` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2AltToken.sol:493` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2AltToken.sol:502` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2AltToken.sol:515` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2AltToken.sol:548` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2AltToken.sol:553` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2AltToken.sol:559` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2AltToken.sol:6` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2AltToken.sol:28` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2Radar.sol:568` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2Radar.sol:95` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2Radar.sol:119` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2Radar.sol:147` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2Radar.sol:569` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2Radar.sol:575` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2Radar.sol:581` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2Radar.sol:590` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2Radar.sol:603` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2Radar.sol:636` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2Radar.sol:641` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2Radar.sol:647` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2Radar.sol:6` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\UltraLightNodeV2Radar.sol:23` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleBadMock.sol:47` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleBadMock.sol:52` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleBadMock.sol:41` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleBadMock.sol:48` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleBadMock.sol:53` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleBadMock.sol:58` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleBadMock.sol:72` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleBadMock.sol:74` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleBadMock.sol:6` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleBadMock.sol:12` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleMock.sol:42` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleMock.sol:36` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleMock.sol:43` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleMock.sol:48` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleMock.sol:50` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleMock.sol:52` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleMock.sol:6` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleMock.sol:10` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleMockV2.sol:44` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleMockV2.sol:55` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleMockV2.sol:59` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleMockV2.sol:61` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleMockV2.sol:6` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\LayerZeroOracleMockV2.sol:10` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\OmniCounter.sol:235` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\OmniCounter.sol:150` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\OmniCounter.sol:166` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\OmniCounter.sol:216` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\OmniCounter.sol:220` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\OmniCounter.sol:236` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\OmniCounter.sol:6` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\OmniCounter.sol:13` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\PriceFeedV2Mock.sol:37` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\PriceFeedV2Mock.sol:39` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\PriceFeedV2Mock.sol:45` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\PriceFeedV2Mock.sol:47` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\PriceFeedV2Mock.sol:51` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\PriceFeedV2Mock.sol:55` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\PriceFeedV2Mock.sol:6` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\PriceFeedV2Mock.sol:12` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\mocks\PriceFeedV2Mock.sol:29` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\DefaultProxyAdmin.sol:54` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\DefaultProxyAdmin.sol:65` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\DefaultProxyAdmin.sol:81` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\DefaultProxyAdmin.sol:5` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\DefaultProxyAdmin.sol:12` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\DefaultProxyAdmin.sol:6` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\DefaultProxyAdmin.sol:9` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\DefaultProxyAdmin.sol:10` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\DefaultProxyAdmin.sol:24` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\DefaultProxyAdmin.sol:39` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\DefaultProxyAdmin.sol:54` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\DefaultProxyAdmin.sol:59` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\DefaultProxyAdmin.sol:65` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\DefaultProxyAdmin.sol:71` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\DefaultProxyAdmin.sol:78` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\TransparentUpgradeableProxy.sol:28` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\TransparentUpgradeableProxy.sol:95` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\TransparentUpgradeableProxy.sol:148` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-v1-0.7\contracts\proxy\TransparentUpgradeableProxy.sol:118` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\EndpointV2.sol:222` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\EndpointV2.sol:230` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\EndpointV2.sol:224` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\EndpointV2.sol:234` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\EndpointV2Alt.sol:44` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\MessageLibManager.sol:137` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\MessageLibManager.sol:139` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\MessageLibManager.sol:153` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\MessageLibManager.sol:156` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\MessageLibManager.sol:167` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\MessageLibManager.sol:170` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\MessageLibManager.sol:196` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\MessageLibManager.sol:140` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\MessageLibManager.sol:160` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\MessageLibManager.sol:175` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\MessageLibManager.sol:204` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\MessageLibManager.sol:6` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\MessageLibManager.sol:13` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\messagelib\SimpleMessageLib.sol:84` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\messagelib\SimpleMessageLib.sol:85` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\messagelib\SimpleMessageLib.sol:89` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\messagelib\SimpleMessageLib.sol:94` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\messagelib\SimpleMessageLib.sol:98` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\messagelib\SimpleMessageLib.sol:109` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\messagelib\SimpleMessageLib.sol:8` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\messagelib\SimpleMessageLib.sol:17` | owner_eoa | 🔴 High | Owner EOA depende de ECDSA — vulnerável a Shor |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\proxy\TransparentUpgradeableProxy.sol:3` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\proxy\TransparentUpgradeableProxy.sol:10` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\proxy\TransparentUpgradeableProxy.sol:32` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\proxy\TransparentUpgradeableProxy.sol:7` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\proxy\TransparentUpgradeableProxy.sol:40` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |
| `audits\LayerZero\src\node_modules\@layerzerolabs\lz-evm-protocol-v2\contracts\proxy\TransparentUpgradeableProxy.sol:42` | upgradeability | 🟡 Moderate | Proxy upgrade depende de admin EOA (ECDSA) |

## 📋 Resumo

- **Total de algoritmos vulneráveis:** 264
- **Total de hash functions em risco:** 351
- **Total de issues de gerenciamento de chaves:** 1638
- **PQR-Score:** 100/100 — 🔴 Crítico

---
*Relatório gerado pelo DeFi Security Workspace — quantum_risk_scanner.py*