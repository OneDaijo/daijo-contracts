pragma solidity ^0.4.13;

import "../permissions/Ownable.sol";
import '../libs/SafeMath.sol';
import "./QINToken.sol";

/** @title Locked QIN Token 
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 *  @dev QIN Tokens that are locked in this contract until a given release time
 */
 contract QINLocked is Ownable {
    using SafeMath for uint256;

    // the token that's being locked
    QINToken token;

    // timestamp of when to release the QIN tokens
    uint public releaseTime;

    // amount of QIN currently frozen
    uint public frozenBalance;

    // whether or not QIN tokens have already been frozen
    bool public frozen = false;

    function QINLocked(uint _releaseTime, uint _frozenBalance) {
        require(_releaseTime > now);
        token = QINToken(msg.sender);
        releaseTime = _releaseTime;
        frozenBalance = _frozenBalance;
    }

    function release(address _wallet) onlyOwner {
        require(frozen);
        require(_wallet != 0x0);
        require(now >= releaseTime);
        token.transfer(_wallet, frozenBalance);
        frozenBalance = 0;
    }

    function () payable {
        require(!frozen);

        assert(msg.value == frozenBalance);
        assert(token.balanceOf(address(this)) == frozenBalance);

        frozen = true;
    }
 }
