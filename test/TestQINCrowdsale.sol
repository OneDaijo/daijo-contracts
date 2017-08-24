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
		address expected = this;
		
		Assert.equal(owner, expected, "Incorrect owner.");
	}

	// TODO(ndeng): This test doesn't work becuase the tcs expects the sender to
	// be the token itself, so when it receives a tokenFallback, it attempts to
	// check its own balance, which fails because there's no balanceOf method
	// defined for this test contract.  One way around this is to change the
	// constructor to take the QINToken contract explicitly rather than assuming
	// the sender is the QINToken.  We could also redesign the test.
	
	// function testQINCrowdsaleTokenFallback() {
	// 	bytes memory empty;
	// 	uint startBlock = block.number + 1;
	// 	uint endBlock = block.number + 5;
	// 	address wallet = 0x1234;
	// 	QINCrowdsale tcs = new QINCrowdsale(startBlock, endBlock, 10, wallet);
	// 	tcs.tokenFallback(wallet, 100, empty);
	// 	bool funded = tcs.hasBeenFunded();
	// 	Assert.equal(funded, true, "tokenFallback was not called.");
	// }

	function testQINCrowdsaleSupportsToken() {
		uint startBlock = block.number + 1;
		uint endBlock = block.number + 5;
		address wallet = 0x1234;
		QINToken qin = new QINToken();
		QINCrowdsale tcs = new QINCrowdsale(startBlock, endBlock, 10, wallet);

		// The contract thinks that the creator contract is the QINToken, so we
		// expect that it will support this contract's address as a token. Similar
		// to the above, maybe this should be changed.
		bool support = tcs.supportsToken(this);
		
		Assert.equal(support, true, "supportsToken() is rejecting QIN.");
    }

	function testQINCrowdsaleOwner() {
		uint startBlock = block.number + 1;
		uint endBlock = block.number + 5;
		address wallet = 0x1234;
		QINCrowdsale tcs = new QINCrowdsale(startBlock, endBlock, 10, wallet);

		// Expect the creator to be the owner.
		address expected = this;
		Assert.equal(tcs.owner(), this, "Not the correct owner. ");
    }
}
