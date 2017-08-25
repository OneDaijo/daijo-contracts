pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/crowdsale/QINCrowdsale.sol";

/** @title QIN Crowdsale Tests
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 */
contract TestQINCrowdsale {

	function testQINCrowdsaleInit() {
		uint startBlock = block.number + 1;
		uint endBlock = block.number + 5;
		address wallet = 0x1234;
		QINToken qin = new QINToken();
		QINCrowdsale tcs = new QINCrowdsale(qin, startBlock, endBlock, 10, wallet);
		Assert.equal(tcs.startBlock(), startBlock, "Incorrect startblock.");
		Assert.equal(tcs.endBlock(), endBlock, "Incorrect endblock.");
		Assert.equal(tcs.rate(), 10, "Incorrect rate.");
		Assert.equal(tcs.wallet(), wallet, "Incorrect wallet address.");
	}

	function testQINCrowdsaleInitFromStartCrowdsaleFunction() {
		uint startBlock = block.number + 1;
		uint endBlock = block.number + 5;
		address wallet = 0x1234;
		uint releaseTime = now + 1000;
		QINToken qin = new QINToken();
		qin.startCrowdsale(startBlock, endBlock, 10, wallet, releaseTime);

		address owner = qin.getCrowdsale().owner();
		address expected = this;
		
		Assert.equal(owner, expected, "Incorrect owner.");
	}

	function testQINCrowdsaleTokenFallback() {
		uint startBlock = block.number + 1;
		uint endBlock = block.number + 5;
		address wallet = 0x1234;
		QINToken qin = new QINToken();
		QINCrowdsale tcs = new QINCrowdsale(qin, startBlock, endBlock, 10, wallet);
		qin.transfer(tcs, 100);
		bool funded = tcs.hasBeenFunded();
		Assert.equal(funded, true, "tokenFallback was not called.");
	}

	function testQINCrowdsaleSupportsToken() {
		uint startBlock = block.number + 1;
		uint endBlock = block.number + 5;
		address wallet = 0x1234;
		QINToken qin = new QINToken();
		QINCrowdsale tcs = new QINCrowdsale(qin, startBlock, endBlock, 10, wallet);

		bool support = tcs.supportsToken(qin);
		
		Assert.equal(support, true, "supportsToken() is rejecting QIN.");
    }

	function testQINCrowdsaleOwner() {
		uint startBlock = block.number + 1;
		uint endBlock = block.number + 5;
		address wallet = 0x1234;
		QINToken qin = new QINToken();
		QINCrowdsale tcs = new QINCrowdsale(qin, startBlock, endBlock, 10, wallet);

		// Expect the creator to be the owner.
		address expected = this;
		Assert.equal(tcs.owner(), this, "Not the correct owner. ");
    }
}
