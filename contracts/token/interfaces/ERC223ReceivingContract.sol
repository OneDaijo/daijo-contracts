pragma solidity ^0.4.13;


 /** @title ERC223 Receiving Contract Interface
 *  @author OneDaijo <info@onedaijo.com>
 *  @notice source: https://github.com/ethereum/EIPs/issues/223
 *  @notice must be implemented by any contract working with ERC223 tokens
 */
contract ERC223ReceivingContract {

    function tokenFallback(address _from, uint _value, bytes _data) external;

}
