pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/QINToken.sol";
import "../contracts/tokensale/QINTokenSale.sol";
import "../contracts/libs/SafeMath256.sol";


/** @title QIN TokenSale Tests
 *  @author DaijoLabs <info@daijolabs.com>
 */
contract TestQINTokenSale3 {
    using SafeMath256 for uint;

    // Truffle will send the TestContract Ether after deploying the contract.
    uint public initialBalance = 10000000 ether; // enough to buy out entire supply of QIN
    uint public decimalMultiplier = 10 ** 18;

    function testTokenSaleFFASaleDays() {
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

        // Because this contract will also serve to be the purchaser, offload the QIN to the wallet for the sake
        // of simplicity of checks below.
        qin.transfer(wallet, qin.reserveSupply());

        // Check state transitions.
        Assert.isTrue(ts.getState() == QINTokenSale.State.BeforeSale, "BeforeSale expected");

        // Add this contract to the whitelist to allow QIN purchase.
        ts.addToWhitelist(this);
        ts.addToWhitelist(extraParticipant);

        // Test FFA Day:
        ts.setCurrentTime(startTime.add(3 days));
        Assert.isTrue(ts.getState() == QINTokenSale.State.SaleFFA, "SaleFFA expected");
        Assert.isTrue(address(ts).call.value(7000000 ether)(), "QIN purchase failed");
        Assert.equal(ts.weiRaised(), 6000000 ether, "weiRaised increased incorrectly");
        Assert.equal(ts.tokenSaleTokensRemaining(), 0, "Incorrect FFA day tokens remaining");
        Assert.equal(qin.balanceOf(this), rate.mul(6000000 ether), "Did not receive the expected amount of QIN");
        Assert.equal(this.balance, 4000000 ether, "Incorrect amount of ETH returned");

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
