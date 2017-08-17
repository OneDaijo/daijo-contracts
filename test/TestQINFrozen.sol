pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/QINFrozen.sol";

/** @title Frozen QIN Tests
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 */
contract TestQINFrozen {

    function testQINFrozenInit() {
        uint releaseTime = now + 1000;
        uint frozenBalance = 20000;
        QINFrozen freeze = new QINFrozen(releaseTime, frozenBalance);

        Assert.equal(freeze.releaseTime(), releaseTime, "Incorrect release time.");
        Assert.equal(freeze.frozenBalance(), frozenBalance, "Incorrect frozen balance.");
    }

}
