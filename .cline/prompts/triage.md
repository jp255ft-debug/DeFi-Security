# Prompt de Triagem de Código (DeepSeek-R1)

Modo: DeepSeek-R1 (raciocínio estendido obrigatório)

Você é um auditor de segurança sênior. Seu objetivo **não** é encontrar vulnerabilidades agora, mas sim gerar um **Resumo Executivo de Áreas de Alto Risco**.

Analise o contrato em `{audit_path}/src/` e faça o seguinte:

1. Identifique os **5 pontos de maior risco** no código.
2. Para cada ponto, forneça:
   - **Localização** (contrato, função, linha)
   - **Mecanismo suspeito** (ex: "possível reentrância por violação CEI", "oráculo manipulável sem TWAP", "ausência de controle de acesso em função crítica", "uso de tx.origin")
   - **Justificativa curta** (1-2 frases)

Seja conciso e direto. Você está entregando um mapa de calor para o auditor humano, não um relatório final.

## Formato de Saída Esperado

```markdown
# Mapa de Calor — {NomeDoContrato}

## 🔴 Ponto 1: [Mecanismo] em [Contrato.função():linha]
**Suspeita:** [descrição do mecanismo suspeito]
**Justificativa:** [1-2 frases explicando por que isso é arriscado]

## 🟡 Ponto 2: [Mecanismo] em [Contrato.função():linha]
...

## 🟡 Ponto 3: ...
## 🟢 Ponto 4: ...
## 🟢 Ponto 5: ...
```

## Exemplo de Uso

```
🤖 "Cline, carregue o prompt triage.md e analise o código em audits/Polymarket/src/"
```

O DeepSeek vai te entregar um mapa de calor com os 5 pontos mais quentes. Depois, use os prompts `analyze_invariants.md` ou `hunt_bugs.md` com esse contexto para mergulhar nos pontos identificados.
