Modo: DeepSeek-R1 (se houver suspeitas complexas) ou DeepSeek-V3 (para revisão padrão)

Você está auditando o(s) contrato(s) em `{audit_path}/src/`.
Carregue os checklists:
- `knowledge_base/checklists/reentrancy.md`
- `knowledge_base/checklists/access_control.md`
- `knowledge_base/checklists/oracle_manipulation.md`
- `knowledge_base/checklists/general_solidity.md`
- `knowledge_base/checklists/erc20_checklist.md` (se houver tokens)

Revise linha a linha, com atenção especial a:
- Falta de modificadores de controle de acesso em funções que alteram estado crítico.
- Uso de `tx.origin`.
- Chamadas externas antes de atualizações de estado (reentrância).
- Manipulação de preços via oráculos descentralizados.
- Loops não limitados e dependência de `block.timestamp`.
- Arredondamentos e precisão em operações matemáticas.

Para cada suspeita, registre um parágrafo em `findings/<severidade>.md` com localização (arquivo, linha), descrição e possível impacto.
