var SafeMath256 = artifacts.require("./libs/SafeMath256.sol");
var SafeMath8 = artifacts.require("./libs/SafeMath8.sol");
var QINToken = artifacts.require("./token/QINToken.sol");

module.exports = function(deployer, network) {
  deployer.deploy(SafeMath256);
  deployer.deploy(SafeMath8);
  deployer.link(SafeMath256, QINToken);
  deployer.link(SafeMath8, QINToken);

  // Set test mode only if deployed on the test network.
  if (network != "test") {
    deployer.deploy(QINToken, false);
  } else {
    deployer.deploy(QINToken, true);
  }
};
