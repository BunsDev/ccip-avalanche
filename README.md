> _This repository represents an example of using a Chainlink product or service. It is provided to help you understand how to interact with Chainlink’s systems so that you can integrate them into your own. This template is provided "AS IS" without warranties of any kind, has not been audited, and may be missing key checks or error handling to make the usage of the product more clear. Take everything in this repository as an example and not something to be copy pasted into a production ready service._

# ccip-avalanche
Demonstrating how to use Chainlink Cross-Chain Interoperobility Protocol (CCIP) and Avalanche Interchain Messaging (ICM) to send a message from Ethereum Sepolia to Avalanche Fuji (_via CCIP_), then forwarding that message from Avalanche Fuji to Dispatch L1 (_via ICM_).

## What is Chainlink CCIP?

**Chainlink Cross-Chain Interoperability Protocol (CCIP)** provides a single, simple, and elegant interface through which dApps and web3 entrepreneurs can securely meet all their cross-chain needs, including token transfers and arbitrary messaging.

<!-- ![basic-architecture](./img/basic-architecture.png) -->

<!-- ```mermaid
sequenceDiagram
    participant Sender as Sender Contract<br/>( Sepolia )
    participant Broker as Broker Contract<br/>( Fuji )
    participant Receiver as Receiver Contract<br/>( Dispatch )

    Sender->>Broker: Sends Message
    Broker->>Receiver: Forwards Message
``` -->

# Getting Started

In the next section you can see how to send data from one chain to another. But before that, you need to set up some environment variables, install dependencies, setup environment variables, and compile contracts.

## 1. Install Dependencies
```bash
yarn && make
```

## 2. Setup Environment Variables
Run the command below, then update the .env `PRIVATE_KEY` and `ETHERSCAN-API-KEY` variables.

```bash
cp .env.example .env && source .env
```

## 3. Create Wallet
To create a new wallet that is stored in a keystore, issue the following command, which will prompt you to secure the private key with a password.

```bash
cast wallet import --private-key $PRIVATE_KEY -k keystore $ACCOUNT_NAME 
```

For ease use of the keystore we already configured a environment variable called `KEYSTORE` pointing to the `keystore` file in the working directory.

You can use the wallet stored in the keystore by adding the `--keystore` flag instead of the `--private-key` flag.

```bash
cast wallet address --keystore $KEYSTORE
```

## 4. Prepare Smart Contracts

### Smart Contract Design
![messaging-process](./img/messaging-process.png)

### A. Deploy Smart Contracts
In order to interact with our contracts, we first need to deploy them, which is simplified in the [`script/Deploy.s.sol`](./script/Deploy.s.sol) smart contract. 

We have package scripts that enable you to deploy contracts, as follows:

```shell
yarn deploy:sender
```
> [`MessageSender.sol`](./src/MessageSender.sol)
```shell
yarn deploy:broker
```
>[`MessageBroker.sol`](./src/MessageBroker.sol)
```shell
yarn deploy:receiver
```
>[`MessageReceiver.sol`](./src/MessageReceiver.sol)

### B. Fund Message Sender Contract

After acquiring testnet tokens, you will proceed with funding your [Message Sender Contract](./src/MessageSender.sol) with some native tokens (ETH).

```shell
cast send $MESSAGE_SENDER_ADDRESS --rpc-url ethereumSepolia --value 0.05ether --keystore keystore
```

# Sending Data Cross-Chain
> *Before proceeding, please ensure you have completed the steps outlined in the [Setup Messaging Scenario](#setup-messaging-scenario) section above.*

## Ethereum Sepolia &rarr; Avalanche Fuji

### Sending Message (Sepolia &rarr; Fuji)

Run the following to send a message to Fuji from Sepolia via the `SendMessage` functionality coded in [Send.s.sol](./script/Send.s.sol):

    ```shell
    yarn sendMessage "$CUSTOM_MESSAGE"
    ```

## Avalanche Fuju &rarr; Dispatch Testnet

### Brokering Message (Fuji &rarr; Dispatch)

Once the message is finalized on the broker chain (*Fuji*), you may see the details about the latest message via the `BrokerMessage` functionality coded in [Broker.s.sol](./script/Broker.s.sol).

<!-- ```shell
forge script ./script/Send.s.sol:GetLatestMessageDetails -vvv --broadcast --rpc-url avalancheFuji --sig "run()"
``` -->

**3 | Get Details**: once the CCIP message is finalized on the destination blockchain (Fuji), you can see the details of the latest CCIP message received, by running the following command:


## Avalanche Fuji &rarr; Dispatch L1

---
# Key Addresses

**`MessageSender.sol`**
[0x1272d0C7CBDD78d4dc2F35F6bB5B9c40fe944dA7](https://eth-sepolia.blockscout.com/address/0x1272d0C7CBDD78d4dc2F35F6bB5B9c40fe944dA7?tab=contract)

**`MessageBroker.sol`**
[0x0a10A4AfE5E852bdaE91678f98fE71168B048e41](https://testnet.snowtrace.io/address/0x0a10A4AfE5E852bdaE91678f98fE71168B048e41)

**`MessageReceiver.sol`**
[0x0d0debEFCaC433885a51B32c359Cc971522F29cD](https://779672.testnet.snowtrace.io/address/0x0d0debEFCaC433885a51B32c359Cc971522F29cD/contract/779672/code)

---
# Resources

----

# ccip-avalanche
- Using CCIP to enable cross-chain transactions -- initiated on Ethereum Sepolia, namely a message broker. 
- Used for a workshop at Avalanche Summit LATAM in Argentina (October 2024).

## Deploy Contracts

- [`MessageSender.sol`](./src/MessageSender.sol)
- [`MessageBroker.sol`](./src/MessageBroker.sol)
- [`MessageReceiver.sol`](./src/MessageReceiver.sol)

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

