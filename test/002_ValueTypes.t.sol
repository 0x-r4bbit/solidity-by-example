// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/002_ValueTypes.sol";

contract ValueTypesTest is Test {
    ValueTypes public valueTypes;

    function setUp() public {
        valueTypes = new ValueTypes();
    }

    function testBool() public {
        assertTrue(valueTypes.b());
    }

    function testUint() public {
        assertEq(valueTypes.u(), 123);
    }

    function testInt() public {
        assertEq(valueTypes.i(), -123);
    }

    function testAddress() public {
        assertEq(valueTypes.addr(), 0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5);
    }
}
