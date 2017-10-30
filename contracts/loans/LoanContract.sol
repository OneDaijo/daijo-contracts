pragma solidity ^0.4.13;

import "../libs/SafeMath256.sol";
import "../token/QINToken.sol";


contract LoanContract {
    using SafeMath256 for uint256;

    QINToken token;

    address borrower;
    address lender;
    address era;

    uint loanAmount;
    uint loanStart;
    uint loanEnd;
    uint interest;
    uint qinTokenAmount;
    uint borrowerShare;
    uint eraShare;

    mapping (address => uint256) loan_participants;

    bool hasbeenFunded;
    bool hasbeenRepaid;


    function loanContract() {
        loanAmount = 0;
    }

    function loanRepaid(address borrower) {
        token.transfer(borrower, borrowerShare);
    }

    function loanDefaulted(address lender) {
        token.transfer(lender, qinTokenAmount);
    }
}
