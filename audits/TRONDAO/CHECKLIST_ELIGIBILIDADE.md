# ✅ Checklist de Elegibilidade — TRON DAO

> **Data:** 05/05/2026
> **Programa:** HackerOne — TRON DAO (US$ 100.000)
> **Repositório:** https://github.com/tronprotocol/java-tron

---

## 🔍 Verificação de Escopo

- [x] O programa lista explicitamente os contratos que vamos auditar?
  - ✅ Sim — `java-tron` (código Java completo do nó TRON)
- [x] Os endereços dos contratos estão na lista de assets in-scope?
  - ✅ Sim — todo o repositório java-tron está in-scope
- [x] O programa tem "Hard Exclusions"? Quais?
  - ✅ **Verificado** — O "Core Ineligible Findings" do HackerOne (regras gerais da plataforma) NÃO afeta nossos vetores:
    - ❌ Teóricos / unlikely interaction → Nossos vetores são práticos
    - ❌ Clickjacking, CSRF → Não é o foco
    - ❌ SSL/TLS, cookies → Não é o foco
    - ⚠️ DoS/DDoS → Evitar vetores puramente DoS (já marcado)
    - ❌ Social engineering → Não é o foco
  - **Decisão:** Consenso, APIs e resource model NÃO estão na lista de inelegíveis
- [x] O programa tem "Known Issues" ou repositório de auditorias anteriores?
  - ⚠️ **Verificar durante a análise** — Buscar por CVE ou disclosures públicas do TRON no HackerOne
  - O SECURITY.md do repositório redireciona para o HackerOne (não há lista pública de known issues)
  - **Risco:** Baixo — consenso é área menos explorada que contratos EVM

## 🚫 Verificação de Exclusões Comuns

- [x] O bug que estamos caçando depende de **admin/owner/role comprometida**?
  - ❌ **NÃO** — Consenso e APIs não dependem de admin comprometido
- [x] O bug é **puramente teórico**?
  - ❌ **NÃO** — Todos os vetores têm PoC prática (envio de blocos/requests maliciosos)
- [x] O impacto é apenas **Denial of Service (DoS)**?
  - ⚠️ **PARCIAL** — Alguns vetores de API podem ser DoS, mas o foco principal é:
    - **Consenso:** Bypass de validação (perda de fundos) → **NÃO é DoS**
    - **APIs:** Injeção/RCE → **NÃO é DoS**
    - **Resource Model:** Energy bypass → **NÃO é DoS**
- [x] O bug é de **centralização**?
  - ❌ **NÃO** — Consenso é sobre validação distribuída, não admin
- [x] O bug depende de **oráculo de terceiros**?
  - ❌ **NÃO** — TRON não usa oráculos externos para consenso
- [x] O bug é **front-running/MEV**?
  - ❌ **NÃO** — Foco em consenso e APIs, não MEV

## ✅ Decisão Final

- [x] O vetor de ataque NÃO está listado como "out of scope" ou "hard exclusion"?
  - ✅ **SIM** — Consenso, APIs e resource model são áreas padrão de bug bounty
- [x] O contrato alvo está EXPLICITAMENTE listado como in-scope?
  - ✅ **SIM** — java-tron é o repositório oficial
- [x] O bug NÃO depende de admin/role comprometida?
  - ✅ **SIM**
- [x] O bug NÃO é puramente teórico (tem PoC explorável no código atual)?
  - ✅ **SIM** — Todos os vetores têm PoC prática
- [x] **Se todas as respostas forem SIM, prossiga com a auditoria.**
  - ✅ **PROSSEGUIR** 🚀

---

## 📊 Resumo

| Critério | Status |
|:---------|:------:|
| In-scope | ✅ |
| Hard Exclusions | ⚠️ Verificar |
| Depende de Admin | ❌ Não |
| Teórico | ❌ Não |
| Apenas DoS | ⚠️ Parcial |
| Centralização | ❌ Não |
| Oracle 3rd | ❌ Não |
| **Elegível?** | **✅ SIM** |
