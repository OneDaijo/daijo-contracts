pragma solidity ^0.4.13;


 /** @title SafeMath Library
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 *  @notice source: OpenZeppelin
 *  @dev math operations with safety checks that throw on error for uint
 */
library SafeMath256 {
    function mul(uint a, uint b) internal constant returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint a, uint b) internal constant returns (uint) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint a, uint b) internal constant returns (uint) {
        assert(b <= a);
        return a - b;
    }

    function add(uint a, uint b) internal constant returns (uint) {
        uint c = a + b;
        assert(c >= a);
        return c;
    }

    function castToUint8(uint a) internal constant returns (uint8) {
        uint8 b = uint8(a);
        assert(a == b);
        return b;
    }
}
