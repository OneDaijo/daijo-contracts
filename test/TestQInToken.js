var QINToken = artifacts.require("./token/QINToken.sol");

contract('QINToken', function(accounts) {
  var qinToken;
  var crowdsale;
  it("integration test for crowdsale", function() {
    return QINToken.deployed().then(function(instance) {
      qinToken = instance;
      return instance.balanceOf.call(accounts[0]);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), 200000000 * 10**18, "the correct balance wasn't in the first account");
    }).then(function() {
      // TODO(mrice): figure out how to get the current block number and manipulate the block number on testrpc.
      // To do this right, we'll need to manually force block increment.
      qinToken.startCrowdsale(100000000, 100000001, 250, accounts[0], 1597721000, {from: accounts[0]}).then(function(tx_id) {
        // If this callback is called, the transaction was successfully processed.
        // Note that Ether Pudding takes care of watching the network and triggering
        // this callback.
        alert("Transaction successful!")
      }).catch(function(e) {
        // There was an error! Handle it.
        throw e;
      });
    });
  });
});