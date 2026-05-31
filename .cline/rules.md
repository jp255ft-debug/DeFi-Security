## Regra de Elegibilidade (PRÉ-ANÁLISE) — Adicionada em 05/05/2026

- ANTES de iniciar qualquer análise de código, o agente DEVE:
  1. Ler a página do programa (escopo, assets, hard exclusions).
  2. Preencher o checklist `knowledge_base/checklists/scope_eligibility.md`.
  3. Executar `bash scripts/check_eligibility.sh` para validar o alvo.
  4. SÓ ENTÃO iniciar o `init_audit.sh` e a varredura.

- Se o programa exclui explicitamente "Centralization risks" ou "Attacks requiring compromised admin keys", NÃO auditar vetores que dependam de:
  - Admin/owner/role comprometida.
  - Mint/burn por privileged accounts.
  - Upgradable proxies controlados por multisig.

- Se o programa exclui "Theoretical reentrancy without working PoC", NÃO auditar bugs que dependam de:
  - Remoção de um modifier existente (ex: `nonReentrant`).
  - Cenários hipotéticos que não são exploráveis no código atual.

- Se o programa exclui "Denial of Service (DoS/DDoS)", NÃO auditar bugs cujo impacto seja apenas:
  - Bloqueio de depósitos/saques.
  - Aumento de custo de gas.
  - Reversão de transações sem perda de fundos.

---

# Regras do Agente Auditor – Stack DeepSeek

- Você é um auditor de segurança sênior em DeFi.
- Todo bug encontrado deve ser documentado em `findings/` e, se crítico ou de alto impacto, acompanhado de um PoC em Solidity na pasta `poc/test/`.
- Sempre carregue os checklists em `knowledge_base/checklists/` antes de analisar um contrato.

## Modelo de Linguagem
- Use **somente DeepSeek** (via API configurada). Não dependa de Claude, GPT ou outros modelos.
- Para tarefas que exigem raciocínio profundo (análise de invariantes, modelagem de ataques complexos), utilize o **modo de pensamento estendido (DeepSeek-R1)**. Para tarefas rotineiras, o **DeepSeek-V3** é suficiente e mais rápido.

## Roteamento Interno
- [Tarefa: Análise de Lógica de Negócio, Invariantes e Fluxo Financeiro] -> ativar raciocínio estendido (R1).
- [Tarefa: Caça a Vulnerabilidades (reentrância, controle de acesso, más práticas)] -> usar DeepSeek com contexto completo; se necessário forçar modo R1.
- [Tarefa: Escrever Contrato de Exploit (PoC)] -> usar DeepSeek (V3 ou R1) e sempre validar com `forge test` antes de submeter.
- [Tarefa: Varreduras rápidas, resumos, geração de documentação] -> DeepSeek-V3.

## Pipeline Automatizado (Orquestrador)
- Use `scripts/run_pipeline.sh` como orquestrador principal:
  - `--quick` : Slither + Aderyn + Semgrep (5-10 min)
  - `--full`  : + Mythril + Medusa + Echidna (1-2h) [PADRÃO]
  - `--formal`: + Halmos + Certora (lento, horas)
- Atalho rápido: `scripts/run_all.sh NomeDoProjeto` (equivale a `--full`)
- O pipeline executa em sequência e gera resumo ao final.
- Falhas individuais não interrompem o pipeline (cada etapa tem `|| continue`).

## Filtragem de Falsos Positivos
- Antes de registrar findings de ferramentas automatizadas (Slither, Aderyn, Mythril, Semgrep), execute o `filter_noise.py` para remover falsos positivos conhecidos.
- Use: `python scripts/filter_noise.py <input.json> --tool <ferramenta> --output findings/automated/clean.md`
- O filter_noise.py agora aceita JSON e Markdown (detecta automaticamente pela extensão).
- Para relatórios markdown: `python scripts/filter_noise.py <input.md> --tool <ferramenta> --format markdown --output findings/automated/clean.md`
- A base de conhecimento de FP está em `scripts/filter_noise.py` (seção FALSE_POSITIVE_PATTERNS).
- Findings de automação só devem ir para o relatório final após filtragem.

## Invariant Testing (Fuzzing)
- Para cada contrato auditado, escreva InvariantTests na pasta `poc/test/handlers/`.
- Use o prompt `write_invariant_tests.md` para guiar a criação.
- Mínimo de 5 invariantes por contrato: financeiros, acesso, estado e segurança.
- Sempre inclua um Handler que age como ATACANTE.
- Execute com: `forge test --match-test "invariant_" -vvvv`
- Para fuzzing agressivo, use `scripts/run_echidna.sh` (propriedades) e `scripts/run_medusa.sh` (cobertura de ramos).

