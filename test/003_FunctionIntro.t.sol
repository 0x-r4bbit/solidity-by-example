// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/003_FunctionIntro.sol";

contract FunctionIntroTest is Test {
    FunctionIntro public functionIntro;

    function setUp() public {
        functionIntro = new FunctionIntro();
    }

    function testAdd() public {
        assertEq(functionIntro.add(5, 5), 10);
    }

    function testSub() public {
        assertEq(functionIntro.sub(10, 5), 5);
    }
}
