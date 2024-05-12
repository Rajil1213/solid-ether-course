// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

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
}
