#!/bin/bash
# Deploy do contrato DataVerifier para uma rede EVM
# Uso: ./deploy_verifier.sh [--rpc <url>] [--private-key <key>] [--chain-id <id>]

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"
DEPIN_DIR="$WORKSPACE/depin"

# Configuracoes padrao
RPC_URL="${RPC_URL:-https://polygon-rpc.com}"
PRIVATE_KEY="${PRIVATE_KEY:-}"
CHAIN_ID="${CHAIN_ID:-137}"
VERIFIER_ADDRESS=""

# Parse args
while [[ $# -gt 0 ]]; do
    case "$1" in
        --rpc) RPC_URL="$2"; shift 2 ;;
        --private-key) PRIVATE_KEY="$2"; shift 2 ;;
        --chain-id) CHAIN_ID="$2"; shift 2 ;;
        --help)
            echo "Uso: ./deploy_verifier.sh [--rpc <url>] [--private-key <key>] [--chain-id <id>]"
            echo ""
            echo "Variaveis de ambiente: RPC_URL, PRIVATE_KEY, CHAIN_ID"
            exit 0
            ;;
        *) echo "Opcao desconhecida: $1"; exit 1 ;;
    esac
done

# Verifica chave privada
if [ -z "$PRIVATE_KEY" ]; then
    if [ -f "$WORKSPACE/.env" ]; then
        source "$WORKSPACE/.env"
        PRIVATE_KEY="${PRIVATE_KEY:-}"
    fi
fi

if [ -z "$PRIVATE_KEY" ]; then
    echo "Erro: PRIVATE_KEY nao definida."
    echo "Use --private-key ou export PRIVATE_KEY=0x..."
    exit 1
fi

echo "Deploy do DataVerifier..."
echo "  RPC:      $RPC_URL"
echo "  Chain ID: $CHAIN_ID"

# Compila o contrato
echo ""
echo "Compilando..."
cd "$DEPIN_DIR/contracts"
forge build --contracts DataVerifier.sol 2>&1 || {
    echo "Tentando compilar com foundry.toml do workspace..."
    cd "$WORKSPACE"
    forge build --contracts "$DEPIN_DIR/contracts/DataVerifier.sol" 2>&1
}

# Deploy com forge script
echo ""
echo "Fazendo deploy..."
cd "$WORKSPACE"

# Cria um script de deploy temporario
TMP_SCRIPT=$(mktemp)
cat > "$TMP_SCRIPT" << 'SCRIPTEOF'
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../depin/contracts/DataVerifier.sol";

contract DeployDataVerifier is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        DataVerifier verifier = new DataVerifier();
        console.log("DataVerifier deployed at:", address(verifier));

        vm.stopBroadcast();
    }
}
SCRIPTEOF

# Executa deploy
forge script "$TMP_SCRIPT" \
    --rpc-url "$RPC_URL" \
    --private-key "$PRIVATE_KEY" \
    --broadcast \
    --chain-id "$CHAIN_ID" 2>&1 || {
    echo ""
    echo "Deploy falhou. Verifique:"
    echo "  1. RPC URL esta correta?"
    echo "  2. A wallet tem fundos para gas?"
    echo "  3. O chain-id esta correto?"
    exit 1
}

# Limpa
rm -f "$TMP_SCRIPT"

echo ""
echo "Deploy concluido!"
echo "Salve o endereco do contrato para usar no conector."
