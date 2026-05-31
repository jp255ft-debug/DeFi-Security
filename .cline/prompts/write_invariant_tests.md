# Prompt: Escrever Testes de Invariantes com Foundry

Modo: DeepSeek-R1 (raciocínio profundo sobre invariantes do protocolo)

Contexto: Você está analisando {contrato} para escrever testes de
invariantes (Invariant Tests) em Foundry.

## Categorias de Invariantes a Modelar

### 1. INVARIANTES FINANCEIROS (obrigatórios)
- "A soma de todos os saldos nunca excede o totalSupply"
- "O colateral total nunca é menor que a dívida total * threshold"
- "O que entra = o que sai + o que fica no protocolo"
- "O balanço do contrato sempre reflete as operações realizadas"

### 2. INVARIANTES DE ACESSO (obrigatórios)
- "Só admins podem chamar funções onlyOwner"
- "Só minters podem mintar tokens"
- "Só wrappers podem chamar wrap/unwrap"
- "Roles nunca são concedidas sem evento correspondente"

### 3. INVARIANTES DE ESTADO (recomendados)
- "Nonces são monotônicos e nunca decrescem"
- "O pause/unpause nunca fica inconsistente"
- "O totalSupply de tokens minted = total burned + circulating"
- "O preço do oráculo nunca desvia mais que X% em Y blocos"

### 4. INVARIANTES DE SEGURANÇA (críticos)
- "Reentrância não consegue drenar mais que o permitido"
- "Flash loans não conseguem manipular preço por mais de 1 bloco"
- "Assinaturas EIP-712 não podem ser reutilizadas entre chains"
- "Nonces incrementam exatamente 1 por operação bem-sucedida"

## Estrutura do InvariantTest

```
poc/test/
├── handlers/
│   ├── LendingPoolHandler.sol    # Age como usuário/atacante
│   └── OracleHandler.sol         # Age como oráculo manipulador
├── InvariantFinancial.t.sol      # Invariantes financeiros
├── InvariantAccess.t.sol         # Invariantes de acesso
└── InvariantSecurity.t.sol       # Invariantes de segurança
```

### Handler.sol — Template Base
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";

/// @title LendingPoolHandler
/// @notice Handler que age como usuário/atacante no protocolo
/// @dev Usado pelo InvariantTest para fuzzar o protocolo
contract LendingPoolHandler is Test {
    // --- Ghost Variables (rastreamento de estado esperado) ---
    uint256 public ghost_totalDeposits;
    uint256 public ghost_totalBorrows;
    uint256 public ghost_totalRepayments;
    
    // --- Actor Management ---
    address[] public actors;
    mapping(address => bool) public isActor;
    
    // --- Funções do Handler ---
    // Cada função do protocolo vira uma função no handler
    // com vm.assume() para filtrar entradas inválidas
    
    function deposit(uint256 amount, uint8 actorIndex) public {
        // Garante que o ator existe
        vm.assume(actorIndex < actors.length);
        address actor = actors[actorIndex];
        
        // Limita o amount para evitar overflow
        amount = bound(amount, 1, 1000 ether);
        
        // Executa a ação
        vm.startPrank(actor);
        // ... chamada ao protocolo ...
        vm.stopPrank();
        
        // Atualiza ghost variable
        ghost_totalDeposits += amount;
    }
    
    function borrow(uint256 amount, uint8 actorIndex) public {
        vm.assume(actorIndex < actors.length);
        address actor = actors[actorIndex];
        amount = bound(amount, 1, 100 ether);
        
        vm.startPrank(actor);
        // ... chamada ao protocolo ...
        vm.stopPrank();
        
        ghost_totalBorrows += amount;
    }
}
```

### InvariantTest — Template
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {LendingPoolHandler} from "./handlers/LendingPoolHandler.sol";

/// @title InvariantFinancial
/// @notice Testa invariantes financeiros do LendingPool
/// @dev Executa com: forge test --match-test "invariant_" -vvvv
contract InvariantFinancial is Test {
    LendingPool public pool;
    LendingPoolHandler public handler;
    
    function setUp() public {
        // Deploy do protocolo
        pool = new LendingPool();
        
        // Deploy do handler
        handler = new LendingPoolHandler();
        
        // Configura o alvo do fuzzing
        // O Foundry vai chamar handler.deposit() e handler.borrow()
        // com valores aleatórios por 256 rounds
        targetContract(address(handler));
        
        // Opcional: adicionar atores
        for (uint256 i = 0; i < 5; i++) {
            address actor = address(uint160(uint256(keccak256(abi.encode(i)))));
            // deal(actor, 1000 ether);
        }
    }
    
    /// @notice Invariante: totalSupply >= soma de todos os saldos
    function invariant_totalSupply_ge_sumOfBalances() public {
        uint256 totalSupply = pool.totalSupply();
        uint256 sumBalances;
        
        for (uint256 i = 0; i < handler.actors.length; i++) {
            sumBalances += pool.balanceOf(handler.actors[i]);
        }
        
        assertGe(totalSupply, sumBalances, "totalSupply < sum of balances");
    }
    
    /// @notice Invariante: colateral >= dívida * threshold
    function invariant_collateral_ge_debtTimesThreshold() public {
        uint256 totalCollateral = pool.totalCollateral();
        uint256 totalDebt = pool.totalDebt();
        uint256 threshold = pool.LIQUIDATION_THRESHOLD();
        
        // Colateral deve ser >= dívida * threshold / 100
        assertGe(totalCollateral, totalDebt * threshold / 100);
    }
    
    /// @notice Invariante: ghost_totalDeposits == pool.totalCollateral()
    function invariant_ghostMatchesState() public {
        assertEq(handler.ghost_totalDeposits, pool.totalCollateral());
    }
}
```

## Regras Obrigatórias

1. **Sempre use `vm.assume()`** para filtrar entradas inválidas antes de chamar o protocolo
2. **Sempre use `bound()`** para limitar ranges de fuzzing a valores realistas
3. **Sempre inclua um handler que age como ATACANTE** — não apenas como usuário legítimo
4. **Use actor management** para evitar colisões de estado entre diferentes chamadas
5. **Ghost variables** são obrigatórias para rastrear o estado esperado
6. **Mínimo de 5 invariantes** por contrato auditado
7. **Mínimo de 3 atores** no handler para testar interações entre usuários

## Exemplo de Handler com Atacante

```solidity
contract AttackHandler is Test {
    LendingPool pool;
    bool public attackMode;
    
    function depositAndBorrow(uint256 amount) public {
        if (attackMode && amount % 100 == 0) {
            // 1% das vezes, tenta reentrância
            try this.reentrancyAttack(amount) {
                // ataque bem-sucedido
            } catch {
                // ataque falhou (esperado se protegido)
            }
        } else {
            // Comportamento normal
            pool.deposit(amount);
        }
    }
    
    function reentrancyAttack(uint256 amount) external {
        // Tenta reentrância
        pool.borrow(amount);
        // Se conseguir, chama de novo no callback
    }
}
```
