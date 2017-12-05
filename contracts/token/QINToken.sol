pragma solidity ^0.4.13;

import "./ERC223Token.sol";
import "./QINFrozen.sol";
import "../permissions/Ownable.sol";
import "../permissions/Testable.sol";
import "../tokensale/QINTokenSale.sol";
import "../libs/SafeMath256.sol";


/** @title QIN Token
 *  @author OneDaijo <info@onedaijo.com>
 */
contract QINToken is ERC223Token, Ownable, Testable {
    using SafeMath256 for uint;

    string public constant NAME = "QIN Token";
    string public constant SYMBOL = "QIN";
    uint public constant DECIMALS = 18;

    // Multiplier to convert QIN to the smallest subdivision of QIN
    uint public decimalMultiplier = 10**DECIMALS;

    uint public reserveSupply = decimalMultiplier.mul(140000000);
    uint public tokenSaleSupply = decimalMultiplier.mul(60000000);

    bool public tokenSaleExecuted = false;

    QINTokenSale internal tokenSale;

    /* Token Creation */

    // initialize the QIN token and assign all funds to the creator

    function QINToken(bool _isTest) Testable(_isTest) {
        totalSupply_ = reserveSupply.add(tokenSaleSupply);
        balances[msg.sender] = totalSupply_;
    }

    function startTokenSale(
        uint _startTime,
        uint _endTime,
        uint8 _days,
        uint _rate,
        address _wallet) external onlyOwner
    {
        require(!tokenSaleExecuted);
        tokenSale = new QINTokenSale(this, _startTime, _endTime, _days, _rate, _wallet);

        // Must transfer ownership to the owner of the QINToken contract rather than the QINToken itself.
        tokenSale.transferOwnership(msg.sender);

        // msg.sender should still be the owner
        transfer(address(tokenSale), tokenSaleSupply);

        tokenSaleExecuted = true;
    }

    function getTokenSale() public constant returns (QINTokenSale) {
        require(tokenSaleExecuted);
        return tokenSale;
    }
}
