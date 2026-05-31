# ✅ Checklist de Avaliação STRIDE — Solana

**Programa:** Solana Foundation — Avaliação Contínua de Segurança
**Versão:** 1.0 — Abril 2026
**Baseado nos 8 Pilares Oficiais do STRIDE**

> Este checklist deve ser executado **antes de finalizar qualquer relatório de avaliação STRIDE** para clientes Solana. Cada pilar é pontuado de 0 a 10.

---

## 📊 Sumário de Pontuação

| # | Pilar | Pontuação (0-10) | Status |
|:--|:------|:-----------------|:-------|
| P1 | Segurança do Programa | — | ⬜ |
| P2 | Governança e Controle de Acesso | — | ⬜ |
| P3 | Risco de Oráculo | — | ⬜ |
| P4 | Infraestrutura | — | ⬜ |
| P5 | Supply Chain | — | ⬜ |
| P6 | Segurança Operacional | — | ⬜ |
| P7 | Monitoramento e Resposta a Incidentes | — | ⬜ |
| P8 | Gerenciamento de Logs e Análise Forense | — | ⬜ |
| | **Total** | **/ 80** | |

---

## P1 — Segurança do Programa

### Revisão de Código Anchor/Sealevel

- [ ] **Verificação de Contas (Account Validation):** Todas as contas passadas como parâmetro são validadas com `Account<'info, T>` ou `UncheckedAccount` com verificações manuais?
- [ ] **Signer Verification:** Toda operação sensível verifica `Signer` ou `signer` na struct de contas?
- [ ] **PDA Derivation:** PDAs são derivados com `find_program_address` e verificados com `seeds` corretas? Não há seeds arbitrárias?
- [ ] **CPI Safety:** Chamadas cross-program (CPI) usam `invoke_signed` quando necessário? O `signer_seeds` é restrito ao mínimo necessário?
- [ ] **Close Account:** Contas fechadas têm `close = <destinatário>` no Anchor? O destinatário não é a própria conta?
- [ ] **Reinitialization Attack:** A conta verifica se já foi inicializada antes de permitir nova inicialização?
- [ ] **Arithmetic Safety:** Usa `checked_*` ou `SafeMath`? Não há `overflow`/`underflow` em operações financeiras?
- [ ] **Integer Casting:** Casts entre `u64`, `u128`, `i64` são seguros? Não há truncamento acidental?
- [ ] **Account Data Matching:** O discriminador de conta Anchor (8 bytes) é verificado? Não há confusão entre tipos de conta?
- [ ] **Owner Check:** O programa verifica `account.owner == program_id` antes de desserializar dados?

### Análise Estática

- [ ] **Soteria:** Executou `soteria -target .` no programa? Nenhum finding crítico?
- [ ] **Anchor Lint:** Executou `anchor lint`? Nenhum aviso de segurança?
- [ ] **Trident:** Se aplicável, executou `trident audit`?

### Testes

- [ ] **Testes Unitários:** Cada instrução tem teste unitário cobrindo casos felizes e borda?
- [ ] **Testes de Integração:** Fluxos completos (depósito → negociação → saque) são testados?
- [ ] **Fuzzing:** Usou `trident fuzz` ou `honggfuzz` para fuzzing de instruções?
- [ ] **Invariant Testing:** Invariantes de estado (ex: total supply == sum of balances) são testados?

**Pontuação P1:** ___ / 10

---

## P2 — Governança e Controle de Acesso

### Modelo de Governança

- [ ] **Multi-sig:** Atualizações de programa exigem multi-sig (ex: Squads, Realms)?
- [ ] **Timelock:** Decisões críticas têm timelock (mínimo 24h para upgrades)?
- [ ] **Quorum:** Decisões de governança exigem quorum mínimo de votos?
- [ ] **Voting Delay:** Há delay entre proposta e execução para permitir contestação?
- [ ] **Emergency Override:** Existe mecanismo de pausa/emergência? Quem controla?

### Controle de Acesso

- [ ] **Role-Based Access:** Funções administrativas usam `#[access_control]` ou equivalente?
- [ ] **Principle of Least Privilege:** Contas admin têm apenas as permissões necessárias?
- [ ] **Key Rotation:** Chaves de admin podem ser rotacionadas? Há processo documentado?
- [ ] **Revogação:** Permissões podem ser revogadas individualmente sem afetar outras?
- [ ] **Delegation:** Delegação de poder é temporária e auditável?

**Pontuação P2:** ___ / 10

---

## P3 — Risco de Oráculo

### Fontes de Dados

