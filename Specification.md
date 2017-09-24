# QIN Token Code Specification
###### This a technical documentation of the smart contracts in the WRF public github repository. It is divided into three parts: A shortlist of the contracts and libraries associated with the QIN Token and the QIN Token Crowdsale, a more detailed discussion of each file including functions and modifiers, and an inheritance diagram.


### Contracts and Libraries
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

### QINToken.sol
//TODO
### QINCrowdsale.sol
###### QINCrowdsale is the contract that will execute the QIN Token crowdsale. It comprises 13 functions, a state machine, and various public and private variables that enable control flow over the QIN crowdsale. It inherits from both Controllable.sol and Ownable.sol, and imports both SafeMath.sol and ConvertLib.sol. The essential function of this contract is to accept Ethereum from whitelisted addresses ('buyers') and return to those addresses QIN Tokens at the rate of X QIN/ETH. The contract is designed to automatically implement the QIN crowdsale structure, available <here>, by restricting the number of QIN a single address may purchase on each day of the crowdsale.  

###### The state machine `State` and associated function `getState()` enumerate the four states that the crowdsale will be in: `BeforeSale`, before the sale opens, `SaleRestrictedDay`, the first two days of the sale in which buy orders are limited, `SaleFFA`, the final day in which buy orders are uncapped, and `SaleComplete`, after the sale has 1) sold out, 2) timed out, or 3) been manually ended by WRF. Note that the `haltCrowdsale` and `unhaltCrowdsale` methods inherited from `Controllable.sol` do not affect the state. These methods merely  pause or unpause the crowdsale by enabling or disabling incoming orders.  

###### The process by which a whitelisted address purchases QIN Tokens is as follows:

1. ###### A user sends Ethereum to the QINCrowdsale.sol contract address.
2. ###### The [fallback function](http://solidity.readthedocs.io/en/develop/contracts.html#fallback-function) of the contract is triggered, which calls `buyQINTokensWithRegisteredAddress` on `msg.sender`.
3. ###### `buyQINTokensWithRegisteredAddress`which is.... , only callable when the crowdsale is unpaused, calls `validPurchase`.  

4. ###### `validPurchase` takes no arguments and returns `true` if the purchase passes several checks (detailed in the next section) and `false` otherwise.  

5. ###### If `validPurchase` returns `true`, `buyQINTokensWithRegisteredAddress` performs several more checks.   
6. ###### Provided the buy order has passed all checks, the contract now calculates the quantity of QIN to be returned to `msg.sender` and adds that amount to `amountBoughtCumulative`, a variable for each whitelisted address that tracks the total QIN they have bought. If `amountBoughtCumulative` exceeds the `cumulativeLimit` for `msg.sender`, the order will be partially filled up to the buyer's `cumulativeLimit` and the leftover Ethereum refunded.  
7. ###### `buyQINTokensWithRegisteredAddress` now updates the total Ethereum contributed to the contract (`weiRaised`), subtracts the ordered QIN from `crowdsaleTokensRemaining`, and refunds the buyer any unspent wei from gas costs.  
8. ###### Finally, `buyQINTokensWithRegisteredAddress` calls `sendQIN` to send the buyer their purchased QIN. This action is performed last to prevent reentry attacks, where the fallback function, and hence the 'send tokens' function, is called repeatedly before the contract updates the state variables that control token transfers, such as `crowdsaleTokensRemaining`.  

#######
//DETAILS OF BUY FUNCTIONS + VALIDPURCHASE, ALSO PENDING CLEANUP


######


### Controllable.sol
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

### Ownable.sol
###### Ownable is a base contract that creates secure ownership of contracts. It contains 1 modifier:
###### `onlyOwner()`: Requires an address to match the owner address
###### Ownable contains 2 functions:
###### `Ownable()`: Sets the "owner" address to the message sender
###### `transferOwnership(address newOwner)`: Sets a new address to be the owner address

### ERC223Token.sol
###### ERC223Token is the base contract of the ERC223 token standard. The ERC223 standard is derived from and backwards-compatible with the ERC20 standard, and improves it in several key areas. Most importantly, ERC223 tokens cannot be sent to addresses that are not equipt to handle them, preventing their accidental loss. In addition, ERC223 has efficiency and uniformity improvements over the ERC20 standard: the token transfer process requires only one function call--`transfer`--as opposed to the two required in ERC20. The Ethereum Improvement Proposal (EIP) for the ERC223 standard can be found [here](https://github.com/ethereum/EIPs/issues/223).


### ERC20Token.sol
###### ERC20Token is the base contract of the ERC20 token standard. The ERC20 standard is a set of 6 functions and 2 events that standardizes token implementation on the Ethereum blockchain. More info can be found at [the Ethereum Wiki](https://theethereum.wiki/w/index.php/ERC20_Token_Standard).

### ERC223Interface.sol
###### ERC223Interface is the abstract (by definition) standardized interface that any ERC223 token contract inherits from.

### ERC20Interface.sol
###### ERC20Interface is the abstract (by definition) standardized interface that any ERC20 token contract inherits from.

### SafeMath.sol
###### SafeMath is a library written by OpenZeppelin that contains secure arithmetic operators. It contains 4 functions:
###### `mul`: Secure Multiplication, `div`: Secure Division , `sub`: Secure Subtraction, and `add`: Secure Addition

### ConvertLib.sol
###### ConvertLib is a library that contains functions for converting between currencies. It contains 3 functions:
\\TODO pending ConvertLib fix

## Inheritance Map
###### The following is a map of the files in the QINCrowdsale repository. Each box represents a contract, interface, or library, and is color coded accordingly. Note that both green and blue refer to the same technical object--a contract--and are only seperated to represent contracts that are inherited from (blue) differently from contracts that only inherit others (green). An arrow drawn from file X pointing at file Y represents 'Y inherits from X'. The rounded arrows originating from the libraries indicate that a file imports that library, as opposed to contractual inheritance.  
<br/><br/>

Layout option 1:  

![Inheritance Diagram](https://github.com/WorldRapidFinance/wrf/blob/Specification-Document/InheritanceLayout1.jpg "Inheritance Diagram") <br/>
Layout option 2:  

![Inheritance Diagram](https://github.com/WorldRapidFinance/wrf/blob/Specification-Document/InheritanceLayout2.jpg "Inheritance Diagram") <br/>
