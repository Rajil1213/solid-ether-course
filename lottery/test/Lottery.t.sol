// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {Lottery} from "../src/Lottery.sol";

contract LotteryTest is Test {
    Lottery public lottery;

    function setUp() public {
        lottery = new Lottery();
    }

    function test_Initialization() public view {
        assertEq(lottery.getPlayers().length, 0);
    }

    function testFail_EnterWithoutSufficientEthers() public {
        address nonDeployerAddress = address(0);
        vm.prank(nonDeployerAddress);

        lottery.enter{value: 0.001 ether}();
    }

    function test_EnterWithSufficientEthers() public {
        address player1 = makeAddr("non-deployer-1");
        address player2 = makeAddr("non-deployer-2");

        vm.startPrank(player1);
        uint256 minEther = 0.01 ether;
        vm.deal(player1, minEther);
        lottery.enter{value: minEther}();
        vm.stopPrank();

        vm.startPrank(player2);
        uint256 moreEther = 0.03 ether;
        vm.deal(player2, moreEther);
        lottery.enter{value: moreEther}();
        vm.stopPrank();

        assertEq(lottery.getPlayers().length, 2);
        assertEq(lottery.getPlayers()[0], player1);
        assertEq(lottery.getPlayers()[1], player2);

        assertEq(address(lottery).balance, minEther + moreEther);
    }

    function testFail_NonManagerPicksWinner() public {
        address player = makeAddr("non-manager");

        vm.startPrank(player);
        lottery.pickWinner();
        vm.stopPrank();
    }

    function test_LotteryGameShouldWork() public {
        uint256 amount = 1 ether;

        // nonces to inject randomness; make sure they are different multiples of players.length
        uint256[2] memory nonces = [uint256(10000), uint256(30000)];

        address winner1 = getWinner(nonces[0], amount);
        assertEq(address(winner1).balance, 3 * amount);

        address winner2 = getWinner(nonces[1], amount);
        assertEq(address(winner2).balance, 3 * amount);

        assertNotEq(winner1, winner2);
    }

    function getWinner(uint256 nonce, uint256 amount) private returns (address) {
        //#region setup
        address player1 = makeAddr("player1");
        address player2 = makeAddr("player2");
        address player3 = makeAddr("player3");

        vm.deal(player1, amount);
        vm.deal(player2, amount);
        vm.deal(player3, amount);
        //#endregion

        //#region enter players
        vm.startPrank(player1);
        lottery.enter{value: amount}();
        vm.stopPrank();

        vm.startPrank(player2);
        lottery.enter{value: amount}();
        vm.stopPrank();

        vm.startPrank(player3);
        lottery.enter{value: amount}();
        vm.stopPrank();

        assertEq(lottery.getPlayers().length, 3);
        assertEq(address(player1).balance, 0);
        assertEq(address(player2).balance, 0);
        assertEq(address(player3).balance, 0);
        //#endregion

        //#region pickWinner
        skip(nonce); // progress `block.timestamp` for randomness
        lottery.pickWinner();
        //#endregion

        //#region return winner
        if (address(player2).balance != 0) {
            emit log_string("Player 2");
            return player2;
        } else if (address(player3).balance != 0) {
            emit log_string("Player 3");
            return player3;
        }

        return player1;
        //#endregion
    }
}
