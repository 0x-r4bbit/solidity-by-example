// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/058_Create2.sol";

contract Create2Test is Test {
    Create2Factory public create2Factory;

    event Deploy(address addr);

    function setUp() public {
      create2Factory = new Create2Factory();
    }

    function testGetAddress() public {
      bytes memory bytecode = create2Factory.getBytecode(address(this));
      uint salt = 777;
      address create2Address = create2Factory.getAddress(bytecode, salt);

      vm.expectEmit(false, false, false, true);
      emit Deploy(create2Address);
      create2Factory.deploy(salt);
    }
}