- [ ] **Pyth Network:** Usa Pyth para preços? Verificou se o feed está ativo e com heartbeat adequado?
- [ ] **Switchboard:** Usa Switchboard? Verificou a frequência de atualização e tolerância a stale data?
- [ ] **Fallback Oráculos:** Existe oráculo secundário em caso de falha do primário?
- [ ] **Aggregation:** Múltiplos oráculos são agregados (mediana, TWAP) ou depende de fonte única?

### Manipulação de Preço

- [ ] **Staleness Check:** O código verifica `price.age < max_age` antes de usar o preço?
- [ ] **Confidence Interval:** Usa `price.confidence` da Pyth para rejeitar preços voláteis?
- [ ] **Price Deviation:** Rejeita preços com desvio > X% do preço anterior?
- [ ] **TWAP:** Usa TWAP (time-weighted average price) em vez de preço spot para operações críticas?
- [ ] **Liquidation Safety:** Liquidações usam preço do oráculo com desconto de segurança (ex: 5%)?

### Dependência

- [ ] **Single Point of Failure:** O protocolo não depende de um único oráculo para funcionar?
- [ ] **Circuit Breaker:** Se o oráculo falhar, o protocolo pausa operações automaticamente?
- [ ] **Oracle Health Monitoring:** Há monitoramento contínuo da saúde dos feeds de oráculo?

**Pontuação P3:** ___ / 10

---

## P4 — Infraestrutura

### RPC e Conectividade

- [ ] **RPC Provider:** Usa provedor RPC confiável (Helius, Triton, QuickNode)? Há redundância?
- [ ] **Rate Limiting:** O código lida com rate limiting de RPC? Há retry com backoff?
- [ ] **WebSocket:** Conexões WebSocket têm reconexão automática e heartbeat?
- [ ] **Geographic Distribution:** Os nós RPC estão distribuídos geograficamente?

### Validadores

- [ ] **Validator Set:** O protocolo depende de validadores específicos? Há diversificação?
- [ ] **Stake Distribution:** A distribuição de stake entre validadores é saudável?
- [ ] **Validator Monitoring:** Validadores críticos são monitorados 24/7?

### Rede

- [ ] **DDoS Protection:** O protocolo tem proteção contra DDoS (rate limiting, captcha)?
- [ ] **Gas Management:** O código gerencia custos de computação (CU) corretamente? Não excede o limite?
- [ ] **Transaction Priority:** Usa `computeUnitPrice` ou `computeUnitLimit` para priorizar transações?
- [ ] **Retry Logic:** Transações falhas têm retry com aumento de priority fee?

**Pontuação P4:** ___ / 10

---

## P5 — Supply Chain

### Dependências

- [ ] **Anchor Version:** Usa versão estável e atualizada do Anchor? Verificou CVE conhecidos?
- [ ] **Dependency Audit:** Todas as dependências (crates, npm) foram auditadas?
- [ ] **Lockfile:** `Cargo.lock` e `yarn.lock` estão versionados? São verificados em CI?
- [ ] **Vulnerability Scanning:** Dependências são escaneadas com `cargo audit` ou `npm audit`?
- [ ] **Supply Chain Attack:** Dependências são de fontes oficiais? Verificou hashes?

### Build e Deploy

- [ ] **Reproducible Build:** O build é reproduzível? `anchor build --verifiable` funciona?
- [ ] **CI/CD Security:** Pipeline CI/CD tem secrets seguros? Não expõe chaves privadas?
- [ ] **Code Signing:** Binários deployados são assinados? A verificação de integridade é automática?
- [ ] **Dependency Pinning:** Versões de dependências são fixadas (não `^` ou `>=`)?

**Pontuação P5:** ___ / 10

---

## P6 — Segurança Operacional

### Gerenciamento de Chaves

- [ ] **Key Storage:** Chaves privadas (deployer, admin) são armazenadas em HSM ou vault (ex: AWS KMS, GCP Cloud KMS)?
- [ ] **Key Rotation:** Chaves são rotacionadas periodicamente? Há política documentada?
- [ ] **Backup:** Chaves têm backup seguro? O backup é testado periodicamente?
- [ ] **Access Control:** Acesso às chaves é restrito ao mínimo de pessoas necessárias?

### Deploy e Upgrades

- [ ] **Upgrade Authority:** O programa tem `upgrade_authority` definido? É um multi-sig?
- [ ] **Buffer Account:** A conta buffer para upgrades é protegida? Não é a mesma que a authority?
- [ ] **Immutable Flag:** Programas imutáveis têm `immutable = true` no deploy?
- [ ] **Deploy Script:** Script de deploy é revisado e versionado? Não contém secrets hardcoded?
- [ ] **Rollback Plan:** Existe plano de rollback documentado para upgrades com falha?

