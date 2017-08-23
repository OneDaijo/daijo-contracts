pragma solidity ^0.4.13;

import "./ERC223Token.sol";
import "./QINFrozen.sol";
import "../permissions/Ownable.sol";
import "../crowdsale/QINCrowdsale.sol";
import "../libs/SafeMath.sol";

/** @title QIN Token 
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 */
contract QINToken is ERC223Token, Ownable {
    using SafeMath for uint256;

    string public constant name = "QIN Token";
    string public constant symbol = "QIN";
    uint public constant decimals = 18;

    // Multiplier to convert QIN to the smallest subdivision of QIN
    uint public decimalMultiplier = 10**18;

    uint public frozenSupply = decimalMultiplier.mul(140000000);
    uint public crowdsaleSupply = decimalMultiplier.mul(60000000);

    QINCrowdsale public crowdsale;
    QINFrozen public frozenQIN;

    bool public crowdsaleExecuted = false;

    /* Token Creation */

    // initialize the QIN token and assign all funds to the creator
    function QINToken() {
        _totalSupply = frozenSupply.add(crowdsaleSupply);
        balances[msg.sender] = _totalSupply;
    }

    function startCrowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet, uint _releaseTime) external onlyOwner {
    	require(!crowdsaleExecuted);
    	crowdsale = new QINCrowdsale(_startBlock, _endBlock, _rate, _wallet);

        // Must transfer ownership to the owner of the QINToken contract rather than the QINToken itself.
        crowdsale.transferOwnership(msg.sender);

        // msg.sender should still be the owner
        transfer(address(crowdsale), crowdsaleSupply);

        // ensure the correct amount was sent to crowdsale, then freeze the rest
        assert(balanceOf(msg.sender) == frozenSupply);

        freezeRemainingTokens(_releaseTime, frozenSupply);
        crowdsaleExecuted = true;
    }

    function freezeRemainingTokens(uint _releaseTime, uint _amountToFreeze) private onlyOwner {
        frozenQIN = new QINFrozen(_releaseTime);

        // Must transfer ownership to the owner of the QINToken contract rather than the QINToken itself.
        frozenQIN.transferOwnership(msg.sender);

        transfer(address(frozenQIN), _amountToFreeze);

    	assert(balanceOf(msg.sender) == 0);
    }

    function getTCSOwner() constant returns (address) {
        return crowdsale.owner();
    }

    function getFreezeOwner() constant returns (address) {
        return frozenQIN.owner();
    }
}