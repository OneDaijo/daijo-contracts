pragma solidity ^0.4.13;

import "./ERC223Token.sol";
import "./QINFrozen.sol";
import "../permissions/Ownable.sol";
import "../tknsale/QINTokenSale.sol";
import "../libs/SafeMath.sol";


/** @title QIN Token
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 */
contract QINToken is ERC223Token, Ownable {
    using SafeMath for uint;

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
    function QINToken() {
        totalSupply_ = reserveSupply.add(tokenSaleSupply);

        balances[msg.sender] = totalSupply_;
    }

    function startTokenSale(
        uint _startTime,
        uint _endTime,
        uint _days,
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

    function getCrowdsale() public constant returns (QINCrowdsale) {
        require(tokenSaleExecuted);
        return tokenSale;
    }
}
