#!/usr/bin/env python3
"""
Helium Ingest — Conector DePIN
================================
Consome dados de IoT da rede Helium e prepara para publicação on-chain.

Fluxo:
  1. Conecta à API Helium (ou nó próprio)
  2. Obtém dados de hotspots/dispositivos
  3. Valida e formata os dados
  4. Prepara para assinatura e envio

Uso:
  python helium_ingest.py --hotspot <address> --output signed_data.json
  python helium_ingest.py --device <device_id> --stream
"""

import argparse
import json
import logging
import os
import sys
import time
from datetime import datetime
from typing import Any, Dict, List, Optional

import requests

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
log = logging.getLogger("helium-ingest")


# =============================================================================
# Configuração
# =============================================================================

HELIUM_API_BASE = "https://api.helium.io/v1"
HELIUM_SOLANA_API = "https://api.helium.com/v1"  # Pós-migração Solana


class HeliumIngest:
    """Consome dados da rede Helium."""

    def __init__(self, api_base: str = HELIUM_API_BASE):
        self.api_base = api_base
        self.session = requests.Session()
        self.session.headers.update({"User-Agent": "DePIN-Security-Workspace/1.0"})

    def get_hotspot_info(self, hotspot_address: str) -> Dict[str, Any]:
        """Obtém informações de um hotspot."""
        url = f"{self.api_base}/hotspots/{hotspot_address}"
        resp = self.session.get(url, timeout=30)
        resp.raise_for_status()
        return resp.json().get("data", {})

    def get_hotspot_rewards(
        self, hotspot_address: str, days: int = 7
    ) -> List[Dict[str, Any]]:
        """Obtém recompensas de um hotspot."""
        url = f"{self.api_base}/hotspots/{hotspot_address}/rewards/sum"
        params = {
            "min_time": f"-{days} day",
            "bucket": "day",
        }
        resp = self.session.get(url, params=params, timeout=30)
        resp.raise_for_status()
        return resp.json().get("data", [])

    def get_device_data(self, device_id: str) -> Dict[str, Any]:
        """Obtém dados de um dispositivo IoT na rede Helium."""
        url = f"{self.api_base}/devices/{device_id}"
        resp = self.session.get(url, timeout=30)
        resp.raise_for_status()
        return resp.json().get("data", {})

    def get_oracle_price(self) -> float:
        """Obtém o preço do HNT via oracle."""
        url = f"{self.api_base}/oracle/prices/current"
        resp = self.session.get(url, timeout=30)
        resp.raise_for_status()
        data = resp.json().get("data", {})
        return float(data.get("price", 0)) / 1e8  # Helium usa 8 decimais

    def format_for_blockchain(
        self, raw_data: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Formata dados Helium para envio à blockchain.
        Normaliza campos, adiciona timestamp, prepara para assinatura.
        """
        return {
            "source": "helium",
            "type": raw_data.get("type", "unknown"),
            "device_id": raw_data.get("id", raw_data.get("address", "")),
            "data": raw_data,
            "timestamp": int(time.time() * 1000),
            "oracle_price_hnt_usd": self.get_oracle_price(),
        }

    def stream_device_data(
        self, device_id: str, interval: int = 60, max_packets: int = 10
    ):
        """
        Stream de dados de dispositivo em tempo real.
        NOTA: Simulação - em produção usar WebSocket Helium.
        """
        count = 0
        while count < max_packets:
            try:
                data = self.get_device_data(device_id)
                formatted = self.format_for_blockchain(data)
                yield formatted
                count += 1
                log.info(
                    "Packet %d/%d recebido de %s",
                    count, max_packets, device_id,
                )
            except Exception as e:
                log.error("Erro no stream: %s", e)
            time.sleep(interval)


# =============================================================================
# CLI
# =============================================================================

def parse_args():
    parser = argparse.ArgumentParser(
        description="Helium Ingest — Conector DePIN",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )

    parser.add_argument(
        "--hotspot",
        help="Endereço do hotspot Helium",
    )
    parser.add_argument(
        "--device",
        help="ID do dispositivo IoT",
    )
    parser.add_argument(
        "--output",
        default="helium_data.json",
        help="Arquivo de saída (JSON)",
    )
    parser.add_argument(
        "--stream",
        action="store_true",
        help="Modo streaming contínuo",
    )
    parser.add_argument(
        "--interval",
        type=int,
        default=60,
        help="Intervalo entre leituras em segundos (default: 60)",
    )
    parser.add_argument(
        "--count",
        type=int,
        default=10,
        help="Número máximo de pacotes (default: 10)",
    )
    parser.add_argument(
        "--api",
        default=HELIUM_API_BASE,
        help="URL base da API Helium",
    )

    return parser.parse_args()


def main():
    args = parse_args()

    ingest = HeliumIngest(api_base=args.api)

    if args.hotspot:
        log.info("Consultando hotspot: %s", args.hotspot)
        info = ingest.get_hotspot_info(args.hotspot)
        rewards = ingest.get_hotspot_rewards(args.hotspot)
        output = {
            "hotspot": info,
            "rewards": rewards,
            "oracle_price_hnt_usd": ingest.get_oracle_price(),
            "timestamp": datetime.utcnow().isoformat(),
        }
        with open(args.output, "w") as f:
            json.dump(output, f, indent=2, default=str)
        log.info("Dados salvos em %s", args.output)

    elif args.device:
        if args.stream:
            log.info(
                "Streaming do dispositivo %s (intervalo=%ds, max=%d)",
                args.device, args.interval, args.count,
            )
            packets = []
            for packet in ingest.stream_device_data(
                args.device, args.interval, args.count
            ):
                packets.append(packet)
            with open(args.output, "w") as f:
                json.dump(packets, f, indent=2, default=str)
            log.info(
                "Streaming concluído. %d pacotes salvos em %s",
                len(packets), args.output,
            )
        else:
            data = ingest.get_device_data(args.device)
            formatted = ingest.format_for_blockchain(data)
            with open(args.output, "w") as f:
                json.dump(formatted, f, indent=2, default=str)
            log.info("Dados do dispositivo salvos em %s", args.output)

    else:
        log.error("Informe --hotspot ou --device")
        sys.exit(1)


if __name__ == "__main__":
    main()
