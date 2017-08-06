/** @title QIN Token 
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 *  @notice source: https://github.com/ethereum/EIPs/issues/20
 */

pragma solidity ^0.4.13;

import "./ConvertLib.sol";
import "./ERC20Token.sol";


contract QINToken is ERC20Token {

    string public name = "QIN Token";
    string public symbol = "QIN";
    uint public decimals = 18;
    uint public qinPerEth = 400;

    // crowdsale info
    uint public startBlock;
    uint public endBlock;
    uint public crowdsaleTokenSupply;
    uint public crowdsaleTokensRemaining;

    address public wallet; // address where raised ETH will be deposited
    bool public halted = false; // for crowdsale emergencies

    // TODO vars for allocations + locktimes?

    function QINToken(address _wallet, uint _startBlock, uint _endBlock) {
        totalSupply = 200000000 * decimals;
        crowdsaleTokenSupply = 60000000 * decimals;
        crowdsaleTokensRemaining = crowdsaleTokenSupply;
        wallet = _wallet;
        startBlock = _startBlock;
        endBlock = _endBlock;
    }

    function getBalanceInUSD(address addr) returns(uint) {
        return ConvertLib.convert(balanceOf(addr), 2); // TODO figure out conversion rate here
    }

    modifier requireSale() {
        require(!halted);
        _;
        if (crowdsaleTokensRemaining == 0) {
            halted = true;
        }
    }

    function () payable requireSale {
        uint weiToSpend = msg.value;

        // This works because QIN is denominated in 10^-18 like ETH
        uint qinToBuy = weiToSpend * qinPerEth;

        if (qinToBuy > crowdsaleTokensRemaining) {
            qinToBuy = crowdsaleTokensRemaining;
            // Will technically round down the amount of wei if this doesn't divide evently, so the last person could get 1/2 a wei extra of QIN.  Maybe this logic could be improved, but whatevs.
            weiToSpend = qinToBuy / qinPerEth;
        }

        crowdsaleTokensRemaining -= qinToBuy;

        // TODO(mrice) don't modify balances directly (?)
        balances[msg.sender] += qinToBuy;

        // All external calls are left until the end of the fucntion just to be safe :)
        // Note: could consider a mutex-locking function modifier instead or in addition to this.  This also poses complexity and security concerns.
        wallet.transfer(weiToSpend);

        // Refund if we ran out of QIN to send them  
        if (weiToSpend < msg.value) {
            msg.sender.transfer(msg.value - weiToSpend);
        }
    }

    // Ensures function is only run by the creator of the contract.
    modifier requireCreator() {
        require(msg.sender == wallet);
        _;
    }

    // functions to halt and unhalt crowdsale in case of emergency
    function haltCrowdsale() requireCreator {
        halted = true;
    }

    function unhaltCrowdsale() requireCreator {
        halted = false;
    }
}
