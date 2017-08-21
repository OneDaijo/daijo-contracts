pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/QINFrozen.sol";
import "../contracts/token/QINToken.sol";

/** @title Frozen QIN Tests
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 */
contract TestQINFrozen is QINToken {

    function testQINFrozenInit() {
        uint releaseTime = now + 1000;
        QINFrozen freeze = new QINFrozen(releaseTime);

        Assert.equal(freeze.releaseTime(), releaseTime, "Incorrect release time.");
        Assert.equal(freeze.frozenBalance(), 0, "Incorrect frozen balance.");
    }

}
