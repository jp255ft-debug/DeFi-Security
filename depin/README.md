# 📡 DePIN Trust Framework

<div align="center">

![Status](https://img.shields.io/badge/status-production%20ready-2ea44f?style=for-the-badge)
![Python](https://img.shields.io/badge/python-3.11%2B-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Solidity](https://img.shields.io/badge/solidity-0.8.24-363636?style=for-the-badge&logo=solidity&logoColor=white)
![Streamr](https://img.shields.io/badge/Streamr-integrated-00D395?style=for-the-badge)
![Helium](https://img.shields.io/badge/Helium-integrated-474DFF?style=for-the-badge)
![DIMO](https://img.shields.io/badge/DIMO-integrated-00BFA5?style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-blue?style=for-the-badge)

**Framework de segurança e verificação para infraestrutura física descentralizada (DePIN)**

[📖 Conectores](connectors/) | [📜 Contratos](contracts/) | [📋 Templates](templates/) | [🚀 Quick Start](#quick-start)

</div>

---

## 🎯 O que é DePIN Trust Framework?

Framework modular para auditoria de segurança, verificação de dados e integração com redes de infraestrutura física descentralizada (DePIN). Combina conectores IoT, smart contracts de verificação e templates de projetos para acelerar o desenvolvimento seguro de aplicações DePIN.

### Redes Suportadas

| Rede | Tipo | Conector | Status |
|------|------|----------|--------|
| **DIMO** | Vehicle Telemetry | `dimo_connector.py` | ✅ Funcional |
| **Helium** | IoT Network | `helium_ingest.py` | ✅ Funcional |
| **Streamr** | Data Streaming | `streamr_publisher.py` | ✅ Funcional |
| **Generic IoT** | Multi-rede | `generic_iot.py` | ✅ Funcional |

---

## 🏗️ Arquitetura

```
┌─────────────────────────────────────────────────────────────┐
│                    DePIN Trust Framework                     │
├──────────────┬──────────────────┬───────────────────────────┤
│  Conectores  │  Smart Contracts │      Templates            │
│              │                  │                           │
│  DIMO ───────┤  DataVerifier   │  depin_checklist.md       │
│  Helium ─────┤  OracleDepin    │  depin_vulnerabilities.md │
│  Streamr ────┤                  │  depin_report_template.md │
│  Generic IoT │                  │  00_Template_Project/     │
└──────────────┴──────────────────┴───────────────────────────┘
         │               │                    │
         ▼               ▼                    ▼
    Dados IoT      Verificação           Projetos
    Coletados      On-chain              DePIN
```

---

## 🚀 Quick Start

### Pré-requisitos

```bash
# Python 3.11+
python --version

# Foundry (para contratos)
foundryup

# Docker (opcional)
docker --version
```

### Instalação

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/defi-security-workspace.git
cd defi-security-workspace

# Instale dependências
pip install -r requirements_depin.txt

# Configure ambiente
cp .env.example .env
# Edite .env com suas chaves de API
```

### Executar Pipeline DePIN

```bash
# Pipeline completo
./scripts/run_depin_pipeline.sh

# Ou componentes individuais:
python depin/connectors/dimo_connector.py      # Dados veiculares
python depin/connectors/helium_ingest.py        # IoT sensors
python depin/connectors/streamr_publisher.py    # Data streaming
python depin/connectors/generic_iot.py          # Custom IoT
```

### Deploy de Contratos

```bash
# Deploy DataVerifier
./scripts/deploy_verifier.sh

# Testar contratos
cd depin/contracts
forge test
```

---

## 📡 Conectores

### DIMO Connector
```python
from depin.connectors.dimo_connector import DIMOConnector

connector = DIMOConnector(api_key="your_key")
vehicles = connector.get_vehicles()
telemetry = connector.get_telemetry(vehicle_id="0x...")
```

### Helium Ingest
```python
from depin.connectors.helium_ingest import HeliumIngest

ingest = HeliumIngest()
hotspots = ingest.get_hotspots()
data = ingest.get_device_data(device_id="0x...")
```

### Streamr Publisher
```python
from depin.connectors.streamr_publisher import StreamrPublisher

publisher = StreamrPublisher(private_key="0x...")
stream = publisher.create_stream("sensor-data")
publisher.publish(stream_id, {"temperature": 25.5, "humidity": 60})
```

---

## 📜 Smart Contracts

### DataVerifier.sol
Verificação de assinaturas de dados IoT on-chain.

```solidity
// Verificar assinatura de dados IoT
function verifyData(
    bytes32 dataHash,
    bytes calldata signature,
    address signer
) external view returns (bool);
```

### OracleDepin.sol
Oráculo descentralizado para dados DePIN.

```solidity
// Publicar dados de sensor
function publishData(
    string memory sensorId,
    uint256 value,
    uint256 timestamp
) external;
```

---

## 📋 Templates de Projetos

| Template | Descrição | Uso |
|----------|-----------|-----|
| `depin_checklist.md` | Checklist de segurança DePIN | Auditorias |
| `depin_vulnerabilities.md` | Catálogo de vulnerabilidades DePIN | Pesquisa |
| `depin_report_template.md` | Template de relatório de auditoria | Relatórios |
| `00_Template_Project/` | Projeto DePIN exemplo | Novos projetos |

---

## 💼 Casos de Uso

### 1. Auditoria de Segurança DePIN
- Verificação de conectores IoT
- Análise de smart contracts DePIN
- Validação de assinaturas de dados

### 2. Integração de Dados IoT
- Coleta de telemetria veicular (DIMO)
- Ingestão de sensores IoT (Helium)
- Streaming de dados em tempo real (Streamr)

### 3. Verificação On-chain
- Assinatura e verificação de dados
- Oráculo descentralizado
- Prova de integridade de dados

---

## 📊 Projetos DePIN

| Projeto | Status | Conectores | Contratos |
|---------|--------|------------|-----------|
| **H2V-Trust** | 🟢 Production | IoT Simulator | SBT + Compliance |
| *Seu projeto aqui* | 📝 Template | - | - |

---

## 🔒 Segurança

- ✅ **Assinatura de dados**: ECDSA para verificação de integridade
- ✅ **Timestamp verification**: Prevenção de replay attacks
- ✅ **Access control**: Role-based para publicação de dados
- ✅ **Oracle security**: Múltiplas fontes de dados

---

## 📄 Licença

MIT License — veja o arquivo [LICENSE](../LICENSE) para detalhes.

---

<div align="center">
  <sub>🔒 DePIN Trust Framework — Segurança para Infraestrutura Descentralizada</sub>
  <br>
  <sub>Parte do <strong>DeFi Security Workspace</strong></sub>
</div>
