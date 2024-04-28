// SPDX-License-Identifier: UNLICENSED
// the version of the solidity language to use
pragma solidity ^0.8.13 .0;

// defines a new contract (a class that will have methods and other members)
// deployed versions of the contract are instantiations of the class
contract Inbox {
    // a storage variable that exists for the life of the contract instance
    // a storage variable exists in the blockchain for all eternity
    string public message;

    // the constructor that instantiates this class
    constructor(string memory initialMessage) {
        message = initialMessage;
    }

    // this method modifies the contract's data
    // so it is not marked with `view` (or `constant`)
    function setMessage(string memory newMessage) public {
        message = newMessage;
    }

    // `getMessage` => name of the function
    // `public view` =>  function type declaration
    function getMessage() public view returns (string memory) {
        return message;
    }
}
