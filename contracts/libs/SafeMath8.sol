pragma solidity ^0.4.13;


 /** @title SafeMath Library
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 *  @notice source: OpenZeppelin
 *  @dev math operations with safety checks that throw on error for uint8
 */
library SafeMath8 {
    function mul(uint8 a, uint8 b) internal constant returns (uint8) {
        uint8 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint8 a, uint8 b) internal constant returns (uint8) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint8 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint8 a, uint8 b) internal constant returns (uint8) {
        assert(b <= a);
        return a - b;
    }

    function add(uint8 a, uint8 b) internal constant returns (uint8) {
        uint8 c = a + b;
        assert(c >= a);
        return c;
    }
}
