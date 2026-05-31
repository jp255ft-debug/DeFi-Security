# CHECKLIST DE SUBMISSAO - Moonwell Bug Bounty

## Pre-Submissao

- [x] Finding documentado em `findings/high/F-001_COMPOSITE_ORACLE_NO_STALENESS_CHECK.md`
- [x] Submissao formatada em `submissions/SUBMISSION_F001_COMPOSITE_ORACLE_STALENESS.md`
- [x] PoC Foundry criado em `poc/test/ExploitCompositeOracleStaleness.t.sol`
- [x] Mock do Chainlink criado em `poc/src/mocks/MockAggregator.sol`
- [x] Relatorio final em `RELATORIO_FINAL_MOONWELL.md`
- [x] KNOWN_ISSUES.md verificado - finding NAO listado
- [x] PoC executado com sucesso (4/4 testes passando)

## Validacao de PoC (Mercado 2026)

### Passo 1: Validacao Automatica
- [ ] Executar `python ../../../scripts/validate_submission.py --poc-dir . --poc-test test/ExploitCompositeOracleStaleness.t.sol --known-issues ../_docs/KNOWN_ISSUES.md --finding "ChainlinkCompositeOracle - Missing Staleness Check" --log`
- [ ] Verificar score 8/8 (todas as verificacoes automaticas passaram)
- [ ] Se alguma verificacao falhar, corrigir antes de prosseguir

### Passo 2: Checklist Manual
- [ ] Revisar `knowledge_base/checklists/poc_validation.md` (12 itens)
- [ ] Verificar item 1.1: PoC usa fork da mainnet? (--fork-url)
- [ ] Verificar item 1.4: PoC nao depende de mocks para o contrato alvo? (MockAggregator e aceitavel pois e um oraculo auxiliar)
- [ ] Verificar item 2: PoC demonstra impacto financeiro? (logs de balanceOf)
- [ ] Verificar item 3: PoC inclui teste de mitigacao? (expectRevert)
- [ ] Verificar item 4: Contrato atacado esta in-scope?
- [ ] Verificar item 5: Bibliotecas herdadas verificadas?
- [ ] Verificar item 6: Formatacao da submissao completa?

### Passo 3: Revisao de Rejeicoes
- [ ] Revisar `knowledge_base/rejection_patterns.md` para verificar se o relatorio se enquadra em algum padrao conhecido
- [ ] Verificar P-001: PoC nao usa mocks para contrato alvo? ✅ (MockAggregator e auxiliar)
- [ ] Verificar P-002: PoC executa transacoes reais? ✅
- [ ] Verificar P-003: Escopo verificado? ✅
- [ ] Verificar P-004: Biblioteca herdada verificada? ✅

## Submissao na Code4rena

### Passo 1: Acessar a plataforma
- [ ] Abrir https://code4rena.com/bounties/moonwell
- [ ] Fazer login (ou criar conta)
- [ ] Clicar em "Submit Finding"

### Passo 2: Preencher o formulario
- [ ] **Titulo:** "ChainlinkCompositeOracle - Missing Staleness Check in getPriceAndDecimals()"
- [ ] **Severidade:** HIGH
- [ ] **Categoria:** Oracle Manipulation
- [ ] **Contrato:** ChainlinkCompositeOracle.sol
- [ ] **Descricao:** Colar o conteudo de `RELATORIO_FINAL_MOONWELL.md` (secao 1-7)
- [ ] **Impacto:** Liquidacoes injustas, emprestimos subcolateralizados, diferenca de 2.85% no preco composto
- [ ] **PoC:** Anexar o arquivo `poc/test/ExploitCompositeOracleStaleness.t.sol`
- [ ] **Links:** Incluir referencia ao Chainlink docs e OWASP SCWE-086

### Passo 3: Revisar antes de enviar
- [ ] Verificar se o PoC esta anexado
- [ ] Verificar se a severidade esta correta (HIGH)
- [ ] Verificar se o titulo e claro e descritivo
- [ ] Verificar se o impacto financeiro esta bem explicado
- [ ] Verificar se a recomendacao de correcao esta incluida

### Passo 4: Submeter
- [ ] Clicar em "Submit"
- [ ] Aguardar confirmacao
- [ ] Salvar o ID da submissao

## Pos-Submissao

- [ ] Monitorar o status da submissao
- [ ] Responder a quaisquer perguntas dos revisores
- [ ] Se solicitado, fornecer informacoes adicionais
- [ ] Aguardar a triagem e classificacao

## Lembretes Importantes

- **KYC:** Pode ser necessario para receber pagamento
- **PoC obrigatorio:** Ja incluido (4/4 testes passando)
- **Nao duplicado:** Verificado contra KNOWN_ISSUES.md
- **Prazo:** Submeter o quanto antes para evitar duplicidade com outros wardens

---

**Recompensa estimada:** US$ 15.000 - US$ 20.000
**Status:** PRONTO PARA SUBMISSAO 🚀
