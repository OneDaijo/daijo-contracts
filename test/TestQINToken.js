var QINToken = artifacts.require("./token/QINToken.sol");
var QINCrowdsale = artifacts.require("./crowdsale/QINCrowdsale.sol");

contract('QINToken', function(accounts) {
  var qinToken;
  var crowdsale;
  var crowdsaleAddress;

  var Web3 = require('web3');
  var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

  var wrf_owner = web3.eth.accounts[0];
  var user = web3.eth.accounts[1];

  it("integration test for crowdsale: create QINToken" + wrf_owner, function() {
    return QINToken.deployed().then(function(instance) {
      qinToken = instance;
      return qinToken.balanceOf.call(accounts[0]);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), 200000000 * 10**18, "the correct balance wasn't in the first account");
    }).then(function() {
      var current_time = new Date().getTime() / 1000;
      qinToken.startCrowdsale(current_time, current_time + 1000, 3, 250, accounts[0], 1597721000);
    }).then(function() {
      return qinToken.crowdsaleExecuted();
    }).then(function(wasExecuted) {
      assert.isTrue(wasExecuted, "crowdsale was not executed");
      return qinToken.balanceOf.call(wrf_owner);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), 0, "the correct balance wasn't in the first after crowdsale start");
    }).then(function() {
      return qinToken.getCrowdsale.call();
    }).then(function(crowsdaleContract) {
      crowdsaleAddress = crowsdaleContract.valueOf();
      crowdsale = QINCrowdsale.at(crowdsaleAddress);
      return crowdsale.updateRegisteredUserWhitelist(user, true);
    }).then(function() {
      // Does not work with the default gas amount.
      return web3.eth.sendTransaction({from: user, to: crowdsaleAddress, value: web3.toWei(1, 'ether'), gas: 95000});
    }).then(function() {
      return qinToken.balanceOf.call(user);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), 250 * 10**18, "the correct balance wasn't in the user account");
    });
  });
});
