pragma solidity ^0.4.16

import '../permissions/Haltable.sol';
import '../permissions/Ownable.sol';

/** @title Crowdsale Admin Controls library
  * @author WorldRapidFinance <info@worldrapidfinance.com>
  *dev control functions that interact with QINCrowdsale.sol
*/

library Controls {

    //sets manualEnd to true, making fxn hasEnded() return true, setting the crowdsale state to SaleComplete
    function endCrowdsale() external onlyOwner {
        require Halted;
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
