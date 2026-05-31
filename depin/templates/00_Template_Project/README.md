# NomeDoProjeto — Projeto DePIN

## Descricao
[Descricao do projeto DePIN]

## Arquitetura
```
[Dispositivo/Sensor] -> [Conector] -> [Assinatura] -> [Rede DePIN] -> [Smart Contract]
```

## Estrutura
```
.
├── connectors/          # Scripts de conexao com dispositivos
│   └── publisher.py     # Publicador de dados
├── contracts/           # Smart contracts Solidity
│   ├── DataVerifier.sol # Verificador de assinaturas
│   └── OracleDepin.sol  # Oracle com sistema de disputas
├── data/                # Dados coletados (gitignored)
├── config/              # Configuracoes
│   └── config.json
├── .env.example         # Template de variaveis de ambiente
└── README.md
```

## Setup

### Pre-requisitos
- Python 3.10+
- Foundry (forge, cast)
- Node.js 18+ (opcional)

### Instalacao
```bash
# Dependencias Python
pip install -r ../../requirements_depin.txt

# Compilar contratos
cd ../../depin/contracts && forge build
```

### Configuracao
```bash
cp .env.example .env
# Edite .env com suas chaves
```

## Uso

### Coleta e Publicacao
```bash
# Dry-run (apenas prepara payload)
python connectors/publisher.py --config config/config.json --dry-run

# Publicar no Streamr
python connectors/publisher.py --config config/config.json

# Pipeline completo
../../scripts/run_depin_pipeline.sh NomeDoProjeto
```

### Deploy dos Contratos
```bash
../../scripts/deploy_verifier.sh --rpc <RPC_URL> --private-key <KEY>
```

## Testes
```bash
# Testes Foundry
cd ../../depin/contracts && forge test

# Teste de assinatura
python ../../depin/connectors/sign_and_send.py \
    --data '{"test": true}' \
    --contract <CONTRACT_ADDRESS> \
    --verify-only
```

## Seguranca
- [ ] Chaves privadas em .env (gitignored)
- [ ] Assinaturas EIP-191
- [ ] Anti-replay implementado
- [ ] Rate limiting configurado
- [ ] Auditoria realizada

## Licenca
MIT
