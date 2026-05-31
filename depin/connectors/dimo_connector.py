#!/usr/bin/env python3
"""
DIMO Connector — Conector DePIN
=================================
Integra com veículos conectados via DIMO API.
Obtém telemetria veicular e prepara para publicação on-chain.

Fluxo:
  1. Autentica na API DIMO
  2. Obtém dados de telemetria do veículo
  3. Formata e prepara para assinatura

Uso:
  python dimo_connector.py --vehicle-id <id> --output telemetry.json
  python dimo_connector.py --token <api_token> --stream
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
log = logging.getLogger("dimo-connector")


# =============================================================================
# Configuração
# =============================================================================

DIMO_API_BASE = "https://api.dimo.zone/v1"
DIMO_AUTH_URL = "https://auth.dimo.zone/auth"


class DIMOConnector:
    """Conector para API DIMO (veículos conectados)."""

    def __init__(
        self,
        client_id: str = "",
        client_secret: str = "",
        api_base: str = DIMO_API_BASE,
    ):
        self.api_base = api_base
        self.client_id = client_id or os.environ.get("DIMO_CLIENT_ID", "")
        self.client_secret = client_secret or os.environ.get(
            "DIMO_CLIENT_SECRET", ""
        )
        self.access_token = ""
        self.session = requests.Session()

    def authenticate(self) -> bool:
        """
        Autentica na API DIMO usando OAuth2.
        Retorna True se autenticado com sucesso.
        """
        if not self.client_id or not self.client_secret:
            log.warning(
                "DIMO_CLIENT_ID e DIMO_CLIENT_SECRET não configurados. "
                "Usando modo anônimo (dados limitados)."
            )
            return False

        try:
            payload = {
                "grant_type": "client_credentials",
                "client_id": self.client_id,
                "client_secret": self.client_secret,
            }
            resp = self.session.post(
                f"{DIMO_AUTH_URL}/token", data=payload, timeout=30
            )
            resp.raise_for_status()
            data = resp.json()
            self.access_token = data.get("access_token", "")
            self.session.headers.update(
                {"Authorization": f"Bearer {self.access_token}"}
            )
            log.info("Autenticado na DIMO API")
            return True

        except Exception as e:
            log.error("Falha na autenticação DIMO: %s", e)
            return False

    def get_vehicle_info(self, vehicle_id: str) -> Dict[str, Any]:
        """Obtém informações do veículo."""
        url = f"{self.api_base}/vehicle/{vehicle_id}"
        resp = self.session.get(url, timeout=30)
        resp.raise_for_status()
        return resp.json().get("data", {})

    def get_telemetry(
        self, vehicle_id: str, signals: Optional[List[str]] = None
    ) -> Dict[str, Any]:
        """
        Obtém telemetria do veículo.
        signals: lista de sinais (ex: ["speed", "odometer", "fuelLevel"])
        """
        if signals is None:
            signals = [
                "speed",
                "odometer",
                "fuelLevel",
                "batteryVoltage",
                "engineRpm",
                "tirePressure",
                "location",
            ]

        url = f"{self.api_base}/vehicle/{vehicle_id}/telemetry"
        params = {"signals": ",".join(signals)}
        resp = self.session.get(url, params=params, timeout=30)
        resp.raise_for_status()
        return resp.json().get("data", {})

    def get_vin_info(self, vin: str) -> Dict[str, Any]:
        """Obtém informações pelo VIN do veículo."""
        url = f"{self.api_base}/vehicle/vin/{vin}"
        resp = self.session.get(url, timeout=30)
        resp.raise_for_status()
        return resp.json().get("data", {})

    def format_for_blockchain(
        self, vehicle_id: str, telemetry: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Formata telemetria veicular para envio à blockchain.
        """
        return {
            "source": "dimo",
            "vehicle_id": vehicle_id,
            "telemetry": telemetry,
            "timestamp": int(time.time() * 1000),
            "signals_count": len(telemetry),
        }

    def stream_telemetry(
        self, vehicle_id: str, interval: int = 300, max_readings: int = 10
    ):
        """
        Stream de telemetria em tempo real.
        interval: segundos entre leituras (default: 5 min)
        """
        count = 0
        while count < max_readings:
            try:
                telemetry = self.get_telemetry(vehicle_id)
                formatted = self.format_for_blockchain(vehicle_id, telemetry)
                yield formatted
                count += 1
                log.info(
                    "Leitura %d/%d do veículo %s",
                    count, max_readings, vehicle_id,
                )
            except Exception as e:
                log.error("Erro no stream: %s", e)
            time.sleep(interval)


# =============================================================================
# CLI
# =============================================================================

def parse_args():
    parser = argparse.ArgumentParser(
        description="DIMO Connector — Conector DePIN para veículos conectados",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )

    parser.add_argument(
        "--vehicle-id",
        help="ID do veículo na DIMO",
    )
    parser.add_argument(
        "--vin",
        help="VIN do veículo (alternativa ao vehicle-id)",
    )
    parser.add_argument(
        "--output",
        default="dimo_telemetry.json",
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
        default=300,
        help="Intervalo entre leituras em segundos (default: 300)",
    )
    parser.add_argument(
        "--count",
        type=int,
        default=10,
        help="Número máximo de leituras (default: 10)",
    )
    parser.add_argument(
        "--signals",
        nargs="+",
        default=["speed", "odometer", "fuelLevel", "location"],
        help="Sinais para coletar (default: speed odometer fuelLevel location)",
    )

    return parser.parse_args()


def main():
    args = parse_args()

    connector = DIMOConnector()
    connector.authenticate()

    if args.vin:
        log.info("Consultando VIN: %s", args.vin)
        info = connector.get_vin_info(args.vin)
        vehicle_id = info.get("id", "")
        if not vehicle_id:
            log.error("VIN não encontrado")
            sys.exit(1)
    else:
        vehicle_id = args.vehicle_id

    if not vehicle_id:
        log.error("Informe --vehicle-id ou --vin")
        sys.exit(1)

    if args.stream:
        log.info(
            "Streaming do veículo %s (intervalo=%ds, max=%d)",
            vehicle_id, args.interval, args.count,
        )
        readings = []
        for reading in connector.stream_telemetry(
            vehicle_id, args.interval, args.count
        ):
            readings.append(reading)
        with open(args.output, "w") as f:
            json.dump(readings, f, indent=2, default=str)
        log.info(
            "Streaming concluído. %d leituras salvas em %s",
            len(readings), args.output,
        )
    else:
        telemetry = connector.get_telemetry(vehicle_id, args.signals)
        formatted = connector.format_for_blockchain(vehicle_id, telemetry)
        with open(args.output, "w") as f:
            json.dump(formatted, f, indent=2, default=str)
        log.info("Telemetria salva em %s", args.output)


if __name__ == "__main__":
    main()
