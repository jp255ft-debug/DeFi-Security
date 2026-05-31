# ✅ Checklist de Submissão Manual — Ripio

## 📋 Instruções Gerais

1. Acesse: https://hackerone.com/ripio/reports/new
2. Para cada finding, crie um **novo report** separado
3. Preencha os campos conforme as tabelas abaixo
4. Cole o conteúdo de "Vulnerability Information" no campo de descrição
5. Anexe os arquivos de PoC como evidência

---

## 🔴 HIGH — H-01: Missing Merkle Proof Verification

| Campo | Valor |
|-------|-------|
| **Título** | `H-01: BridgeDeposit — Missing Merkle Proof Verification Allows Arbitrary Minting` |
| **Severidade** | High (CVSSv3: 8.5) |
| **CWE** | CWE-347 |
| **Asset** | https://github.com/ripio/latam-contracts |
| **Tags** | `solidity`, `evm`, `bridge`, `h-01` |
| **Guia completo** | `submissions/MANUAL_SUBMISSION_HIGH.md` |
| **PoC** | `poc/test/ExploitBridgeDepositNoMerkle.t.sol` |
| **Status** | ⬜ Pendente |

---

## 🟡 MEDIUM — M-01: Reentrancy in burn()

| Campo | Valor |
|-------|-------|
| **Título** | `M-01: LimitedMinter — Reentrancy in burn() Allows Double-Spend via Callback` |
| **Severidade** | Medium (CVSSv3: 6.5) |
| **CWE** | CWE-362 |
| **Asset** | https://github.com/ripio/latam-contracts |
| **Tags** | `solidity`, `evm`, `bridge`, `m-01` |
| **Guia completo** | `submissions/MANUAL_SUBMISSION_MEDIUM.md` |
| **PoC** | `poc/test/ExploitLimitedMinterReentrancy.t.sol` |
| **Status** | ⬜ Pendente |

---

## 🟡 MEDIUM — M-02: Fee Calculation Rounding

| Campo | Valor |
|-------|-------|
| **Título** | `M-02: BridgeDeposit — Fee Calculation Rounding Error Allows Small Fee Bypass` |
| **Severidade** | Medium (CVSSv3: 5.3) |
| **CWE** | CWE-190 |
| **Asset** | https://github.com/ripio/latam-contracts |
| **Tags** | `solidity`, `evm`, `bridge`, `m-02` |
| **Guia completo** | `submissions/MANUAL_SUBMISSION_MEDIUM.md` |
| **PoC** | `poc/test/ExploitBridgeFeeBypass.t.sol` |
| **Status** | ⬜ Pendente |

---

## ⚪ LOW — L-01: Unlimited Mint

| Campo | Valor |
|-------|-------|
| **Título** | `L-01: LatamStable — Unlimited Mint Allows Infinite Token Supply` |
| **Severidade** | Low (CVSSv3: 3.7) |
| **CWE** | CWE-284 |
| **Asset** | https://github.com/ripio/latam-contracts |
| **Tags** | `solidity`, `evm`, `stablecoin`, `l-01` |
| **Guia completo** | `submissions/MANUAL_SUBMISSION_LOW.md` |
| **PoC** | `poc/test/ExploitLatamStableUnlimitedMint.t.sol` |
| **Status** | ⬜ Pendente |

---

## 📊 Resumo

| Severidade | Total | Submetidos | Pendentes |
|------------|-------|------------|-----------|
| 🔴 High | 1 | 0 | 1 |
| 🟡 Medium | 2 | 0 | 2 |
| ⚪ Low | 1 | 0 | 1 |
| **Total** | **4** | **0** | **4** |

---

## 🔗 Links Úteis

- [HackerOne — Novo Report](https://hackerone.com/ripio/reports/new)
- [HackerOne — Meus Reports](https://hackerone.com/reports)
- [Guia de Submissão HackerOne](https://docs.hackerone.com/en/articles/8480691-submitting-a-report)
