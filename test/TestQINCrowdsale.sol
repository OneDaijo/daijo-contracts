pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "../contracts/crowdsale/QINCrowdsale.sol";

/** @title QIN Crowdsale Tests
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 */
contract TestQINCrowdsale {

	function testQINCrowdsaleInit() {
        uint startBlock = block.number + 1;
        uint endBlock = block.number + 5;
		QINCrowdsale tcs = new QINCrowdsale(startBlock, endBlock, 10, 0x1234);
		Assert.equal(tcs.startBlock(), startBlock, "Incorrect startblock.");
	}
}
