pragma solidity ^0.4.16

import '../permissions/Ownable.sol';

/** @title Crowdsale Admin Controls library
  * @author WorldRapidFinance <info@worldrapidfinance.com>
  * @dev control functions that interact with QINCrowdsale.sol
*/

library Controls {

    // Modifiers allowing easy access to boolean halted
    modifier breakInEmergency {
        if (halted) {
            revert();
        }
        _;
    }

    modifier onlyInEmergency {
        if (!halted) {
            revert();
        }
        _;
    }

    // Halt the crowdsale in case of an emergency
    function haltCrowdsale() external onlyOwner {
        halted = true;
    }

    // Unhalt the crowdsale
    function unhaltCrowdsale() external onlyOwner onlyInEmergency {
        halted = false;
    }

    // Sets manualEnd to true, making fxn hasEnded() return true, setting the crowdsale state to SaleComplete
    // This function is an option to prematurely end a halted crowdsale
    function endCrowdsale() external onlyOwner {
        require halted;
        manualEnd = true;
    }

    // Adds an address to the whitelist
    function addToWhitelist(address _addr) external onlyOwner {
      registeredUserWhitelist[_addr] = true;
      registeredUserCount = registeredUserCount.add(1);
    }


    // Removes an address from the whitelist
    function removeFromWhitelist(address _addr)  external onlyOwner {
      registeredUserWhitelist[_addr] = false;
      registeredUserCount = registeredUserCount.sub(1);
    }

    // Returns true if address is on the whitelist
    function getUserRegistrationState(address _addr) public constant returns (bool) {
      return registeredUserWhitelist[_addr];
    }
}
