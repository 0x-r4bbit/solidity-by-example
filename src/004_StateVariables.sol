// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/*
* Instructions
*
*/
contract StateVariables {
  uint public myUint = 123;

  function foo() external pure returns (uint) {
    uint notStateVariable = 456;
    return notStateVariable;
  }
}
