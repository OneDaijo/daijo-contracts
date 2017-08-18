var ConvertLib = artifacts.require("./libs/ConvertLib.sol");
var SafeMath = artifacts.require("./libs/SafeMath.sol");
var QINToken = artifacts.require("./token/QINToken.sol");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, QINToken);
  deployer.deploy(QINToken);
};
