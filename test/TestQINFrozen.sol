pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/QINToken.sol";
import "../contracts/token/QINFrozen.sol";
import "../contracts/libs/SafeMath256.sol";


/** @title Frozen QIN Tests
 *  @author DaijoLabs <info@daijolabs.com>
 */
contract TestQINFrozen {
    using SafeMath256 for uint;

    uint decimalMultiplier = 10**18;

    function testQINFrozenInit() {
        uint releaseTime = now.add(1000);

        QINToken qin = new QINToken(true);

        QINFrozen freeze = new QINFrozen(qin, releaseTime);

        Assert.equal(freeze.releaseTime(), releaseTime, "Incorrect release time.");
        Assert.equal(freeze.frozenBalance(), 0, "Incorrect frozen balance.");
    }

    function testTransferToFrozenQIN() {
        uint releaseTime = now.add(1000);
        QINToken qin = new QINToken(true);
        QINFrozen freeze = new QINFrozen(qin, releaseTime);

        Assert.isFalse(freeze.frozen(), "Frozen before payment.");
        Assert.isTrue(qin.transfer(freeze, decimalMultiplier.mul(140000000)), "Transfer to freeze failed.");
        Assert.isTrue(freeze.frozen(), "Not frozen.");
        Assert.equal(qin.balanceOf(this), decimalMultiplier.mul(60000000), "Incorrect.");
        Assert.equal(qin.balanceOf(freeze), decimalMultiplier.mul(140000000), "Incorrect.");
    }

    function testQINFrozenOwner() {
        uint releaseTime = now.add(1000);
        QINToken qin = new QINToken(true);
        QINFrozen freeze = new QINFrozen(qin, releaseTime);

        Assert.equal(freeze.owner(), this, "Not the correct owner. ");
    }

    function testQINFrozenSupportsToken() {
        uint releaseTime = now.add(1000);
        QINToken qin = new QINToken(true);
        QINFrozen freeze = new QINFrozen(qin, releaseTime);

        bool support = freeze.supportsToken(qin);

        Assert.isTrue(support, "supportsToken() is rejecting QIN.");
    }

    function testReleaseFunction() {
        uint releaseTime = now.add(1000);
        QINToken qin = new QINToken(true);
        QINFrozen freeze = new QINFrozen(qin, releaseTime);

        qin.transfer(freeze, 140000000);

        freeze.setCurrentTime(now.add(1001));
        freeze.release(msg.sender);
        Assert.equal(qin.balanceOf(freeze), 0, "Frozen balance was not reset.");

    }

}