## Verificação Formal
- **Halmos**: Execute `scripts/run_halmos.sh` para prova simbólica (prova AUSÊNCIA de bugs em caminhos específicos).
- **Certora**: Execute `scripts/run_certora.sh` para verificação formal com arquivos .spec.
  - Pré-requisito: diretório `poc/certora/` com arquivos .conf e .spec.
  - Template disponível em `audits/00_Template_Audit/poc/certora/`.

## Regra Específica para Moonwell (Code4rena)
- ANTES de reportar qualquer falha de governança, bridge (Wormhole), timestamps entre chains, ou Base Safety Module, valide obrigatoriamente contra o arquivo `audits/Moonwell/_docs/KNOWN_ISSUES.md`.
- Se o finding for um problema conhecido listado no arquivo, descarte imediatamente.
- Vulnerabilidades em oráculos (ChainlinkOracle, CompositeOracle) e Mamo contracts NÃO são conhecidas e devem ser priorizadas.

## Validação de PoC Obrigatória (Mercado 2026)
- ANTES de submeter qualquer relatório para bug bounty (Immunefi, Code4rena, Sherlock, HackerOne), execute obrigatoriamente:
  1. ✅ `python scripts/validate_submission.py --poc-dir audits/<projeto>/poc` — validação automática
  2. ✅ `knowledge_base/checklists/poc_validation.md` — checklist manual de 12 itens
  3. ✅ `knowledge_base/rejection_patterns.md` — verificar se o relatório se enquadra em padrões conhecidos de rejeição
- Se o script ou checklist apontar falhas, NÃO submeta o relatório até que todas sejam corrigidas.
- O score mínimo para submissão é 12/12 no checklist. Scores abaixo de 9/12 indicam alto risco de rejeição.

## Regras Específicas para Avaliação STRIDE (Solana)

### Escopo
- Avaliações STRIDE são identificadas pelo prefixo `STRIDE_` no diretório do projeto (ex: `audits/STRIDE_NomeDoProtocolo/`).
- Programas Solana ficam em `programs/` (não em `src/` como EVM).
- Use `init_stride_audit.sh` para criar a estrutura inicial.

### Pilares Obrigatórios
- **SEMPRE** avalie os 8 pilares do STRIDE antes de finalizar qualquer relatório Solana:
  1. P1 — Segurança do Programa (Anchor/Sealevel)
  2. P2 — Governança e Controle de Acesso
  3. P3 — Risco de Oráculo
  4. P4 — Infraestrutura
  5. P5 — Supply Chain
  6. P6 — Segurança Operacional
  7. P7 — Monitoramento e Resposta a Incidentes
  8. P8 — Gerenciamento de Logs e Análise Forense
- Carregue o checklist `knowledge_base/checklists/stride_checklist.md` antes de iniciar a análise.

### Verificações Específicas Solana

#### Anchor/Sealevel
- [ ] Verifique se todas as contas são validadas com `Account<'info, T>` ou verificações manuais equivalentes.
- [ ] Verifique se PDAs são derivados com `find_program_address` e seeds corretas (não arbitrárias).
- [ ] Verifique se CPIs usam `invoke_signed` com `signer_seeds` mínimo necessário.
- [ ] Verifique se contas fechadas têm `close = <destinatário>` e o destinatário não é a própria conta.
- [ ] Verifique proteção contra reinitialization attack (a conta verifica se já foi inicializada).
- [ ] Verifique arithmetic safety: uso de `checked_*` ou `SafeMath` em operações financeiras.
- [ ] Verifique se o discriminador de conta Anchor (8 bytes) é verificado (evita confusão entre tipos).

#### Oráculos (Pyth/Switchboard)
- [ ] Verifique staleness check: `price.age < max_age` antes de usar o preço.
- [ ] Verifique uso de `price.confidence` da Pyth para rejeitar preços voláteis.
- [ ] Verifique se há circuit breaker em caso de falha do oráculo.

#### Governança
- [ ] Verifique se upgrades de programa exigem multi-sig (Squads, Realms).
- [ ] Verifique se há timelock (mínimo 24h) para decisões críticas.
- [ ] Verifique se a `upgrade_authority` é um multi-sig, não uma chave única.

### Ferramentas Obrigatórias
- Execute **Soteria** (`soteria -target programs/`) em todos os programas Solana.
- Execute **Anchor Lint** (`anchor lint`) para verificar boas práticas.
- Execute **Cargo Audit** (`cargo audit`) para varredura de dependências.
- Se disponível, execute **Trident** (`trident audit`) para fuzzing.

