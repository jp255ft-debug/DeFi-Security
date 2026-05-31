#!/bin/bash
# Inicializa a estrutura de um novo projeto DePIN
# Uso: ./init_depin_project.sh NomeDoProjeto [--streamr|--helium|--dimo|--generic]

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"

if [ -z "$1" ]; then
    echo "Uso: ./init_depin_project.sh NomeDoProjeto [--streamr|--helium|--dimo|--generic]"
    echo "Exemplo: ./init_depin_project.sh DroneFleet --streamr"
    exit 1
fi

PROJECT_NAME="$1"
CONNECTOR_TYPE="${2:---generic}"
TARGET_DIR="$WORKSPACE/depin/projects/${PROJECT_NAME}"

if [ -d "$TARGET_DIR" ]; then
    echo "Erro: O diretorio $TARGET_DIR ja existe."
    exit 1
fi

echo "Inicializando projeto DePIN: $PROJECT_NAME"

# Cria estrutura
mkdir -p "$TARGET_DIR"/{connectors,contracts,data,config}

# Template de configuracao
cat > "$TARGET_DIR/config/config.json" << 'CONFIGEOF'
{
    "project_name": "'"${PROJECT_NAME}"'",
    "network": "polygon",
    "rpc_url": "https://polygon-rpc.com",
    "chain_id": 137,
    "connector_type": "'"${CONNECTOR_TYPE#--}"'",
    "stream_id": "",
    "contract_address": "",
    "private_key_env": "PRIVATE_KEY"
}
CONFIGEOF

# Template de .env
cat > "$TARGET_DIR/.env.example" << 'ENVEOF'
# Chave privada da wallet (NUNCA commitar)
PRIVATE_KEY=0x...

# APIs especificas
DIMO_CLIENT_ID=
DIMO_CLIENT_SECRET=
HELIUM_API_KEY=
ENVEOF

# Copia conector apropriado
case "$CONNECTOR_TYPE" in
    --streamr)
        cp "$WORKSPACE/depin/connectors/streamr_publisher.py" "$TARGET_DIR/connectors/publisher.py"
        echo "Conector Streamr copiado"
        ;;
    --helium)
        cp "$WORKSPACE/depin/connectors/helium_ingest.py" "$TARGET_DIR/connectors/ingest.py"
        echo "Conector Helium copiado"
        ;;
    --dimo)
        cp "$WORKSPACE/depin/connectors/dimo_connector.py" "$TARGET_DIR/connectors/connector.py"
        echo "Conector DIMO copiado"
        ;;
    *)
        cp "$WORKSPACE/depin/connectors/generic_iot.py" "$TARGET_DIR/connectors/iot.py"
        echo "Conector generico copiado"
        ;;
esac

# Copia contratos
cp "$WORKSPACE/depin/contracts/DataVerifier.sol" "$TARGET_DIR/contracts/"
cp "$WORKSPACE/depin/contracts/OracleDepin.sol" "$TARGET_DIR/contracts/"

# README do projeto
cat > "$TARGET_DIR/README.md" << READMEEOF
# ${PROJECT_NAME} — Projeto DePIN

## Estrutura
- \`connectors/\`: Scripts de conexao com dispositivos/API
- \`contracts/\`: Smart contracts Solidity
- \`data/\`: Dados coletados (JSON)
- \`config/\`: Configuracoes

## Setup
\`\`\`bash
pip install -r ../../requirements_depin.txt
\`\`\`

## Uso
\`\`\`bash
python connectors/publisher.py --config config/config.json
\`\`\`
READMEEOF

echo "Projeto criado em: $TARGET_DIR"
echo ""
echo "Proximos passos:"
echo "  1. Edite config/config.json com suas configuracoes"
echo "  2. Copie .env.example para .env e preencha"
echo "  3. Execute: python connectors/publisher.py --config config/config.json"
echo "  4. Deploy dos contratos: forge script ..."
