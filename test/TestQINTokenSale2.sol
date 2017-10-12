pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/QINToken.sol";
import "../contracts/tokensale/QINTokenSale.sol";
import "../contracts/libs/SafeMath256.sol";


/** @title QIN TokenSale Tests
 *  @author DaijoLabs <info@daijolabs.com>
 */
contract TestQINTokenSale2 {
    using SafeMath256 for uint;

    // Truffle will send the TestContract one Ether after deploying the contract.
    uint public initialBalance = 10000000 ether; // enough to buy out entire supply of QIN
    uint public decimalMultiplier = 10 ** 18;

    function testTokenSaleNormalInitialization() {
        uint startTime = now.add(1 days);
        uint endTime = now.add(5 days);
        address wallet = 0x1234;
        address extraParticipant = 0x5678;
        uint8 restrictedDays = 3;
        uint rate = 10;
        QINToken qin = new QINToken(true);
        qin.startTokenSale(
            startTime,
            endTime,
            restrictedDays,
            rate,
            wallet
        );

        QINTokenSale ts = qin.getTokenSale();

        // Tests are similar to the above, but initialization goes through a different path.
        Assert.equal(ts.startTime(), startTime, "Incorrect startTime.");
        Assert.equal(ts.endTime(), endTime, "Incorrect endTime.");
        Assert.equal(ts.rate(), rate, "Incorrect rate.");
        Assert.isTrue(ts.getNumRestrictedDays() == restrictedDays, "Incorrect initial number of restricted days.");
        Assert.equal(ts.wallet(), wallet, "Incorrect wallet address.");
        Assert.equal(ts.owner(), this, "Not the correct owner");
        Assert.isTrue(ts.supportsToken(qin), "supportsToken() is rejecting QIN.");
        Assert.isTrue(ts.hasBeenSupplied(), "tokenFallback was not called.");
        Assert.equal(ts.registeredUserCount(), 0, "Should be Initialized with 0 users whitelisted");

        Assert.equal(qin.balanceOf(this), qin.reserveSupply(), "Owner not granted the correct amount of reserve QIN");

        // Because this contract will also serve to be the purchaser, offload the QIN to the wallet for the sake
        // of simplicity of checks below.
        qin.transfer(wallet, qin.reserveSupply());
        Assert.equal(qin.balanceOf(this), 0, "Transfer function did not transfer the correct amount of QIN");
        Assert.equal(ts.tokenSaleTokenSupply(), qin.tokenSaleSupply(), "tokenSaleTokenSupply not set correctly");

        // Check state transitions.
        Assert.isTrue(ts.getState() == QINTokenSale.State.BeforeSale, "BeforeSale expected");

        // Add this contract to the whitelist to allow QIN purchase.
        ts.addToWhitelist(this);
        Assert.equal(ts.registeredUserCount(), 1, "Incorrect registered user count");
        ts.addToWhitelist(extraParticipant);
        Assert.equal(ts.registeredUserCount(), 2, "Incorrect registered user count");

        // Test Restricted Day 1: First transaction overshoots daily limit, expect
        // restrictedDayLimit to be enforced, and for second transaction to throw
        ts.setCurrentTime(startTime);
        Assert.isTrue(ts.getState() == QINTokenSale.State.SaleRestrictedDay, "SaleRestrictedDay expected");
        // First transaction, intentionally over intended daily limit
        Assert.isTrue(address(ts).call.value(3100000 ether)(), "QIN purchase failed");
        uint testDayOneLimit = ts.tokenSaleTokenSupply().div(ts.registeredUserCount());
        Assert.equal(ts.getRestrictedDayLimit(), testDayOneLimit, "First restricted day limit set incorrectly");
        Assert.equal(ts.weiRaised(), 3000000 ether, "weiRaised increased incorrectly");
        Assert.equal(ts.tokenSaleTokensRemaining(), ts.tokenSaleTokenSupply().sub(rate * 3000000 ether), "Incorrect first day tokens remaining");
        Assert.equal(qin.balanceOf(this), rate.mul(3000000 ether), "Did not receive the expected amount of QIN");
        Assert.equal(this.balance, 7000000 ether, "Incorrect amount of ETH returned");
        // Second purchase, should throw due to maxed out purchase limit
        Assert.isFalse(address(ts).call.value(1 ether)(), "QIN purchase failed");
        Assert.equal(this.balance, 7000000 ether, "Incorrect amount of ETH returned");

        // Test Restricted Day 2: First transaction buys arbitrary amount of QIN under
        // restrictedDailyLimit, second transaction expected to be limited by restrictedDailyLimit
        // when combined with first transaction, third transaction expected to throw.
        ts.setCurrentTime(startTime.add(1 days));
        Assert.isTrue(ts.getState() == QINTokenSale.State.SaleRestrictedDay, "SaleRestrictedDay expected");
        // First transaction, arbitrary amount under limit
        Assert.isTrue(address(ts).call.value(1000000 ether)(), "QIN purchase failed");
        uint testDayTwoLimit = (ts.tokenSaleTokensRemaining().add(rate * 1000000 ether)).div(ts.registeredUserCount());
        Assert.equal(ts.getRestrictedDayLimit(), testDayTwoLimit, "Second restricted day limit set incorrectly");
        Assert.equal(ts.weiRaised(), 4000000 ether, "weiRaised increased incorrectly");
        Assert.equal(ts.tokenSaleTokensRemaining(), ts.tokenSaleTokenSupply().sub(rate * 4000000 ether), "Incorrect second day tokens remaining");
        Assert.equal(qin.balanceOf(this), rate.mul(4000000 ether), "Did not receive the expected amount of QIN");
        // Second transaction, expected to be limited by restrictedDailyLimit
        Assert.isTrue(address(ts).call.value(2000000 ether)(), "QIN purchase failed");
        Assert.equal(ts.weiRaised(), 4500000 ether, "weiRaised increased incorrectly");
        Assert.equal(ts.tokenSaleTokensRemaining(), ts.tokenSaleTokenSupply().sub(rate * 4500000 ether), "Incorrect second day tokens remaining");
        Assert.equal(qin.balanceOf(this), rate.mul(4500000 ether), "Did not receive the expected amount of QIN");
        Assert.equal(this.balance, 5500000 ether, "Incorrect amount of ETH returned");
        // Third transaction, expected to throw
        Assert.isFalse(address(ts).call.value(1 ether)(), "QIN purchase failed");
        Assert.equal(this.balance, 5500000 ether, "Incorrect amount of ETH returned");

        // Test FFA Day:
        ts.setCurrentTime(startTime.add(3 days));
        Assert.isTrue(ts.getState() == QINTokenSale.State.SaleFFA, "SaleFFA expected");
        ts.setCurrentTime(endTime);
        Assert.isTrue(ts.getState() == QINTokenSale.State.SaleComplete, "SaleComplete expected");

        ts.depositFunds();
        Assert.equal(wallet.balance, 4500000 ether, "Incorrect amount of ether was deposited");
    }

    function () public payable {
        // This is here to allow this test contract to be paid in ETH without throwing.
    }

    function tokenFallback() public {
        // This is here to allow this test contract to be paid in QIN without throwing.
    }
}
