// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";
import "../src/PayVictims.sol";
import "./mock/MockERC20.sol";

contract PayVictimsTest is DSTest {
    PayVictims payVictims;
    MockERC20 mockUSDC;
    address treasury;

    function setUp() public {
        // Set up the test environment
        treasury = address(this); // for simplicity, the test contract itself will be the treasury
        mockUSDC = new MockERC20("Mock USDC", "mUSDC", 18);
        payVictims = new PayVictims(treasury, address(mockUSDC));
    }

    function testInitialTreasuryBalance() public {
        // Test initial treasury balance
        assertEq(payVictims.balances(treasury), 0);
    }

    function testRegisterNewTreasury() public {
        // Test registering a new treasury
        address newTreasury = address(1); // example new treasury address
        payVictims.registerNewTreasury(newTreasury);
        assertEq(payVictims.treasury(), newTreasury);
    }

    function testFailRegisterNewTreasuryNotTreasury() public {
        // Test failure case for registering a new treasury by a non-treasury account
        payVictims.registerNewTreasury(address(2));
    }

}

