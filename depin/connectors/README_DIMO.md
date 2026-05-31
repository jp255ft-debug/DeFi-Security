# DIMO MVP Connector — DePIN Production-Ready

Conector modernizado usando SDK oficial DIMO + Streamr + Web3 signing.

## Arquitetura

```
┌─────────────┐     ┌──────────┐     ┌─────────────┐     ┌──────────────┐
│ DIMO Vehicle │────▶│ Vehicle  │────▶│   ECDSA     │────▶│   Streamr    │
│ (ou simulado)│     │  Auth    │     │   Sign      │     │   Network    │
└─────────────┘     └──────────┘     └─────────────┘     └──────────────┘
                        │                                      │
                        ▼                                      ▼
                  dimo-python-sdk                    streamr-client
```

## Requisitos

```bash
pip install web3 python-dotenv
pip install streamr-client   # para publicacao real na Streamr
pip install dimo-python-sdk  # apenas para modo producao
```

## Configuração

1. Copie o arquivo `.env.example` para `.env`:
   ```bash
   cp .env.example .env
   ```

2. Preencha as variáveis no `.env`:

   | Variável | Obrigatório | Descrição |
   |:---------|:-----------:|:----------|
   | `PRIVATE_KEY` | ✅ | Chave privada Ethereum (0x...) |
   | `STREAMR_STREAM_ID` | ✅ | ID do Stream criado no Streamr Hub |
   | `DIMO_CLIENT_ID` | ❌ (produção) | Client ID do app DIMO |
   | `DIMO_DOMAIN` | ❌ (produção) | Domínio do app DIMO |
   | `VEHICLE_TOKEN_ID` | ❌ (produção) | Token ID do veículo NFT |

## 🌊 Configuração da Streamr (Publicação Real)

Para publicar os dados na rede Streamr (em vez de apenas salvar localmente):

### Passo 1: Instalar o cliente Streamr
```bash
pip install streamr-client
```

### Passo 2: Criar um Stream no Streamr Hub

1. Acesse [Streamr Hub](https://streamr.network/hub)
2. Conecte sua **MetaMask** (use a mesma carteira que gerou a `PRIVATE_KEY` do `.env`)
3. Clique em **"Create Stream"**
4. Dê um nome: `DIMO-Secure-Telemetry`
5. Copie o **Stream ID** gerado (formato: `0x123.../DIMO-Secure-Telemetry`)

### Passo 3: Configurar o `.env`

Adicione o Stream ID ao seu `.env`:
```env
STREAMR_STREAM_ID=0xseu_stream_id_aqui
```

### Passo 4: Testar a Publicação

```bash
cd depin/connectors
python dimo_mvp.py --simulate
```

Saída esperada:
```
📡 Publicando na Streamr (stream=0x123.../DIMO-Secure-Telemetry)...
✅ Dados publicados na Streamr com sucesso
```

No Streamr Hub, vá na aba **Messages** ou **Live** para ver os dados chegando em tempo real.

### 🔐 Autenticação Headless

O script usa `StreamrClient(priv_key=PRIVATE_KEY)` para autenticar sem depender de MetaMask no navegador. A mesma chave privada do `.env` é usada tanto para assinar os dados (ECDSA) quanto para autenticar na Streamr.

## Uso

### Modo Simulação (Teste sem veículo real)

```bash
cd depin/connectors
python dimo_mvp.py --simulate
```

Gera telemetria de um Tesla Model 3 fictício, assina com ECDSA e publica na Streamr.

### Modo Produção (Com veículo real)

```bash
cd depin/connectors
python dimo_mvp.py --production
```

Requer veículo cadastrado na rede DIMO e credenciais configuradas no `.env`.

### Salvar em arquivo específico

```bash
python dimo_mvp.py --simulate --output meu_resultado.json
```

## Pipeline

1. **Coleta** — Obtém telemetria do veículo (real via DIMO API ou simulada)
2. **Assinatura** — Assina os dados com ECDSA (EIP-191) usando `encode_defunct()`
3. **Publicação** — Publica o payload assinado na rede Streamr
4. **Fallback** — Se Streamr não estiver disponível, salva localmente em JSON

## Exemplo de Output

```json
{
  "success": true,
  "telemetry": {
    "speed_kmh": 65.0,
    "make": "Tesla",
    "model": "Model 3",
    "location": { "latitude": 40.7128, "longitude": -74.006 }
  },
  "signature": "0xabc123...",
  "signer": "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
  "signed_at": 1780098986
}
```
