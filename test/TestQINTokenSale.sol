pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/QINToken.sol";
import "../contracts/tokensale/QINTokenSale.sol";


/** @title QIN TokenSale Tests
 *  @author DaijoLabs <info@daijolabs.com>
 */
contract TestQINTokenSale {

    function testTokenSaleManualInitialization() {
        uint startTime = now + 100;
        uint endTime = now + 200;
        address wallet = 0x1234;
        uint restrictedDays = 3;
        uint rate = 10;
        QINToken qin = new QINToken(true);
        QINTokenSale ts = new QINTokenSale(
            qin,
            startTime,
            endTime,
            restrictedDays,
            rate,
            wallet
        );

        // Check constructor args.
        Assert.equal(ts.startTime(), startTime, "Incorrect startTime.");
        Assert.equal(ts.endTime(), endTime, "Incorrect endTime.");
        Assert.equal(ts.rate(), rate, "Incorrect rate.");
        Assert.equal(ts.wallet(), wallet, "Incorrect wallet address.");

        // Check initialized state
        Assert.equal(ts.owner(), this, "Not the correct owner.");
        Assert.isTrue(ts.supportsToken(qin), "supportsToken() is rejecting QIN.");
        Assert.isTrue(ts.getState() == QINTokenSale.State.BeforeSale, "BeforeSale expected");

        // Check post-funding state.
        qin.transfer(ts, 100);
        Assert.isTrue(ts.hasBeenSupplied(), "tokenFallback was not called.");

        // Check registration setters and getters.
        Assert.equal(ts.registeredUserCount(), 0, "Incorrect initial user count.");
        Assert.isFalse(ts.getUserRegistrationState(userWallet), "User status should not be set to registered");
        address userWallet = 0x5678;
        ts.addToWhitelist(userWallet);
        Assert.equal(ts.registeredUserCount(), 1, "Incorrect new user count.");
        Assert.isTrue(ts.getUserRegistrationState(userWallet), "User status should be set to registered");

        // Check registration days setter and getter
        Assert.equal(ts.numRestrictedDays(), restrictedDays, "Incorrect initial number of restricted days.");
        ts.setRestrictedSaleDays(5);
        Assert.equal(ts.numRestrictedDays(), 5, "Incorrect modified number of restricted days.");
    }

    function testTokenSaleNormalInitialization() {
        uint startTime = now + 1 days;
        uint endTime = now + 5 days;
        address wallet = 0x1234;
        uint restrictedDays = 3;
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
        Assert.equal(ts.numRestrictedDays(), restrictedDays, "Incorrect initial number of restricted days.");
        Assert.equal(ts.wallet(), wallet, "Incorrect wallet address.");
        Assert.equal(ts.owner(), this, "Not the correct owner");
        Assert.isTrue(ts.supportsToken(qin), "supportsToken() is rejecting QIN.");
        Assert.isTrue(ts.hasBeenSupplied(), "tokenFallback was not called.");
        Assert.equal(ts.registeredUserCount(), 0, "Should be Initialized with 0 users whitelisted");

        // Check state transitions.
        Assert.isTrue(ts.getState() == QINTokenSale.State.BeforeSale, "BeforeSale expected");
        ts.setCurrentTime(startTime);
        Assert.isTrue(ts.getState() == QINTokenSale.State.SaleRestrictedDay, "SaleRestrictedDay expected");
        ts.setCurrentTime(startTime + 3 days);
        Assert.isTrue(ts.getState() == QINTokenSale.State.SaleFFA, "SaleFFA expected");
        ts.setCurrentTime(endTime);
        Assert.isTrue(ts.getState() == QINTokenSale.State.SaleComplete, "SaleComplete expected");
    }
}
