// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {console, Test} from "forge-std/Test.sol";
import {CCIPLocalSimulatorFork, Register} from "@chainlink/local/src/ccip/CCIPLocalSimulatorFork.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {BurnMintERC677Helper, IERC20} from "@chainlink/local/src/ccip/CCIPLocalSimulator.sol";
import {ITeleporterMessenger} from "@teleporter/TeleporterMessenger.sol";

import {MessageBroker} from "../src/MessageBroker.sol";
import {MessageSender} from "../src/MessageSender.sol";
import {MessageReceiver} from "../src/MessageReceiver.sol";

contract Setup is Test {
    bool private baseTestInitialized;

    CCIPLocalSimulatorFork ccipLocalSimulatorFork;
    uint256 sepoliaFork;
    uint256 fujiFork;
    uint256 dispatchFork;

    MessageSender messageSender;
    MessageBroker messageBroker;
    MessageReceiver messageReceiver;
    ITeleporterMessenger teleporterMessenger;

    // local addresses //
    address MESSAGE_SENDER_ADDRESS;
    address MESSAGE_BROKER_ADDRESS;
    address MESSAGE_RECEIVER_ADDRESS;

    address constant WARP_PRECOMPILE_ADDRESS = 0x0200000000000000000000000000000000000005;

    uint256 constant FAUCET_REQUEST_AMOUNT = 10 ether;
    string public messageText = "Hai Dispatch";

    string FUJI_RPC_URL = vm.envString("FUJI_RPC_URL");
    string SEPOLIA_RPC_URL = vm.envString("SEPOLIA_RPC_URL");
    string DISPATCH_RPC_URL = vm.envString("DISPATCH_RPC_URL");

    // ETHEREUM SEPOLIA
    uint256 SEPOLIA_CHAIN_ID = vm.envUint("SEPOLIA_CHAIN_ID");
    uint64 SEPOLIA_CHAIN_SELECTOR = uint64(vm.envUint("SEPOLIA_CHAIN_SELECTOR"));
    address SEPOLIA_ROUTER_ADDRESS = vm.envAddress("SEPOLIA_ROUTER_ADDRESS");
    
    // AVALANCHE FUJI
    uint256 FUJI_CHAIN_ID = vm.envUint("FUJI_CHAIN_ID");
    bytes32 FUJI_BLOCKCHAIN_ID = vm.envBytes32("FUJI_BLOCKCHAIN_ID");
    uint64 FUJI_CHAIN_SELECTOR = uint64(vm.envUint("FUJI_CHAIN_SELECTOR"));
    address FUJI_ROUTER_ADDRESS = vm.envAddress("FUJI_ROUTER_ADDRESS");
    address TELEPORTER_MESSENGER_ADDRESS = vm.envAddress("TELEPORTER_MESSENGER_ADDRESS");
    // DISPATCH TESTNET
    bytes32 DISPATCH_BLOCKCHAIN_ID = vm.envBytes32("DISPATCH_BLOCKCHAIN_ID");

    mapping (uint => string) public network;

    function setUp() public virtual {
        // creates: CCIP Local Simulator Fork.
        ccipLocalSimulatorFork = new CCIPLocalSimulatorFork();
        vm.makePersistent(address(ccipLocalSimulatorFork));

        setup_sepoliaFork();
        setup_fujiFork();
        setup_dispatchFork();

        // BaseTest.setUp is often called multiple times from tests' setUp due to inheritance.
        if (baseTestInitialized) return;
        baseTestInitialized = true;
    }

    // [SEPOLIA] CONFIGURATION //
    function setup_sepoliaFork() public {
        sepoliaFork = vm.createSelectFork(SEPOLIA_RPC_URL);
        messageSender = new MessageSender(SEPOLIA_ROUTER_ADDRESS);
        MESSAGE_SENDER_ADDRESS = address(messageSender);
        network[block.chainid] = 'Sepolia'; // 11155111
        deal(MESSAGE_SENDER_ADDRESS, 10 ether);
    }

    // [FUJI] CONFIGURATION //
    function setup_fujiFork() public {
        fujiFork = vm.createSelectFork(FUJI_RPC_URL);
        messageBroker = new MessageBroker(FUJI_ROUTER_ADDRESS);
        MESSAGE_BROKER_ADDRESS = address(messageBroker);
        network[block.chainid] = 'Fuji'; // 779672
    }

    // [DISPATCH] CONFIGURATION //
    function setup_dispatchFork() public {
        dispatchFork = vm.createSelectFork(DISPATCH_RPC_URL);
        teleporterMessenger = ITeleporterMessenger(TELEPORTER_MESSENGER_ADDRESS);
        messageReceiver = new MessageReceiver(TELEPORTER_MESSENGER_ADDRESS);
        MESSAGE_RECEIVER_ADDRESS = address(messageReceiver);
        network[block.chainid] = 'Dispatch'; // 43114
    }
}