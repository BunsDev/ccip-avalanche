// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Client, console, Enchanted} from './Enchanted.sol';

contract BrokerTest is Enchanted {

    function test_interceptMessage() public {
        (uint _sentFrom, bytes32 _sentMessageId, string memory _messageSent) = _send(messageText);
        vm.selectFork(sepoliaFork);
        bytes32 latestSentMessageId = messageSender.latestMessageId();

        assertEq(_sentMessageId, latestSentMessageId);
        console.log('\u2705 | Sent from %s', network[_sentFrom]);

        (uint _chainId, string memory _messageIntercepted) = _intercept();
        assertEq(_messageSent, _messageIntercepted);
        console.log('\u2705 | Intercepted on %s', network[_chainId]);
    }

    function test_brokerMessage() public {
        string memory _messageSent = _sendMessage();
        _interceptMessage();
        _brokerMessage(_messageSent);
    }

    function _sendMessage() internal returns (string memory _messageSent) {
        (uint _sentFrom, bytes32 _sentMessageId, string memory _sentMessage) = _send(messageText);
        vm.selectFork(sepoliaFork);
        bytes32 latestSentMessageId = messageSender.latestMessageId();
        _messageSent = _sentMessage;

        assertEq(_sentMessageId, latestSentMessageId);
        console.log('\u2705 | Sent on %s', network[_sentFrom]);
    }

    function _interceptMessage() internal {
        (uint _chainId, string memory _messageIntercepted) = _intercept();

        assertEq(_messageIntercepted, messageText);
        console.log('\u2705 | Intercepted on %s', network[_chainId]);
    }

    function _brokerMessage(string memory _messageSent) internal {
        (uint _fromChain, bytes32 _brokerMessageId, string memory _messageBrokered) = _broker(_messageSent);
        vm.selectFork(fujiFork);
        bytes32 latestBrokerMessageId = messageBroker.latestBrokeredId();

        assertEq(_brokerMessageId, latestBrokerMessageId);
        assertEq(_messageSent, _messageBrokered);
        console.log('\u2705 | Brokered on %s', network[_fromChain]);
    }
}
