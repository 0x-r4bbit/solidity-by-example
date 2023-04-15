// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/009_DefaultValues.sol";

contract DefaultValuesTest is Test {
    DefaultValues public defaultValues;

    function setUp() public {
      defaultValues = new DefaultValues();
    }

    function testBool() public {
      console2.log("DEPLOYER", address(this));
      assertFalse(defaultValues.b());
    }

    function testUint() public {
      assertEq(defaultValues.u(), 0);
    }

    function testInt() public {
      assertEq(defaultValues.i(), 0);
    }

    function testAddress() public {
      assertEq(defaultValues.a(), address(0));
    }

    function testBytes32() public {
      bytes32 testValue;
      assertEq(defaultValues.b32(), testValue);
    }
}
