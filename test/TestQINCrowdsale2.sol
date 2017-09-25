pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/QINToken.sol";
import "../contracts/crowdsale/QINCrowdsale.sol";


contract TestQINCrowdsale2 {

<<<<<<< HEAD
  function testUserCountPostRegistration() {
    uint startTime = now + 100;
		uint endTime = now + 200;
		address wallet = 0x1234;
		uint restrictedDays = 3;
		QINToken qin = new QINToken();
		QINCrowdsale tcs = new QINCrowdsale(qin, startTime, endTime, restrictedDays, 10, wallet);

    uint userCountBefore = tcs.registeredUserCount();
    tcs.addToWhitelist(wallet);
    uint userCountAfter = tcs.registeredUserCount();
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
		QINCrowdsale tcs = new QINCrowdsale(qin, startTime, endTime, restrictedDays, 10, wallet);

    tcs.addToWhitelist(wallet);

    bool walletStatus = tcs.getUserRegistrationState(wallet);
    bool walletStatus2 = tcs.getUserRegistrationState(wallet2);

    Assert.equal(walletStatus, true, "User was not registered.");
    Assert.equal(walletStatus2, false, "User was registered somehow");
  }

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
=======
    function testUserCountPostRegistration() {
        uint startTime = now + 100;
        uint endTime = now + 200;
        address wallet = 0x1234;
        uint restrictedDays = 3;
        QINToken qin = new QINToken();
        QINCrowdsale tcs = new QINCrowdsale(qin, startTime, endTime, restrictedDays, 10, wallet);

        uint userCountBefore = tcs.registeredUserCount();
        tcs.updateRegisteredUserWhitelist(wallet, true);
        uint userCountAfter = tcs.registeredUserCount();
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
        QINCrowdsale tcs = new QINCrowdsale(qin, startTime, endTime, restrictedDays, 10, wallet);

        tcs.updateRegisteredUserWhitelist(wallet, true);

        bool walletStatus = tcs.getUserRegistrationState(wallet);
        bool walletStatus2 = tcs.getUserRegistrationState(wallet2);

        Assert.equal(walletStatus, true, "User was not registered.");
        Assert.equal(walletStatus2, false, "User was registered somehow");
    }

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
>>>>>>> master
}
