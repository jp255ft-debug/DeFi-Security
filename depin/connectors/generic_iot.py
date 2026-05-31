#!/usr/bin/env python3
"""
Generic IoT Connector — Template DePIN
========================================
Template genérico para conectar qualquer dispositivo/sensor IoT à blockchain.

Fluxo:
  1. Define fonte de dados (API, MQTT, serial, arquivo)
  2. Coleta dados do dispositivo
  3. Valida e normaliza
  4. Assina e prepara para envio

Uso:
  python generic_iot.py --source api --url https://api.sensor.com/data
  python generic_iot.py --source mqtt --topic sensors/temperature
  python generic_iot.py --source file --path readings.csv
"""

import argparse
import csv
import json
import logging
import os
import sys
import time
from abc import ABC, abstractmethod
from typing import Any, Dict, Generator, List, Optional

import requests

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
log = logging.getLogger("generic-iot")


# =============================================================================
# Fontes de Dados (Data Sources)
# =============================================================================

class DataSource(ABC):
    """Fonte de dados abstrata para dispositivos IoT."""

    @abstractmethod
    def read(self) -> Dict[str, Any]:
        """Le uma leitura do dispositivo."""
        pass

    @abstractmethod
    def stream(self, interval: int) -> Generator[Dict[str, Any], None, None]:
        """Stream continuo de leituras."""
        pass


class APISource(DataSource):
    """Fonte de dados via API REST."""

    def __init__(self, url: str, headers: Optional[Dict] = None):
        self.url = url
        self.headers = headers or {}

    def read(self) -> Dict[str, Any]:
        resp = requests.get(self.url, headers=self.headers, timeout=30)
        resp.raise_for_status()
        data = resp.json()
        return self._normalize(data)

    def stream(self, interval: int = 60):
        while True:
            yield self.read()
            time.sleep(interval)

    def _normalize(self, raw: Any) -> Dict[str, Any]:
        if isinstance(raw, dict):
            return raw
        return {"value": raw}


class MQTTSource(DataSource):
    """Fonte de dados via MQTT (placeholder)."""

    def __init__(self, broker: str, topic: str, port: int = 1883):
        self.broker = broker
        self.topic = topic
        self.port = port
        log.warning("MQTT requer paho-mqtt: pip install paho-mqtt")

    def read(self) -> Dict[str, Any]:
        raise NotImplementedError("MQTT requer cliente conectado")

    def stream(self, interval: int = 1):
        raise NotImplementedError("Use cliente MQTT dedicado")


class FileSource(DataSource):
    """Fonte de dados via arquivo (CSV, JSON, JSONL)."""

    def __init__(self, path: str):
        self.path = path
        self._rows: List[Dict] = []
        self._index = 0
        self._load()

    def _load(self):
        ext = os.path.splitext(self.path)[1].lower()
        if ext == ".csv":
            with open(self.path, "r") as f:
                reader = csv.DictReader(f)
                self._rows = list(reader)
        elif ext == ".json":
            with open(self.path, "r") as f:
                data = json.load(f)
                self._rows = data if isinstance(data, list) else [data]
        elif ext == ".jsonl":
            with open(self.path, "r") as f:
                self._rows = [json.loads(line) for line in f if line.strip()]
        else:
            raise ValueError(f"Formato nao suportado: {ext}")
        log.info("Carregadas %d linhas de %s", len(self._rows), self.path)

    def read(self) -> Dict[str, Any]:
        if self._index >= len(self._rows):
            self._index = 0
        row = self._rows[self._index]
        self._index += 1
        return row

    def stream(self, interval: int = 10):
        while True:
            yield self.read()
            time.sleep(interval)


# =============================================================================
# Processador IoT
# =============================================================================

class IoTProcessor:
    """Processa dados IoT e prepara para blockchain."""

    def __init__(self, device_id: str, device_type: str = "generic"):
        self.device_id = device_id
        self.device_type = device_type

    def validate(self, data: Dict[str, Any]) -> bool:
        if not data:
            log.warning("Dados vazios")
            return False
        return True

    def normalize(self, data: Dict[str, Any]) -> Dict[str, Any]:
        return {
            "device_id": self.device_id,
            "device_type": self.device_type,
            "timestamp": int(time.time() * 1000),
            "readings": data,
            "source": "generic_iot",
        }

    def process(self, data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        if not self.validate(data):
            return None
        return self.normalize(data)


# =============================================================================
# CLI
# =============================================================================

def parse_args():
    parser = argparse.ArgumentParser(
        description="Generic IoT Connector — Template DePIN",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )

    parser.add_argument(
        "--source",
        choices=["api", "mqtt", "file"],
        required=True,
        help="Tipo de fonte de dados",
    )
    parser.add_argument("--url", help="URL da API (source=api)")
    parser.add_argument("--topic", help="Topico MQTT (source=mqtt)")
    parser.add_argument("--broker", default="localhost", help="Broker MQTT")
    parser.add_argument("--path", help="Caminho do arquivo (source=file)")
    parser.add_argument(
        "--device-id",
        default="device-001",
        help="ID do dispositivo",
    )
    parser.add_argument(
        "--device-type",
        default="generic",
        help="Tipo do dispositivo",
    )
    parser.add_argument(
        "--output",
        default="iot_data.json",
        help="Arquivo de saida",
    )
    parser.add_argument(
        "--stream",
        action="store_true",
        help="Modo streaming",
    )
    parser.add_argument(
        "--interval",
        type=int,
        default=60,
        help="Intervalo entre leituras (segundos)",
    )
    parser.add_argument(
        "--count",
        type=int,
        default=10,
        help="Numero de leituras (stream)",
    )

    return parser.parse_args()


def main():
    args = parse_args()

    if args.source == "api":
        if not args.url:
            log.error("--url e obrigatorio para source=api")
            sys.exit(1)
        source = APISource(args.url)
    elif args.source == "mqtt":
        if not args.topic:
            log.error("--topic e obrigatorio para source=mqtt")
            sys.exit(1)
        source = MQTTSource(args.broker, args.topic)
    elif args.source == "file":
        if not args.path:
            log.error("--path e obrigatorio para source=file")
            sys.exit(1)
        source = FileSource(args.path)
    else:
        log.error("Fonte invalida")
        sys.exit(1)

    processor = IoTProcessor(args.device_id, args.device_type)

    if args.stream:
        log.info(
            "Streaming de %s (intervalo=%ds, max=%d)",
            args.source, args.interval, args.count,
        )
        results = []
        count = 0
        for raw_data in source.stream(args.interval):
            processed = processor.process(raw_data)
            if processed:
                results.append(processed)
                count += 1
                log.info("Leitura %d/%d processada", count, args.count)
            if count >= args.count:
                break

        with open(args.output, "w") as f:
            json.dump(results, f, indent=2, default=str)
        log.info("Streaming concluido. %d leituras salvas em %s", len(results), args.output)
    else:
        raw_data = source.read()
        processed = processor.process(raw_data)
        if processed:
            with open(args.output, "w") as f:
                json.dump(processed, f, indent=2, default=str)
            log.info("Dados salvos em %s", args.output)


if __name__ == "__main__":
    main()
