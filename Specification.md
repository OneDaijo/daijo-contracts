# QIN Token Code Specification
###### This a technical documentation of the smart contracts in the WRF public github repository. It is divided into three parts: A shortlist of the contracts and libraries associated with the QIN Token and the QIN Token Crowdsale, a more detailed discussion of each file including functions and modifiers, and an inheritance diagram.


#### Contracts and Libraries
* ###### QINToken.sol (Contract): Contract for the ERC223 QIN Token on the Ethereum Blockchain
* ###### QINCrowdsale.sol (Contract): Crowdsale contract for the QIN Token
* ###### Controllable.sol (Base Contract): Administrator control functions and modifiers for the crowdsale
* ###### Ownable.sol (Base Contract): Ownership functionality
* ###### ERC223Token.sol (Base Contract): Framework for the ERC223 token standard.
* ###### ERC20Token.sol (Base Contract): Framework for the ERC20 token standard.
* ###### ERC223Interface.sol (Interface): Interface for the ERC223 token standard.
* ###### ERC20Interface.sol (Interface): Interface for the ERC20 token standard.
* ###### SafeMath.sol (Library): Protected arithmetic.
* ###### ConvertLib.sol (Library) Currency conversions.

#### QINToken.sol
//TODO
#### QINCrowdsale.sol
###### QINCrowdsale is the contract that will execute the QIN Token crowdsale. It comprises 13 functions, incuding a fallback function, a state machine, and various public and private variables that enable control flow over the QIN crowdsale. It inherits from both Controllable.sol and Ownable.sol, and imports both SafeMath.sol and ConverLib.sol to provide a complete set of tools for administrator control, security, and utility.


#### Controllable.sol
###### Controllable is a base contract that provides administrator control functionality for the crowdsale contract. It contains 3 modifiers:
###### `onlyIfActive`: Requires the crowdsale to be active
###### `onlyIfHalted`: Requires the crowdsale to be halted
###### `onlyWhitelisted`: Requires an address to be on the whitelist

###### Controllable contains 6 functions:
###### `haltCrowdsale()`: Halts the crowdsale
###### `unhaltCrowdsale()`: Resumes a halted crowdsale
###### `endCrowdsale()`: Completes a halted crowdsale in an emergency
###### `addToWhitelist(address _addr)`: Adds an address to the whitelist
###### `removeFromWhitelist(address _addr)`: Removes an address from the whitelist
###### `getUserRegistrationState(address _addr)`: Checks if an address is on the whitelist

#### Ownable.sol
###### Ownable is a base contract that creates secure ownership of contracts. It contains 1 modifier:
###### `onlyOwner()`: Requires an address to match the owner address
###### Ownable contains 2 functions:
###### `Ownable()`: Sets the "owner" address to the message sender
###### `transferOwnership(address newOwner)`: Sets a new address to be the owner address

#### ERC223Token.sol
###### ERC223Token is the base contract of the ERC223 token standard. The ERC223 standard is derived from and backwards-compatible with the ERC20 standard, and improves it in several key areas. Most importantly, ERC223 tokens cannot be sent to addresses that cannot handle them, preventing the accidental loss of tokens. In addition, ERC223 has efficiency and uniformity improvements over the ERC20 standard: the token transfer process requires only one function call as opposed to the two required in ERC20. The Ethereum Improvement Proposal (EIP) for the ERC223 standard can be found [here](https://github.com/ethereum/EIPs/issues/223).


#### ERC20Token.sol
###### ERC20Token is the base contract of the ERC20 token standard. The ERC20 standard is a set of 6 functions and 2 events that standardizes token implementation on the Ethereum blockchain. More info can be found at [the Ethereum Wiki](https://theethereum.wiki/w/index.php/ERC20_Token_Standard).

#### ERC223Interface.sol
###### ERC223Interface is the abstract (by definition) standardized interface that any ERC223 token contract inherits from.

#### ERC20Interface.sol
###### ERC20Interface is the abstract (by definition) standardized interface that any ERC20 token contract inherits from.

#### SafeMath.sol
###### SafeMath is a library written by OpenZeppelin that contains secure arithmetic operators. It contains 4 functions:
###### `mul`: Multiplication, `div`: Division , `sub`: Subtraction, and `add`: Addition

#### ConvertLib.sol
###### ConvertLib is a library that contains functions for converting between currencies. It contains 3 functions:
\\TODO pending ConvertLib fix