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
        QINToken qin = new QINToken();
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
        Assert.equal(funded, true, "tokenFallback was not called.");
    }

    //function testQINTokenSaleSupportsToken() {
        //uint startTime = now + 100;
        //uint endTime = now + 200;
        //address wallet = 0x1234;
        //uint restrictedDays = 3;
        //QINToken qin = new QINToken();
        //QINTokenSale ts = new QINTokenSale(
        //    qin,
        //    startTime,
        //    endTime,
        //    restrictedDays,
        //    10,
        //    wallet
        //);

        //bool support = ts.supportsToken(qin);

        //Assert.equal(support, true, "supportsToken() is rejecting QIN.");
    //}

    function testQINTokenSaleOwner() {
        uint startTime = now + 100;
        uint endTime = now + 200;
        address wallet = 0x1234;
        uint8 restrictedDays = 3;
        QINToken qin = new QINToken();
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
}
