# MacCoin (MAC)

A simple fungible token smart contract written in Clarity using Clarinet.

- Token name: MacCoin
- Symbol: MAC
- Decimals: 6
- Capabilities: mint (by contract deployer), transfer, burn

## Project layout

This repository contains a Clarinet project under `clarinet/`:

- `clarinet/Clarinet.toml` — Clarinet project manifest
- `clarinet/contracts/maccoin.clar` — MacCoin smart contract
- `clarinet/settings/` — network settings (Devnet/Testnet/Mainnet)
- `clarinet/tests/` — placeholder for unit tests (TypeScript)

## Prerequisites

- Clarinet CLI (installed already if `clarinet --version` works). If you need to install it, see the official guide: https://docs.hiro.so/clarinet/getting-started/install-clarinet
- Node.js (optional, for running tests)

## Quick start

1. Change into the Clarinet project directory:
   
   ```bash
   cd clarinet
   ```

2. Check the contract syntax:
   
   ```bash
   clarinet check
   ```

3. Open a REPL to interact with the contract:
   
   ```bash
   clarinet console
   ```

4. (Optional) Install test dependencies and run tests:
   
   ```bash
   npm install
   npm test
   ```

## Contract interface

Read-only functions:
- `get-name` -> `(response (string-ascii 32) uint)`
- `get-symbol` -> `(response (string-ascii 32) uint)`
- `get-decimals` -> `(response uint uint)`
- `get-total-supply` -> `(response uint uint)`
- `get-balance-of (principal)` -> `(response uint uint)`

Public functions (all return `(response bool uint)`):
- `transfer (amount uint) (sender principal) (recipient principal)`
- `mint (amount uint) (recipient principal)` — only callable by `contract-owner`
- `burn (amount uint)` — callable by token holder (burns from `tx-sender`)

Error codes:
- `u100` — not authorized
- `u101` — insufficient balance
- `u102` — not contract owner

## Development tips

- Format Clarity files:
  
  ```bash
  clarinet format
  ```

- LSP (editor integration):
  
  ```bash
  clarinet lsp
  ```

- Start Devnet for local dApp integration:
  
  ```bash
  clarinet integrate
  ```

## License

See `LICENSE`.
