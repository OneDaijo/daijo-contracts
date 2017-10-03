pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/libs/SafeMath.sol";


/** @title Safe Math Tests
 *  @author DaijoLabs <info@daijolabs.com>
 */
contract TestSafeMath {
    using SafeMath for uint;

    // tests SafeMath multiplication function
    function testBasicMultiplication() {
        uint a = 5678;
        uint b = 1234;

        uint result = a.mul(b);
        uint expected = 7006652;

        Assert.equal(result, expected, "Does not multiply correctly.");
    }

    // tests SafeMath division function
    function testBasicDivision() {
        uint a = 6000;
        uint b = 2;

        uint result = a.div(b);
        uint expected = 3000;

        Assert.equal(result, expected, "Does not divide correctly.");
    }

    // tests SafeMath addition function
    function testBasicAddition() {
        uint a = 5678;
        uint b = 1234;

        uint result = a.add(b);
        uint expected = 6912;

        Assert.equal(result, expected, "Does not add correctly.");
    }

    // tests SafeMath subtraction function
    function testBasicSubtraction() {
        uint a = 5678;
        uint b = 1234;

        uint result = a.sub(b);
        uint expected = 4444;

        Assert.equal(result, expected, "Does not subtract correctly.");
    }
}
