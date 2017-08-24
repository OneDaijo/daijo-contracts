pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "../contracts/token/QINToken.sol";
import "../contracts/libs/SafeMath.sol";

/** @title QIN Token Test
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 */
contract TestQINToken {
    using SafeMath for uint256;

    uint decimalMultiplier = 10**18; 

    // this tests the initial balance of QIN tokens when deployed as a contract
    function testInitialBalanceWithNewQINToken() {
        QINToken qin = new QINToken();
        uint expected = qin.frozenSupply() + qin.crowdsaleSupply();

        Assert.equal(qin.balanceOf(this), expected, "Owner should have fozenSupply + crowdsaleSupply initially.");
    }

    function testNewQINTokenOwner() {
        QINToken qin = new QINToken();
        address expected = this;

        Assert.equal(qin.owner(), expected, "Sender should be initial owner.");
    }

    function testTotalSupplyAfterConstruction() {
        QINToken qin = new QINToken();
        uint totalSupply = qin.totalSupply();

        Assert.equal(totalSupply, decimalMultiplier.mul(200000000), "Total supply incorrect.");
    }

    function testCorrectAllowanceAmountAfterApproval() {
        QINToken qin = new QINToken();
        qin.approve(0x1234, 100);
        uint result = qin.allowance(qin.owner(), 0x1234);

        Assert.equal(result, 100, "Incorrect allowance amount.");
    }

    function testCorrectBalancesAfterTransfer() {
        QINToken qin = new QINToken();
        qin.transfer(0x1234, decimalMultiplier.mul(200000000));
        uint balance0 = qin.balanceOf(qin.owner());
        uint balance1 = qin.balanceOf(0x1234);

        Assert.equal(balance0, 0, "Incorrect sender balance.");
        Assert.equal(balance1, decimalMultiplier.mul(200000000), "Incorrect receiver balance.");
    }

    // Test works if qin.transferFrom() were initiated by 0x5678
    function testCorrectBalancesAfterTransferringFromAnotherAccount() {
        QINToken qin = new QINToken();
        Assert.isTrue(qin.approve(0x1234, 100), "address 1 approval failed");
        Assert.isTrue(qin.approve(this, 100), "address 2 approval failed");
        Assert.isTrue(qin.transferFrom(this, 0x5678, 100), "address 2 transfer failed");
        uint balance0 = qin.balanceOf(this);
        uint balance1 = qin.balanceOf(0x1234);
        uint balance2 = qin.balanceOf(0x5678);
        uint allowance = qin.allowance(qin.owner(), 0x1234);

        Assert.equal(allowance, 100, "Target was not approved correct amount."); // approve() works
        Assert.equal(balance0, decimalMultiplier.mul(200000000) - 100, "Incorrect owner balance.");
        Assert.equal(balance1, 0, "Incorrect address 1 balance.");
        Assert.equal(balance2, 100, "Incorrect address 2 balance.");
    }
}
