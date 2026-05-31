#!/usr/bin/env python3
"""
Sign & Send — Utilitário de Assinatura DePIN
==============================================
Assina dados com wallet Ethereum e envia para smart contract on-chain.

Fluxo:
  1. Lê dados de entrada (JSON, arquivo, pipe)
  2. Assina com ECDSA via Web3.py
  3. Envia transação para smart contract de verificação
  4. Retorna tx hash

Uso:
  python sign_and_send.py --data '{"temp": 25.5}' --contract 0x...
  python sign_and_send.py --file data.json --contract 0x... --send
  cat data.json | python sign_and_send.py --contract 0x...
"""

import argparse
import json
import logging
import os
import sys
from typing import Any, Dict, Optional

from eth_account import Account
from eth_account.messages import encode_defunct
from web3 import Web3
from web3.middleware import geth_poa_middleware

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
log = logging.getLogger("sign-and-send")


# =============================================================================
# Configuração
# =============================================================================

DEFAULT_RPC = "https://polygon-rpc.com"
DEFAULT_CHAIN_ID = 137  # Polygon


class SignAndSend:
    """Assina dados e envia para smart contract."""

    def __init__(
        self,
        private_key: str,
        contract_address: str,
        rpc_url: str = DEFAULT_RPC,
        chain_id: int = DEFAULT_CHAIN_ID,
        abi_path: Optional[str] = None,
    ):
        self.account = Account.from_key(private_key)
        self.address = self.account.address
        self.contract_address = Web3.to_checksum_address(contract_address)

        self.w3 = Web3(Web3.HTTPProvider(rpc_url))
        self.w3.middleware_onion.inject(geth_poa_middleware, layer=0)
        self.chain_id = chain_id

        # Carrega ABI do contrato
        if abi_path and os.path.exists(abi_path):
            with open(abi_path, "r") as f:
                abi = json.load(f)
            self.contract = self.w3.eth.contract(
                address=self.contract_address, abi=abi
            )
        else:
            self.contract = None
            log.warning(
                "ABI não fornecida. Usando modo genérico (dados brutos)."
            )

        log.info("Wallet: %s", self.address)
        log.info("Contrato: %s", self.contract_address)

        if not self.w3.is_connected():
            log.error("RPC %s não respondeu", rpc_url)
            sys.exit(1)

    def sign_data(self, data: Dict[str, Any]) -> str:
        """Assina dados com a wallet."""
        message_hash = encode_defunct(
            text=json.dumps(data, sort_keys=True, separators=(",", ":"))
        )
        signed = self.account.sign_message(message_hash)
        return signed.signature.hex()

    def verify_signature(
        self, data: Dict[str, Any], signature: str, signer: str
    ) -> bool:
        """Verifica se a assinatura corresponde ao signer."""
        message_hash = encode_defunct(
            text=json.dumps(data, sort_keys=True, separators=(",", ":"))
        )
        recovered = Account.recover_message(message_hash, signature=signature)
        return recovered.lower() == signer.lower()

    def send_transaction(
        self,
        data: Dict[str, Any],
        signature: str,
        gas_limit: int = 300000,
        gas_price_gwei: Optional[int] = None,
    ) -> str:
        """
        Envia transação para o smart contract.
        Chama a função storeData(bytes32,bytes) do contrato.
        """
        if not self.contract:
            log.error("ABI não carregada. Não é possível enviar transação.")
            return ""

        # Prepara dados para envio
        data_hash = Web3.keccak(
            text=json.dumps(data, sort_keys=True, separators=(",", ":"))
        )
        signature_bytes = bytes.fromhex(signature.replace("0x", ""))

        # Gas
        gas_price = gas_price_gwei or self.w3.eth.gas_price
        if gas_price_gwei:
            gas_price = self.w3.to_wei(gas_price_gwei, "gwei")

        # Nonce
        nonce = self.w3.eth.get_transaction_count(self.address)

        # Monta transação
        tx = self.contract.functions.storeData(
            data_hash, signature_bytes
        ).build_transaction(
            {
                "from": self.address,
                "nonce": nonce,
                "gas": gas_limit,
                "gasPrice": gas_price,
                "chainId": self.chain_id,
            }
        )

        # Assina e envia
        signed_tx = self.w3.eth.account.sign_transaction(tx, self.account.key)
        tx_hash = self.w3.eth.send_raw_transaction(signed_tx.raw_transaction)
        tx_hash_hex = tx_hash.hex()

        log.info("✅ Transação enviada: %s", tx_hash_hex)
        return tx_hash_hex

    def wait_for_receipt(
        self, tx_hash: str, timeout: int = 120
    ) -> Dict[str, Any]:
        """Aguarda confirmação da transação."""
        receipt = self.w3.eth.wait_for_transaction_receipt(
            tx_hash, timeout=timeout
        )
        log.info(
            "📦 Transação confirmada no bloco %d", receipt["blockNumber"]
        )
        return receipt


