// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/006_GlobalVariables.sol";

contract GlobalVariablesTest is Test {
  GlobalVariables public globalVariables;

  function setUp() public {
    globalVariables = new GlobalVariables();
  }

  function testGlobalVars() public {
    (address addr, , ) = globalVariables.globalVars();
    assertEq(addr, 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496);
  }
}
