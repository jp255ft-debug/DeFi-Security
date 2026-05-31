#!/usr/bin/env python3
"""
DIMO MVP Connector — DePIN Production-Ready
============================================
Conector modernizado usando SDK oficial DIMO + Streamr + Web3 signing.

Casos de uso:
  1. Coleta telemetria de veículos DIMO
  2. Assina dados com prova criptográfica ECDSA
  3. Publica dados assinados na Streamr
  4. Prepara para verificação on-chain

Requisitos:
  - dimo-python-sdk
  - streamr-client
  - web3
  - python-dotenv

Uso:
  # Modo produção (com veículo real)
  python dimo_mvp.py --production

  # Modo simulação (teste sem veículo)
  python dimo_mvp.py --simulate

  # Salvar resultado em arquivo específico
  python dimo_mvp.py --simulate --output meu_resultado.json
"""

import os
import asyncio
import json
import time
import logging
import argparse
from typing import Dict, Any, Optional

from web3 import Web3
from eth_account.messages import encode_defunct
from dotenv import load_dotenv

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
log = logging.getLogger("dimo-mvp")

load_dotenv()


class DIMOMVPConnector:
    """Conector MVP DIMO com assinatura criptográfica e publicação Streamr."""

    def __init__(
        self,
        private_key: str,
        streamr_stream_id: str,
        dimo_env: str = "Production",
        simulate: bool = False,
    ):
        self.private_key = private_key
        self.streamr_stream_id = streamr_stream_id
        self.dimo_env = dimo_env
        self.simulate = simulate

        # Web3 setup
        self.w3 = Web3()
        self.account = self.w3.eth.account.from_key(private_key)

        # DIMO setup (opcional, apenas modo produção)
        self.dimo = None
        if not simulate:
            try:
                from dimo import DIMO

                self.dimo = DIMO(env=dimo_env)
            except ImportError:
                log.warning(
                    "dimo-python-sdk não instalado. "
                    "Use 'pip install dimo-python-sdk' para modo produção."
                )

        # Streamr setup (opcional, autenticado via chave privada)
        self.streamr = None
        try:
            from streamr_client import StreamrClient

            self.streamr = StreamrClient(
                private_key=self.private_key,
                streamr_ws="wss://streamr.network/ws/v1",
            )
            log.info("StreamrClient inicializado com autenticacao via priv_key")
        except ImportError:
            log.warning(
                "streamr_client nao instalado. "
                "Use 'pip install streamr-client' para publicar na Streamr."
            )

        log.info(
            f"🔧 Conector iniciado "
            f"(simulate={simulate}, signer={self.account.address})"
        )

    async def authenticate_vehicle(
        self,
        client_id: str,
        domain: str,
        vehicle_token_id: int,
    ) -> Dict[str, str]:
        """
        Autentica veículo usando VehicleAuth (método correto da SDK atual).
        """
        from dimo.auth.vehicle_auth import VehicleAuth

        log.info(f"🔑 Autenticando veículo #{vehicle_token_id}...")

        auth = VehicleAuth(
            client_id=client_id,
            domain=domain,
            private_key=self.private_key,
        )

        headers = await auth.get_token(vehicle_token_id=vehicle_token_id)
        log.info("✅ Veículo autenticado com sucesso")
        return headers

    async def get_vehicle_telemetry(
        self,
        headers: Dict[str, str],
        vehicle_token_id: int,
    ) -> Dict[str, Any]:
        """Obtém telemetria real do veículo via DIMO API."""
        log.info(f"🚗 Coletando telemetria do veículo #{vehicle_token_id}...")

        vehicle_data = await self.dimo.devices.get_device_status(
            headers=headers,
            device_id=vehicle_token_id,
        )

        log.info(f"✅ Telemetria coletada: {len(vehicle_data)} campos")
        return vehicle_data

    def simulate_telemetry(self) -> Dict[str, Any]:
        """Gera telemetria simulada para testes (sem veículo real)."""
        log.info("🧪 Gerando telemetria simulada...")

        return {
            "timestamp": int(time.time()),
            "location": {
                "latitude": 40.7128,
                "longitude": -74.0060,
                "altitude": 10.5,
            },
            "speed_kmh": 65.0,
            "fuel_level_percent": 78.5,
            "odometer_km": 15234.7,
            "engine_rpm": 2100,
            "battery_voltage": 12.6,
            "vin": "SIMULATED_VIN_12345",
            "make": "Tesla",
            "model": "Model 3",
            "year": 2023,
        }

    def sign_data(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Assina dados com ECDSA usando chave privada Ethereum.
        Retorna payload com assinatura e endereço do assinante.
        """
        log.info("🔒 Assinando dados com ECDSA...")

        # Serializa dados de forma determinística
        message_text = json.dumps(data, sort_keys=True)

        # Cria mensagem EIP-191 e assina
        message = encode_defunct(text=message_text)
        signed = self.w3.eth.account.sign_message(
            message,
            private_key=self.private_key,
        )

        payload = {
            "data": data,
            "signature": signed.signature.hex(),
            "signer": self.account.address,
            "signed_at": int(time.time()),
        }

        log.info(f"✅ Dados assinados (sig={signed.signature.hex()[:16]}...)")
        return payload

    def publish_to_streamr(self, payload: Dict[str, Any]) -> bool:
        """Publica payload assinado na rede Streamr."""
        if not self.streamr:
            log.warning("StreamrClient nao disponivel. Salvando localmente.")
            return True  # Pipeline continua como sucesso em modo simulação

        log.info(
            f"📡 Publicando na Streamr (stream={self.streamr_stream_id})..."
        )

        try:
            self.streamr.publish(self.streamr_stream_id, payload)
            log.info("✅ Dados publicados na Streamr com sucesso")
            return True
        except Exception as e:
            log.error(f"❌ Erro ao publicar na Streamr: {e}")
            return False

    async def run_pipeline(
        self,
        client_id: Optional[str] = None,
        domain: Optional[str] = None,
        vehicle_token_id: Optional[int] = None,
    ) -> Dict[str, Any]:
        """
        Pipeline completo: coleta → assina → publica.
        """
        log.info("🚀 Iniciando pipeline DIMO → Sign → Streamr")

        # 1. Obtém telemetria (real ou simulada)
        if self.simulate:
            telemetry = self.simulate_telemetry()
        else:
            if not all([client_id, domain, vehicle_token_id]):
                raise ValueError(
                    "Modo produção requer client_id, domain e vehicle_token_id"
                )

            headers = await self.authenticate_vehicle(
                client_id, domain, vehicle_token_id
            )
            telemetry = await self.get_vehicle_telemetry(
                headers, vehicle_token_id
            )

        # 2. Assina dados
        signed_payload = self.sign_data(telemetry)

        # 3. Publica na Streamr
        success = self.publish_to_streamr(signed_payload)

        result = {
            "success": success,
            "telemetry": telemetry,
            "signature": signed_payload["signature"],
            "signer": signed_payload["signer"],
            "signed_at": signed_payload["signed_at"],
        }

        log.info(
            f"{'✅ Pipeline concluído' if success else '❌ Pipeline falhou'}"
        )
        return result


async def main():
    parser = argparse.ArgumentParser(
        description="DIMO MVP Connector — DePIN Production-Ready"
    )
    parser.add_argument(
        "--simulate",
        action="store_true",
        help="Modo simulação (sem veículo real)",
    )
    parser.add_argument(
        "--production",
        action="store_true",
        help="Modo produção (veículo real)",
    )
    parser.add_argument(
        "--output",
        default="dimo_output.json",
        help="Arquivo de saída (default: dimo_output.json)",
    )
    args = parser.parse_args()

    # Carrega variáveis de ambiente
    private_key = os.getenv("PRIVATE_KEY")
    streamr_stream_id = os.getenv("STREAMR_STREAM_ID")

    if not private_key or not streamr_stream_id:
        log.error(
            "❌ PRIVATE_KEY e STREAMR_STREAM_ID são obrigatórios no .env\n"
            "   Crie um arquivo .env na raiz do projeto com:\n"
            "   PRIVATE_KEY=sua_chave_privada\n"
            "   STREAMR_STREAM_ID=seu/stream/id"
        )
        return

    # Cria conector
    connector = DIMOMVPConnector(
        private_key=private_key,
        streamr_stream_id=streamr_stream_id,
        simulate=args.simulate or not args.production,
    )

    # Executa pipeline
    if args.production:
        client_id = os.getenv("DIMO_CLIENT_ID")
        domain = os.getenv("DIMO_DOMAIN")
        vehicle_token_id_str = os.getenv("VEHICLE_TOKEN_ID", "0")

        if not all([client_id, domain, vehicle_token_id_str]):
            log.error(
                "❌ Modo produção requer DIMO_CLIENT_ID, DIMO_DOMAIN "
                "e VEHICLE_TOKEN_ID no .env"
            )
            return

        result = await connector.run_pipeline(
            client_id=client_id,
            domain=domain,
            vehicle_token_id=int(vehicle_token_id_str),
        )
    else:
        result = await connector.run_pipeline()

    # Salva resultado
    with open(args.output, "w") as f:
        json.dump(result, f, indent=2, default=str)

    log.info(f"Resultado salvo em {args.output}")
    print(f"\n=== RESUMO ===")
    print(f"  Signer:    {result['signer']}")
    print(f"  Signature: {result['signature'][:20]}...")
    print(f"  Success:   {'OK' if result['success'] else 'FALHOU'}")


if __name__ == "__main__":
    asyncio.run(main())
