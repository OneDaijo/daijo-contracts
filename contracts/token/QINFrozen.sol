pragma solidity ^0.4.13;

import "./interfaces/ERC223ReceivingContract.sol";
import "../permissions/Ownable.sol";
import '../libs/SafeMath.sol';
import "./QINToken.sol";
import "./interfaces/ERC223ReceivingContract.sol";


/** @title Frozen QIN Tokens
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 *  @dev QIN Tokens that are locked in this contract until a given release time
 */
/*contract QINFrozen is Ownable, ERC223ReceivingContract {
    using SafeMath for uint;

    // the token that's being locked
    QINToken public token;

    // timestamp of when to release the QIN tokens
    uint public releaseTime;

    // whether or not QIN tokens have already been frozen
    bool public frozen = false;

    function QINFrozen(QINToken _token, uint _releaseTime) {
        require(_releaseTime > now);
        token = _token;
        releaseTime = _releaseTime;
    }

    function release(address _wallet) external onlyOwner {
        require(frozen);
        require(_wallet != 0x0);
        require(now >= releaseTime);
        token.transfer(_wallet, frozenBalance());
    }

    function frozenBalance() public constant returns (uint) {
        return token.balanceOf(this);
    }

    function tokenFallback(address _from, uint _value, bytes _data) external {
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

    function supportsToken(address _token) public constant returns (bool) {
        // The only ERC223 token that can be paid to this contract is QIN
        return _token == address(token);
    }
}*/
