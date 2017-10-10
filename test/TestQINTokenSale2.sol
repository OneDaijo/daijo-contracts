pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/QINToken.sol";
import "../contracts/tokensale/QINTokenSale.sol";


/** @title QIN TokenSale Tests
 *  @author DaijoLabs <info@daijolabs.com>
 */
contract TestQINTokenSale2 {

    // Truffle will send the TestContract one Ether after deploying the contract.
    uint public initialBalance = 1 ether;
    uint public decimalMultiplier = 10 ** 18;

    function testTokenSaleNormalInitialization() {
        uint startTime = now + 1 days;
        uint endTime = now + 5 days;
        address wallet = 0x1234;
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

        Assert.equal(qin.balanceOf(this), 140000000 * decimalMultiplier, "Owner not granted the correct amount of reserve QIN");

        // Because this contract will also serve to be the purchaser, offload the QIN to the wallet for the sake
        // of simplicity of checks below.
        qin.transfer(wallet, 140000000 * decimalMultiplier);
        Assert.equal(qin.balanceOf(this), 0, "Transfer function did not transfer the correct amount of QIN");

        // Check state transitions.
        Assert.isTrue(ts.getState() == QINTokenSale.State.BeforeSale, "BeforeSale expected");

        // Add this contract to the whitelist to allow QIN purchase.
        ts.addToWhitelist(this);

        ts.setCurrentTime(startTime);
        Assert.isTrue(ts.getState() == QINTokenSale.State.SaleRestrictedDay, "SaleRestrictedDay expected");
        Assert.isTrue(address(ts).call.value(1 ether)(), "QIN purchase failed");
        Assert.equal(qin.balanceOf(this), rate * 1 ether, "Did not receive the expected amount of QIN");
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
