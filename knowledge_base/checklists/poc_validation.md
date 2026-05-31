# ✅ Checklist de Validação de PoC (Proof of Concept)

**Padrões:** Immunefi, Code4rena, Sherlock — Mercado 2026

> Este checklist deve ser executado **antes de qualquer submissão** de bug bounty ou relatório de auditoria. Cada item não verificado é um risco de rejeição.

---

## 🔬 1. Ambiente de Execução

- [ ] **O PoC foi executado com `forge test --fork-url <RPC> -vvvv`?**
  - ❌ PoCs com `forge test` sem `--fork-url` são rejeitados pela Immunefi
  - ✅ O fork da mainnet reflete o estado real da blockchain (saldo, storage, oráculos)
- [ ] **O PoC compila sem erros?** (`forge build`)
- [ ] **O PoC usa Foundry ou Hardhat?** (ferramentas exigidas pela Immunefi)
- [ ] **O PoC não depende de mocks genéricos para o contrato alvo?**
  - ⚠️ Mocks são aceitáveis apenas para contratos auxiliares (ex: token ERC20 mock)
  - ❌ O contrato **vulnerável** deve ser o real, implantado na mainnet

## 💰 2. Impacto Financeiro

- [ ] **O PoC demonstra alteração no saldo de tokens/ETH?**
  - Use `console.log` ou `emit log` para exibir `balanceOf()` antes e depois
  - Ex: `console.log("Attacker balance after:", attackerBalance);`
- [ ] **O PoC quantifica o valor perdido?**
  - Ex: "Drained 5 ETH", "Stole 10,000 USDC"
  - ✅ A Immunefi exige "detalhar claramente cada etapa do ataque com print statements, exibindo informações relevantes como fundos roubados"
- [ ] **O PoC mostra o estado da blockchain antes e depois do ataque?**
  - ✅ Logs de pré-condição e pós-condição são obrigatórios

## 🛡️ 3. Mitigação

- [ ] **O PoC inclui um teste que aplica a correção proposta e reverte?**
  - ✅ Crie um segundo teste que aplica a mitigação e espera `revert`
  - Ex: `vm.expectRevert();` seguido da chamada vulnerável com a correção
- [ ] **A correção proposta é específica e implementável?**
  - ✅ Código de correção deve ser fornecido no relatório, não apenas descrito

## 🎯 4. Escopo

- [ ] **O contrato atacado está listado como "in-scope"?**
  - ✅ Verifique o escopo do programa antes de escrever o PoC
  - ❌ Fora de escopo = rejeição garantida (HackerOne: causa #1 de rejeição)
- [ ] **O vetor de ataque não está excluído pelo programa?**
  - ✅ Verifique exclusões como "dados incorretos de oráculos de terceiros", "problemas de frontend", etc.
- [ ] **O finding não está listado como "known issue"?**
  - ✅ Verifique `KNOWN_ISSUES.md` ou documentação equivalente do projeto

## 📚 5. Bibliotecas e Dependências

- [ ] **As bibliotecas herdadas pelo contrato foram verificadas?**
  - ✅ Verifique se a biblioteca já implementa a proteção que você identificou como ausente
  - Ex: Solady EIP-712 já inclui `deadline` e `chainId` — verificar antes de reportar
- [ ] **A versão do Solidity e das dependências está atualizada?**
  - ✅ Versões antigas podem ter vulnerabilidades conhecidas já corrigidas

## 📝 6. Formatação da Submissão

- [ ] **O PoC é auto-contido e executável em um único comando?**
  - ✅ `forge test --fork-url <RPC> --match-contract ExploitX -vvvv`
- [ ] **O relatório inclui o comando exato para reproduzir?**
- [ ] **O relatório inclui a saída esperada dos logs?**
- [ ] **O relatório referencia fontes externas (OWASP, CVE, documentação)?**

---

## 📊 Score de Validação

| Status | Itens OK | Ação |
|:---|:---|:---|
| 🟢 **Pronto para submeter** | 12/12 | Submeta o relatório |
| 🟡 **Risco moderado** | 9-11/12 | Revise os itens faltantes antes de submeter |
| 🔴 **Alto risco de rejeição** | < 9/12 | Não submeta — corrija os itens primeiro |

---

## 🔗 Referências

- [Immunefi — Submission Standards](https://immunefi.com/)
- [Code4rena — Submission Guidelines](https://code4rena.com/)
- [Sherlock — Criteria for Payouts](https://sherlock.xyz/)
- [OWASP SCWE-147 — Missing EIP-712 Fields](https://owasp.org/)
- [HackerOne — Top Reasons for Report Rejection](https://hackerone.com/)

---

> ⚡ **Regra de Ouro:** Se o PoC não passa em todos os 12 itens, a submissão tem alta probabilidade de rejeição. Invista o tempo para acertar antes de submeter.
