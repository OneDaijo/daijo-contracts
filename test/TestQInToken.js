var QINToken = artifacts.require("./token/QINToken.sol");

contract('QINToken', function(accounts) {
  var qinToken;
  var crowdsale;

  var Web3 = require('web3');
  var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

  it("integration test for crowdsale", function() {
    return QINToken.deployed().then(function(instance) {
      qinToken = instance;
      return instance.balanceOf.call(accounts[0]);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), 200000000 * 10**18, "the correct balance wasn't in the first account");
    }).then(function() {
      // TODO(mrice): the block number is coming back undefined.  This needs to be investigated further.
      var blockNumber = web3.eth.blockNumber;
      qinToken.startCrowdsale(10000, 10001, 250, accounts[0], 1597721000);
    }).then(function() {
      return qinToken.balanceOf.call(accounts[0]);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), 0, "the correct balance wasn't in the first after crowdsale start");
    }).catch(function(err) {
      assert.equal("error", "no error", "there was an error thrown" + web3.eth.blockNumber);
    });
  });
});
