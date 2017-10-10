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
    uint public initialBalance = 1 ether;
    uint public decimalMultiplier = 10 ** 18;

    function testTokenSaleNormalInitialization() {
        uint startTime = now + 1 days;
        uint endTime = now + 5 days;
        address wallet = 0x1234;
        address extraParticipant = 0x5678;
        uint8 restrictedDays = 3;
        uint rate = 10;
        QINToken qin = new QINToken(true);
        qin.startTokenSale(
            startTime,
            endTime,
            restrictedDays,
            10,
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

        ts.setCurrentTime(startTime);
        Assert.isTrue(ts.getState() == QINTokenSale.State.SaleRestrictedDay, "SaleRestrictedDay expected");
        Assert.isTrue(address(ts).call.value(500 finney)(), "QIN purchase failed");
        uint testDayOneLimit = ts.tokenSaleTokenSupply().div(ts.registeredUserCount());
        Assert.equal(ts.getRestrictedDayLimit(), testDayOneLimit, "First restricted day limit set incorrectly");
        Assert.equal(ts.weiRaised(), 500 finney, "weiRaised increased incorrectly");
        Assert.equal(ts.tokenSaleTokensRemaining(), ts.tokenSaleTokenSupply().sub(rate * 500 finney), "Incorrect tokens remaining");
        Assert.equal(qin.balanceOf(this), rate * 500 finney, "Did not receive the expected amount of QIN");
        ts.setCurrentTime(startTime + 1 days);
        Assert.isTrue(ts.getState() == QINTokenSale.State.SaleRestrictedDay, "SaleRestrictedDay expected");
        Assert.isTrue(address(ts).call.value(500 finney)(), "QIN purchase failed");
        uint testDayTwoLimit = (ts.tokenSaleTokensRemaining().add(rate * 500 finney)).div(ts.registeredUserCount());
        Assert.equal(ts.getRestrictedDayLimit(), testDayTwoLimit, "Second restricted day limit set incorrectly");
        ts.setCurrentTime(startTime + 3 days);
        Assert.isTrue(ts.getState() == QINTokenSale.State.SaleFFA, "SaleFFA expected");
        ts.setCurrentTime(endTime);
        Assert.isTrue(ts.getState() == QINTokenSale.State.SaleComplete, "SaleComplete expected");
    }

    function () public payable {
        // This is here to allow this test contract to be paid in ETH without throwing.
    }

    function tokenFallback() public {
        // This is here to allow this test contract to be paid in QIN without throwing.
    }
}
