#!/usr/bin/env python3
"""
Baixa contratos do Etherscan / repositório isolando o escopo para auditoria.
Uso: python fetch_scope.py <endereco_contrato> [--network mainnet|sepolia] [--output pasta]
"""

import argparse
import json
import os
import sys
import requests
from pathlib import Path

ETHERSCAN_API_KEYS = {
    "mainnet": os.environ.get("ETHERSCAN_API_KEY", ""),
    "sepolia": os.environ.get("ETHERSCAN_API_KEY_SEPOLIA", ""),
}

ETHERSCAN_URLS = {
    "mainnet": "https://api.etherscan.io/api",
    "sepolia": "https://api-sepolia.etherscan.io/api",
}


def fetch_contract_source(address: str, network: str = "mainnet") -> dict:
    """Busca o código fonte do contrato no Etherscan."""
    api_key = ETHERSCAN_API_KEYS.get(network, "")
    if not api_key:
        print(f"❌ Erro: API key para {network} não configurada.")
        print(f"   Exporte: export ETHERSCAN_API_KEY='sua-chave'")
        sys.exit(1)

    url = ETHERSCAN_URLS.get(network)
    params = {
        "module": "contract",
        "action": "getsourcecode",
        "address": address,
        "apikey": api_key,
    }

    print(f"📡 Buscando contrato {address} na {network}...")
    response = requests.get(url, params=params)
    data = response.json()

    if data["status"] != "1":
        print(f"❌ Erro ao buscar contrato: {data.get('message', 'Desconhecido')}")
        sys.exit(1)

    return data["result"][0]


def save_contracts(contract_data: dict, output_dir: str):
    """Salva os contratos no diretório de saída."""
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)

    # Salva o contrato principal
    source_code = contract_data.get("SourceCode", "")
    contract_name = contract_data.get("ContractName", "Unknown")
    
    # Remove wrapper JSON se presente (contratos com múltiplos arquivos)
    if source_code.startswith("{"):
        try:
            sources = json.loads(source_code[1:-1]) if source_code.startswith("{{") else json.loads(source_code)
            for path, content in sources.get("sources", sources).items():
                file_path = output_path / path
                file_path.parent.mkdir(parents=True, exist_ok=True)
                with open(file_path, "w", encoding="utf-8") as f:
                    f.write(content.get("content", content))
                print(f"   ✅ {path}")
        except json.JSONDecodeError:
            with open(output_path / f"{contract_name}.sol", "w", encoding="utf-8") as f:
                f.write(source_code)
            print(f"   ✅ {contract_name}.sol")
    else:
        with open(output_path / f"{contract_name}.sol", "w", encoding="utf-8") as f:
            f.write(source_code)
        print(f"   ✅ {contract_name}.sol")

    # Salva metadados
    metadata = {
        "address": contract_data.get("Address", ""),
        "contract_name": contract_name,
        "compiler_version": contract_data.get("CompilerVersion", ""),
        "optimization_used": contract_data.get("OptimizationUsed", ""),
        "runs": contract_data.get("Runs", ""),
        "license": contract_data.get("LicenseType", ""),
    }
    
    with open(output_path / "_metadata.json", "w", encoding="utf-8") as f:
        json.dump(metadata, f, indent=2)
    print(f"   ✅ _metadata.json")


def main():
    parser = argparse.ArgumentParser(description="Fetch contract source from Etherscan")
    parser.add_argument("address", help="Contract address")
    parser.add_argument("--network", default="mainnet", choices=["mainnet", "sepolia"])
    parser.add_argument("--output", default=None, help="Output directory")
    
    args = parser.parse_args()
    
    if not args.output:
        args.output = f"contracts/{args.address[:8]}"
    
    print(f"🔍 Fetching scope for: {args.address}")
    contract_data = fetch_contract_source(args.address, args.network)
    save_contracts(contract_data, args.output)
    print(f"\n✅ Contratos salvos em: {args.output}/")


if __name__ == "__main__":
    main()
