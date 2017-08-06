/** @title ConvertLib
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 *  @notice source: truffle framework
 */
 
pragma solidity ^0.4.13;


library ConvertLib {
    function convert(uint amount, uint conversionRate) returns (uint convertedAmount) {
        return amount * conversionRate;
    }

    // Returns USD/10^18
    function ethToUSD(uint inputWei) returns (uint usdEquivalent) {
        // Not sure why the line below causes an error.  Not sure how to do library self-reference...
        // return ConvertLib.convert(inputWei, 1);
        return inputWei;
    }

    // Inputs inputWei - amount of eth in amount_wei
    // This function returns values in QIN.
    function ethToQIN(uint inputWei) returns (uint qinEquivalent) {
        // Same as above.
        // return ConvertLib.ethToUSD(inputWei);
        return inputWei;
    }
}
