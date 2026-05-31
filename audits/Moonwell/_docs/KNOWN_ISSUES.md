# 🚫 Known Issues — Moonwell (Code4rena Bug Bounty)

> **ATENÇÃO:** Bugs listados aqui são **conhecidos e NÃO elegíveis para recompensa**.
> Consulte este arquivo ANTES de submeter qualquer finding.

---

## 🧠 Base Safety Module (MIP-X28)

- Bug no Base Safety Module permite que alguns usuários reivindiquem todo o orçamento de recompensa do MIP-X28.

---

## 💰 Reward Distribution

- Recompensas de empréstimo para mercados onde `reward speed` não está configurada não acumulam sem um usuário chamar `claim()` (ou alguém chamar `claimBehalf()`).
- Quando `reward speed = 0` é reativado para um mercado, as recompensas acumulam como se a nova taxa sempre estivesse ativa.

---

## 🔐 Colateral e Mercados

- Ativos fornecidos por um usuário que não chamou `enterMarkets()` ainda podem ser liquidados (seized). **Comportamento esperado.**
- Novos mercados devem ser adicionados com **collateral factor = 0**, e uma pequena quantidade do token de colateral deve ser queimada para evitar manipulação de mercado. **Problema conhecido.**

---

## 🪱 Wormhole Bridge

- Se a Wormhole ficar offline ou pausar seu relayer/contratos core, o **Multichain Governor** e o **Vote Collector** não funcionarão.
- Se a Wormhole se tornar maliciosa, pode registrar contagens de votos incorretas ou impedir que o Multichain Governor execute propostas.
- Se a Wormhole estiver pausada/offline, o Multichain Governor ainda pode executar propostas, mas usuários em outras chains não poderão submeter votos.

---

## 🗳️ Governança Cross-Chain

- Se `maxUserLiveProposals` for atualizado para um valor menor que o atual, o invariante `live proposals <= maxUserLiveProposals` pode ser temporariamente violado.
- **Quorum pode ser atualizado para zero** — se isso acontecer, uma proposta com UM único voto a favor pode passar.
- Configurar quorum muito alto faz com que propostas nunca atinjam quorum (estado `Defeated`).
- **Gas limit** pode ser atualizado via proposta de governança. Se uma chain externa tiver opcodes re-precificados, o sistema pode quebrar. Mitigação: break glass guardian.
- **Timestamps entre chains:** O sistema de governança opera em 3 chains. Se os timestamps divergirem >45s, um usuário pode votar na Moonbeam e depois bridgear tokens para outra chain e votar novamente (double voting).
- **Pause Guardian malicioso:** Pode esperar uma proposta de governança, pausar o contrato e limpar a proposta do conjunto ativo. Comunidade precisa esperar 30 dias.
- **Vote Collection malicioso:** Pode impedir execução de propostas ou passar propostas falhando ao registrar contagens incorretas.
- **Temporal Governor na Base** não pode receber ETH bruto (sem fallback payable). Reserves não podem ser enviadas do mercado ETH para ele.

---

## 🛡️ Break Glass Guardian

- Calldata aprovado deve estar configurado corretamente. Calldata incorreto pode permitir:
  - Perda completa de governança em Base, Optimism e/ou Moonbeam
  - Configuração de dados de oráculo incorretos
  - Alterações arbitrárias em parâmetros de governança

---

## ⏰ Block Timestamp

- O block timestamp não pode divergir >45 segundos entre Moonbeam e a chain externa.
- Em diferenças >45s, o Vote Collection corre risco de double voting.

---

## 📋 Regras Gerais

- **NÃO** serão pagos bounties para issues que surgirem de um governador se tornando malicioso. O pesquisador deve demonstrar como o código é vulnerável **sem usar known issues** e fornecer PoC funcional.
- **Todas as issues** de auditorias passadas estão fora de escopo: https://docs.moonwell.fi/moonwell/protocol-information/audits
- Issues submetidas por outros wardens ao bounty da Moonwell serão adicionadas a este repositório após revisão dos sponsors.

---

## ✅ Checklist de Verificação Rápida

Antes de submeter, pergunte:

1. [ ] Este bug depende de Wormhole offline/pausado/malicioso? → **KNOWN ISSUE**
2. [ ] Este bug depende de timestamps >45s entre chains? → **KNOWN ISSUE**
3. [ ] Este bug depende de Pause Guardian malicioso? → **KNOWN ISSUE**
4. [ ] Este bug depende de governador se tornando malicioso? → **NÃO ELEGÍVEL**
5. [ ] Este bug está em uma auditoria anterior? → **KNOWN ISSUE**
6. [ ] Este bug é sobre Base Safety Module (MIP-X28)? → **KNOWN ISSUE**
7. [ ] Este bug é sobre reward distribution sem `claim()`? → **KNOWN ISSUE**
8. [ ] Este bug é sobre Temporal Governor sem fallback payable? → **KNOWN ISSUE**

**Se respondeu SIM a qualquer um acima, DESCARTE o finding.**
