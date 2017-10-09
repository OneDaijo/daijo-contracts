pragma solidity ^0.4.13;

import '../token/interfaces/ERC223ReceivingContract.sol';
import '../token/QINFrozen.sol';
import '../token/QINToken.sol';
import '../libs/SafeMath256.sol';
import '../libs/SafeMath8.sol';
import '../permissions/Controllable.sol';
import '../permissions/Testable.sol';
import '../permissions/Ownable.sol';
import '../permissions/BuyerStore.sol';


/** @title QIN Token TokenSale Contract
 *  @author DaijoLabs <info@daijolabs.com>
 */
contract QINTokenSale is ERC223ReceivingContract, Controllable, Testable, BuyerStore {
    using SafeMath8 for uint8;
    using SafeMath256 for uint;

    /* QIN Token TokenSale */

    // The token being sold
    QINToken public token;

    // QINTokens will be sent from this address
    address public wallet;

    // start and end UNIX timestamp where investments are allowed
    uint public startTime;
    uint public endTime;

    struct RestrictedSaleDays {
        uint8 numRestrictedDays;
        uint8 saleDay;
        uint dailyReset;
    }

    RestrictedSaleDays internal rsd;

    // how many token units a buyer gets per wei
    uint public rate;

    // amount of raised money in wei
    uint public weiRaised;

    // total amount and amount remaining of QIN in the tokenSale
    uint public tokenSaleTokenSupply;
    uint public tokenSaleTokensRemaining;

    uint private restrictedDayLimit; // set on each subsequent restricted day

    // whether QIN has been transferred to the tokenSale contract
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

    function QINTokenSale(
        QINToken _token,
        uint _startTime,
        uint _endTime,
        uint8 _days,
        uint _rate,
        address _wallet) Testable(_token.getTestState())
    {

        require(_startTime >= getCurrentTime());
        require(_endTime >= _startTime);
        require(_rate > 0);
        require(_wallet != 0x0);

        token = _token;
        startTime = _startTime;
        endTime = _endTime;
        rate = _rate; // Qin per ETH = 400, subject to change
        wallet = _wallet;

        rsd.numRestrictedDays = _days;
        rsd.dailyReset = _startTime.sub(1 days);
    }

    function setRestrictedSaleDays(uint8 _days) external onlyOwner {
        rsd.numRestrictedDays = _days;
    }

    function getNumRestrictedDays() external constant returns (uint8) {
        return rsd.numRestrictedDays;
    }

    // TODO: This assumes ERC223 - which should be added
    function tokenFallback(address _from, uint _value, bytes) external {
        // Require that the paid token is supported
        require(supportsToken(msg.sender));

        // Ensures this function has only been run once
        require(!hasBeenSupplied);

        // TokenSale can only be paid by the owner of the tokenSale.
        require(_from == owner);

        // Sanity check to ensure that QIN was correctly transferred
        require(_value > 0);
        assert(token.balanceOf(this) == _value);

        tokenSaleTokenSupply = _value;
        tokenSaleTokensRemaining = _value;
        hasBeenSupplied = true;
    }

    function supportsToken(address _token) public constant returns (bool) {
        // The only ERC223 token that can be paid to this contract is QIN
        return _token == address(token);
    }

    // fallback function can be used to buy tokens
    function () external payable {
        buyQIN();
    }

    // low level QIN token purchase function
    function buyQIN() onlyIfActive onlyWhitelisted public payable {
        State currentCrowdsaleState = getState();
        require(validPurchase(currentCrowdsaleState));

        address buyer = msg.sender;
        Buyer storage b = buyers[buyer];
        require(b.isRegistered);
        uint weiToSpend = msg.value;

        // calculate token amount to be sent
        uint qinToBuy = weiToSpend.mul(rate);

        uint time = getCurrentTime();
        if (time >= rsd.dailyReset.add(1 days)) { // will only evaluate to true on first sale each subsequent day
            uint8 dayIncrement = time.sub(rsd.dailyReset).div(1 days).castToUint8();
            rsd.dailyReset = rsd.dailyReset.add(uint(1 days).mul(dayIncrement));
            rsd.saleDay = rsd.saleDay.add(dayIncrement);
            if (currentCrowdsaleState == State.SaleRestrictedDay) {
                restrictedDayLimit = tokenSaleTokensRemaining.div(registeredUserCount);
            }
        }

        if (currentCrowdsaleState == State.SaleRestrictedDay) {
            if (b.lastRestrictedDayBought < rsd.saleDay) {
                b.amountBoughtCurrentRestrictedDay = 0;
                b.lastRestrictedDayBought = rsd.saleDay;
            }

            require(b.amountBoughtCurrentRestrictedDay < restrictedDayLimit); // throw if buyer has hit restricted day limit
            if (qinToBuy > restrictedDayLimit.sub(b.amountBoughtCurrentRestrictedDay)) {
                qinToBuy = restrictedDayLimit.sub(b.amountBoughtCurrentRestrictedDay);
            }

            // qinToBuy will not be modified after this, so add to the buyer's count.
            b.amountBoughtCurrentRestrictedDay = b.amountBoughtCurrentRestrictedDay.add(qinToBuy);

        } else if (currentCrowdsaleState == State.SaleFFA) {
            if (qinToBuy > tokenSaleTokensRemaining) {
                qinToBuy = tokenSaleTokensRemaining;
            }
        }

        b.amountBoughtCumulative = b.amountBoughtCumulative.add(qinToBuy);
        tokenSaleTokensRemaining = tokenSaleTokensRemaining.sub(qinToBuy);

        // Will technically round down the amount of wei if this doesn't
        // divide evenly, so the last person could get 1/2 a wei extra of QIN.
        weiToSpend = qinToBuy.div(rate);

        // update amount of wei raised
        weiRaised = weiRaised.add(weiToSpend);

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
    function validPurchase(State state) internal constant returns (bool) {
        bool validPurchaseState = state != State.SaleComplete && state != State.BeforeSale;
        bool nonZeroPurchase = msg.value != 0;
        return validPurchaseState && nonZeroPurchase && !halted;
    }

    // @return true if tokenSale event has ended
    function hasEnded() public constant returns (bool) {
        return getCurrentTime() >= endTime || (hasBeenSupplied && tokenSaleTokensRemaining == 0) || manualEnd;
    }

    // burn remaining funds if goal not met
    function burnRemainder() external onlyOwner {
        require(hasEnded());
        if (tokenSaleTokensRemaining > 0) {
            token.transfer(0x0, tokenSaleTokensRemaining);
            Burn(tokenSaleTokensRemaining);
            assert(tokenSaleTokensRemaining == 0);
            assert(token.balanceOf(this) == 0);
        }
    }

    // Deposit the ETH received by the token sale to the designated wallet.  Must be run after the token sale has ended.
    function depositFunds() onlyOwner external {
        require(getState() == State.SaleComplete);
        wallet.transfer(this.balance);
    }

    function getState() public constant returns (State) {
        uint time = getCurrentTime();
        if (hasEnded()) {
            return State.SaleComplete;
        } else if (time >= startTime.add(uint(1 days).mul(rsd.numRestrictedDays))) {
            return State.SaleFFA;
        } else if (time >= startTime) {
            return State.SaleRestrictedDay;
        } else {
            return State.BeforeSale;
        }
    }
}
