pragma solidity ^0.4.13;

import "./ConvertLib.sol";
import "./ERC20Token.sol";

/** @title QIN Token 
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 *  @notice source: https://github.com/ethereum/EIPs/issues/20
 */
contract QINToken is ERC20Token {

    string public name = "QIN Token";
    string public symbol = "QIN";
    uint public decimals = 5;

    // crowdsale info
    uint public startBlock;
    uint public endBlock;
    uint public crowdsaleTokenSupply;
    address public wallet; // address where raised ETH will be deposited
    bool public halted = false; // for crowdsale emergencies

    // TODO vars for allocations + locktimes?

    function QINToken(address _wallet, uint _startBlock, uint _endBlock) {
        totalSupply = 200000000;
        wallet = _wallet;
        startBlock = _startBlock;
        endBlock = _endBlock;
    }

    function getBalanceInUSD(address addr) returns(uint){
        return ConvertLib.convert(balanceOf(addr), 2); // TODO figure out conversion rate here
    }

    // functions to halt and unhalt crowdsale in case of emergency
    function haltCrowdsale() {
        if (msg.sender != wallet) 
            throw;
        halted = true;
    }

    function unhaltCrowdsale() {
        if (msg.sender != wallet)
            throw;
        halted = false;
    }
}
