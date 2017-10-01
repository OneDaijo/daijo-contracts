pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/QINToken.sol";
import "../contracts/tokensale/QINTokenSale.sol";


contract TestQINTokenSale2 {

    function testUserCountPostRegistration() {
        uint startTime = now + 100;
        uint endTime = now + 200;
        address wallet = 0x1234;
        uint restrictedDays = 3;
        QINToken qin = new QINToken();
        QINTokenSale ts = new QINTokenSale(qin, startTime, endTime, restrictedDays, 10, wallet);

        uint userCountBefore = ts.registeredUserCount();
        ts.addToWhitelist(wallet);
        uint userCountAfter = ts.registeredUserCount();
        Assert.equal(userCountBefore, 0, "Incorrect original user count.");
        Assert.equal(userCountAfter, 1, "Incorrect new user count.");
    }

    function testGetUserRegistration() {
        uint startTime = now + 100;
        uint endTime = now + 200;
        address wallet = 0x1234;
        address wallet2 = 0x5678;
        uint restrictedDays = 3;
        QINToken qin = new QINToken();
        QINTokenSale ts = new QINTokenSale(qin, startTime, endTime, restrictedDays, 10, wallet);

        ts.addToWhitelist(wallet);

        bool walletStatus = ts.getUserRegistrationState(wallet);
        bool walletStatus2 = ts.getUserRegistrationState(wallet2);

        Assert.equal(walletStatus, true, "User was not registered.");
        Assert.equal(walletStatus2, false, "User was registered somehow");
    }

    function testSetRestrictedDays() {
        uint startTime = now + 100;
        uint endTime = now + 200;
        address wallet = 0x1234;
        uint restrictedDays = 3;
        QINToken qin = new QINToken();
        QINTokenSale ts = new QINTokenSale(qin, startTime, endTime, restrictedDays, 10, wallet);

        Assert.equal(ts.numRestrictedDays(), 3, "Incorrect initial number of restricted days.");
        ts.setRestrictedSaleDays(5);
        Assert.equal(ts.numRestrictedDays(), 5, "Incorrect modified number of restricted days.");
    }
}
