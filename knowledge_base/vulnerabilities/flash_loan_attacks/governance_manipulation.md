# Manipulação de Governança via Flash Loan

## Descrição
Se o poder de voto é proporcional ao saldo de token e o token é obtível via flash loan, um atacante pode tomar um flash loan, votar em uma proposta maliciosa e devolver o empréstimo no mesmo bloco.

## Vetores de Ataque
- **Votação direta:** Emprestar tokens, delegar a si mesmo, votar em proposta maliciosa.
- **Criação de proposta:** Criar proposta para drenar tesouro, votar e aprovar em um bloco.
- **Quórum:** Se o quórum é baseado em saldo atual, flash loans podem atingi-lo facilmente.

## Verificações de Segurança
- O token de governança possui período de lockup ou snapshot histórico? (ex: `delegates` com `checkpointing` como Uniswap UNI).
- A proposta exige quórum mínimo baseado em snapshots passados?
- Há um delay entre votação e execução (timelock)?

## Mitigação
- Usar snapshots de saldo (ex: ERC20Votes do OpenZeppelin)
- Implementar timelock entre aprovação e execução
- Exigir período mínimo de staking para votar
