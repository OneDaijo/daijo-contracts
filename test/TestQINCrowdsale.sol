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
		uint releaseTime = now + 1000;
		QINCrowdsale tcs = new QINCrowdsale(startBlock, endBlock, 10, wallet);
		Assert.equal(tcs.startBlock(), startBlock, "Incorrect startblock.");
		Assert.equal(tcs.endBlock(), endBlock, "Incorrect endblock.");
		Assert.equal(tcs.rate(), 10, "Incorrect rate.");
		Assert.equal(tcs.wallet(), wallet, "Incorrect wallet address.");
	}
}
