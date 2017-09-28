pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/QINToken.sol";
import "../contracts/crowdsale/QINCrowdsale.sol";


/** @title QIN Crowdsale Tests
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 */
contract TestQINCrowdsale3 {

    function testQINCrowdsaleTokenFallback() {
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
        qin.transfer(tcs, 100);
        bool funded = tcs.hasBeenSupplied();
        Assert.equal(funded, true, "tokenFallback was not called.");
    }

    //function testQINCrowdsaleSupportsToken() {
        //uint startTime = now + 100;
        //uint endTime = now + 200;
        //address wallet = 0x1234;
        //uint restrictedDays = 3;
        //QINToken qin = new QINToken();
        //QINCrowdsale tcs = new QINCrowdsale(
        //    qin,
        //    startTime,
        //    endTime,
        //    restrictedDays,
        //    10,
        //    wallet
        //);

        //bool support = tcs.supportsToken(qin);

        //Assert.equal(support, true, "supportsToken() is rejecting QIN.");
    //}

    function testQINCrowdsaleOwner() {
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

        Assert.equal(tcs.owner(), this, "Not the correct owner. ");
    }
}
