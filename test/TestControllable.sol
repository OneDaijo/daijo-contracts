pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/QINToken.sol";
import "../contracts/tokensale/QINTokenSale.sol";
import "../contracts/permissions/Controllable.sol";
import "../contracts/libs/SafeMath256.sol";


/** @title QIN TokenSale Tests
 *  @author DaijoLabs <info@daijolabs.com>
 */
contract TestControllable {
    using SafeMath256 for uint;

    // Truffle will send the TestContract one Ether after deploying the contract.
    uint public initialBalance = 10000000 ether; // enough to buy out entire supply of QIN
    uint public decimalMultiplier = 10 ** 18;

    function testControllableHaltAndManualEnd() {
        uint startTime = now.add(1 days);
        uint endTime = now.add(5 days);
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

        // Add this contract to the whitelist to allow QIN purchase.
        ts.addToWhitelist(this);

        // Test functions while halted = false
        ts.setCurrentTime(startTime);
        Assert.isTrue(address(ts).call.value(1 ether)(), "QIN purchase failed");
        ts.haltTokenSale();
        Assert.isFalse(address(ts).call.value(1 ether)(), "QIN purchase should have failed");
        ts.unhaltTokenSale();

        // Test end token sale while halted = true
        ts.haltTokenSale();
        ts.endTokenSale();
        Assert.isTrue(ts.hasEnded(), "Token sale should have been manually ended");
    }

    function () public payable {
        // This is here to allow this test contract to be paid in ETH without throwing.
    }

    function tokenFallback() public {
        // This is here to allow this test contract to be paid in QIN without throwing.
    }
}
