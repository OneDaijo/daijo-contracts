pragma solidity ^0.4.13;

import "./interfaces/ERC223ReceivingContract.sol";
import "../permissions/Ownable.sol";
import '../libs/SafeMath.sol';
import "./QINToken.sol";

/** @title Frozen QIN Tokens
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 *  @dev QIN Tokens that are locked in this contract until a given release time
 */
 contract QINFrozen is Ownable, ERC223ReceivingContract {
    using SafeMath for uint256;

    // the token that's being locked
    QINToken token;

    // timestamp of when to release the QIN tokens
    uint public releaseTime;

    // whether or not QIN tokens have already been frozen
    bool public frozen = false;

    function QINFrozen(uint _releaseTime) {
        require(_releaseTime > now);
        token = QINToken(msg.sender);
        releaseTime = _releaseTime;
    }

    function release(address _wallet) onlyOwner {
        require(frozen);
        require(_wallet != 0x0);
        require(now >= releaseTime);
        token.transfer(_wallet, frozenBalance());
    }

    function frozenBalance() constant returns (uint balance) {
        return token.balanceOf(this);
    }

    function tokenFallback(address _from, uint _value, bytes _data) {
        // Require that the paid token is supported
        require(supportsToken(msg.sender));

        // Ensures this function has only been run once
        require(!frozen);

        // Crowdsale can only be paid by the owner of QINFrozen.
        require(_from == owner);

        // Ensure that QIN was actually transferred.  Not sure if this is really necessary, but for correctness' sake.
        require(_value > 0);
        assert(frozenBalance() == _value);

        frozen = true;
    }

    function supportsToken(address _token) constant returns (bool) {
        // The only ERC223 token that can be paid to this contract is QIN
        return _token == address(token);
    }
 }
