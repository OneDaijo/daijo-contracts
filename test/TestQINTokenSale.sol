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
        uint8 restrictedDays = 3;
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
        Assert.isTrue(ts.getNumRestrictedDays() == restrictedDays, "Incorrect initial number of restricted days.");
        ts.setRestrictedSaleDays(5);
        Assert.isTrue(ts.getNumRestrictedDays() == 5, "Incorrect modified number of restricted days.");
    }
}
