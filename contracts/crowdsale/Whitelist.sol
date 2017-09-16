pragma solidity ^0.4.16;

import '../libs/SafeMath.sol';

/** @title Token Crowdsale whitelist
  * @author WorldRapidFinance <info@worldrapidfinance.com>
  */

contract whitelist {
    using SafeMath for uint256;

    // Number of addresses on the whitelist
    uint public registeredUserCount = 0;

    mapping(address => bool) registeredUserWhitelist;

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
