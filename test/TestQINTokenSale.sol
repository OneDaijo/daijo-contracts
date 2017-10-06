pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/QINToken.sol";
import "../contracts/tokensale/QINTokenSale.sol";


/** @title QIN TokenSale Tests
 *  @author DaijoLabs <info@daijolabs.com>
 */
contract TestQINTokenSale {

    function testQINTokenSaleInit() {
        uint startTime = now + 100;
        uint endTime = now + 200;
        address wallet = 0x1234;
        uint restrictedDays = 3;
        QINToken qin = new QINToken(true);
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
        QINToken qin = new QINToken(true);
        qin.startTokenSale(
            startTime,
            endTime,
            restrictedDays,
            10,
            wallet
        );

        address owner = qin.getTokenSale().owner();

        Assert.equal(owner, this, "Incorrect owner.");
    }
}
