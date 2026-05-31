# Checklist de Manipulação de Oráculos

## Vetores Principais
1. **Preço spot de AMM:** Usar `getReserves()` de uma DEX diretamente é altamente manipulável via flash loans.
2. **TWAP (Time-Weighted Average Price):** Mais seguro, mas pode ser manipulado se o período for muito curto e o atacante tiver capital.
3. **Chainlink e feeds descentralizados:** Verificar se o feed é atualizado e a latência é aceitável; feeds podem ser desatualizados em situações de extrema volatilidade.
4. **Oráculos compostos por vários AMMs:** Um atacante pode manipular todos se o pool for pequeno.

## Checklist
- [ ] O contrato calcula preços usando apenas `getReserves()` de pools Uniswap/PancakeSwap? → **crítico**.
- [ ] Se usa TWAP, qual o período? (recomendado ≥ 30 minutos).
- [ ] Verificar se o feed da Chainlink é o correto e se a frequência de atualização é adequada.
- [ ] Em caso de oráculo composto, analisar se um pool tem peso desproporcional.
