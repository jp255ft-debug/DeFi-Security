Modo: DeepSeek-R1

Leia o contrato alvo em `{audit_path}/src/`.
Consulte `knowledge_base/checklists/defi_primitives.md` para identificar os invariantes financeiros esperados (ex: "totalSupply == soma de todos os saldos", "colateralização nunca abaixo de 150%").
Modele cada função que altera o estado global.
Liste os invariantes e descreva, para cada um, se alguma sequência de chamadas poderia quebrá-lo.
Se encontrar uma potencial quebra, forneça um cenário de ataque passo a passo que possa ser implementado em um PoC.
