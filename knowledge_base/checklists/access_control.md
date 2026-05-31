# Checklist de Controle de Acesso

## Pontos Críticos
1. Toda função que altera variáveis de estado críticas (donos, taxas, limites) deve ter um modificador de acesso (`onlyOwner`, `onlyRole`).
2. Nunca usar `tx.origin` para autenticação. Sempre usar `msg.sender`.
3. Verificar se funções de inicialização (`initialize`) podem ser chamadas múltiplas vezes (ausência de `initializer`).
4. Contas privilegiadas (owner, admin) devem ser controladas por timelock ou multisig.
5. Funções de `approve` e `transferFrom` devem usar os padrões corretos (ERC20, ERC721).

## Exemplos de Falhas
- Função `setFee(uint256)` sem modificador – permite que qualquer um altere taxas.
- `require(tx.origin == owner)` – vulnerável a phishing via contrato intermediário.
- `initialize()` pública sem checar `initialized` – permite que atacante re-inicialize e troque dono.

## Perfil de Risco
Mais de 59% das perdas em DeFi em 2025 foram causadas por falhas de controle de acesso.
