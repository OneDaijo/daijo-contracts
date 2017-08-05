pragma solidity ^0.4.13;

/** @title ConvertLib
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 *  @notice source: truffle framework
 */
library ConvertLib {
	function convert(uint amount, uint conversionRate) returns (uint convertedAmount)
	{
		return amount * conversionRate;
	}
}
