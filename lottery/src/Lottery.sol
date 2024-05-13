// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25 .0;

contract Lottery {
    address public manager;
    address[] public players;

    constructor() {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value >= 0.01 ether, "Ethers insufficient, expected: >= 0.01 ETH");
        players.push(msg.sender);
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }

    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp)));
    }

    function pickWinner() public restricted {
        uint256 index = random() % players.length;
        address payable winnerAddress = payable(players[index]);

        winnerAddress.transfer(address(this).balance);

        // reset players list
        players = new address[](0);
    }

    modifier restricted() {
        require(msg.sender == manager, "Only manager can pick the winner");
        _;
    }
}
