pragma solidity ^0.4.13;

import '../permissions/Ownable.sol';


/** @title Testable
  * @author OneDaijo <info@onedaijo.com>
  * @dev Base class that allows extra external controls when deployed as test.
*/
contract Testable is Ownable {

    // Is the contract being run on the test network. Note: this variable should be set on construction and never
    // modified.
    bool private isTest;

    uint private currentTime;

    function Testable(bool _isTest) {
        isTest = _isTest;
        currentTime = now;
    }

    modifier onlyIfTest {
        require(isTest);
        _;
    }

    function getTestState() public constant returns (bool) {
        return isTest;
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
