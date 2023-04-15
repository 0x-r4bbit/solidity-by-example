// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/*
* Instructions
*
*/
contract ViewAndPureFunctions {

  uint public num;

  function viewFunc() external view returns (uint) {
    return num;
  }

  function pureFunc() external pure returns (uint) {
    return 1;
  }

  function addToNum(uint x) external view returns (uint) {
    return num + x;
  }

  function add(uint x, uint y) external pure returns(uint) {
    return x + y;
  }
}

