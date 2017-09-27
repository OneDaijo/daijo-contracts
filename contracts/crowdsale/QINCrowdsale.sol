pragma solidity ^0.4.13;

import '../token/interfaces/ERC223ReceivingContract.sol';
import '../token/QINFrozen.sol';
import '../libs/SafeMath.sol';
import '../permissions/Controllable.sol';
import '../permissions/Ownable.sol';


/** @title QIN Token Crowdsale Contract
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 */

contract QINCrowdsale is ERC223ReceivingContract, Controllable {
    using SafeMath for uint256;

/* QIN Token Crowdsale */

    // The token being sold
    QINToken public token;

    // QINTokens will be sent from this address
    address public wallet;

    // start and end UNIX timestamp where investments are allowed
    uint public startTime;
    uint public endTime;

    uint public numRestrictedDays;
    bool public saleHasStarted = false;
    uint public saleDay = 0;
    uint public dailyReset;
    uint public constant UNIX_DAY = 24*60*60;
    uint public dayIncrement;

    // how many token units a buyer gets per wei
    uint public rate;

    // amount of raised money in wei
    uint public weiRaised;

    mapping (address => uint) amountBoughtCumulative;

    // total amount and amount remaining of QIN in the crowdsale
    uint public crowdsaleTokenSupply;
    uint public crowdsaleTokensRemaining;

    uint private restrictedDayLimit; // set on each subsequent restricted day
    uint private cumulativeLimit;
    bool private restrictedDayLimitSet;

    // whether QIN has been transferred to the crowdsale contract
    bool public hasBeenSupplied = false;

    /* State Machine for each day of sale */
    enum State {BeforeSale, SaleRestrictedDay, SaleFFA, SaleComplete}

    /**
     * event for token purchase logging
     * @param purchaser who paid for and receives the tokens
     * @param value weis paid for purchase
     * @param amount amount of tokens purchased
     */
    event QINPurchase(address indexed purchaser, uint value, uint amount);

    /**
     * event that notifies clients about the amount burned
     * @param value the value burned
     */
    event Burn(uint value);

    function QINCrowdsale(
        QINToken _token,
        uint _startTime,
        uint _endTime,
        uint _days,
        uint _rate,
        address _wallet) {

        require(_startTime >= now);
        require(_endTime >= _startTime);
        require(_rate > 0);
        require(_wallet != 0x0);

        token = _token;
        startTime = _startTime;
        dailyReset = _startTime;
        endTime = _endTime;
        numRestrictedDays = _days;
        rate = _rate; // Qin per ETH = 400, subject to change
        wallet = _wallet;
    }

    function setRestrictedSaleDays(uint _days) external onlyOwner {

        numRestrictedDays = _days;
    }


    // TODO: This assumes ERC223 - which should be added
    function tokenFallback(address _from, uint _value, bytes) external {
        // Require that the paid token is supported
        require(supportsToken(msg.sender));

        // Ensures this function has only been run once
        require(!hasBeenSupplied);

        // Crowdsale can only be paid by the owner of the crowdsale.
        require(_from == owner);

        // Sanity check to ensure that QIN was correctly transferred
        require(_value > 0);
        assert(token.balanceOf(this) == _value);

        crowdsaleTokenSupply = _value;
        crowdsaleTokensRemaining = _value;
        hasBeenSupplied = true;
    }

    function supportsToken(address _token) public constant returns (bool) {
        // The only ERC223 token that can be paid to this contract is QIN
        return _token == address(token);
    }

    // fallback function can be used to buy tokens
    function () external payable {
        buyQINTokensWithRegisteredAddress(msg.sender);
    }

    // low level QIN token purchase function
    function buyQINTokensWithRegisteredAddress(address buyer) onlyIfActive onlyWhitelisted private {
        require(validPurchase());
        require(getState() != State.SaleComplete);
        uint weiToSpend = msg.value;

        // calculate token amount to be sent
        uint qinToBuy = weiToSpend.mul(rate);

        if (!saleHasStarted) { // runs once upon the first transaction of the crowdsale
            saleHasStarted = true;
            saleDay = saleDay.add(1);
        }

        if (now >= dailyReset.add(UNIX_DAY)) { // will only evaluate to true on first sale each subsequent day
            dayIncrement = now.sub(dailyReset).div(UNIX_DAY);
            dailyReset = dailyReset.add(dayIncrement.mul(UNIX_DAY));
            saleDay = saleDay.add(dayIncrement);
            if (getState() == State.SaleRestrictedDay) {
                restrictedDayLimit = crowdsaleTokensRemaining.div(registeredUserCount);
                cumulativeLimit = cumulativeLimit.add(restrictedDayLimit.mul(dayIncrement));
            }
        }

        if (getState() == State.SaleRestrictedDay) {
            require(amountBoughtCumulative[buyer] < cumulativeLimit); // throw if buyer has hit restricted day limit
            if (qinToBuy > cumulativeLimit.sub(amountBoughtCumulative[buyer])) {
                qinToBuy = cumulativeLimit.sub(amountBoughtCumulative[buyer]); // set qinToBuy to remaining daily limit if buy order goes over
            }
            weiToSpend = qinToBuy.div(rate);
        } else if (getState() == State.SaleFFA) {
            if (qinToBuy > crowdsaleTokensRemaining) {
                qinToBuy = crowdsaleTokensRemaining;
            }

            // Will technically round down the amount of wei if this doesn't
            // divide evenly, so the last person could get 1/2 a wei extra of QIN.
            // TODO: improve this logic
            weiToSpend = qinToBuy.div(rate);
        }

        crowdsaleTokensRemaining = crowdsaleTokensRemaining.sub(qinToBuy);

        // update amount of wei raised
        weiRaised = weiRaised.add(weiToSpend);

        // send ETH to the fund collection wallet
        // Note: could consider a mutex-locking function modifier instead or in addition to this.  This also poses complexity and security concerns.
        wallet.transfer(weiToSpend);
        amountBoughtCumulative[buyer] = amountBoughtCumulative[buyer].add(qinToBuy);

        // Refund any unspend wei.
        if (msg.value > weiToSpend) {
            msg.sender.transfer(msg.value.sub(weiToSpend));
        }

        // send purchased QIN to the buyer
        sendQIN(msg.sender, qinToBuy);
        QINPurchase(msg.sender, weiToSpend, qinToBuy);
    }

    // send purchased QIN tokens to buyer's address, ensure only the contract can call this
    function sendQIN(address _to, uint _amount) private {
        token.transfer(_to, _amount);
    }

    // @return true if the transaction can buy tokens
    function validPurchase() internal constant returns (bool) {
        bool duringCrowdsale = (now >= startTime) && (now <= endTime);
        bool nonZeroPurchase = msg.value != 0;
        return duringCrowdsale && nonZeroPurchase && !halted && crowdsaleTokensRemaining != 0;
    }

    // @return true if crowdsale event has ended
    function hasEnded() public constant returns (bool) {
        return now > endTime || crowdsaleTokensRemaining == 0 || manualEnd;
    }

    // burn remaining funds if goal not met
    function burnRemainder() external onlyOwner {
        require(hasEnded());
        if (crowdsaleTokensRemaining > 0) {
            token.transfer(0x0, crowdsaleTokensRemaining);
            Burn(crowdsaleTokensRemaining);
            assert(crowdsaleTokensRemaining == 0);
            assert(token.balanceOf(this) == 0);
        }
    }

    function getState() public constant returns (State) {
        if (hasEnded()) {
            return State.SaleComplete;
        } else if (saleDay > numRestrictedDays) {
            return State.SaleFFA;
        } else if (now >= startTime.add(UNIX_DAY.mul(saleDay.sub(1)))) {
            return State.SaleRestrictedDay;
        } else {
            return State.BeforeSale;
        }
    }
}
