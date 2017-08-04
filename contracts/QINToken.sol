pragma solidity ^0.4.15;

import "./ConvertLib.sol";

/** @title QIN Token 
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 *  @notice source: https://github.com/ethereum/EIPs/issues/20
 */
contract QINToken is ERC20Token {

	string public name;
	uint8 public decimals;
	string public symbol;

	function QINToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
		totalSupply = _initialAmount;
		balances[msg.sender] = _initialAmount;
		name = _tokenName;
		decimals = _decimalUnits;
		symbol = _tokenSymbol;
	}

	function getBalanceInUSD(address addr) returns(uint){
		return ConvertLib.convert(balanceOf(addr), 2); // TODO figure out conversion rate here
	}
}
