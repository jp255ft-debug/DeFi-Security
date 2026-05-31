Modo: DeepSeek (escolha automática; preferir R1 se a vulnerabilidade for sutil)

Com base na vulnerabilidade relatada em `{findings_file}`, escreva um contrato de ataque em Solidity dentro de `{audit_path}/poc/test/`.
O arquivo deve chamar-se `Exploit<Nome>.t.sol`.

Requisitos:
- Use Foundry e fork da mainnet (configuração em `foundry.toml`).
- Importe interfaces de `poc/src/interfaces/`.
- Demonstre claramente o roubo de fundos (use `deal` ou flash loans para financiar o atacante).
- O teste deve passar com `forge test --fork-url <RPC_URL> -vvvv`.
- Inclua comentários explicativos no código.
