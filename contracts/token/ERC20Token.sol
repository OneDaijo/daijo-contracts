pragma solidity ^0.4.13;

import "./interfaces/ERC20Interface.sol";
import "../libs/SafeMath.sol";


/** @title ERC20 Token Implementation
 *  @author DaijoLabs <info@daijolabs.com>
 *  @notice source: https://theethereum.wiki/w/index.php/ERC20_Token_Standard
 *  @notice functions check against integer over and underflow
 *  TODO: make this use safemath instead
 */
contract ERC20Token is ERC20Interface {
    using SafeMath for uint;

    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;

    uint totalSupply_;

    function totalSupply() constant returns (uint) {
        return totalSupply_;
    }

    function balanceOf(address _owner) public constant returns (uint) {
        return balances[_owner];
    }

    function transfer(address _to, uint _value) public returns (bool) {
        if (balances[msg.sender] >= _value &&
            _value > 0 &&
            balances[_to] + _value > balances[_to]) {
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
        uint _value
        ) public returns (bool)
    {
        if (balances[_from] >= _value &&
            allowed[_from][msg.sender] >= _value &&
            _value > 0 &&
            balances[_to] + _value > balances[_to]) {
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(_from, _to, _value);
            return true;
        } else {
            return false;
        }
    }

    function approve(address _spender, uint _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public constant returns (uint) {
        return allowed[_owner][_spender];
    }
}
