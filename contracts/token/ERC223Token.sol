pragma solidity ^0.4.13;

import "./interfaces/ERC223Interface.sol";
import "./ERC20Token.sol";
import "./interfaces/ERC223ReceivingContract.sol";
import "../libs/SafeMath.sol";

/** @title ERC223 Token Implementation
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 *  @notice source: https://github.com/ethereum/EIPs/issues/223
 */
contract ERC223Token is ERC223Interface, ERC20Token {
    using SafeMath for uint256;

    // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
    function isContract(address _to) private returns (bool isContract) {
        uint length;
        assembly {
            //retrieve the size of the code on target address, this needs assembly
            length := extcodesize(_to)
        }
        if (length > 0) {
            return true;
        } else {
            return false;
        }
    }
   
    // note: overrides the transfer function in ERC20Token
    //       included for backwards compatibility
    function transfer(address _to, uint256 _value) returns (bool success) { 
        bytes memory empty;
        if(isContract(_to)) {
            return transferToContract(_to, _value, empty);
        } else {
            return transferToAddress(_to, _value, empty);
        }
    }

    function transfer(address _to, uint _value, bytes _data) returns (bool success) {
        if(isContract(_to)) {
            return transferToContract(_to, _value, _data);
        } else {
            return transferToAddress(_to, _value, _data);
        }   
    }

    // function that is called when transaction target is a contract
    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
        require(balanceOf(msg.sender) >= _value);

        balances[msg.sender] = balanceOf(msg.sender).sub(_value);
        balances[_to] = balanceOf(_to).add(_value);
        ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
        receiver.tokenFallback(msg.sender, _value, _data);
        Transfer(msg.sender, _to, _value, _data);
        return true;
    }

    // function that is called when transaction target is an address
    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
        require(balanceOf(msg.sender) >= _value);

        balances[msg.sender] = balanceOf(msg.sender).sub(_value);
        balances[_to] = balanceOf(_to).add(_value);
        Transfer(msg.sender, _to, _value, _data);
        return true;
    }
  

}
