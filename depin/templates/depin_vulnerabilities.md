# Vulnerabilidades Comuns em Projetos DePIN

## 1. Assinatura e Verificacao

### Assinatura Replay
- **Problema**: Atacante reutiliza uma assinatura valida para enviar dados duplicados
- **Mitigacao**: Incluir nonce ou timestamp na mensagem assinada
- **Exemplo**: `sign(keccak256(abi.encodePacked(data, nonce, address(this))))`

### Recuperacao Incorreta de Endereco
- **Problema**: Uso incorreto de ecrecover (v out of range, hash sem prefixo)
- **Mitigacao**: Sempre usar `\x19Ethereum Signed Message:\n32` prefix
- **Referencia**: EIP-191, EIP-712

### Chave Privada Exposta
- **Problema**: Chave privada no codigo fonte, logs, ou variaveis de ambiente
- **Mitigacao**: Usar HSM, AWS KMS, ou hardware wallet
- **Nunca**: Commitar .env, hardcodear keys

## 2. Dados e Telemetria

### Manipulacao de Dados
- **Problema**: Dispositivo comprometido envia dados falsos
- **Mitigacao**: Validacao cruzada com oracles, reputacao de dispositivos
- **Mitigacao**: Assinatura hardware-based (TPM, Secure Enclave)

### Frequencia de Dados
- **Problema**: Dispositivo envia dados em frequencia maior que o esperado (spam)
- **Mitigacao**: Rate limiting no contrato, custo por submissao

### Dados Incompletos
- **Problema**: Dados parciais ou corrompidos
- **Mitigacao**: Schema validation, checksums, campos obrigatorios

## 3. Smart Contracts

### Reentrancy
- **Problema**: Contrato chama externo antes de atualizar estado
- **Mitigacao**: Checks-Effects-Interactions pattern, ReentrancyGuard

### Oracle Manipulation
- **Problema**: Atacante manipula fonte de dados do oracle
- **Mitigacao**: Multiplos oracles, median pricing, challenge period

### Front-running
- **Problema**: Atacante ve transacao pendente e antecipa
- **Mitigacao**: Commit-reveal schemes, submarine sends

### Gas Griefing
- **Problema**: Atacante faz transacao com gas insuficiente
- **Mitigacao**: Verificar gas remaining, usar forwarding contracts

## 4. Rede e Conectividade

### Man-in-the-Middle
- **Problema**: Atacante intercepta comunicacao dispositivo-servidor
- **Mitigacao**: TLS/HTTPS obrigatorio, assinatura dos dados

### DDoS no Conector
- **Problema**: Sobrecarga do servidor de coleta
- **Mitigacao**: Rate limiting, autenticacao, cloudflare

### Dependencia de API Centralizada
- **Problema**: Conector depende de API unica que pode cair
- **Mitigacao**: Fallback para multiplas APIs, cache local

## 5. Economico

### Sybil Attack
- **Problema**: Atacante cria multiplos dispositivos falsos
- **Mitigacao**: Proof-of-physical-presence, staking, reputacao

### Incentivos Mal Projetados
- **Problema**: Sistema recompensa comportamento malicioso
- **Mitigacao**: Game theory analysis, testar incentivos em testnet

### Custos de Gas Imprevisiveis
- **Problema**: Picos de gas tornam operacao inviavel
- **Mitigacao**: L2 solutions, batching de transacoes, gas oracles

## 6. Checklist de Seguranca DePIN

- [ ] Assinaturas usam EIP-191/EIP-712
- [ ] Nonce ou timestamp na mensagem (anti-replay)
- [ ] Rate limiting no contrato
- [ ] Multiplos oracles ou challenge period
- [ ] Dados validados antes de armazenar
- [ ] Chaves privadas em HSM/secure storage
- [ ] Logs nao expoem informacoes sensiveis
- [ ] Testes de fuzz para assinatura
- [ ] Auditoria externa do contrato
- [ ] Plano de resposta a incidentes
