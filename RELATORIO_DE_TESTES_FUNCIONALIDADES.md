# Relatório de Testes H2V-Trust

**Data:** 25 de Abril de 2026
**Objetivo:** Avaliar e reportar o nível de integridade de todas as funcionalidades de Backend (Integração e Oráculos) e Smart Contracts.

A execução dos testes foi dividida em duas grandes frentes: Testes de Contrato Inteligente (Hardhat/Solidity) e Testes de Backend (Pytest/Python).

Métricas Gerais:
- **Total de testes da Suíte Smart Contracts:** 39
- **Total de testes da Suíte Backend:** 54
- **Total Executado:** 93
- **Testes com Sucesso (Passed):** 90 (96.8%)
- **Testes com Falhas (Failed):** 3 (3.2%)

---

## 1. Testes de Smart Contracts (Hardhat)

> [!TIP]
> **Status:** 100% de Sucesso (39 passed)
> Todos os testes rodaram de forma estável, com cobertura robusta sobre a lógica On-Chain.

**Funcionalidades Validadas:**
- **Deployment:** Nomes e Símbolos corretos, Owner fixado, contador inicializado.
- **Minting (Emissão):** Emissão de certificados, bloqueio de conta *non-owner*, restrição de lote duplicado. Múltiplos mintings.
- **Consumption (Consumo):** Consumo correto e bloqueios para re-consumo.
- **Verificação:** Extração e verificação de validade de dados e cálculo de compensação de carbono.
- **Batch Operations e Admin:** Operações por produto, alteração de registradores e impedimentos a *non-owners*.
- **SBT Properties (Soulbound):** Bloqueio intencional de transferência de Tokens para usuários regulares e permissão livre apenas para o Owner (Migração).

---

## 2. Testes de Backend e Integração (Pytest)

> [!WARNING]
> **Status:** 94.4% de Sucesso (51 passed, 3 failed)
> A maioria significativa testou limpo, mas existem 3 falhas concentradas na integração simulada da Web3 (`web3.py`) dentro dos módulos do Blockchain Client.

**Funcionalidades Com Sucesso:**
- **API Geral (`test_api.py`):** Completos e corretos.
- **Regras Analíticas de Compliance (`test_compliance.py`):** Os testes que confirmam limites estritos de emissão, geração de relatórios e regras do CBAM estão **passando com perfeição**.
- **Sistema de Delegação (`test_delegation.py`):** Completo; criação, revogação e limite de *expiry* passam sem erros.
- **Fluxo Integrado (`test_integration.py`):** Todo o fluxo de simulação unida.
- **Oráculo e Telemetria (`test_oracle.py`):** Completamente aprovado no mock.

**Falhas Encontradas (Necessária Revisão):**

Todos os erros ocorrem em `tests/test_blockchain.py`:

1. `TestWeb3Client.test_get_network_info`
   - *Motivo:* Há uma asserção de Chain ID dura: `assert 1337 == 31337`. O teste experava 31337 (geralmente do Hardhat), mas a rede mockada/configurações do .env subiram o network info como `1337` (geralmente Ganache).

2. `TestMintingService.test_mint_certificate`
   - *Motivo:* Exceção estrita de validação do Web3: `web3.exceptions.InvalidAddress`.
   - *Detalhes:* O teste está passando uma string hexadecimal qualquer para imitar o endereço (`0x1234567890abcdef1234567890abcdef12345678`). Contudo, a lib `web3.py` demanda _Checksum Addresses_ (letras maiúsculas e minúsculas formatadas usando EIP-55).

3. `TestMintingService.test_mint_with_invalid_address`
   - *Motivo:* Outra exceção não tratada devidamente pelo teste de validação do Web3: `web3.exceptions.InvalidAddress: ENS name: 'invalid' is invalid`.
   - *Detalhes:* Este teste possivelmente visa verificar a "graça" do mock/backend ao falhar. No entanto, o `web3.py` está injetando a Exceção pura durante a preparação da transação `encode_transaction_data`, quebrando a rotina inteira no Python usando Asyncio.

---

## Conclusões e Recomendações

O projeto em grande parte encontra-se em um excelente estado funcional. A criptografia e as checagens normativas de Blockchain não expuseram furos lógicos nas políticas de Compliance ou Autenticação.

**Passos Seguintes:**
1. **[Backend]** No arquivo `tests/test_blockchain.py`, corrija a asserção da Chain ID para bater com a do ambiente usado para o mock (1337).
2. **[Backend]** Refatore o `producer_address` mockado nos testes para utilizar um endereço checksum real gerado por `Web3.to_checksum_address()` se ele for fixo, evitando hardcodes sem Checksum.
3. **[Backend]** No teste de endereço inválido, use `pytest.raises` para capturar a `InvalidAddress` devidamente, evitando que esse *edge case* exploda o runner de testes inteiro.
