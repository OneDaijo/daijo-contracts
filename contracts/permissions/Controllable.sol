pragma solidity ^0.4.13;

import '../libs/SafeMath.sol';
import '../permissions/Ownable.sol';


/** @title Controllable
  * @author WorldRapidFinance <info@worldrapidfinance.com>
  * @dev Base class that provides token sale control functions to interact with QINTokenSale.sol
*/
contract Controllable is Ownable {
    using SafeMath for uint256;

    bool public halted = false;
    bool public manualEnd = false;

    // Requires the token sale to be not halted (previously breakInEmergency)
    modifier onlyIfActive {
        if (halted) {
            revert();
        }
        _;
    }
    // Requires the token sale to be halted (previously onlyInEmergency)
    modifier onlyIfHalted {
        if (!halted) {
            revert();
        }
        _;
    }

    // Halt the token sale in case of an emergency
    function haltCrowdsale() external onlyOwner {
        halted = true;
    }

    // Unhalt the token sale
    function unhaltCrowdsale() external onlyOwner onlyIfHalted {
        halted = false;
    }

    // Sets manualEnd to true, making fxn hasEnded() return true, setting the token sale state to SaleComplete
    // This function is an option to prematurely end a halted token sale
    function endCrowdsale() external onlyOwner onlyIfHalted {
        manualEnd = true;
    }

}
