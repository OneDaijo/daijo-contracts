pragma solidity ^0.4.13;

import '../libs/SafeMath.sol';
import '../permissions/Ownable.sol';

/** @title Controllable
  * @author WorldRapidFinance <info@worldrapidfinance.com>
  * @dev Base class that provides crowdsale control functions to interact with QINCrowdsale.sol
*/


contract Controllable is Ownable {
    using SafeMath for uint256;

    bool public halted = false;
    bool public manualEnd = false;

    uint public registeredUserCount = 0;

    mapping (address => bool) registeredUserWhitelist;

    // Requires the crowdsale to be not halted (previously breakInEmergency)
    modifier onlyIfActive {
        if (halted) {
            revert();
        }
        _;
    }
    // Requires the crowdsale to be halted (previously onlyInEmergency)
    modifier onlyIfHalted {
        if (!halted) {
            revert();
        }
        _;
    }
    // Requires address to be on the whitelist
    modifier onlyWhitelisted() {
        require(getUserRegistrationState(msg.sender));
        _;
    }

    // Halt the crowdsale in case of an emergency
    function haltCrowdsale() external onlyOwner {
        halted = true;
    }

    // Unhalt the crowdsale
    function unhaltCrowdsale() external onlyOwner onlyIfHalted {
        halted = false;
    }

    // Sets manualEnd to true, making fxn hasEnded() return true, setting the crowdsale state to SaleComplete
    // This function is an option to prematurely end a halted crowdsale
    function endCrowdsale() external onlyOwner onlyIfHalted {
        manualEnd = true;
    }

    // Adds an address to the whitelist
    function addToWhitelist(address _addr) external onlyOwner {

        registeredUserWhitelist[_addr] = true;
        registeredUserCount = registeredUserCount.add(1);
    }


    // Removes an address from the whitelist
    function removeFromWhitelist(address _addr) external onlyOwner {
        registeredUserWhitelist[_addr] = false;
        registeredUserCount = registeredUserCount.sub(1);
    }

    // Returns true if address is on the whitelist
    function getUserRegistrationState(address _addr) public constant returns (bool) {
        return registeredUserWhitelist[_addr];
    }

}
