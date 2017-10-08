pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/QINToken.sol";
import "../contracts/tokensale/QINTokenSale.sol";


/** @title QIN TokenSale Tests
 *  @author DaijoLabs <info@daijolabs.com>
 */
contract TestQINTokenSale3 {

    function testQINTokenSaleTokenFallback() {
        uint startTime = now + 100;
        uint endTime = now + 200;
        address wallet = 0x1234;
        uint8 restrictedDays = 3;
        QINToken qin = new QINToken(true);
        QINTokenSale ts = new QINTokenSale(
            qin,
            startTime,
            endTime,
            restrictedDays,
            10,
            wallet
        );
        qin.transfer(ts, 100);
        bool funded = ts.hasBeenSupplied();
        Assert.isTrue(funded, "tokenFallback was not called.");
    }

    //function testQINTokenSaleSupportsToken() {
        //uint startTime = now + 100;
        //uint endTime = now + 200;
        //address wallet = 0x1234;
        //uint restrictedDays = 3;
        //QINToken qin = new QINToken(true);
        //QINTokenSale ts = new QINTokenSale(
        //    qin,
        //    startTime,
        //    endTime,
        //    restrictedDays,
        //    10,
        //    wallet
        //);

        //bool support = ts.supportsToken(qin);

        //Assert.isTrue(support, "supportsToken() is rejecting QIN.");
    //}

    function testQINTokenSaleOwner() {
        uint startTime = now + 100;
        uint endTime = now + 200;
        address wallet = 0x1234;
        uint8 restrictedDays = 3;
        QINToken qin = new QINToken(true);
        QINTokenSale ts = new QINTokenSale(
            qin,
            startTime,
            endTime,
            restrictedDays,
            10,
            wallet
        );

        Assert.equal(ts.owner(), this, "Not the correct owner. ");
    }

    function testTokenSaleTimeStateTransitions() {
        uint startTime = now + 1 days;
        uint endTime = now + 5 days;
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

        QINTokenSale ts = qin.getTokenSale();

        // Using isTrue because equal does not compile with enum types.
        Assert.isTrue(ts.getState() == QINTokenSale.State.BeforeSale, "BeforeSale expected");
        ts.setCurrentTime(startTime);
        Assert.isTrue(ts.getState() == QINTokenSale.State.SaleRestrictedDay, "SaleRestrictedDay expected");
        ts.setCurrentTime(startTime + 3 days);
        Assert.isTrue(ts.getState() == QINTokenSale.State.SaleFFA, "SaleFFA expected");
        ts.setCurrentTime(endTime);
        Assert.isTrue(ts.getState() == QINTokenSale.State.SaleComplete, "SaleComplete expected");
    }
}