# =============================================================================
# CLI
# =============================================================================

def parse_args():
    parser = argparse.ArgumentParser(
        description="Sign & Send — Utilitário de Assinatura DePIN",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )

    parser.add_argument(
        "--data",
        type=json.loads,
        help="Dados JSON para assinar e enviar",
    )
    parser.add_argument(
        "--file",
        help="Arquivo JSON com dados",
    )
    parser.add_argument(
        "--contract",
        required=True,
        help="Endereço do smart contract",
    )
    parser.add_argument(
        "--abi",
        help="Caminho para ABI do contrato (JSON)",
    )
    parser.add_argument(
        "--private-key",
        default="PRIVATE_KEY",
        help="Chave privada (hex, arquivo ou env var)",
    )
    parser.add_argument(
        "--rpc",
        default=DEFAULT_RPC,
        help="URL do RPC",
    )
    parser.add_argument(
        "--chain-id",
        type=int,
        default=DEFAULT_CHAIN_ID,
        help="Chain ID (default: 137 Polygon)",
    )
    parser.add_argument(
        "--send",
        action="store_true",
        help="Envia transação on-chain",
    )
    parser.add_argument(
        "--verify-only",
        action="store_true",
        help="Apenas assina e verifica, não envia",
    )
    parser.add_argument(
        "--gas-limit",
        type=int,
        default=300000,
        help="Gas limit (default: 300000)",
    )
    parser.add_argument(
        "--gas-price",
        type=int,
        help="Gas price em gwei (default: automático)",
    )

    return parser.parse_args()


def main():
    args = parse_args()

    # Carrega dados
    if args.file:
        with open(args.file, "r") as f:
            data = json.load(f)
    elif args.data:
        data = args.data
    else:
        # Tenta ler do stdin (pipe)
        if not sys.stdin.isatty():
            data = json.load(sys.stdin)
        else:
            log.error("Forneça --data, --file, ou pipe dados via stdin")
            sys.exit(1)

    # Chave privada
    private_key = os.environ.get(args.private_key, args.private_key)
    if private_key == "PRIVATE_KEY":
        private_key = os.environ.get("PRIVATE_KEY", "")
    if not private_key:
        log.error("Chave privada não encontrada")
        sys.exit(1)

    engine = SignAndSend(
        private_key=private_key,
        contract_address=args.contract,
        rpc_url=args.rpc,
        chain_id=args.chain_id,
        abi_path=args.abi,
    )

    # Assina
    signature = engine.sign_data(data)
    log.info("📝 Assinatura: 0x%s...%s", signature[:10], signature[-10:])

    # Verifica
    is_valid = engine.verify_signature(data, signature, engine.address)
    log.info("🔍 Assinatura válida: %s", is_valid)

    if not is_valid:
        log.error("Falha na verificação da assinatura")
        sys.exit(1)

    # Apenas verificação
    if args.verify_only:
        result = {
            "data": data,
            "signature": f"0x{signature}",
            "signer": engine.address,
            "valid": is_valid,
        }
        print(json.dumps(result, indent=2))
        return

    # Envia transação
    if args.send:
        tx_hash = engine.send_transaction(
            data, signature, args.gas_limit, args.gas_price
        )
        if tx_hash:
            receipt = engine.wait_for_receipt(tx_hash)
            result = {
                "data": data,
                "signature": f"0x{signature}",
                "signer": engine.address,
                "tx_hash": tx_hash,
                "block_number": receipt["blockNumber"],
                "gas_used": receipt["gasUsed"],
                "status": "success" if receipt["status"] else "failed",
            }
            print(json.dumps(result, indent=2))
    else:
        log.info("Use --send para enviar a transação on-chain")
        result = {
            "data": data,
            "signature": f"0x{signature}",
            "signer": engine.address,
            "valid": is_valid,
        }
        print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
