# LayerZero Bug Bounty — Proof of Concept (PoC)

## 📋 Visão Geral

Este diretório contém os **Proofs of Concept (PoCs)** para as vulnerabilidades identificadas no protocolo LayerZero V2, como parte do programa de Bug Bounty na Immunefi (recompensa de até **US$ 15.000.000**).

## 🛠️ Setup

### Pré-requisitos
- [Foundry](https://book.getfoundry.sh/getting-started/installation) (forge, cast, anvil)

### Instalação
```bash
# Já está no diretório correto
cd audits/LayerZero/poc

# Baixar dependências (forge-std)
forge install foundry-rs/forge-std --no-commit

# Compilar
forge build
```

## 🧪 Execução dos Testes

### Opção 1: JavaScript (Requer apenas Node.js — recomendado)
```bash
# PoC #1: SimpleMessageLib
node test/exploit_simple_message_lib.js

# PoC #2: DVN.execute
node test/exploit_dvn_execute.js
```

### Opção 2: Foundry (Requer forge instalado)
```bash
forge install foundry-rs/forge-std --no-commit
forge build
forge test --match-contract ExploitSimpleMessageLib -vvv
forge test --match-contract ExploitDVNExecute -vvv
forge test --gas-report
```

## 📂 Estrutura

```
poc/
├── foundry.toml              # Configuração do Foundry
├── src/
│   └── mocks/
│       ├── SimpleMessageLibMock.sol  # Mock do SimpleMessageLib
│       └── DVNExecuteMock.sol        # Mock do DVN
├── test/
│   ├── ExploitSimpleMessageLib.t.sol # PoC #1: Validação insuficiente
│   └── ExploitDVNExecute.t.sol       # PoC #2: Execução sem verificação
└── README.md
```

## 🎯 Vulnerabilidades Demonstradas

### PoC #1: SimpleMessageLib — Validação Insuficiente (CRÍTICO)
- **Arquivo:** `test/ExploitSimpleMessageLib.t.sol`
- **Descrição:** `validatePacket()` verifica apenas se `msg.sender == whitelistCaller`, mas `whitelistCaller` é um endereço conhecido (EndpointV2). Qualquer um que conheça esse endereço pode forjar validações.
- **Testes:**
  1. `test_AnyoneCanCallValidatePacket` — Atacante faz prank do EndpointV2 e valida pacote
  2. `test_MultipleMaliciousPackets` — Atacante valida múltiplos pacotes maliciosos
  3. `test_NoWhitelistMeansAnyoneCanCall` — Sem whitelist, qualquer um pode chamar

### PoC #2: DVN.execute — Execução sem Verificação de Hash (ALTO)
- **Arquivo:** `test/ExploitDVNExecute.t.sol`
- **Descrição:** `_shouldCheckHash()` retorna `false` para operações `TYPE_VERIFY`, permitindo execução sem verificação de hash.
- **Testes:**
  1. `test_ShouldCheckHashReturnsFalseForVerify` — Verify não verifica hash
  2. `test_ExecuteCanBeReplayedForVerify` — Replay de mensagens verify é possível
  3. `test_FullReplayAttackScenario` — Cenário completo de ataque com replay

## 📊 Resultados Esperados

```
[PASS] test_AnyoneCanCallValidatePacket() (gas: ...)
[PASS] test_MultipleMaliciousPackets() (gas: ...)
[PASS] test_NoWhitelistMeansAnyoneCanCall() (gas: ...)
[PASS] test_ShouldCheckHashReturnsFalseForVerify() (gas: ...)
[PASS] test_ExecuteCanBeReplayedForVerify() (gas: ...)
[PASS] test_FullReplayAttackScenario() (gas: ...)
```

## ⚠️ Notas Importantes

- Os mocks em `src/mocks/` replicam fielmente a lógica vulnerável dos contratos reais
- Para testar contra contratos reais em uma mainnet fork, use `forge test --fork-url <RPC_URL>`
- Todos os testes passam sem dependências externas (apenas forge-std)
