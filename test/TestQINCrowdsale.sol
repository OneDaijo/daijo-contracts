pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/QINToken.sol";
import "../contracts/crowdsale/QINCrowdsale.sol";


/** @title QIN Crowdsale Tests
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 */
contract TestQINCrowdsale {

    function testQINCrowdsaleInit() {
        uint startTime = now + 100;
        uint endTime = now + 200;
        address wallet = 0x1234;
        uint restrictedDays = 3;
        QINToken qin = new QINToken();
        QINCrowdsale tcs = new QINCrowdsale(
            qin,
            startTime,
            endTime,
            restrictedDays,
            10,
            wallet
        );
        Assert.equal(tcs.startTime(), startTime, "Incorrect startTime.");
        Assert.equal(tcs.endTime(), endTime, "Incorrect endTime.");
        Assert.equal(tcs.rate(), 10, "Incorrect rate.");
        Assert.equal(tcs.wallet(), wallet, "Incorrect wallet address.");
    }

    function testQINCrowdsaleInitFromStartCrowdsaleFunction() {
        uint startTime = now + 100;
        uint endTime = now + 200;
        address wallet = 0x1234;
        uint restrictedDays = 3;
        uint releaseTime = now + 1000;
        QINToken qin = new QINToken();
        qin.startCrowdsale(
            startTime,
            endTime,
            restrictedDays,
            10,
            wallet,
            releaseTime
        );

        address owner = qin.getCrowdsale().owner();

        Assert.equal(owner, this, "Incorrect owner.");
    }
}
