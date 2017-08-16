pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/libs/ConvertLib.sol";

/** @title ConvertLib Tests
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 */
contract TestConvertLib {

	function testConvertFunction() {
		uint amount = 10; // 10 ETH
		uint conversionRate = 2; // you get 2 of 'X' Token per ETH

		uint expected = 20; // expect 10 ETH = 20 'X' Token
		Assert.equal(ConvertLib.convert(amount, conversionRate), expected, "Value does not convert correctly.");
	}
}
