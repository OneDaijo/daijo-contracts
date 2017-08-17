pragma solidity ^0.4.13;

import "./interfaces/ERC20Interface.sol";
import "../permissions/Ownable.sol";
import "../libs/SafeMath.sol";

/** @title ERC20 Token Implementation
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 *  @notice source: https://theethereum.wiki/w/index.php/ERC20_Token_Standard
 *  @notice functions check against integer over and underflow
 *  TODO: make this use safemath instead
 */
contract ERC20Token is ERC20Interface, Ownable {
    using SafeMath for uint256;

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) returns (bool success) {
        if (balances[msg.sender] >= _value
            && _value > 0
            && balances[_to] + _value > balances[_to]) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { 
            return false; 
        }
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
        ) returns (bool success) {
        if (balances[_from] >= _value
            && allowed[_from][msg.sender] >= _value
            && _value > 0
            && balances[_to] + _value > balances[_to]) {
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(_from, _to, _value);
            return true;
        } else { 
            return false; 
        }
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
}
