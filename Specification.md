# QIN Token Code Specification
###### This a technical documentation of the smart contracts in the WRF public github repository. It is divided into three parts: A shortlist of the contracts and libraries associated with the QIN Token and the QIN Token Crowdsale, a more detailed discussion of each file, and an inheritance diagram.


#### Contracts and Libraries
* ###### QINToken.sol (Contract): Base contract for the ERC223 QIN Token on the Ethereum Blockchain
* ###### QINCrowdsale.sol (Contract): Crowdsale contract for the QIN Token
* ###### Controllable.sol (Abstract Contract): Administrator control functions and modifiers for the crowdsale
* ###### Ownable.sol (Abstract Contract): Ownership functionality
* ###### ERC223Token.sol (Abstract Contract): Framework for the ERC223 token standard.
* ###### ERC20Token.sol (Abstract Contract): Framework for the ERC20 token standard.
* ###### ERC223Interface.sol (Interface): Interface for the ERC223 token standard.
* ###### ERC20Interface.sol (Interface): Interface for the ERC20 token standard.
* ###### SafeMath.sol (Library): Protected math functions.
* ###### ConvertLib.sol (Library) Currency conversions.

#### QINToken.sol
//TODO
#### QINCrowdsale.sol
//TODO
#### Controllable.sol
###### Controllable is an Abstract Base Class that provides administrator control functionality for the crowdsale contract. It contains 3 modifiers:
###### `onlyIfActive`: Requires the crowdsale to be active
###### `onlyIfHalted`: Requires the crowdsale to be halted
###### `onlyWhitelisted`: Requires an address to be on the whitelist

###### Controllable contains 6 functions:
###### `haltCrowdsale()`: Halts the crowdsale
###### `unhaltCrowdsale()`: Resumes a halted crowdsale
###### `endCrowdsale()`: completes a halted crowdsale in an emergency
###### `addToWhitelist(address _addr)`: Adds an address to the whitelist
###### `removeFromWhitelist(address _addr)`: Removes an address from the whitelist
###### `getUserRegistrationState(address _addr)`: Checks if an address is on the whitelist

#### Ownable.sol
