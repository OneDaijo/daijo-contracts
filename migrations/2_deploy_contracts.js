var SafeMath = artifacts.require("./libs/SafeMath.sol");
var QINToken = artifacts.require("./token/QINToken.sol");

module.exports = function(deployer, network) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, QINToken);

  // Set test mode only if deployed on the test network.
  if (network != "test") {
    deployer.deploy(QINToken, false);
  } else {
    deployer.deploy(QINToken, true);
  }
};
