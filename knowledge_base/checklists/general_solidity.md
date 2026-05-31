# Checklist Geral de Solidity

## Más Práticas
- [ ] Uso de `block.timestamp` como fonte de aleatoriedade ou prazo crítico (pode ser manipulado em ±15s).
- [ ] Loops não limitados que dependem de entrada do usuário (risco de DoS).
- [ ] Envio de ETH com `transfer` (pode falhar). Usar `call{value: ...}("")`.
- [ ] Falta de verificação do retorno de `call`.
- [ ] `delegatecall` para endereços não confiáveis (pode reescrever storage).
- [ ] `selfdestruct` e `delegatecall` em contratos atualizáveis.

## Otimização e Segurança de Armazenamento
- [ ] Variáveis de state não inicializadas têm valor default – cuidado com contadores que partem de 0.
- [ ] `uint` overflow/underflow (resolvido em Solidity ≥0.8, mas verificar uso de `unchecked`).
- [ ] Arrays de tamanho dinâmico em storage podem explodir custo de gas em loop.

## Atualização e Auditabilidade
- [ ] Uso de proxies (UUPS, Transparent) – verificar colisões de storage.
- [ ] Recomendado documentar invariantes no próprio código (`@notice`).
