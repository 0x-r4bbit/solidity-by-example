// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/007_ViewAndPureFunctions.sol";

contract ViewAndPureFunctionsTest is Test {
  ViewAndPureFunctions public viewAndPureFunctions;

  function setUp() public {
    viewAndPureFunctions = new ViewAndPureFunctions();
  }

  function testViewFunc() public {
    assertEq(viewAndPureFunctions.viewFunc(), 0);
  }

  function testPureFunc() public {
    assertEq(viewAndPureFunctions.pureFunc(), 1);
  }

  function testAddToNum() public {
    assertEq(viewAndPureFunctions.addToNum(3), 3);
  }

  function testAdd() public {
    assertEq(viewAndPureFunctions.add(3, 2), 5);
  }
}

