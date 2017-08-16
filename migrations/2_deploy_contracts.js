var ConvertLib = artifacts.require("./libs/ConvertLib.sol");
var QinCoin = artifacts.require("./token/QINToken.sol");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, QinCoin);
  deployer.deploy(QinCoin);
};
