# Checklist de Reentrância

## Variantes a Verificar
1. **Single-function reentrancy:** A função chama um contrato externo e depois atualiza o estado.
2. **Cross-function reentrancy:** Duas funções compartilham estado; uma chamada a contrato externo em uma pode causar reentrância na outra.
3. **Read-only reentrancy:** Uma view function retorna dados inconsistentes porque o estado foi alterado por um contrato malicioso durante uma chamada externa.

## Regras de Mitigação
- Usar o modificador `nonReentrant` do OpenZeppelin **em todas as funções que fazem transferências externas**.
- Seguir o padrão **Checks-Effects-Interactions**:
  1. Validar condições (Checks).
  2. Atualizar estado (Effects).
  3. Interagir com contratos externos (Interactions).
- Desconfiar de funções que enviam ETH ou chamam tokens desconhecidos (ERC777, ERC721 `onERC721Received`).

## Checklist
- [ ] As transferências externas (`transfer`, `send`, `call`) ocorrem **após** todas as atualizações de saldo?
- [ ] Há loops que iteram sobre arrays controlados pelo usuário e enviam ETH? (Pode causar negação de serviço ou reentrância.)
- [ ] O contrato usa tokens que disparam callbacks (ERC777, ERC721)? Se sim, todas as funções que os transferem são protegidas contra reentrância?
- [ ] O padrão CEI foi respeitado?
