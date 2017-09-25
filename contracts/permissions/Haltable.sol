pragma solidity ^0.4.13;

import "./Ownable.sol";


contract Haltable is Ownable {

    bool public halted = false;

    modifier breakInEmergency {
        require(!halted);
        _;
    }

    modifier onlyInEmergency {
        require(halted);
        _;
    }

    // halt the crowdsale in case of an emergency
    function haltCrowdsale() external onlyOwner {
        halted = true;
    }

    // continue the crowdsale
    function unhaltCrowdsale() external onlyOwner onlyInEmergency {
        halted = false;
    }
}