pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/QINToken.sol";

/** @title QIN Token Test
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 */
contract TestQINToken {

  function testInitialBalanceUsingDeployedContract() {
    QINToken qin = new QINToken();

    uint expected = qin.frozenSupply() + qin.crowdsaleSupply();

    Assert.equal(qin.balanceOf(tx.origin), expected, "Owner should have fozenSupply + crowdsaleSupply initially");
  }

  function testInitialBalanceWithNewQINToken() {
    QINToken qin = new QINToken();

    address expected = tx.origin;

    Assert.equal(qin.owner(), expected, "sender should be initial owner");
  }

}
