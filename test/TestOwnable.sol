pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/permissions/Ownable.sol";

/** @title Ownable Test
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 */
contract TestOwnable {

    // this tests that the deployed contract has an owner at all
    function testOwnerExists() {
        Ownable ownable = new Ownable();
        address owner = ownable.owner();

        Assert.isTrue(owner != 0x0, "Contract should have an owner.");
    }

    // this test covers changing ownership
    function testOwnerChangesAfterTransfer() {
        Ownable ownable = new Ownable();
        address newOwner = 0x123456789;
        ownable.transferOwnership(newOwner);
        address owner = ownable.owner();

        Assert.isTrue(owner == newOwner, "Owner should be changed after transfer.");
    }
    
}
