pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/QINToken.sol";
import "../contracts/crowdsale/QINCrowdsale.sol";

contract TestQINCrowdsaleUser {

  function testUserCountPostRegistration() {
    uint startTime = now + 100;
    uint endTime = now + 200;
    address wallet = 0x1234;
    QINToken qin = new QINToken();
    QINCrowdsale tcs = new QINCrowdsale(qin, startTime, endTime, 10, wallet);

    uint userCountBefore = tcs.registeredUserCount();
    tcs.updateRegisteredUserWhitelist(wallet, true);
    uint userCountAfter = tcs.registeredUserCount();
    Assert.equal(userCountBefore, 0, "Incorrect original user count.");
    Assert.equal(userCountAfter, 1, "Incorrect new user count.");
	}

  function testUserRegistration() {
    uint startTime = now + 100;
    uint endTime = now + 200;
    address wallet = 0x1234;
    QINToken qin = new QINToken();
    QINCrowdsale tcs = new QINCrowdsale(qin, startTime, endTime, 10, wallet);

    uint userCountBefore = tcs.registeredUserCount();
    tcs.updateRegisteredUserWhitelist(wallet, true);
    uint userCountAfter = tcs.registeredUserCount();
    Assert.equal(userCountBefore, 0, "Incorrect initial user count.");
    Assert.equal(userCountAfter, 1, "Incorrect new user count.");

    bool walletStatus = tcs.getUserRegistrationState(wallet);

    Assert.equal(walletStatus, true, "User was not registered.");
  }


}
