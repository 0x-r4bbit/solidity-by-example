// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/004_StateVariables.sol";

contract StateVariablesTest is Test {
    StateVariables public stateVariables;

    function setUp() public {
        stateVariables = new StateVariables();
    }

    function testFoo() public {
        assertEq(stateVariables.foo(), 456);
    }
}
