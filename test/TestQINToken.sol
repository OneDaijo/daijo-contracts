pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "../contracts/token/QINToken.sol";

/** @title QIN Token Test
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 */
contract TestQINToken {

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

        Assert.equal(qin.totalSupply(), 200000000, "Total supply incorrect.");
    }

    function testCorrectAllowanceAmountAfterApproval() {
        QINToken qin = new QINToken();
        qin.approve(0x1234, 100);
        uint result = qin.allowance(qin.owner(), 0x1234);

        Assert.equal(result, 100, "Incorrect allowance amount.");
    }

    function testCorrectBalancesAfterTransfer() {
        QINToken qin = new QINToken();
        qin.transfer(0x1234, 200000000);
        uint balance0 = qin.balanceOf(qin.owner());
        uint balance1 = qin.balanceOf(0x1234);

        Assert.equal(balance0, 0, "Incorrect sender balance.");
        Assert.equal(balance1, 200000000, "Incorrect receiver balance.");
    }

    // TODO fix this test, not sure why it doesn't work
    // function testCorrectBalancesAfterTransferingFromAnotherAccount() {
    //     QINToken qin = new QINToken();
    //     qin.approve(0x1234, 100);
    //     qin.transferFrom(qin.owner(), 0x5678, 100);
    //     uint balance0 = qin.balanceOf(qin.owner());
    //     uint balance1 = qin.balanceOf(0x1234);
    //     uint balance2 = qin.balanceOf(0x5678);

    //     Assert.equal(balance0, 199999900, "Incorrect owner balance.");
    //     Assert.equal(balance1, 0, "Incorrect address 1 balance.");
    //     Assert.equal(balance2, 100, "Incorrect address 2 balance.");
    // }

    // TODO complete it
    function testCrowdsaleExecutionFromQINToken() {
        QINToken qin = new QINToken();
        Assert.isFalse(qin.crowdsaleExecuted(), "Crowdsale should not have started yet.");

    }
}
