pragma solidity ^0.4.13;


/** @title ERC223 Standard
 *  @author WorldRapidFinance <info@worldrapidfinance.com>
 *  @notice source: https://github.com/ethereum/EIPs/issues/223
 *  @notice only has functions that differ from ERC20 since ERC223
 *          is backwards compatible with ERC20
 */
contract ERC223Interface {
    
    function transfer(address _to, uint _value, bytes _data) public returns (bool);

    event Transfer(address indexed _from, address indexed _to, uint _value, bytes _data);

}
