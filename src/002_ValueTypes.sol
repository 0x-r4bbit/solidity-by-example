// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/*
* Instructions
*
*/
contract ValueTypes {
  bool public b = true;
  uint public u = 123;

  int public i = -123;

  int public minInt = type(int).min;
  int public maxInt = type(int).max;

  address public addr = 0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5;
  bytes32 public b32 = 0x674cd055d68f23f9eb785375eda773d9ec0c72de5c172186b3dc109e93a744e3;
}