### Incident Response

- [ ] **Runbook:** Runbook de resposta a incidentes está documentado e testado?
- [ ] **Contacts:** Contatos de emergência estão atualizados e acessíveis 24/7?
- [ ] **Communication Plan:** Plano de comunicação com usuários em caso de incidente?
- [ ] **Insurance:** O protocolo tem seguro (Nexus Mutual, Unslashed) para cobrir perdas?

**Pontuação P6:** ___ / 10

---

## P7 — Monitoramento e Resposta a Incidentes

### Monitoramento

- [ ] **On-Chain Monitoring:** Transações suspeitas são monitoradas em tempo real (ex: solana-tracker, bespoke)?
- [ ] **Anomaly Detection:** Há detecção de anomalias (volume anormal, padrões de ataque conhecidos)?
- [ ] **Alerting:** Alertas são enviados para canais apropriados (PagerDuty, Slack, Telegram)?
- [ ] **Dashboard:** Há dashboard de segurança com métricas em tempo real?
- [ ] **Health Checks:** Endpoints de health check são monitorados? Falhas geram alertas?

### Resposta

- [ ] **Pause Mechanism:** O protocolo pode ser pausado em < 5 minutos?
- [ ] **Emergency Upgrade:** Upgrade de emergência pode ser feito em < 30 minutos?
- [ ] **Whitelist/Blacklist:** Endereços maliciosos podem ser bloqueados rapidamente?
- [ ] **Fund Recovery:** Há mecanismo de recuperação de fundos (ex: rescue, clawback)?
- [ ] **Post-Mortem:** Incidentes passados têm post-mortem documentado com ações corretivas?

**Pontuação P7:** ___ / 10

---

## P8 — Gerenciamento de Logs e Análise Forense

### Logging

- [ ] **Event Emission:** Instruções emitem eventos Anchor (`emit!`) para ações críticas?
- [ ] **Data Richness:** Eventos incluem dados suficientes para reconstruir o estado (amount, user, timestamp)?
- [ ] **Indexed Fields:** Campos indexados permitem busca eficiente por usuário, token, etc.?
- [ ] **Sensitive Data:** Eventos não expõem dados sensíveis (senhas, chaves privadas)?
- [ ] **Log Retention:** Logs são retidos por período mínimo (ex: 1 ano)?

### Análise Forense

- [ ] **Transaction Tracing:** É possível rastrear uma transação do início ao fim (incluindo CPIs)?
- [ ] **Account History:** Histórico de contas (mudanças de estado) é rastreável?
- [ ] **Simulation:** Ferramentas de simulação (ex: `solana-test-validator`) podem reproduzir o incidente?
- [ ] **Snapshot:** Snapshots de estado são tirados periodicamente para análise forense?
- [ ] **External Tools:** Ferramentas como Solscan, SolanaFM, ou bespoke são usadas para investigação?

### Compliance

- [ ] **Audit Trail:** Logs formam uma trilha de auditoria completa e imutável?
- [ ] **Regulatory Compliance:** Logs atendem requisitos regulatórios (ex: GDPR, MiCA)?
- [ ] **Data Privacy:** Logs não violam privacidade de usuários (dados pessoais são anonimizados)?

**Pontuação P8:** ___ / 10

---

## 📋 Score Final

| Pontuação Total | Classificação | Ação |
|:---------------:|:-------------|:------|
| **70-80** | 🟢 Excelente | Baixo risco — recomendações menores |
| **50-69** | 🟡 Moderado | Risco médio — algumas melhorias necessárias |
| **30-49** | 🟠 Elevado | Risco alto — várias correções obrigatórias |
| **< 30** | 🔴 Crítico | Risco crítico — não recomendado para produção |

---

## 🔗 Referências

- [Solana STRIDE Program — Documentação Oficial](https://solana.com/stride)
- [Anchor Framework — Security Best Practices](https://www.anchor-lang.com/docs/security)
- [Pyth Network — Security Considerations](https://docs.pyth.network/)
- [Soteria — Solana Security Scanner](https://soteria.dev/)
- [OWASP — Solana Smart Contract Top 10](https://owasp.org/)
- [Solana Foundation — Security Guidelines](https://docs.solana.com/)

---

> ⚡ **Regra de Ouro:** Uma avaliação STRIDE completa exige pontuação >= 50/80 para recomendação de produção. Abaixo disso, o cliente deve implementar correções antes do lançamento.
