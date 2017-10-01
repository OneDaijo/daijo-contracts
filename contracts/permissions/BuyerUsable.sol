pragma solidity ^0.4.13;

import '../libs/SafeMath.sol';
import '../permissions/Ownable.sol';


/** @title User
  * @author WorldRapidFinance <info@worldrapidfinance.com>
  * @dev Base class that provides token sale control functions to interact with QINCrowdsale.sol
*/
contract BuyerUsable is Ownable {
    using SafeMath for uint256;

    uint public registeredUserCount = 0;

    struct Buyer {
        bool isRegistered;
        uint lastBought;
        uint amountBoughtCumulative;
        uint amountBoughtToday;
    }

    mapping (address => Buyer) buyersList;

    // Requires address to be on the whitelist
    modifier onlyWhitelisted() {
        require(getUserRegistrationState(msg.sender));
        _;
    }

    // Adds an address to the whitelist
    function addToWhitelist(address _addr) external onlyOwner {
        buyersList[_addr] = Buyer(true, 0, 0, 0);
        registeredUserCount = registeredUserCount.add(1);
    }

    // Removes an address from the whitelist
    function removeFromWhitelist(address _addr) external onlyOwner {
        delete buyersList[_addr];
        registeredUserCount = registeredUserCount.sub(1);
    }

    // Returns true if address is on the whitelist
    function getUserRegistrationState(address _addr) public constant returns (bool) {
        Buyer storage b = buyersList[_addr];
        return b.isRegistered;
    }
}
