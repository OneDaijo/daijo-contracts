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

	// Returns USD/10^18
	function ethToUSD(uint input_wei) returns (uint usdEquivalent) {
		// Not sure why the line below causes an error.  Not sure how to do library self-reference...
		// return ConvertLib.convert(input_wei, 1);
		return input_wei;
	}

	// Inputs input_wei - amount of eth in amount_wei
	// This function returns values in QIN.
	function ethToQIN(uint input_wei) returns (uint qinEquivalent) {
		// Same as above.
		// return ConvertLib.ethToUSD(input_wei);
		return input_wei;
	}
}
