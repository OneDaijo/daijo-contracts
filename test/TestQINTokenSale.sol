pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/QINToken.sol";
import "../contracts/tknsale/QINTokenSale.sol";


/** @title QIN TokenSale Tests
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 */
contract TestQINTokenSale {

    function testQINTokenSaleInit() {
        uint startTime = now + 100;
        uint endTime = now + 200;
        address wallet = 0x1234;
        uint restrictedDays = 3;
        QINToken qin = new QINToken();
        QINTokenSale ts = new QINTokenSale(
            qin,
            startTime,
            endTime,
            restrictedDays,
            10,
            wallet
        );
        Assert.equal(ts.startTime(), startTime, "Incorrect startTime.");
        Assert.equal(ts.endTime(), endTime, "Incorrect endTime.");
        Assert.equal(ts.rate(), 10, "Incorrect rate.");
        Assert.equal(ts.wallet(), wallet, "Incorrect wallet address.");
    }

    function testQINTokenSaleInitFromStartTokenSaleFunction() {
        uint startTime = now + 100;
        uint endTime = now + 200;
        address wallet = 0x1234;
        uint restrictedDays = 3;
        uint releaseTime = now + 1000;
        QINToken qin = new QINToken();
        qin.startTokenSale(
            startTime,
            endTime,
            restrictedDays,
            10,
            wallet,
            releaseTime
        );

        address owner = qin.getTokenSale().owner();

        Assert.equal(owner, this, "Incorrect owner.");
    }
}
