// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13 .0;

import {Test} from "forge-std/Test.sol";
import {Inbox} from "../src/Inbox.sol";

contract InboxTest is Test {
    Inbox public inbox;

    function setUp() public {
        inbox = new Inbox("hello");
    }

    function test_SetMessage() public {
        assertEq(inbox.message(), "hello");
        string memory message = "hello, world";
        inbox.setMessage(message);
        assertEq(inbox.message(), message);
    }
}
