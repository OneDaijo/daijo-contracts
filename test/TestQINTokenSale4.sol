pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/QINToken.sol";
import "../contracts/tokensale/QINTokenSale.sol";


/** @title QIN TokenSale Tests
 *  @author DaijoLabs <info@daijolabs.com>
 */
contract TestQINTokenSale4 {

    // Truffle will send the TestContract one Ether after deploying the contract.
    uint public initialBalance = 10000000 ether; // enough to buy out entire supply of QIN
    uint public decimalMultiplier = 10 ** 18;

    function testTokenSaleHasEnded() {
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
            rate,
            wallet
        );

        QINTokenSale ts = qin.getTokenSale();

        Assert.isFalse(ts.hasEnded(), "Token sale should not have ended on construction");
        qin.transfer(wallet, qin.reserveSupply());
        ts.addToWhitelist(this);
        Assert.isFalse(ts.hasEnded(), "Token sale should not have ended before it begins");
        ts.setCurrentTime(endTime);
        Assert.isTrue(ts.hasEnded(), "Token sale should have ended");
        ts.setCurrentTime(startTime + 3 days);
        Assert.isFalse(ts.hasEnded(), "Token sale should not have ended during the sale with tokens remaining");
        Assert.isTrue(address(ts).call.value(3000000 ether)(), "QIN purchase failed");
        Assert.isFalse(ts.hasEnded(), "Token sale should not have ended with tokens remaining");
        Assert.isTrue(address(ts).call.value(3000000 ether)(), "QIN purchase failed");
        Assert.isTrue(ts.hasEnded(), "Token sale should have ended with no tokens remaining");
    }

    function testTokenSaleBurnRemainder() {
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
            rate,
            wallet
        );

        QINTokenSale ts = qin.getTokenSale();

        qin.transfer(wallet, qin.reserveSupply());
        ts.setCurrentTime(startTime);
        ts.setCurrentTime(endTime);
        ts.burnRemainder();
        Assert.equal(ts.tokenSaleTokensRemaining(), 0, "Tokens remaining was incorrectly set");
        Assert.equal(qin.balanceOf(address(ts)), 0, "Tokens were not burned");
    }

    function () public payable {
        // This is here to allow this test contract to be paid in ETH without throwing.
    }

    function tokenFallback() public {
        // This is here to allow this test contract to be paid in QIN without throwing.
    }
}
