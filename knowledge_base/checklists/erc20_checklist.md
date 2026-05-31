# Checklist ERC-20 / Tokens

## Padrão Básico
- [ ] `totalSupply` não pode ser alterado arbitrariamente.
- [ ] `balanceOf` retorna valores consistentes após transferências.
- [ ] `transfer`, `transferFrom`, `approve` seguem a especificação ERC-20.
- [ ] `decimals` retorna valor correto e imutável.

## Extensões e Armadilhas
- **Permit:** Verificar que a assinatura verifica `deadline` e `nonce` para evitar replay.
- **Mint/Burn:** Certificar que apenas ator autorizado pode criar novas moedas.
- **Taxas em transferências:** Podem quebrar integrações com AMMs e lending se não forem bem documentadas.
- **Tokens ERC-777 / hooks:** Qualquer transferência pode disparar callbacks – risco de reentrância.
