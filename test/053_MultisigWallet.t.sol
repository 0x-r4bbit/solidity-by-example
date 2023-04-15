// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "../src/053_MultisigWallet.sol";

contract MultisigWalletTest is Test {

  MultisigWallet public multisigWallet;

  event Submit(uint indexed txId);
  event Approve(address indexed owner, uint indexed txId);
  event Revoke(address indexed owner, uint indexed txId);
  event Execute(uint indexed txId);

  function setUp() public {
  }

  function testFail_When_NoOwners() public {
    address[] memory owners;
    multisigWallet = new MultisigWallet(owners, 1);
  }

  function testFail_When_InvalidRequired() public {
    address[] memory owners = new address[](1);
    owners[0] = makeAddr("alice");
    multisigWallet = new MultisigWallet(owners, 0);
  }

  function testFail_When_NotEnoughOwners() public {
    address[] memory owners = new address[](2);

    owners[0] = makeAddr("alice");
    owners[1] = makeAddr("bob");

    multisigWallet = new MultisigWallet(owners, 3);
  }

  function testFail_When_OwnerHasZeroAddress() public {
    address[] memory owners = new address[](1);
    owners[0] = address(0) ;
    multisigWallet = new MultisigWallet(owners, 1);
  }

  function testFail_When_AlreadyOwner() public {
    address[] memory owners = new address[](2);
    address alice = makeAddr("alice");

    owners[0] = alice;
    owners[1] = alice;

    multisigWallet = new MultisigWallet(owners, 1);
  }

  function testFail_When_SubmitAndNotOwner() public {
    (, , , MultisigWallet multisig) = _setupMultisig(2);

    address notOwner = makeAddr("notOwner");
    address receiver = makeAddr("receiver");
    bytes memory data;

    vm.prank(notOwner);
    multisig.submit(receiver, 1 ether, data);
  }

  function testFail_When_SubmitAndReceiverHasZeroAddress() public {
    (address alice, , , MultisigWallet multisig) = _setupMultisig(2);

    address receiver = address(0); 
    bytes memory data;

    vm.prank(alice);
    multisig.submit(receiver, 1 ether, data);
  }

  function testSubmit() public {
    (address alice, , , MultisigWallet multisig) = _setupMultisig(2);

    address receiver = makeAddr("receiver");
    bytes memory data;

    vm.expectEmit(true, false, false, true);
    emit Submit(0);

    vm.prank(alice);
    multisig.submit(receiver, 1 ether, data);

    (address addr, uint val, bytes memory dat, bool executed) = multisig.transactions(0);
    assertEq(addr, receiver);
    assertEq(val, 1 ether);
    assertEq(dat, data);
    assertEq(executed, false);
  }

  function testFail_When_RevokeAndNotOwner() public {
    (, , , MultisigWallet multisig) = _setupMultisig(2);

    address notOwner = makeAddr("notOwner");

    vm.prank(notOwner);
    multisig.revoke(0);
  }

  function testFail_When_RevokeAndTxDoesNotExist() public {
    (address alice, , , MultisigWallet multisig) = _setupMultisig(2);
    vm.prank(alice);
    multisig.revoke(0);
  }

  function testFail_When_RevokeAndTxAlreadyExecuted() public {
    (address alice, address bob, , MultisigWallet multisig) = _setupMultisig(2);
    vm.deal(alice, 1 ether);

    address receiver = makeAddr("receiver");
    bytes memory data;

    // submit transaction
    vm.prank(alice);
    multisig.submit{value: 1 ether}(receiver, 1 ether, data);

    vm.expectEmit(true, true, false, true);
    emit Approve(alice, 0);
    // approve transaction
    vm.prank(alice);
    multisig.approve(0);

    vm.expectEmit(true, true, false, true);
    emit Approve(bob, 0);
    vm.prank(bob);
    multisig.approve(0);

    // execute transaction
    multisig.execute(0);

    // attempt to revoke transaction
    vm.prank(alice);
    multisig.revoke(0);
  }

  function testFail_When_RevokeTransactionNotApproved() public {
    (address alice, , , MultisigWallet multisig) = _setupMultisig(2);
    vm.deal(alice, 1 ether);

    address receiver = makeAddr("receiver");
    bytes memory data;

    // submit transaction
    vm.prank(alice);
    multisig.submit(receiver, 1 ether, data);

    // attempt to revoke transaction
    vm.prank(alice);
    multisig.revoke(0);
  }

  function testRevoke() public {
    (address alice, , , MultisigWallet multisig) = _setupMultisig(2);
    vm.deal(alice, 1 ether);

    address receiver = makeAddr("receiver");
    bytes memory data;

    // submit transaction
    vm.prank(alice);
    multisig.submit(receiver, 1 ether, data);

    vm.expectEmit(true, true, false, true);
    emit Approve(alice, 0);
    vm.prank(alice);
    multisig.approve(0);

    vm.expectEmit(true, true, false, true);
    emit Revoke(alice, 0);
    vm.prank(alice);
    multisig.revoke(0);
  }

  function testFail_When_ApproveAndNotOwner() public {
    (, , , MultisigWallet multisig) = _setupMultisig(2);

    address notOwner = makeAddr("notOwner");
    vm.prank(notOwner);
    multisig.approve(0);
  }

  function testFail_When_ApproveAndTransactionDoesNotExist() public {
    (address alice, , , MultisigWallet multisig) = _setupMultisig(2);
    vm.prank(alice);
    multisig.approve(0);
  }

  function testFail_When_ApproveAndTransactionAlreadyApproved() public {
    (address alice, , , MultisigWallet multisig) = _setupMultisig(2);

    address receiver = makeAddr("receiver");
    bytes memory data;

    // submit transaction
    vm.prank(alice);
    multisig.submit(receiver, 1 ether, data);

    vm.expectEmit(true, true, false, true);
    emit Approve(alice, 0);

    vm.prank(alice);
    multisig.approve(0);
    vm.prank(alice);
    multisig.approve(0);
  }

  function testFail_When_ApproveAndTxAlreadyExecuted() public {
    (address alice, address bob, address eve, MultisigWallet multisig) = _setupMultisig(2);
    vm.deal(alice, 1 ether);

    address receiver = makeAddr("receiver");
    bytes memory data;

    // submit transaction
    vm.prank(alice);
    multisig.submit{value: 1 ether}(receiver, 1 ether, data);

    // eve approves transaction
    vm.expectEmit(true, true, false, true);
    emit Approve(eve, 0);
    vm.prank(eve);
    multisig.approve(0);

    // bob approves transaction
    vm.expectEmit(true, true, false, true);
    emit Approve(bob, 0);
    vm.prank(bob);
    multisig.approve(0);

    // execute transaction
    multisig.execute(0);

    // alice wants to approve transaction 
    vm.prank(alice);
    multisig.approve(0);
  }

  function testApprove() public {
    (address alice, , , MultisigWallet multisig) = _setupMultisig(2);
    vm.deal(alice, 1 ether);

    address receiver = makeAddr("receiver");
    bytes memory data;

    // submit transaction
    vm.prank(alice);
    multisig.submit{value: 1 ether}(receiver, 1 ether, data);

    vm.expectEmit(true, true, false, true);
    emit Approve(alice, 0);
    vm.prank(alice);
    multisig.approve(0);
  }

  function testFail_When_ExecuteAndTransactionDoesNotExist() public {
    (address alice, , , MultisigWallet multisig) = _setupMultisig(2);
    vm.prank(alice);
    multisig.execute(0);
  }

  function testFail_When_ExecuteAndTxAlreadyExecuted() public {
    (address alice, address bob, address eve, MultisigWallet multisig) = _setupMultisig(2);
    vm.deal(alice, 1 ether);

    address receiver = makeAddr("receiver");
    bytes memory data;

    // submit transaction
    vm.prank(alice);
    multisig.submit{value: 1 ether}(receiver, 1 ether, data);

    // eve approves transaction
    vm.expectEmit(true, true, false, true);
    emit Approve(eve, 0);
    vm.prank(eve);
    multisig.approve(0);

    // bob approves transaction
    vm.expectEmit(true, true, false, true);
    emit Approve(bob, 0);
    vm.prank(bob);
    multisig.approve(0);

    // execute transaction
    multisig.execute(0);
    multisig.execute(0);
  }

  function testFail_When_ExecuteAndNotEnoughApprovals() public {
    (address alice, address bob, , MultisigWallet multisig) = _setupMultisig(2);
    vm.deal(alice, 1 ether);

    address receiver = makeAddr("receiver");
    bytes memory data;

    // submit transaction
    vm.prank(alice);
    multisig.submit{value: 1 ether}(receiver, 1 ether, data);

    // bob approves transaction
    vm.expectEmit(true, true, false, true);
    emit Approve(bob, 0);
    vm.prank(bob);
    multisig.approve(0);

    // executes transaction but needs two approvals
    multisig.execute(0);
  }

  function testExecute() public {
    (address alice, address bob, address eve, MultisigWallet multisig) = _setupMultisig(3);
    vm.deal(alice, 1 ether);

    address receiver = makeAddr("receiver");
    bytes memory data;

    // submit transaction
    vm.prank(alice);
    multisig.submit{value: 1 ether}(receiver, 1 ether, data);

    // alice approves transaction
    vm.expectEmit(true, true, false, true);
    emit Approve(alice, 0);
    vm.prank(alice);
    multisig.approve(0);

    // bob approves transaction
    vm.expectEmit(true, true, false, true);
    emit Approve(bob, 0);
    vm.prank(bob);
    multisig.approve(0);

    // eve approves transaction
    vm.expectEmit(true, true, false, true);
    emit Approve(eve, 0);
    vm.prank(eve);
    multisig.approve(0);

    vm.expectEmit(true, false, false, true);
    emit Execute(0);
    multisig.execute(0);

    (address addr, uint val, bytes memory dat, bool executed) = multisig.transactions(0);
    assertEq(addr, receiver);
    assertEq(val, 1 ether);
    assertEq(dat, data);
    assertEq(executed, true);
  }

  function _setupMultisig(uint _required) internal returns (address alice, address bob, address eve, MultisigWallet multisig){
    address[] memory owners = new address[](3);
    alice = makeAddr("alice");
    bob = makeAddr("bob");
    eve = makeAddr("eve");

    owners[0] = alice;
    owners[1] = bob; 
    owners[2] = eve; 

    multisig = new MultisigWallet(owners, _required);
  }
}
