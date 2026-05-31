# Checklist de Projeto DePIN

## 1. Planejamento
- [ ] Definir caso de uso (IoT, veicular, energia, etc.)
- [ ] Escolher rede DePIN (Streamr, Helium, DIMO, custom)
- [ ] Definir frequencia de coleta de dados
- [ ] Estimar custos de gas on-chain
- [ ] Definir modelo de incentivo (se aplicavel)

## 2. Conectores
- [ ] Escolher tipo de conector (API, MQTT, arquivo)
- [ ] Implementar autenticacao (API key, OAuth, wallet)
- [ ] Testar coleta de dados offline
- [ ] Validar formato dos dados (JSON schema)
- [ ] Implementar rate limiting e retry
- [ ] Testar modo streaming

## 3. Assinatura Criptografica
- [ ] Gerar wallet Ethereum segura
- [ ] Configurar PRIVATE_KEY em .env (nunca no codigo!)
- [ ] Testar assinatura ECDSA com Web3.py
- [ ] Verificar recuperacao de endereco (ecrecover)
- [ ] Testar compatibilidade com contrato Solidity

## 4. Smart Contracts
- [ ] Compilar DataVerifier.sol com Foundry
- [ ] Executar testes unitarios (forge test)
- [ ] Executar testes fuzz
- [ ] Auditar contrato com Slither
- [ ] Deploy em testnet (Polygon Mumbai, Sepolia)
- [ ] Verificar deploy no explorer
- [ ] Autorizar signers no contrato

## 5. Pipeline
- [ ] Testar pipeline completo localmente
- [ ] Configurar logging e monitoramento
- [ ] Implementar tratamento de erros
- [ ] Testar dry-run antes de producao
- [ ] Configurar backup dos dados

## 6. Seguranca
- [ ] NUNCA commitar chaves privadas
- [ ] Usar .gitignore para .env
- [ ] Validar assinaturas on-chain
- [ ] Implementar rate limiting no contrato
- [ ] Considerar upgradeability do contrato
- [ ] Testar cenarios de ataque (replay, spoofing)

## 7. Producao
- [ ] Deploy em mainnet
- [ ] Configurar monitoramento continuo
- [ ] Documentar procedimento de emergencia
- [ ] Estabelecer processo de atualizacao
- [ ] Backup da wallet e configs
