# Template de Finding

## [SEV-XX] Título do Finding

| Campo | Valor |
|---|---|
| **Severidade** | [Critical / High / Medium / Low / Gas / Informational] |
| **CVSSv3** | [Score] — Vetor: [AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:N] |
| **Arquivo** | `src/Contrato.sol` |
| **Linha** | XX |
| **Função** | `nomeDaFuncao()` |
| **Status** | [Aberto / Corrigido / Aceito] |

## Descrição
[Descrição detalhada da vulnerabilidade, incluindo contexto do contrato]

## Código Vulnerável
```solidity
// Código vulnerável com comentários apontando o problema
function exemplo() external {
    // ❌ Problema aqui
}
```

## Impacto
[O que um atacante pode fazer com essa vulnerabilidade]

## Prova de Conceito
**Arquivo:** `poc/test/ExploitX.t.sol`
**Comando:**
```bash
forge test --fork-url $RPC_URL -vvvv
```
**Resultado esperado:**
```
[PASS] testAttack() (gas: 142530)
Logs:
  💥 Attack successful: Drained 5x the allowed amount!
```

## Recomendação de Correção
```solidity
// Código corrigido
function exemplo() external onlyOwner {
    // ✅ Correção aqui
}
```

## Cronograma
| Prioridade | Esforço |
|---|---|
| 🔴 Imediato | X horas |

## Referências
- [Link para documentação relevante]
- [Link para CVE ou exploit similar]
