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
    uint public initialSupply = 200000000;
    uint public crowdsaleSupply = 60000000;

    QINCrowdsale public crowdsale;
    QINLocked public lockedTokens;

    // initialize the QIN token and assign all funds to the creator
    function QINToken() {
        totalSupply = initialSupply;
        balances[msg.sender] = initialSupply;
    }

    function startCrowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet) onlyOwner {
    	crowdsale = new QINCrowdsale(_startBlock, _endBlock, _rate, _wallet);

        // msg.sender should still be the owner.
        transfer(address(crowdsale), crowdsaleSupply);
    }

    function freezeRemainingTokens() {
    	// call transfer here
    }
}
