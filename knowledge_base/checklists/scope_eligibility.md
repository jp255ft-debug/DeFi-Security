# Checklist de Elegibilidade de Escopo (Pre-Análise)

> Preencher **ANTES** de iniciar qualquer análise de código.

## 🔍 Verificação de Escopo

- [ ] O programa lista explicitamente os contratos que vamos auditar?
- [ ] Os endereços dos contratos estão na lista de assets in-scope?
- [ ] O programa tem "Hard Exclusions"? Quais?
- [ ] O programa tem "Known Issues" ou repositório de auditorias anteriores?

## 🚫 Verificação de Exclusões Comuns

- [ ] O bug que estamos caçando depende de **admin/owner/role comprometida**?
  - Se SIM, verificar se o programa exclui "Centralization risks" ou "Attacks requiring compromised admin keys".
- [ ] O bug é **puramente teórico** (ex: "se o `nonReentrant` for removido")?
  - Se SIM, está EXCLUÍDO em programas como Ripio ("Theoretical reentrancy without working PoC").
- [ ] O impacto é apenas **Denial of Service (DoS)**?
  - Se SIM, verificar se o programa aceita DoS. A maioria exclui.
- [ ] O bug é de **centralização** (ex: admin pode mintar, pausar, upgradar)?
  - Se SIM, está EXCLUÍDO na maioria dos programas como "accepted design choice".
- [ ] O bug depende de **oráculo de terceiros**?
  - Se SIM, verificar se o programa exclui "Incorrect data supplied by third party oracles".
- [ ] O bug é **front-running/MEV**?
  - Se SIM, verificar se o programa exclui MEV como "inherent to public blockchains".

## ✅ Decisão Final

- [ ] O vetor de ataque NÃO está listado como "out of scope" ou "hard exclusion"?
- [ ] O contrato alvo está EXPLICITAMENTE listado como in-scope?
- [ ] O bug NÃO depende de admin/role comprometida (a menos que o programa aceite)?
- [ ] O bug NÃO é puramente teórico (tem PoC explorável no código atual)?
- [ ] Se todas as respostas forem SIM, **prossiga com a auditoria**.

## 📚 Referência Rápida de Programas

| Programa | Centralização? | DoS? | Teórico? | Oracle 3rd? |
|:---|:---:|:---:|:---:|:---:|
| **Ripio** | ❌ Excluído | ❌ Excluído | ❌ Excluído | ❌ Excluído |
| **Polymarket** | ❌ Excluído | ⚠️ Verificar | ⚠️ Verificar | ❌ Excluído |
| **Circle** | ⚠️ Verificar | ⚠️ Verificar | ⚠️ Verificar | ⚠️ Verificar |
| **LayerZero** | ⚠️ Verificar | ⚠️ Verificar | ⚠️ Verificar | ⚠️ Verificar |
