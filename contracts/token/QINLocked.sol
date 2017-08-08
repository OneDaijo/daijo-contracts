pragma solidity ^0.4.13;

/** @title Locked QIN Token 
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 *  @dev QIN Tokens that are locked in this contract until a given release time
 */
 contract QINLocked {

    // address to send the QIN to once they are released
    address beneficiary;

    // timestamp of when to release the QIN tokens
    uint releaseTime;

    // TODO finish this
    function QINLocked(address _beneficiary, uint _releaseTime) {
        require(_releaseTime > now);
        beneficiary = _beneficiary;
        releaseTime = _releaseTime;
    }

    // TODO finish this
    function release() {
        require(now >= releaseTime);
        // call transfer here
    }
 }
