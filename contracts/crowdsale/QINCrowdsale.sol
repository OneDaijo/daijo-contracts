pragma solidity ^0.4.13;

import './QINToken.sol';
import './SafeMath.sol';
import './Ownable.sol';

/** @title QIN Token Crowdsale Contract
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 */
contract QINCrowdsale is Ownable {
    using SafeMath for uint256;

    // The token being sold
    QINToken public token;

    // start and end block where investments are allowed (both inclusive)
    uint256 public startBlock;
    uint256 public endBlock;

    // address where funds are collected
    address public wallet;

    // how many token units a buyer gets per wei
    uint256 public rate;

    // amount of raised money in wei
    uint256 public weiRaised;

    // total amount and amount remaining of QIN in the crowdsale
    uint256 public crowdsaleTokenSupply;
    uint256 public crowdsaleTokensRemaining;

    // whether or not the crowdsale is halted, for emergencies only
    bool public halted = false;

    /**
     * event for token purchase logging
     * @param purchaser who paid for and receives the tokens
     * @param value weis paid for purchase
     * @param amount amount of tokens purchased
     */ 
    event QINPurchase(address indexed purchaser, uint256 value, uint256 amount);

    function QINCrowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet, uint256 _tokenSupply) {
        require(_startBlock >= block.number);
        require(_endBlock >= _startBlock);
        require(_rate > 0);
        require(_wallet != 0x0);
        require(_tokenSupply > 0);

        crowdsaleTokenSupply = _tokenSupply;
        startBlock = _startBlock;
        endBlock = _endBlock;
        rate = _rate; // qinpereth = 400
        wallet = _wallet;
    }

    // creates the token to be sold. 
    // override this method to have crowdsale of a specific mintable token.
    function createTokenContract() internal returns (QINToken) {
        return new QINToken();
    }

    // fallback function can be used to buy tokens
    function () payable {
        buyQINTokens(msg.sender);
    }

    // low level QIN token purchase function
    function buyQINTokens() payable {
        require(validPurchase());

        uint256 weiToSpend = msg.value;

        // calculate token amount to be created
        uint256 QINToBuy = weiAmount.mul(rate);

        if (QINToBuy > crowdsaleTokensRemaining) {
            QINToBuy = crowdsaleTokensRemaining;

            // Will technically round down the amount of wei if this doesn't 
            // divide evenly, so the last person could get 1/2 a wei extra of QIN.  
            // TODO: improve this logic
            weiToSpend = QINToBuy.div(rate);
        }

        crowdsaleTokensRemaining = crowdsaleTokensRemaining.sub(QINToBuy);

        // update amount of wei raised
        weiRaised = weiRaised.add(weiAmount);

        // send purchased QIN to the buyer
        sendQIN(msg.sender, QINToBuy);
        QINPurchase(msg.sender, weiAmount, QINToBuy);

        // send ETH to the fund collection wallet
        // Note: could consider a mutex-locking function modifier instead or in addition to this.  This also poses complexity and security concerns.
        wallet.transfer(msg.value);
    }

    // send purchased QIN tokens to buyer's address, ensure only the owner can call this
    function sendQIN(address _to, uint256 _amount) onlyOwner {
        balances[_to] = balances[_to].add(_amount);
    }

    // @return true if the transaction can buy tokens
    function validPurchase() internal constant returns (bool) {
        bool duringCrowdsale = (block.number >= startBlock) && (block.number <= endBlock);
        bool nonZeroPurchase = msg.value != 0;
        return duringCrowdsale && nonZeroPurchase && !halted && crowdsaleTokensRemaining != 0;
    }

    // @return true if crowdsale event has ended
    function hasEnded() public constant returns (bool) {
        return block.number > endBlock || crowdsaleTokensRemaining == 0;
    }

    // halt the crowdsale in case of an emergency
    function haltCrowdsale() onlyOwner {
        halted = true;
    }

    // continue the crowdsale
    function unhaltCrowdsale() onlyOwner {
        halted = false;
    }

    // burn remaining funds if goal not met
    // TODO: fix this chit, my logic is for sure off
    function burnRemainder() onlyOwner {
        require(hasEnded);
        if (crowdsaleTokensRemaining > 0) {
            crowdsaleTokensRemaining = 0;
        }
    }
}
