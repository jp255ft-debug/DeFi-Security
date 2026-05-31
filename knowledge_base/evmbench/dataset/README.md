# EVMbench Dataset

## Sobre
O EVMbench é um benchmark desenvolvido pela OpenAI em parceria com a Paradigm para avaliar a capacidade de modelos de linguagem em detectar vulnerabilidades em contratos Solidity.

## Dataset
O dataset contém **120 vulnerabilidades reais** extraídas de:
- Relatórios de auditoria públicos
- Exploits reais na mainnet
- CTFs de segurança (Ethernaut, Damn Vulnerable DeFi)
- Contratos propositalmente vulneráveis

## Como Baixar
```bash
# Clone o repositório oficial do EVMbench
git clone https://github.com/openai/evmbench.git

# Copie o dataset para esta pasta
cp -r evmbench/data/* ./dataset/
```

## Como Usar
Execute o script `scripts/eval_evmbench.sh` para testar o DeepSeek contra todo o benchmark:

```bash
./scripts/eval_evmbench.sh
```

## Estrutura do Dataset
```
dataset/
├── vulnerabilities.json    # Metadados das 120 vulnerabilidades
├── contracts/              # Código fonte dos contratos
│   ├── 001_*.sol
│   ├── 002_*.sol
│   └── ...
└── answers.json            # Gabarito com as vulnerabilidades esperadas
```
