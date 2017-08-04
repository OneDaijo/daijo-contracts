pragma solidity ^0.4.15;

import "./ConvertLib.sol";

/** @title QIN Token 
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 *  @notice source: https://github.com/ethereum/EIPs/issues/20
 */
contract QINToken is ERC20Token {

	function QINToken() {
		balances[tx.origin] = 10000;
	}

	function getBalanceInUSD(address addr) returns(uint){
		return ConvertLib.convert(balanceOf(addr), 2);
	}
}
