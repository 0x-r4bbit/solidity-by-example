// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/*
* Instructions
*
*/
contract GlobalVariables {

  function globalVars() external view returns (address, uint, uint) {
    address sender = msg.sender;
    uint timestamp = block.timestamp;
    uint blockNum = block.number;
    return (sender, timestamp, blockNum);
  }
}
