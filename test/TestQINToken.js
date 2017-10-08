var QINToken = artifacts.require("./token/QINToken.sol");
var QINTokenSale = artifacts.require("./tokenSale/QINTokenSale.sol");

contract('QINToken', function(accounts) {
  var qinToken;
  var tokenSale;
  var tokenSaleAddress;

  var Web3 = require('web3');
  var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

  var daijo_owner = web3.eth.accounts[0];
  var user = web3.eth.accounts[1];

  it("integration test for tokenSale: simple crowdsale purchase", function() {
    return QINToken.deployed().then(function(instance) {
      qinToken = instance;
      return qinToken.getTestState.call();
    }).then(function(isTest) {
      assert.isTrue(isTest.valueOf(), "Contract not running in test mode");
      return qinToken.balanceOf.call(accounts[0]);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), 200000000 * 10**18, "the correct balance wasn't in the first account");
    }).then(function() {
      var current_time = new Date().getTime() / 1000;
      qinToken.startTokenSale(current_time, current_time + 1000, 3, 250, accounts[0]);
    }).then(function() {
      return qinToken.tokenSaleExecuted();
    }).then(function(wasExecuted) {
      assert.isTrue(wasExecuted, "tokenSale was not executed");
      return qinToken.balanceOf.call(daijo_owner);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), 140000000 * 10**18, "the correct balance wasn't in the first after tokenSale start");
    }).then(function() {
      return qinToken.getTokenSale.call();
    }).then(function(crowsdaleContract) {
      tokenSaleAddress = crowsdaleContract.valueOf();
      tokenSale = QINTokenSale.at(tokenSaleAddress);
      return tokenSale.addToWhitelist(user);
    }).then(function() {
      // Does not work with the default gas amount.
      return web3.eth.sendTransaction({from: user, to: tokenSaleAddress, value: web3.toWei(1, 'ether'), gas: 250000});
    }).then(function() {
      return qinToken.balanceOf.call(user);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), 250 * 10**18, "the correct balance wasn't in the user account");
    });
  });
});
