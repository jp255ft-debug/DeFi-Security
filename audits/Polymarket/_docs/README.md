# Auditoria de Segurança — Polymarket CTF Exchange v2

## Escopo da Auditoria

| Contrato | Caminho | Linhas | Linguagem |
|---|---|---|---|
| **PermissionedRamp** (NonceManager) | `src/collateral/PermissionedRamp.sol` | 210 | Solidity 0.8.34 |
| **CollateralToken** | `src/collateral/CollateralToken.sol` | 250 | Solidity 0.8.34 |
| **CTFExchange** | `src/exchange/CTFExchange.sol` | 113 | Solidity 0.8.34 |
| **Trading** | `src/exchange/mixins/Trading.sol` | 717 | Solidity <0.9.0 |
| **Auth** | `src/exchange/mixins/Auth.sol` | 91 | Solidity <0.9.0 |
| **Hashing** | `src/exchange/mixins/Hashing.sol` | 38 | Solidity <0.9.0 |
| **Fees** | `src/exchange/mixins/Fees.sol` | 68 | Solidity <0.9.0 |
| **Assets** | `src/exchange/mixins/Assets.sol` | 50 | Solidity <0.9.0 |
| **Structs** | `src/exchange/libraries/Structs.sol` | 89 | Solidity <0.9.0 |

## Metodologia

- Análise manual linha a linha com checklists de segurança
- Verificação de padrões CEI (Checks-Effects-Interactions)
- Análise de controle de acesso e roles
- Verificação de validação de nonce e assinaturas EIP-712
- Análise de reentrância e chamadas externas
- Verificação de dependência de oráculos

## Resumo dos Findings

| Severidade | Quantidade | Descrição |
|---|---|---|
| 🔴 **High** | 5 | Perda financeira direta, bloqueio de fundos, drenagem de colateral |
| 🟡 **Medium** | 8 | Condições adversas, riscos operacionais, falta de eventos |
| 🔵 **Low** | 0 | — |
| ⚪ **Gas** | 0 | — |

## Findings de Alta Severidade

| ID | Título | Arquivo | CVSSv3 |
|---|---|---|---|
| HIGH-01 | Cross-Chain Replay de Nonce — Ausência de `block.chainid` | PermissionedRamp.sol | 8.3 |
| HIGH-02 | Nonce Incrementado Antes da Validação da Assinatura | PermissionedRamp.sol | 7.5 |
| HIGH-03 | Reentrância no Callback de Wrap/Unwrap — Quebra do CEI | CollateralToken.sol | 7.6 |
| HIGH-04 | Ausência de Validação de Limite no Nonce | PermissionedRamp.sol | 6.5 |
| HIGH-05 | Dependência de Oráculo UMA sem Validação | CtfCollateralAdapter.sol | 7.5 |

## Findings de Média Severidade

| ID | Título | Arquivo | CVSSv3 |
|---|---|---|---|
| MED-01 | Ausência de Validação de `_callbackReceiver` | CollateralToken.sol | 5.3 |
| MED-02 | Aprovação Ilimitada de Token no Construtor | Assets.sol | 5.9 |
| MED-03 | Ausência de Verificação signer vs maker | Signatures.sol | 5.4 |
| MED-04 | Ausência de Deadline em Ordens | Structs.sol | 5.3 |
| MED-05 | Possível Manipulação de Preço via Flash Loan | Trading.sol | 5.9 |
| MED-06 | `renounceOperatorRole` Pode Deixar sem Operadores | Auth.sol | 5.9 |
| MED-07 | Ausência de Eventos em Role Management | CollateralToken.sol | 5.3 |
| MED-08 | Ausência de Validação de Amount Zero | CollateralToken.sol | 5.3 |

## Contexto do Ataque de 19 de Fevereiro de 2026

O ataque reportado em fevereiro de 2026 explorou exatamente o mecanismo de sincronização off-chain/on-chain do Polymarket. O atacante manipulou o nonce, fazendo com que transações on-chain fossem canceladas ou invalidadas enquanto os registros off-chain permaneciam válidos. Isso enganou bots de market making e permitiu drenagem de lucros.

### Vetores Identificados na Auditoria

1. **Nonce incrementado antes da validação da assinatura (HIGH-02):** Permite que um atacante front-run a transação da vítima, queimando seu nonce e invalidando operações legítimas enquanto as operações off-chain permanecem ativas.

2. **Cross-chain replay (HIGH-01):** Se o domain separator EIP-712 não incluir `block.chainid`, assinaturas válidas em uma chain podem ser reutilizadas em outra, permitindo drenagem cross-chain.

3. **Reentrância em wrap/unwrap (HIGH-03):** Callbacks antes da finalização das operações permitem reentrância e manipulação de estado.

## Recomendações Prioritárias

1. **Corrigir HIGH-02 imediatamente:** Mover o incremento do nonce para depois da validação da assinatura
2. **Corrigir HIGH-01:** Adicionar `block.chainid` ao hash do struct EIP-712
3. **Corrigir HIGH-03:** Reordenar operações em wrap/unwrap para seguir CEI
4. **Implementar deadline em ordens (MED-04):** Evitar execução de ordens antigas
5. **Adicionar verificação de operador mínimo (MED-06):** Evitar paralisação do sistema

## Como Reproduzir

```bash
# Configurar ambiente
cd audits/Polymarket/poc
forge install

# Rodar testes de PoC
forge test --match-contract ExploitNonceFrontrun -vvvv
forge test --match-contract ExploitCrossChainReplay -vvvv
forge test --match-contract ExploitReentrancyWrap -vvvv
```
