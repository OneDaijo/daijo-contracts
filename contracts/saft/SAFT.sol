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


/** @title QIN Token SAFT Contract
 *  @author DaijoLabs <info@daijolabs.com>
 */
contract SAFT is ERC223ReceivingContract, Controllable, Testable, BuyerStore {
    using SafeMath8 for uint8;
    using SafeMath256 for uint;

    /* QIN Token SAFT */

    // The token being sold
    QINToken public token;

    // QINTokens will be sent from this address
    address public wallet;

    // start and end UNIX timestamp where investments are allowed
    uint public startTime;
    uint public endTime;

    // how many token units an investor gets per wei
    uint public rate;

    // amount of raised money in wei
    uint public weiRaised;

    // total amount and amount remaining of QIN in the SAFT
    uint public saftTokenSupply;
    uint public saftTokensRemaining;

    // whether QIN has been transferred to the SAFT contract
    bool public hasBeenSupplied = false;

    /* State Machine for each day of sale */
    enum State {BeforeSAFT, SAFTActive, SAFTComplete}

    /**
     * event for token purchase logging
     * @param purchaser who paid for and will receive the tokens
     * @param value weis paid for purchase
     * @param amount amount of tokens purchased
     */
    event QINPurchase(address indexed purchaser, uint value, uint amount);

    /**
     * event that notifies clients about the amount burned
     * @param value the value burned
     */
    event Burn(uint value);

    function SAFT(
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
    }

    // TODO: This assumes ERC223 - which should be added
    function tokenFallback(address _from, uint _value, bytes) external {
        // Require that the paid token is supported
        require(supportsToken(msg.sender));

        // Ensures this function has only been run once
        require(!hasBeenSupplied);

        // SAFT can only be paid by the owner of the SAFT.
        require(_from == owner);

        // Sanity check to ensure that QIN was correctly transferred
        require(_value > 0);
        assert(token.balanceOf(this) == _value);

        saftTokenSupply = _value;
        saftTokensRemaining = _value;
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

        if (qinToBuy > saftTokensRemaining) {
            qinToBuy = saftTokensRemaining;
        }

        b.amountBoughtCumulative = b.amountBoughtCumulative.add(qinToBuy);
        saftTokensRemaining = saftTokensRemaining.sub(qinToBuy);

        // Will technically round down the amount of wei if this doesn't
        // divide evenly, so the last person could get 1/2 a wei extra of QIN.
        weiToSpend = qinToBuy.div(rate);

        // update amount of wei raised
        weiRaised = weiRaised.add(weiToSpend);

        // Refund any unspend wei.
        if (msg.value > weiToSpend) {
            msg.sender.transfer(msg.value.sub(weiToSpend));
        }
        QINPurchase(msg.sender, weiToSpend, qinToBuy);
    }

    // send purchased QIN tokens to buyer's address, ensure only the contract can call this
    function sendQIN(address _to, uint _amount) private {
        token.transfer(_to, _amount);
    }

    // @return true if the transaction can buy tokens
    function validPurchase(State state) internal constant returns (bool) {
        bool validPurchaseState = state != State.SAFTComplete && state != State.BeforeSAFT;
        bool nonZeroPurchase = msg.value != 0;
        return validPurchaseState && nonZeroPurchase && !halted;
    }

    // @return true if SAFT event has ended
    function hasEnded() public constant returns (bool) {
        return getCurrentTime() >= endTime || (hasBeenSupplied && saftTokensRemaining == 0) || manualEnd;
    }

    // burn remaining funds if goal not met
    function burnRemainder() external onlyOwner {
        require(hasEnded());
        if (saftTokensRemaining > 0) {
            token.transfer(0x0, saftTokensRemaining);
            Burn(saftTokensRemaining);
            saftTokensRemaining = 0;
            assert(token.balanceOf(this) == 0);
        }
    }

    // Deposit the ETH received by the token sale to the designated wallet.  Must be run after the token sale has ended.
    function depositFunds() onlyOwner external {
        require(getState() == State.SAFTComplete);
        wallet.transfer(this.balance);
    }

    function getState() public constant returns (State) {
        uint time = getCurrentTime();
        if (hasEnded()) {
            return State.SAFTComplete;
        } else if (time > startTime  && time < endTime) {
            return State.SAFTActive;
        } else {
            return State.BeforeSAFT;
        }
    }
}
