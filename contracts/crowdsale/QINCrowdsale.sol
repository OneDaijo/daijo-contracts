pragma solidity ^0.4.13;

import '../token/interfaces/ERC223ReceivingContract.sol';
import '../token/QINFrozen.sol';
import '../libs/SafeMath.sol';
import '../permissions/Ownable.sol';
import '../permissions/Haltable.sol';

/** @title QIN Token Crowdsale Contract
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 */
contract QINCrowdsale is ERC223ReceivingContract, Haltable {
    using SafeMath for uint256;

/* QIN Token Crowdsale */

    // The token being sold
    QINToken public token;

    // QINTokens will be sent from this address
    address public wallet;

    // start and end UNIX timestamp where investments are allowed
    uint256 public startTime;
    uint256 public endTime;

    uint256 public unixDay = 24*60*60;

    // how many token units a buyer gets per wei
    uint256 public rate;

    // amount of raised money in wei
    uint256 public weiRaised;

    // number of registered users
    uint256 public registeredUserCount;

    mapping (address => bool) registeredUserWhitelist;
    mapping (address => uint256) amountBoughtDayOne;
    mapping (address => uint256) amountBoughtDayTwo;

    // total amount and amount remaining of QIN in the crowdsale
    uint256 public crowdsaleTokenSupply;
    uint256 public crowdsaleTokensRemaining;

    uint256 private dayOneLimit = crowdsaleTokenSupply / registeredUserCount;
    uint256 private dayTwoLimit; // set on second day
    bool private dayTwoLimitSet;

    // whether QIN has been transferred to the crowdsale contract
    bool public hasBeenFunded = false;

    /* State Machine for each day of sale */
    enum State {BeforeSale, SaleDay1, SaleDay2, SaleFFA}

    /**
     * event for token purchase logging
     * @param purchaser who paid for and receives the tokens
     * @param value weis paid for purchase
     * @param amount amount of tokens purchased
     */
    event QINPurchase(address indexed purchaser, uint256 value, uint256 amount);

    /**
     * event that notifies clients about the amount burned
     * @param value the value burned
     */
    event Burn(uint256 value);

    function QINCrowdsale(QINToken _token, uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
        require(_startTime >= block.timestamp);
        require(_endTime >= _startTime);
        require(_rate > 0);
        require(_wallet != 0x0);

        // TODO(mrice) assumes the QINToken is the creator. If not, we should take the QIN token in explicitly.
        token = _token;
        startTime = _startTime;
        endTime = _endTime;
        rate = _rate; // Qin per ETH = 400, subject to change
        wallet = _wallet;
    }

    function updateRegisteredUserWhitelist(address addr, bool status) external onlyOwner {
      registeredUserWhitelist[addr] = status;
    }

    // TODO: This assumes ERC223 - which should be added
    function tokenFallback(address _from, uint _value, bytes _data) external {
        // Require that the paid token is supported
        require(supportsToken(msg.sender));

        // Ensures this function has only been run once
        require(!hasBeenFunded);

        // Crowdsale can only be paid by the owner of the crowdsale.
        require(_from == owner);

        // Sanity check to ensure that QIN was correctly transferred
        require(_value > 0);
        assert(token.balanceOf(this) == _value);

        crowdsaleTokenSupply = _value;
        crowdsaleTokensRemaining = _value;
        hasBeenFunded = true;
    }

    function supportsToken(address _token) public constant returns (bool) {
        // The only ERC223 token that can be paid to this contract is QIN
        return _token == address(token);
    }

    // fallback function can be used to buy tokens
    /* Since we're trying to make it so that only registered
       buy tokens, should we make it so that the generic
       fallback function throws? */
    function () external payable {
        buyQINTokensWithRegisteredAddress(msg.sender);
    }

    function buyQINTokensWithRegisteredAddress(address buyer) public payable {
      require(validPurchase());
      require(registeredUserWhitelist[buyer]);

      buyQINTokens(buyer);
    }

    // low level QIN token purchase function
    function buyQINTokens(address buyer) breakInEmergency private {
        uint256 weiToSpend = msg.value;

        // calculate token amount to be sent
        uint256 QINToBuy = weiToSpend.mul(rate);

        // Token Crowdsale Day 1 Structure
        if (getState() == State.SaleDay1) {
          if(amountBoughtDayOne[buyer] == dayOneLimit) { // throw if buyer has hit Day 1 limit
            revert();
          }
          else if (QINToBuy > dayOneLimit - amountBoughtDayOne[buyer]) {
            QINToBuy = dayOneLimit - amountBoughtDayOne[buyer]; // set QINToBuy to remaining daily limit if buy order goes over
          }
          weiToSpend = QINToBuy.div(rate);
        }

        if (getState() == State.SaleDay2) {
          if(!dayTwoLimitSet) { // only triggers once, upon first sale of day 2
            dayTwoLimit = crowdsaleTokensRemaining;
            dayTwoLimitSet = true;
          }
          if(amountBoughtDayTwo[buyer] == dayTwoLimit) { // throw if buyer has hit Day 2 limit
            revert();
          }
          else if (QINToBuy > dayTwoLimit - amountBoughtDayTwo[buyer]) {
            QINToBuy = dayTwoLimit - amountBoughtDayTwo[buyer]; // set QINToBuy to remaining daily limit if buy order goes over
          }
          weiToSpend = QINToBuy.div(rate);
        }

        if (getState() == State.SaleFFA) {
          if (QINToBuy > crowdsaleTokensRemaining) {
            QINToBuy = crowdsaleTokensRemaining;

            // Will technically round down the amount of wei if this doesn't
            // divide evenly, so the last person could get 1/2 a wei extra of QIN.
            // TODO: improve this logic
            weiToSpend = QINToBuy.div(rate);
          }
        }

        crowdsaleTokensRemaining = crowdsaleTokensRemaining.sub(QINToBuy);

        // update amount of wei raised
        weiRaised = weiRaised.add(weiToSpend);

        // send ETH to the fund collection wallet
        // Note: could consider a mutex-locking function modifier instead or in addition to this.  This also poses complexity and security concerns.
        wallet.transfer(weiToSpend);

        // send purchased QIN to the buyer
        sendQIN(msg.sender, QINToBuy);
        if(getState() == State.SaleDay1) {
          amountBoughtDayOne[buyer] = amountBoughtDayOne[buyer].add(QINToBuy);
        }
        if(getState() == State.SaleDay2) {
          amountBoughtDayTwo[buyer] = amountBoughtDayTwo[buyer].add(QINToBuy);
        }

        // Refund any unspend wei.
        if (msg.value > weiToSpend) {
            msg.sender.transfer(msg.value - weiToSpend);
        }

        QINPurchase(msg.sender, weiToSpend, QINToBuy);
    }

    // send purchased QIN tokens to buyer's address, ensure only the contract can call this
    function sendQIN(address _to, uint256 _amount) private {
        token.transfer(_to, _amount);
    }

    // @return true if the transaction can buy tokens
    function validPurchase() internal constant returns (bool) {
        bool duringCrowdsale = (block.timestamp >= startTime) && (block.timestamp <= endTime);
        bool nonZeroPurchase = msg.value != 0;
        return duringCrowdsale && nonZeroPurchase && !halted && crowdsaleTokensRemaining != 0;
    }

    // @return true if crowdsale event has ended
    function hasEnded() public constant returns (bool) {
        return block.timestamp > endTime || crowdsaleTokensRemaining == 0;
    }

    // burn remaining funds if goal not met
    function burnRemainder() external onlyOwner {
        require(hasEnded());
        if (crowdsaleTokensRemaining > 0) {
            token.transfer(0x0, crowdsaleTokensRemaining);
            Burn(crowdsaleTokensRemaining);
            assert(crowdsaleTokensRemaining == 0);
        }
    }

    function getState() public constant returns (State) {
      if (block.timestamp >= startTime + unixDay*2) {
        return State.SaleFFA;
      }
      else if (block.timestamp >= startTime + unixDay) {
        return State.SaleDay2;
      }
      else if (block.timestamp >= startTime) {
        return State.SaleDay1;
      }
      else {
        return State.BeforeSale;
      }
    }
}
