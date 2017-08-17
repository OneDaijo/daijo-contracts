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
		QINCrowdsale tcs = new QINCrowdsale(startBlock, endBlock, 10, 0x1234);
		Assert.equal(tcs.startBlock(), startBlock, "Incorrect startblock.");
		Assert.equal(tcs.endBlock(), endBlock, "Incorrect endblock.");
		Assert.equal(tcs.rate(), 10, "Incorrect rate.");
		Assert.equal(tcs.wallet(), 0x1234, "Incorrect waller address.");
	}

	//  function testBuyQINTokens() {
	//	  uint startBlock = block.number + 1;
    //    uint endBlock = block.number + 5;
	//	  INCrowdsale tcs = QINCrowdsale(startBlock, endBlock, 10, 0x1234);
	// }

}
