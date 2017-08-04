pragma solidity ^0.4.15;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/QINToken.sol";

/** @title QIN Token Test
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 */
contract TestQINToken {

  function testInitialBalanceUsingDeployedContract() {
    MetaCoin meta = QINToken(DeployedAddresses.QINToken());

    uint expected = 10000;

    Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 10000 QIN initially");
  }

  function testInitialBalanceWithNewQINToken() {
    QINToken qin = new QINToken();

    uint expected = 10000;

    Assert.equal(qin.getBalance(tx.origin), expected, "Owner should have 10000 QIN initially");
  }

}
