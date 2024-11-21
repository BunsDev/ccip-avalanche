# Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

---
## Verification Instructions

### Sepolia Example
```shell
forge verify-contract $MESSAGE_SENDER_ADDRESS src/MessageSender.sol:MessageSender \
--rpc-url 'https://eth-sepolia.public.blastapi.io' \
--verifier blockscout \
--verifier-url 'https://eth-sepolia.blockscout.com/api/' \
```

### Fuji Example
```shell
forge verify-contract $MESSAGE_BROKER_ADDRESS src/MessageBroker.sol:MessageBroker \
--rpc-url 'https://api.avax-test.network/ext/bc/C/rpc' \
--verifier-url 'https://api.routescan.io/v2/network/testnet/evm/43113/etherscan' \
--etherscan-api-key "verifyContract"
```

### Dispatch Example
```shell
forge verify-contract 0x0d0debEFCaC433885a51B32c359Cc971522F29cD src/MessageReceiver.sol:MessageReceiver \
--rpc-url 'https://subnets.avax.network/dispatch/testnet/rpc' \
--verifier-url 'https://api.routescan.io/v2/network/testnet/evm/779672/etherscan' \
--verifier etherscan \
--etherscan-api-key "verifyContract"
```