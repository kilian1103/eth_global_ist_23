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
        mockUSDC = new MockERC20("Mock USDC", "mUSDC");
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

    function testPayVictims() public {
        address[] memory victims = new address[](2);
        victims[0] = address(3); // Mock victim address
        victims[1] = address(4); // Another mock victim address

        uint locId = 1; // Example location ID
        uint totalAmount = 100; // Total amount in mockUSDC

        // Mint mockUSDC tokens to the treasury
        mockUSDC.mint(treasury, totalAmount);

        // Register victims
        payVictims.registerPotentialVictims(victims, locId);

        // Approve the PayVictims contract to spend the treasury's mockUSDC
        mockUSDC.approve(address(payVictims), totalAmount);

        // Pay victims
        payVictims.payVictims(locId, totalAmount);

        // Check if the victims are paid correctly
        uint256 amountPerVictim = totalAmount / victims.length;
        for (uint i = 0; i < victims.length; i++) {
            assertEq(mockUSDC.balanceOf(victims[i]), amountPerVictim);
        }
    }

    function testFailPayVictimsNotEnoughBalance() public {
        address[] memory victims = new address[](2);
        victims[0] = address(3);
        victims[1] = address(4);

        uint locId = 1;
        uint totalAmount = 100;

        // Register victims
        payVictims.registerPotentialVictims(victims, locId);

        // This should fail because the treasury doesn't have enough mockUSDC balance
        payVictims.payVictims(locId, totalAmount);
    }

}

