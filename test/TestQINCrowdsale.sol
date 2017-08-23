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
		QINCrowdsale tcs = new QINCrowdsale(startBlock, endBlock, 10, wallet);
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

		address owner = qin.getTCSOwner();
		address expected = 0x1234;

		Assert.equal(owner, expected, "Incorrect owner.");
	}

	function testQINCrowdsaleTokenFallback() {
		bytes memory empty;
		uint startBlock = block.number + 1;
    	uint endBlock = block.number + 5;
		address wallet = 0x1234;
		QINCrowdsale tcs = new QINCrowdsale(startBlock, endBlock, 10, wallet);
		tcs.tokenFallback(wallet, 100, empty);
		bool funded = tcs.hasBeenFunded();
		Assert.equal(funded, true, "tokenFallback was not called.");
	}

	function testQINCrowdsaleSupportsToken() {
		uint startBlock = block.number + 1;
    	uint endBlock = block.number + 5;
		address wallet = 0x1234;
		QINToken qin = new QINToken();
        QINCrowdsale tcs = new QINCrowdsale(startBlock, endBlock, 10, wallet);

        bool support = tcs.supportsToken(address(qin));

        Assert.equal(support, true, "supportsToken() is rejecting QIN.");
    }

	function testQINCrowdsaleOwner() {
		uint startBlock = block.number + 1;
    	uint endBlock = block.number + 5;
		address wallet = 0x1234;
        QINCrowdsale tcs = new QINCrowdsale(startBlock, endBlock, 10, wallet);
		address expected = 0x1234;

        Assert.equal(tcs.owner(), 0x1234, "Not the correct owner. ");
    }
}
