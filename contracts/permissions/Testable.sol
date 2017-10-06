pragma solidity ^0.4.13;

import '../permissions/Ownable.sol';


/** @title Testable
  * @author DaijoLabs <info@daijolabs.com>
  * @dev Base class that allows extra external controls when deployed as test.
*/
contract Testable is Ownable {

    // Is the contract being run on the test network. Note: this variable should be set on construction and never
    // modified.
    bool public isTest;

    uint private currentTime;

    function Testable(bool _isTest) {
        isTest = _isTest;
        currentTime = now;
    }

    modifier onlyIfTest {
        require(isTest);
        _;
    }

    function getCurrentTime() public constant returns (uint) {
        if (isTest) {
            return currentTime;
        } else {
            return now;
        }
    }

    function setCurrentTime(uint _time) external onlyOwner onlyIfTest {
        currentTime = _time;
    }
}