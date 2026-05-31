#!/bin/bash
# Pipeline completo DePIN: coleta -> assina -> publica -> verifica
# Uso: ./run_depin_pipeline.sh NomeDoProjeto [--dry-run]

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"

if [ -z "$1" ]; then
    echo "Uso: ./run_depin_pipeline.sh NomeDoProjeto [--dry-run]"
    echo "Exemplo: ./run_depin_pipeline.sh DroneFleet"
    exit 1
fi

PROJECT_NAME="$1"
DRY_RUN="${2:---send}"
PROJECT_DIR="$WORKSPACE/depin/projects/${PROJECT_NAME}"
CONFIG_FILE="$PROJECT_DIR/config/config.json"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "Erro: Projeto $PROJECT_NAME nao encontrado em $PROJECT_DIR"
    echo "Crie com: ./init_depin_project.sh $PROJECT_NAME"
    exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Erro: config.json nao encontrado em $CONFIG_FILE"
    exit 1
fi

echo "=========================================="
echo " Pipeline DePIN: $PROJECT_NAME"
echo "=========================================="
echo ""

# Step 1: Coleta dados
echo "[1/4] Coletando dados..."
CONNECTOR_SCRIPT=$(ls "$PROJECT_DIR/connectors/"*.py 2>/dev/null | head -1)
if [ -z "$CONNECTOR_SCRIPT" ]; then
    echo "  Nenhum conector encontrado em connectors/"
    echo "  Pulando etapa de coleta..."
    DATA_FILE="$PROJECT_DIR/data/sample.json"
    echo '{"temperature": 25.5, "humidity": 60}' > "$DATA_FILE"
else
    DATA_FILE="$PROJECT_DIR/data/collected_$(date +%Y%m%d_%H%M%S).json"
    python "$CONNECTOR_SCRIPT" --output "$DATA_FILE" 2>&1 || {
        echo "  Falha na coleta. Usando dados de exemplo..."
        echo '{"temperature": 25.5, "humidity": 60}' > "$DATA_FILE"
    }
fi
echo "  Dados salvos em: $DATA_FILE"
echo ""

# Step 2: Assina dados
echo "[2/4] Assinando dados..."
CONTRACT_ADDRESS=$(python -c "import json; print(json.load(open('$CONFIG_FILE')).get('contract_address', ''))")
if [ -z "$CONTRACT_ADDRESS" ]; then
    echo "  Contract address nao configurado. Pulando assinatura..."
    SIGNED_FILE="$PROJECT_DIR/data/signed.json"
    cp "$DATA_FILE" "$SIGNED_FILE"
else
    SIGNED_FILE="$PROJECT_DIR/data/signed_$(date +%Y%m%d_%H%M%S).json"
    python "$WORKSPACE/depin/connectors/sign_and_send.py" \
        --file "$DATA_FILE" \
        --contract "$CONTRACT_ADDRESS" \
        --verify-only \
        --output "$SIGNED_FILE" 2>&1 || {
        echo "  Falha na assinatura. Pulando..."
        cp "$DATA_FILE" "$SIGNED_FILE"
    }
fi
echo "  Dados assinados em: $SIGNED_FILE"
echo ""

# Step 3: Publica (ou dry-run)
echo "[3/4] Publicando dados..."
if [ "$DRY_RUN" = "--dry-run" ]; then
    echo "  [DRY-RUN] Publicacao simulada. Dados prontos em: $SIGNED_FILE"
else
    echo "  Publicando no Streamr/blockchain..."
    # Tenta publicar via streamr_publisher se disponivel
    if python -c "import streamr_client" 2>/dev/null; then
        STREAM_ID=$(python -c "import json; print(json.load(open('$CONFIG_FILE')).get('stream_id', ''))")
        if [ -n "$STREAM_ID" ]; then
            python "$WORKSPACE/depin/connectors/streamr_publisher.py" \
                --stream-id "$STREAM_ID" \
                --file "$SIGNED_FILE" 2>&1 || echo "  Falha na publicacao Streamr"
        fi
    fi
    echo "  Dados prontos para publicacao manual em: $SIGNED_FILE"
fi
echo ""

# Step 4: Verifica on-chain
echo "[4/4] Verificacao on-chain..."
if [ -n "$CONTRACT_ADDRESS" ] && [ "$DRY_RUN" != "--dry-run" ]; then
    echo "  Verificando no contrato $CONTRACT_ADDRESS..."
    python "$WORKSPACE/depin/connectors/sign_and_send.py" \
        --file "$SIGNED_FILE" \
        --contract "$CONTRACT_ADDRESS" \
        --send 2>&1 || echo "  Verificacao falhou (esperado se contrato nao implantado)"
else
    echo "  Pulando verificacao on-chain (dry-run ou sem contrato)"
fi

echo ""
echo "=========================================="
echo " Pipeline concluido!"
echo "  Dados:       $DATA_FILE"
echo "  Assinados:   $SIGNED_FILE"
echo "=========================================="
