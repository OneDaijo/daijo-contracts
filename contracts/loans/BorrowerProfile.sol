pragma solidity ^0.4.13;

import '../libs/SafeMath256.sol';


contract BorrowerProfile {
    using SafeMath256 for uint256;

    uint borrowerID;
    address borrowerAddr;
    address[] loanContracts;

    bool isBorrowing = false;
    uint numberOfCurrentContracts = 0;
    uint successfulLoans = 0;
    uint defaultedLoans = 0;
    uint totalAmountBorrowed = 0;
    uint currentAmountBorrowed = 0;

    function borrowerProfile(uint id) {
        borrowerID = id;
        borrowerAddr = msg.sender;
    }

    function contractSigned(address addr) {
        loanContracts.push(addr);
        numberOfCurrentContracts = numberOfCurrentContracts.add(1);
    }

    function receivingLoan() payable {
        revert();
    }

    function toggleBorrowing() {
        if (isBorrowing == false) {
            isBorrowing = true;
        } else {
            isBorrowing = false;
        }
    }

    function loanSuccess() {
        successfulLoans = successfulLoans.add(1);
    }

    function loanDefault() {
        defaultedLoans = defaultedLoans.add(1);
    }
}
