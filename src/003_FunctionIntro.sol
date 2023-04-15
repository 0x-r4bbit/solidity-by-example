// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/*
* Instructions
*
*/
contract FunctionIntro {
  function add(uint _x, uint _y) external pure returns (uint) {
    return _x + _y;
  }

  function sub(uint _x, uint _y) external pure returns (uint) {
    return _x - _y;
  }
}

