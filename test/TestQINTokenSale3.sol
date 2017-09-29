pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/QINToken.sol";
import "../contracts/tknsale/QINTokenSale.sol";


/** @title QIN TokenSale Tests
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 */
contract TestQINTokenSale3 {

    function testSetRestrictedDays() {
        uint startTime = now + 100;
        uint endTime = now + 200;
        address wallet = 0x1234;
        uint restrictedDays = 3;
        QINToken qin = new QINToken();
        QINCrowdsale tcs = new QINCrowdsale(qin, startTime, endTime, restrictedDays, 10, wallet);

        Assert.equal(tcs.numRestrictedDays(), 3, "Incorrect initial number of restricted days.");
        tcs.setRestrictedSaleDays(5);
        Assert.equal(tcs.numRestrictedDays(), 5, "Incorrect modified number of restricted days.");
    }

    function testQINCrowdsaleTokenFallback() {
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
        qin.transfer(ts, 100);
        bool funded = ts.hasBeenSupplied();
        Assert.equal(funded, true, "tokenFallback was not called.");
    }

    function testQINCrowdsaleSupportsToken() {
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

        bool support = tcs.supportsToken(qin);

        Assert.equal(support, true, "supportsToken() is rejecting QIN.");
    }
}
