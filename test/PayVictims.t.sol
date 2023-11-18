pragma solidity 0.8.10;

import "forge-std/Test.sol";
import {PayVictims} from "../src/PayVictims.sol";

contract ContractTest is Test {
    PayVictims public payvictims;

    address victim;
    uint256 locID;
    uint256 testNumber;

    function setUp() public {
        victim = 0x0932f3f97f22D514E392B648Ce7c559F27BadB83;
        locID = 1;
        payvictims = new PayVictims();
        payvictims.registerVictims(victim, locID);
    }

    function (test_validateVictim) public {
        payvictims.validateVictim(victim, locID);
        //assertEq();
    }
}
