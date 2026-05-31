# Relatório de Vulnerabilidade

**Título:** [Nome descritivo da vulnerabilidade]
**Protocolo:** [Nome do projeto]
**Severidade:** [Critical / High / Medium / Low]
**CVSSv3:** [Score] — Vetor: [AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:N]
**Recompensa esperada:** [Valor ou percentual, conforme programa]

---

## Resumo
Descreva a vulnerabilidade em 2-3 frases.

## Descrição Detalhada
Explique tecnicamente a falha, incluindo trechos de código relevantes e como o estado é manipulado.

```solidity
// Código vulnerável com comentários apontando o problema
function exemplo() external {
    // ❌ Problema aqui
}
```

## Impacto
Descreva o que um atacante pode conseguir (roubo de fundos, congelamento, etc.) e quanto pode ser perdido.

## Prova de Conceito
**Arquivo:** `poc/test/ExploitX.t.sol`
**Comando para executar:**
```bash
forge test --fork-url <RPC> -vvvv
```
**Resultado esperado:**
```
Running 1 test for test/ExploitX.t.sol
[PASS] testAttack() (gas: 142530)
Logs:
  Attacker balance before: 0 ETH
  Attacker balance after:  5 ETH
  Expected max:            1 ETH
  💥 Attack successful: Drained 5x the allowed amount!
```

## Recomendação de Correção
Proponha código de correção ou alterações de lógica.

```solidity
// Código corrigido
function exemplo() external onlyOwner {
    // ✅ Correção aqui
}
```

## Cronograma de Correção
| Prioridade | Finding | Esforço Estimado | Recomendação |
|---|---|---|---|
| 🔴 Imediato | [ID] | [X horas] | [Ação] |
| 🟡 Curto prazo | [ID] | [Y horas] | [Ação] |
| ⚪ Quando puder | [ID] | [30 min] | [Ação] |

## Como Reproduzir
```bash
# Clone e configure
git clone <repo>
cd audits/01_Example_Protocol/poc
cp .env.example .env  # configure RPC_URL

# Execute os PoCs
forge test --match-contract ExploitReentrancy -vvvv
forge test --match-contract ExploitOracleManipulation -vvvv
```

## Referências
- [Link para documentação relevante]
- [Link para CVE ou exploit similar]
- [Link para Immunefi]
