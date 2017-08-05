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

    // crowdsale info
    uint public startBlock;
    uint public endBlock;
    uint public crowdsaleTokenSupply;
    address public wallet; // address where raised ETH will be deposited
    bool public halted = false; // for crowdsale emergencies

    // TODO vars for allocations + locktimes?

    function QINToken(address _wallet, uint _startBlock, uint _endBlock) {
        totalSupply = 200000000 * decimals;
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
    }

    function buyQIN() payable requireSale {
        // TODO(mrice) don't modify balances directly
        uint wei_sent = msg.value;
        uint qin_purchased = ConvertLib.ethToQIN(wei_sent);
        wallet.transfer(wei_sent);
        balances[msg.sender] += qin_purchased;
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
