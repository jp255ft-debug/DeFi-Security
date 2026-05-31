# 🚫 Padrões de Rejeição — Base de Conhecimento

**Propósito:** Documentar cada rejeição como um padrão a ser evitado, com causa, lição e prevenção.

> "Aqueles que não aprendem com a história estão condenados a repeti-la." — Adaptado de George Santayana

---

## Como Usar

1. **Antes de submeter**: Revise esta lista para verificar se seu relatório se enquadra em algum padrão conhecido
2. **Após uma rejeição**: Adicione um novo padrão aqui para sistematizar o aprendizado
3. **Periodicamente**: Revise os padrões para identificar tendências nos seus erros

---

## 📋 Padrões Documentados

### P-001: PoC não interagia com contratos reais

| Campo | Detalhe |
|:---|:---|
| **Projeto** | Moonwell (Code4rena) |
| **Finding** | HIGH-03 — `MockCollateralToken` sem controle de acesso |
| **Data** | Maio/2026 |
| **Causa Raiz** | O PoC usava um mock (`MockCollateralToken`) que não tinha o controle de acesso real (`onlyRoles(WRAPPER_ROLE)`). O ataque funcionava no mock, mas não seria possível no contrato real. |
| **Lição** | O PoC deve ser escrito contra o contrato **implantado na mainnet**, não contra mocks. Mocks só são aceitáveis para contratos auxiliares (tokens, oráculos mock). |
| **Prevenção** | ✅ `validate_submission.py` detecta se o PoC usa mocks para o contrato alvo |
| | ✅ `poc_validation.md` item 1.4: "O PoC não depende de mocks genéricos para o contrato alvo?" |
| | ✅ Sempre usar fork da mainnet e interagir com endereços oficiais |

---

### P-002: PoC não executava transações reais

| Campo | Detalhe |
|:---|:---|
| **Projeto** | LayerZero (Immunefi) |
| **Finding** | HIGH-05 — SimpleMessageLib sem verificação de `_payloadHash` |
| **Data** | Maio/2026 |
| **Causa Raiz** | O PoC apenas imprimia texto explicando o ataque, sem executar transações reais na blockchain. A Immunefi exige um "PoC codificado e executável". |
| **Lição** | Um PoC textual não é aceito. O PoC deve ser um contrato Solidity executável que demonstre o ataque em uma transação real. |
| **Prevenção** | ✅ `validate_submission.py` verifica a presença de logs de impacto financeiro |
| | ✅ `poc_validation.md` item 2: "O PoC demonstra alteração no saldo de tokens/ETH?" |
| | ✅ Todo PoC deve ser escrito em Solidity (Foundry) e executado com `forge test` |

---

### P-003: Escopo não verificado antes do PoC

| Campo | Detalhe |
|:---|:---|
| **Projeto** | Circle USDC Bridge (HackerOne) |
| **Finding** | Relatório sobre oráculo UMA — rejeitado por escopo |
| **Data** | Maio/2026 |
| **Causa Raiz** | O programa excluía explicitamente "dados incorretos de oráculos de terceiros". O vetor de ataque identificado estava fora do escopo do programa. |
| **Lição** | A verificação de escopo deve ser o **primeiro passo**, antes mesmo de escrever o PoC. O HackerOne confirma que problemas "fora do escopo" são uma das principais causas de rejeição. |
| **Prevenção** | ✅ `validate_submission.py` verifica contratos in-scope vs PoC |
| | ✅ `poc_validation.md` item 4: "O contrato atacado está listado como in-scope?" |
| | ✅ Sempre baixar e ler o escopo completo antes de começar a análise |

---

### P-004: Biblioteca herdada já mitigava o risco

| Campo | Detalhe |
|:---|:---|
| **Projeto** | LayerZero (Immunefi) |
| **Finding** | HIGH-04 — EIP-712 sem `deadline` e `chainId` |
| **Data** | Maio/2026 |
| **Causa Raiz** | O finding identificou que a implementação de EIP-712 não incluía `deadline` e `chainId`. No entanto, a biblioteca **Solady** (herdada pelo contrato) já implementava essas proteções. O achado era conceitualmente correto (OWASP SCWE-147), mas a biblioteca já resolvia o problema. |
| **Lição** | Antes de reportar a ausência de uma proteção, verifique se a biblioteca herdada já a implementa. Bibliotecas como Solady, OpenZeppelin e Solmate frequentemente incluem proteções que não são óbvias à primeira vista. |
| **Prevenção** | ✅ `validate_submission.py` verifica bibliotecas conhecidas no PoC |
| | ✅ `poc_validation.md` item 5: "As bibliotecas herdadas pelo contrato foram verificadas?" |
| | ✅ Sempre inspecionar as dependências do contrato antes de finalizar o finding |

---

### P-005: PoC sem fork da mainnet

| Campo | Detalhe |
|:---|:---|
| **Projeto** | Monetrix (Code4rena) |
| **Finding** | M-01 — `settle()` ignora bridge retention |
| **Data** | Maio/2026 |
| **Causa Raiz** | O PoC foi escrito como um teste unitário simples, sem usar fork da mainnet. A Immunefi é clara: "O PoC de smart contract deve ser sempre feito através de um fork da mainnet" para refletir o estado real da blockchain. |
| **Lição** | Testes unitários com mocks não substituem um fork da mainnet. O fork garante que saldos, permissões e estados de contratos reais sejam respeitados. |
| **Prevenção** | ✅ `validate_submission.py` verifica `--fork-url` em foundry.toml e arquivos de teste |
| | ✅ `poc_validation.md` item 1.1: "O PoC foi executado com `forge test --fork-url <RPC> -vvvv`?" |
| | ✅ Template de PoC já inclui configuração de fork |

---

## 📊 Estatísticas

| Métrica | Valor |
|:---|:---|
| Total de padrões documentados | 5 |
| Rejeições por escopo | 1 (20%) |
| Rejeições por PoC inadequado | 3 (60%) |
| Rejeições por biblioteca mitigadora | 1 (20%) |
| Taxa de aprendizado | 100% (todos os padrões têm prevenção implementada) |

---

## 🔄 Ciclo de Melhoria Contínua

```
Rejeição → Documentar padrão → Implementar prevenção → Validar → Submeter novamente
    ↑                                                              |
    └──────────────────────────────────────────────────────────────┘
```

Cada rejeição documentada aqui representa um investimento que se paga múltiplas vezes ao evitar que o mesmo erro se repita.

---

> ⚡ **Lembrete:** Rejeições não são fracassos — são dados. Cada rejeição documentada aqui é um padrão que você nunca mais precisará aprender da maneira difícil.
