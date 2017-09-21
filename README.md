<img src = "https://github.com/WorldRapidFinance/wrf/blob/master/wrf_logo.png" width = "211" height = "132">

# WRF Project

Smart contracts for the QIN token.

## Prerequisites

The following prerequisites will be necessary to build and run the WRF project smart contracts (Ubuntu examples provided):

1. [Install node](https://nodejs.org/en/) and [install npm](https://www.npmjs.com/get-npm):
```
sudo apt-get install nodejs
sudo apt-get install npm
# Allows the typical "node" command to be used.
sudo ln -s /usr/bin/nodejs /usr/bin/node
```

2. Install [truffle (beta 4.0)](https://github.com/trufflesuite/truffle), [testrpc](https://github.com/ethereumjs/testrpc), and [web3 (0.20.1)](https://github.com/ethereum/web3.js/). Note: to install to a local directory (the WRF project folder, for instance), remove the -g (and sudo). This is helpful as to not have version collissions with other projects' requirements:
```
sudo npm install -g truffle@beta
sudo npm install -g ethereumjs-testrpc
sudo npm install -g web3@0.20.1
```

## Build and Test

The WRF project uses truffle, so the typical truffle commands will work.  For full truffle documentation, see the [truffle docs](http://truffleframework.com/docs/) and the [truffle beta release](https://github.com/trufflesuite/truffle/releases/tag/v4.0.0-beta.0).

To build the contracts and publish artifacts to the `build/` folder, run:
```
truffle compile
```
from the base of the WRF repo.

For the rest of the sample commands, an ethereum network will be required. WRF uses testrpc to test against. To run testrpc, run `testrpc` in a separate shell session. It will need to remain running for the later commands to run successfully.

To publish the contracts to the network, run:
```
truffle migrate
```
from the base of the repo.

To run the contract tests, run:
```
truffle test
```
from the base of the repo.