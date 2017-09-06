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
		QINToken qin = new QINToken();
		QINCrowdsale tcs = new QINCrowdsale(qin, startTime, endTime, 10, wallet);
		Assert.equal(tcs.startTime(), startTime, "Incorrect startTime.");
		Assert.equal(tcs.endTime(), endTime, "Incorrect endTime.");
		Assert.equal(tcs.rate(), 10, "Incorrect rate.");
		Assert.equal(tcs.wallet(), wallet, "Incorrect wallet address.");
	}

	function testQINCrowdsaleInitFromStartCrowdsaleFunction() {
		uint startTime = now + 100;
		uint endTime = now + 200;
		address wallet = 0x1234;
		uint releaseTime = now + 1000;
		QINToken qin = new QINToken();
		qin.startCrowdsale(startTime, endTime, 10, wallet, releaseTime);

		address owner = qin.getCrowdsale().owner();
		address expected = this;

		Assert.equal(owner, expected, "Incorrect owner.");
	}

	function testQINCrowdsaleTokenFallback() {
		uint startTime = now + 100;
		uint endTime = now + 200;
		address wallet = 0x1234;
		QINToken qin = new QINToken();
		QINCrowdsale tcs = new QINCrowdsale(qin, startTime, endTime, 10, wallet);
		qin.transfer(tcs, 100);
		bool funded = tcs.hasBeenSupplied();
		Assert.equal(funded, true, "tokenFallback was not called.");
	}

	function testQINCrowdsaleSupportsToken() {
		uint startTime = now + 100;
		uint endTime = now + 200;
		address wallet = 0x1234;
		QINToken qin = new QINToken();
		QINCrowdsale tcs = new QINCrowdsale(qin, startTime, endTime, 10, wallet);

		bool support = tcs.supportsToken(qin);

		Assert.equal(support, true, "supportsToken() is rejecting QIN.");
	}

	function testQINCrowdsaleOwner() {
		uint startTime = now + 100;
		uint endTime = now + 200;
		address wallet = 0x1234;
		QINToken qin = new QINToken();
		QINCrowdsale tcs = new QINCrowdsale(qin, startTime, endTime, 10, wallet);

		// Expect the creator to be the owner.
		address expected = this;
		Assert.equal(tcs.owner(), this, "Not the correct owner. ");
  }

	// TODO: Figure out 'before all' errors. No reason these tests shouldn't work,
	// but are not functioning properly due to previously mentioned error.

	//function testUserCountAfterRegistration() {
	//	uint startTime = now + 100;
	//	uint endTime = now + 200;
	//	address wallet = 0x1234;
	//	QINToken qin = new QINToken();
	//	QINCrowdsale tcs = new QINCrowdsale(qin, startTime, endTime, 10, wallet);

	//	tcs.updateRegisteredUserWhitelist(wallet, true);
	//	uint userCountAfter = tcs.registeredUserCount();
	//	Assert.equal(userCountAfter, 1, "Incorrect new user count.");
	//}

	//function testUserRegistration() {
	//	uint startTime = now + 100;
	//	uint endTime = now + 200;
	//	address wallet = 0x1234;
	//	QINToken qin = new QINToken();
	//	QINCrowdsale tcs = new QINCrowdsale(qin, startTime, endTime, 10, wallet);


		// There are some really weird interactions here.
		//uint userCountBefore = tcs.registeredUserCount();
		//tcs.updateRegisteredUserWhitelist(wallet, true);
		//uint userCountAfter = tcs.registeredUserCount();
		//Assert.equal(userCountBefore, 0, "Incorrect initial user count.");
		//Assert.equal(userCountAfter, 1, "Incorrect new user count.");

		//bool test2 = tcs.getUserRegistrationState(wallet);

		// causing hook error. TODO: research how to pull value from mapping
		//Assert.equal(test2, true, "User was not registered.");
	//}

	//function testGetState() {
	//	uint startTime = now + 100;
	//	uint endTime = now + 200;
	//	address wallet = 0x1234;
	//	QINToken qin = new QINToken();
	//	QINCrowdsale tcs = new QINCrowdsale(qin, startTime, endTime, 10, wallet);

	//	Assert.equal(tcs.getState(), State.BeforeSale, "Incorrect state.");
	//}

	// TODO: Test new daily limit features. Contingent upon figuring out
	// how to artificially advance time in test.
}
