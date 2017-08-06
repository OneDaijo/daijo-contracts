pragma solidity ^0.4.13;

import "./ConvertLib.sol";
import "./ERC20Token.sol";

/** @title QIN Token 
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 *  @notice source: https://github.com/ethereum/EIPs/issues/20
 */
contract QINToken is ERC20Token {

    string public name = "QIN Token";
    string public symbol = "QIN";
    uint public decimals = 18;
    uint public qinPerEth = 400;

    // crowdsale info
    uint public startBlock;
    uint public endBlock;
    uint public crowdsaleTokenSupply;

    address public wallet; // address where raised ETH will be deposited
    bool public halted = false; // for crowdsale emergencies

    // TODO vars for allocations + locktimes?

    function QINToken(address _wallet, uint _startBlock, uint _endBlock) {
        totalSupply = 200000000 * decimals;
        crowdsaleTokenSupply = 60000000 * decimals;
        wallet = _wallet;
        startBlock = _startBlock;
        endBlock = _endBlock;
    }

    function getBalanceInUSD(address addr) returns(uint){
        return ConvertLib.convert(balanceOf(addr), 2); // TODO figure out conversion rate here
    }

    modifier requireSale() {
        require(!halted);
        _;
        if (crowdsaleTokenSupply == 0) {
            halted = true;
        }
    }

    function () payable requireSale {
        uint wei_to_spend = msg.value;

        // This works because QIN is denominated in 10^-18 like ETH
        uint qin_to_buy = wei_to_spend * qinPerEth;

        if (qin_to_buy > crowdsaleTokenSupply) {
            qin_to_buy = crowdsaleTokenSupply;
            // Will technically round down the amount of wei if this doesn't divide evently, so the last person could get 1/2 a wei extra of QIN.  Maybe this logic could be improved, but whatevs.
            wei_to_spend = qin_to_buy / qinPerEth;
        }

        crowdsaleTokenSupply -= qin_to_buy;
        // Is totalSupply a constant or is it something we deplete as the reserved amount decreases?
        totalSupply -= qin_to_buy;

        // TODO(mrice) don't modify balances directly (?)
        balances[msg.sender] += qin_to_buy;

        // All external calls are left until the end of the fucntion just to be safe :)
        // Note: could consider a mutex-locking function modifier instead or in addition to this.  This also poses complexity and security concerns.

        wallet.transfer(wei_to_spend);

        // Refund if we ran out of QIN to send them  
        if (wei_to_spend < msg.value) {
            msg.sender.transfer(msg.value - wei_to_spend);
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

