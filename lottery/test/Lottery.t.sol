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
}
