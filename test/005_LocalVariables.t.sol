// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/005_LocalVariables.sol";

contract LocalVariablesTest is Test {
    LocalVariables public localVariables;

    function setUp() public {
        localVariables = new LocalVariables();
    }

    function testVariables() public {
        assertFalse(localVariables.b());
        assertEq(localVariables.i(), 0);
        assertEq(localVariables.myAddress(), address(0));

        localVariables.foo();

        assertTrue(localVariables.b());
        assertEq(localVariables.i(), 123);
        assertEq(localVariables.myAddress(), address(1));
    }
}

