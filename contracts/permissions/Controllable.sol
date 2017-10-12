pragma solidity ^0.4.13;

import '../libs/SafeMath256.sol';
import '../permissions/Ownable.sol';


/** @title Controllable
  * @author DaijoLabs <info@daijolabs.com>
  * @dev Base class that provides token sale control functions to interact with QINCrowdsale.sol
*/
contract Controllable is Ownable {
    using SafeMath256 for uint;

    bool public halted = false;
    bool public manualEnd = false;

    // Requires the token sale to be not halted (previously breakInEmergency)
    modifier onlyIfActive {
        require(!halted);
        _;
    }
    // Requires the token sale to be halted (previously onlyInEmergency)
    modifier onlyIfHalted {
        require(halted);
        _;
    }

    // Halt the token sale in case of an emergency
    function haltTokenSale() external onlyOwner {
        halted = true;
    }

    // Unhalt the token sale
    function unhaltTokenSale() external onlyOwner onlyIfHalted {
        halted = false;
    }

    // Sets manualEnd to true, making fxn hasEnded() return true, setting the token sale state to SaleComplete
    // This function is an option to prematurely end a halted token sale
    function endTokenSale() external onlyOwner onlyIfHalted {
        manualEnd = true;
    }

}
