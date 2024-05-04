// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19 .0;

contract Inbox {
    string public message;

    constructor(string memory _message) {
        message = _message;
    }

    function getMessage() public view returns (string memory) {
        return message;
    }

    function setMessage(string memory newMessage) public {
        message = newMessage;
    }
}
