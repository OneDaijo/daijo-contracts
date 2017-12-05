pragma solidity ^0.4.13;

import '../libs/SafeMath256.sol';
import '../libs/SafeMath8.sol';
import '../permissions/Ownable.sol';


/** @title User
  * @author OneDaijo <info@onedaijo.com>
  * @dev Base class that provides user-related functionality
*/
contract BuyerStore is Ownable {
    using SafeMath8 for uint8;
    using SafeMath256 for uint;

    uint public registeredUserCount = 0;

    struct Buyer {
        bool isRegistered;
        uint8 lastRestrictedDayBought;
        uint amountBoughtCumulative;
        uint amountBoughtCurrentRestrictedDay;
    }

    mapping (address => Buyer) buyers;

    // Requires address to be on the whitelist
    modifier onlyWhitelisted() {
        require(getUserRegistrationState(msg.sender));
        _;
    }

    // Adds an address to the whitelist
    function addToWhitelist(address _addr) external onlyOwner {
        require(!buyers[_addr].isRegistered);
        buyers[_addr].isRegistered = true;
        registeredUserCount = registeredUserCount.add(1);
    }

    // Removes an address from the whitelist
    function removeFromWhitelist(address _addr) external onlyOwner {
        require(buyers[_addr].isRegistered);
        buyers[_addr].isRegistered = false;
        registeredUserCount = registeredUserCount.sub(1);
    }

    // Returns true if address is on the whitelist
    function getUserRegistrationState(address _addr) public constant returns (bool) {
        return buyers[_addr].isRegistered;
    }
}
