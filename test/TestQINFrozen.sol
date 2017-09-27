pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/QINToken.sol";
import "../contracts/token/QINFrozen.sol";
import "../contracts/libs/SafeMath.sol";


/** @title Frozen QIN Tests
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 */
contract TestQINFrozen {
    /*using SafeMath for uint;

    uint decimalMultiplier = 10**18;*/

    // TODO(thiefinparis): testing these internal functions (if we even want to do this) will requre special
    // test contracts to provide hooks into these internal methods.

    // // Note: freezeRemainingTokens() function is private, remove modifier temporarily to perform test
    // function testQINFrozenInitFromQINToken() {
    //     uint releaseTime = now + 1000;
    //     uint freezeAmount = decimalMultiplier.mul(200000000);
    //     QINToken qin = new QINToken();
    //     qin.freezeRemainingTokens(releaseTime, freezeAmount);
    //     address expected = this;
    //     address owner = qin.getQINFrozen().owner();

    //     Assert.equal(owner, expected, "Freeze has wrong owner.");
    // }

    // // Note: freezeRemainingTokens() function is private, remove modifier temporarily to perform test
    // function testQINTokenIsTransferringToQINFrozen() {
    //     uint releaseTime = now + 1000;
    //     uint freezeAmount = decimalMultiplier.mul(200000000);
    //     QINToken qin = new QINToken();
    //     qin.freezeRemainingTokens(releaseTime, freezeAmount);

    //     Assert.equal(qin.balanceOf(qin.owner()), 0, "Incorrect amount of QIN sent.");
    // }

    /*function testQINFrozenInit() {
        uint releaseTime = now + 1000;

        QINToken qin = new QINToken();

        QINFrozen freeze = new QINFrozen(qin, releaseTime);

        Assert.equal(freeze.releaseTime(), releaseTime, "Incorrect release time.");
        Assert.equal(freeze.frozenBalance(), 0, "Incorrect frozen balance.");
    }*/

    /*function testTransferToFrozenQIN() {
        uint releaseTime = now + 1000;
        QINToken qin = new QINToken();
        QINFrozen freeze = new QINFrozen(qin, releaseTime);

        Assert.isFalse(freeze.frozen(), "Frozen before payment.");
        Assert.isTrue(qin.transfer(freeze, decimalMultiplier.mul(140000000)), "Transfer to freeze failed.");
        Assert.isTrue(freeze.frozen(), "Not frozen.");
        Assert.equal(qin.balanceOf(this), decimalMultiplier.mul(60000000), "Incorrect.");
        Assert.equal(qin.balanceOf(freeze), decimalMultiplier.mul(140000000), "Incorrect.");
    }*/

    /*function testQINFrozenOwner() {
        uint releaseTime = now + 1000;
        QINToken qin = new QINToken();
        QINFrozen freeze = new QINFrozen(qin, releaseTime);

        Assert.equal(freeze.owner(), this, "Not the correct owner. ");
    }*/

    /*function testQINFrozenSupportsToken() {
        uint releaseTime = now + 1000;
        QINToken qin = new QINToken();
        QINFrozen freeze = new QINFrozen(qin, releaseTime);

        bool support = freeze.supportsToken(qin);

        Assert.equal(support, true, "supportsToken() is rejecting QIN.");
    }*/

    // TODO(thiefinparis): Like the tests at the top, triggering the release will require hooks into
    // the internal contract state to modify the time to allow the payment and release to occur in
    // the same solidity transaction.

    //function testReleaseFunction() {
    //    uint releaseTime = now + 1000;
    //    uint frozenBalance = 200000000;
    //    QINToken qin = new QINToken();
    //    QINFrozen freeze = new QINFrozen(qin, releaseTime);

    //    qin.transfer(freeze, 140000000);

    //    freeze.release(msg.sender);
    //    Assert.equal(qin.balanceOf(freeze), 0, "Frozen balance was not reset.");

    //}

}
