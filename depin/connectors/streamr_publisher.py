#!/usr/bin/env python3
"""
Streamr Publisher — Conector DePIN
====================================
Publica dados de telemetria assinados na rede Streamr.

Fluxo:
  1. Lê dados de uma fonte (API, arquivo, sensor)
  2. Assina com wallet Ethereum via Web3.py
  3. Publica no Streamr com metadados de assinatura

Uso:
  python streamr_publisher.py --stream-id 0x.../my-stream --data '{"temp": 25.5}'
  python streamr_publisher.py --config config.json
"""

import argparse
import json
import logging
import os
import sys
import time
from typing import Any, Dict, Optional

from eth_account import Account
from eth_account.messages import encode_defunct
from web3 import Web3

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
log = logging.getLogger("streamr-publisher")


# =============================================================================
# Configuração
# =============================================================================

DEFAULT_RPC = "https://polygon-rpc.com"  # Streamr usa Polygon
DEFAULT_STREAMR_WS = "wss://streamr.network/ws/v1"


class StreamrPublisher:
    """Publica dados assinados no Streamr."""

    def __init__(
        self,
        private_key: str,
        stream_id: str,
        rpc_url: str = DEFAULT_RPC,
        streamr_ws: str = DEFAULT_STREAMR_WS,
    ):
        self.account = Account.from_key(private_key)
        self.address = self.account.address
        self.stream_id = stream_id
        self.w3 = Web3(Web3.HTTPProvider(rpc_url))
        self.streamr_ws = streamr_ws

        log.info("Wallet carregada: %s", self.address)
        log.info("Stream ID: %s", self.stream_id)

        if not self.w3.is_connected():
            log.warning("RPC %s não respondeu. Modo offline.", rpc_url)

    def sign_data(self, data: Dict[str, Any]) -> str:
        """
        Assina os dados com a wallet Ethereum.
        Retorna a assinatura hex.
        """
        message_hash = encode_defunct(
            text=json.dumps(data, sort_keys=True, separators=(",", ":"))
        )
        signed = self.account.sign_message(message_hash)
        return signed.signature.hex()

    def build_payload(
        self, data: Dict[str, Any], timestamp: Optional[int] = None
    ) -> Dict[str, Any]:
        """
        Monta o payload completo com dados + assinatura.
        """
        ts = timestamp or int(time.time() * 1000)
        signature = self.sign_data(data)

        payload = {
            "data": data,
            "signature": signature,
            "signer": self.address,
            "timestamp": ts,
            "streamId": self.stream_id,
        }
        return payload

    def publish(self, data: Dict[str, Any]) -> bool:
        """
        Publica dados assinados no Streamr.
        NOTA: Requer streamr-client instalado.
        """
        payload = self.build_payload(data)

        try:
            # Tentativa de usar streamr-client (se instalado)
            from streamr_client import StreamrClient

            client = StreamrClient(
                private_key=self.account.key.hex(),
                streamr_ws=self.streamr_ws,
            )
            client.publish(self.stream_id, payload)
            log.info(
                "✅ Publicado em %s: %s", self.stream_id, json.dumps(data)[:100]
            )
            return True

        except ImportError:
            log.warning(
                "streamr-client não instalado. Payload preparado mas não enviado."
            )
            log.info("Payload: %s", json.dumps(payload, indent=2)[:500])
            return False

    def publish_batch(self, data_list: list) -> int:
        """Publica múltiplos dados em lote."""
        success = 0
        for data in data_list:
            if self.publish(data):
                success += 1
            time.sleep(0.1)  # Rate limiting
        log.info("Lote: %d/%d publicados com sucesso", success, len(data_list))
        return success


# =============================================================================
# Utilitários
# =============================================================================

def load_config(path: str) -> dict:
    """Carrega configuração de arquivo JSON."""
    with open(path, "r") as f:
        return json.load(f)


def load_private_key(key_source: str) -> str:
    """Carrega chave privada de env var, arquivo ou argumento."""
    if key_source.startswith("0x"):
        return key_source
    if os.path.isfile(key_source):
        with open(key_source, "r") as f:
            return f.read().strip()
    return os.environ.get(key_source, "")


# =============================================================================
# CLI
# =============================================================================

def parse_args():
    parser = argparse.ArgumentParser(
        description="Streamr Publisher — Conector DePIN",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Exemplos:
  python streamr_publisher.py \\
      --stream-id 0x1234/my-telemetry \\
      --data '{"temperature": 25.5, "humidity": 60}'
  
  python streamr_publisher.py --config config.json
        """,
    )

    parser.add_argument(
        "--stream-id",
        help="ID do stream no Streamr (ex: 0x.../my-stream)",
    )
    parser.add_argument(
        "--data",
        type=json.loads,
        help="Dados JSON para publicar",
    )
    parser.add_argument(
        "--config",
        help="Arquivo JSON de configuração",
    )
    parser.add_argument(
        "--private-key",
        default="PRIVATE_KEY",
        help="Chave privada (hex, arquivo ou env var). Default: PRIVATE_KEY",
    )
    parser.add_argument(
        "--rpc",
        default=DEFAULT_RPC,
        help="URL do RPC. Default: Polygon RPC",
    )
    parser.add_argument(
        "--batch",
        help="Arquivo JSON com array de dados para publicar em lote",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Apenas prepara payload, não publica",
    )

    return parser.parse_args()


def main():
    args = parse_args()

    # Config
    if args.config:
        config = load_config(args.config)
        stream_id = config.get("stream_id", args.stream_id)
        private_key = load_private_key(config.get("private_key", args.private_key))
        rpc = config.get("rpc", args.rpc)
    else:
        stream_id = args.stream_id
        private_key = load_private_key(args.private_key)
        rpc = args.rpc

    if not stream_id:
        log.error("--stream-id é obrigatório")
        sys.exit(1)

    if not private_key or private_key == "PRIVATE_KEY":
        log.error(
            "Chave privada não encontrada. Defina PRIVATE_KEY ou use --private-key"
        )
        sys.exit(1)

    publisher = StreamrPublisher(
        private_key=private_key,
        stream_id=stream_id,
        rpc_url=rpc,
    )

    # Batch mode
    if args.batch:
        with open(args.batch, "r") as f:
            data_list = json.load(f)
        if not isinstance(data_list, list):
            log.error("Arquivo batch deve conter um array JSON")
            sys.exit(1)
        publisher.publish_batch(data_list)
        return

    # Single publish
    if not args.data:
        log.error("--data ou --batch é obrigatório")
        sys.exit(1)

    if args.dry_run:
        payload = publisher.build_payload(args.data)
        print(json.dumps(payload, indent=2))
        return

    publisher.publish(args.data)


if __name__ == "__main__":
    main()
