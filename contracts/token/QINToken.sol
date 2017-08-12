pragma solidity ^0.4.13;

import "./ERC20Token.sol";
import "./QINLocked.sol";
import "../permissions/Ownable.sol";
import "../crowdsale/QINCrowdsale.sol";
import "../libs/SafeMath.sol";

/** @title QIN Token 
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 *  @notice source: https://github.com/ethereum/EIPs/issues/20
 */
contract QINToken is ERC20Token, Ownable {
    using SafeMath for uint256;

    string public name = "QIN Token";
    string public symbol = "QIN";
    uint public decimals = 18;

    uint public frozenSupply = 140000000;
    uint public crowdsaleSupply = 60000000;
    uint public initialSupply = frozenSupply.add(crowdsaleSupply); // a check to make sure the math works out

    QINCrowdsale public crowdsale;
    QINLocked public frozenQIN;

    bool public crowdsaleExecuted = false;

    // initialize the QIN token and assign all funds to the creator
    function QINToken() {
        totalSupply = initialSupply;
        balances[msg.sender] = initialSupply;
    }

    function startCrowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet, uint _releaseTime) onlyOwner {
    	require(!crowdsaleExecuted);
    	crowdsale = new QINCrowdsale(_startBlock, _endBlock, _rate, _wallet);

        // msg.sender should still be the owner
        transfer(address(crowdsale), crowdsaleSupply);

        // ensure the correct amount was sent to crowdsale, then freeze the rest
        assert(balanceOf(msg.sender) == frozenSupply);

        freezeRemainingTokens(_releaseTime, frozenSupply);
        crowdsaleExecuted = true;
    }

    function freezeRemainingTokens(uint _releaseTime, uint _amountToFreeze) internal onlyOwner {
    	frozenQIN = new QINLocked(_releaseTime, _amountToFreeze);
    	transfer(address(frozenQIN), _amountToFreeze);
    	assert(balanceOf(msg.sender) == 0);
    }
}