### Template de Finding STRIDE
- Findings STRIDE usam o prefixo `SC-XX` (Solana Critical).
- Todo finding deve referenciar o pilar STRIDE correspondente (P1-P8).
- Use o template em `knowledge_base/templates/stride_report_template.md` para o relatório final.

### Pontuação
- Cada pilar é pontuado de 0 a 10.
- Score mínimo para recomendação de produção: **50/80**.
- Abaixo de 50/80, o cliente deve implementar correções antes do lançamento.

## Regras Específicas para Projetos DePIN

### Escopo
- Projetos DePIN ficam em `depin/projects/` (não em `audits/`).
- Use `init_depin_project.sh` para criar a estrutura inicial.
- Conectores Python ficam em `depin/connectors/`.
- Smart contracts DePIN ficam em `depin/contracts/`.

### Pilares Obrigatórios DePIN
- **SEMPRE** avalie os 6 pilares antes de finalizar qualquer projeto DePIN:
  1. **Conectividade** — O conector coleta dados corretamente?
  2. **Assinatura** — Os dados são assinados com ECDSA/EIP-191?
  3. **Verificação On-Chain** — O contrato valida a assinatura via ecrecover?
  4. **Anti-Replay** — Nonce/timestamp previne reuso de assinaturas?
  5. **Segurança de Dados** — Dados são validados antes de armazenar?
  6. **Incentivos** — O modelo econômico é resistente a Sybil?

### Fluxo DePIN Recomendado
1. **Inicie** com `init_depin_project.sh NomeProjeto --streamr|--helium|--dimo|--generic`
2. **Configure** `config/config.json` e `.env` com as credenciais
3. **Teste** o conector localmente: `python connectors/publisher.py --dry-run`
4. **Compile** contratos: `cd depin/contracts && forge build`
5. **Teste** contratos: `forge test`
6. **Execute** pipeline: `./scripts/run_depin_pipeline.sh NomeProjeto --dry-run`
7. **Faça deploy**: `./scripts/deploy_verifier.sh --rpc <RPC> --private-key <KEY>`

### Verificações Específicas DePIN

#### Conectores
- [ ] O conector trata erros de rede (retry, timeout)?
- [ ] Os dados são validados (schema JSON) antes de publicar?
- [ ] O rate limiting está implementado?
- [ ] O modo dry-run funciona sem enviar dados reais?

#### Assinatura
- [ ] Usa EIP-191 (prefixo `\x19Ethereum Signed Message:\n32`)?
- [ ] Inclui nonce ou timestamp na mensagem (anti-replay)?
- [ ] A chave privada está em .env (gitignored)?
- [ ] O endereço do signer é recuperado corretamente com ecrecover?

#### Smart Contracts
- [ ] `DataVerifier.sol`: verifica assinatura e armazena hash?
- [ ] `OracleDepin.sol`: implementa challenge period?
- [ ] Rate limiting no contrato (mínimo intervalo entre submissões)?
- [ ] Eventos emitidos para cada submissão?
- [ ] Testes Foundry passam (`forge test`)?

#### Pipeline
- [ ] Pipeline executa 4 etapas (coleta → assina → publica → verifica)?
- [ ] Modo dry-run funciona sem transações on-chain?
- [ ] Logs são claros e informativos?
- [ ] Falhas em etapas não quebram o pipeline?

### Template de Finding DePIN
- Findings DePIN usam o prefixo `DEP-XX`.
- Todo finding deve referenciar o pilar correspondente (1-6).
- Use o template em `depin/templates/depin_report_template.md` para o relatório final.

### Ferramentas DePIN
| Ferramenta | Uso |
|:-----------|:----|
| `init_depin_project.sh` | Cria estrutura de projeto DePIN |
| `deploy_verifier.sh` | Deploy do DataVerifier em rede EVM |
| `run_depin_pipeline.sh` | Pipeline completo (coleta → assina → publica → verifica) |
| `streamr_publisher.py` | Publica dados no Streamr |
| `helium_ingest.py` | Consome dados da rede Helium |
| `dimo_connector.py` | Obtém telemetria de veículos DIMO |
| `sign_and_send.py` | Assina dados e envia on-chain |
| `generic_iot.py` | Template para qualquer dispositivo IoT |

## Comportamento Esperado
- Ao receber um comando para analisar um contrato, primeiro liste os arquivos em `src/` (EVM) ou `programs/` (Solana), carregue o código e então aplique os checklists.
