# Momentum v3-Core (Sui / Move)

Core smart contracts for **Momentum DEX v3**, a Uniswap-v3–style CLMM (concentrated liquidity market maker) implemented in **Move** on **Sui**.  
This repo contains the on-chain building blocks used by Momentum’s DEX and related components (e.g., slippage checking).

> For high-level product docs and concepts, see the [Momentum Developer Docs](https://docs.mmt.finance/core-products/momentum-dex/developers).  
> For the official TypeScript SDK, see [`@mmt-finance/clmm-sdk`](https://github.com/mmt-finance/clmm-sdk).  
> For low-level contract interfaces used by integrators, see [`mmt-contract-interface`](https://github.com/mmt-finance/mmt-contract-interface).

## Packages & features

This repo currently ships two Move packages:

- **`clmm/`** – Core CLMM protocol: pools, positions, ticks, swap/quote, fees, and liquidity accounting.
- **`slippage_check/`** – Pure-function helpers for slippage check.

```
v3-core/
├─ clmm/ # Move package: CLMM core contracts
├─ slippage_check/ # Move package: slippage guard utilities
├─ package.json
├─ yarn.lock
├─ .prettierrc
└─ README.md
```

## Prerequisites

- **Sui CLI** (matching your localnet/testnet version).  
  Install from Sui’s official releases and ensure `sui` is on your PATH.
- **Move toolchain** (bundled with Sui).
- **Node.js 18+** & **Yarn** (for formatting scripts / CI only).
- A **Sui account** with gas (for testnet/devnet).

> If you’re integrating from an app/service, you’ll usually pair these contracts with the [`@mmt-finance/clmm-sdk`](https://github.com/mmt-finance/clmm-sdk) TypeScript library.

## Build, test & deploy

From the repo root:

```bash
# Build each package
sui move build --path clmm
sui move build --path slippage_check

# Run unit tests
sui move test --path clmm
sui move test --path slippage_check

# Deploy
sui client publish --path clmm
sui client publish --path slippage_check
```

### Developer documentation

For detailed guides on:

* Deployment and package IDs
* Integration with Momentum SDK, including
  * Pool creation
  * Liquidity management
  * Swaps
  * And more
* Auditing reports

Please refer to the official [Momentum Developer Docs](https://docs.mmt.finance/core-products/momentum-dex/developers).

## Security

Security is the highest priority of the Momentum protocol. All smart contracts in this repository undergo rigorous testing, peer review, and professional audits prior to mainnet deployment.

### Auditing

Momentum DEX v3 Core has been **professionally audited** by independent security firms.  
For complete audit results, risk assessments, and findings, see the official audit reports:

[View full audit reports →](https://docs.mmt.finance/core-products/momentum-dex/developers/audit-report)

### Security bounty (Coming soon)

## Links

- **Developer Docs:** [Momentum DEX overview & developer guides](https://docs.mmt.finance/core-products/momentum-dex/developers)  
- **Audit Reports:** [Momentum DEX v3 Core Security Audits](https://docs.mmt.finance/core-products/momentum-dex/developers/audit-report)  
- **SDK:** [`@mmt-finance/clmm-sdk`](https://github.com/mmt-finance/clmm-sdk)  
- **Contract Interfaces:** [`mmt-contract-interface`](https://github.com/mmt-finance/mmt-contract-interface)  

