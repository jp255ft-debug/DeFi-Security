# DoS por Limite de Gas do Bloco

## Descrição
Uma função que consome muito gas (ex: loops grandes, operações complexas) pode exceder o limite de gas do bloco (~30M na Ethereum), tornando-a impossível de executar.

## Exemplos
- **Arrays de stakers:** Distribuir recompensas para milhares de stakers em um loop.
- **Liquidações em lote:** Processar muitas liquidações em uma única transação.
- **Atualizações de estado:** Salvar muitos registros em storage em um loop.

## Mitigação
- Processar operações em lotes (batch processing)
- Usar padrão pull-over-push para pagamentos
- Limitar o tamanho de arrays controlados por usuários
- Implementar funções de emergência para cenários de DoS
