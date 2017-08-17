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
    using SafeMath for uint256;

    uint decimalMultiplier = 10**18;

    //disabled temporarily - function is private
    //function testQINFrozenInitFromQINToken() {
    //    uint releaseTime = now + 1000;
    //    uint freezeAmount = decimalMultiplier.mul(200000000);
    //    QINToken qin = new QINToken();
    //    qin.freezeRemainingTokens(releaseTime, freezeAmount);
	//	address expected = this;
	//	address owner = qin.getFreezeOwner();

	//	Assert.equal(owner, expected, "Freeze has wrong owner.");
	//}

    //disabled temporarily - function is private
    //function testQINTokenIsTransferringToQINFrozen() {
    //    uint releaseTime = now + 1000;
    //    uint freezeAmount = decimalMultiplier.mul(200000000);
    //    QINToken qin = new QINToken();
    //    qin.freezeRemainingTokens(releaseTime, freezeAmount);

    //    Assert.equal(qin.balanceOf(qin.owner()), 0, "Incorrect amount of QIN sent.");
    //}

    function testQINFrozenInit() {
        uint releaseTime = now + 1000;
        QINFrozen freeze = new QINFrozen(releaseTime);

        Assert.equal(freeze.releaseTime(), releaseTime, "Incorrect release time.");
        Assert.equal(freeze.frozenBalance(), 0, "Incorrect frozen balance.");
    }

    function testTransferToFrozenQIN() {
        uint releaseTime = now + 1000;
        uint frozenBalance = decimalMultiplier.mul(20000);
        QINToken qin = new QINToken();
        QINFrozen freeze = new QINFrozen(releaseTime);

        qin.transfer(freeze, decimalMultiplier.mul(140000000));
        Assert.equal(qin.balanceOf(this), decimalMultiplier.mul(60000000), "Incorrect.");
        Assert.equal(qin.balanceOf(freeze), decimalMultiplier.mul(140000000), "Incorrect.");
    }

    //TODO: Fix this test
    //function testReleaseFunction() {
    //    uint releaseTime = now + 1000;
    //    uint frozenBalance = 200000000;
    //    QINToken qin = new QINToken();
    //    QINFrozen freeze = new QINFrozen(releaseTime, frozenBalance);

    //    qin.transfer(freeze, 140000000);

    //    bool frozen = freeze.frozen();
    //    Assert.isTrue(frozen, "Transfer did not trigger freeze.");

    //    freeze.release(this);
    //    Assert.equal(qin.balanceOf(freeze), 0, "Frozen balance was not reset.");

    //}

}
