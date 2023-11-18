// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "ds-test/test.sol";
import "../src/PayVictims.sol";
import "./mock/MockERC20.sol";

contract PayVictimsTest is DSTest {
    PayVictims payVictims;
    MockERC20 mockUSDC;
    address treasury;

    event TokensMinted(address indexed treasury, uint amount);
    event VictimsRegistered(uint locId, address[] victims);
    event ApprovalGranted(uint amount);
    event VictimsPaid(uint locId, uint totalAmount);


    function setUp() public {
        // Set up the test environment
        treasury = address(this); // for simplicity, the test contract itself will be the treasury
        mockUSDC = new MockERC20("Mock USDC", "mUSDC");
        uint initialBalance = 100_000; // Initial balance of mockUSDC in the treasury
        mockUSDC.mint(treasury, initialBalance);
        payVictims = new PayVictims(treasury, address(mockUSDC), initialBalance);
    }

    function testInitialTreasuryBalance() public {
        // Test initial treasury balance
        assertEq(payVictims.balances(treasury), 100_000);
    }

    function testRegisterNewTreasury() public {
        // Test registering a new treasury
        address newTreasury = address(1); // example new treasury address
        payVictims.registerNewTreasury(newTreasury);
        assertEq(payVictims.treasury(), newTreasury);
    }

    /*
    function testFailRegisterNewTreasuryNotTreasury() public {
        // Simulate the call from an address that is not the treasury
        vm.prank(address(2));
        payVictims.registerNewTreasury(address(3));
    }
    */

    function testPayVictims() public {
        address[] memory victims = new address[](2);
        victims[0] = address(3); // Mock victim address
        victims[1] = address(4); // Another mock victim address

        uint locId = 1; // Example location ID
        uint totalAmount = 100; // Total amount in mockUSDC

        // Mint mockUSDC tokens to the treasury
        mockUSDC.mint(treasury, totalAmount * 10);
        emit TokensMinted(treasury, totalAmount * 10);

        // Register victims
        payVictims.registerPotentialVictims(victims, locId);
        emit VictimsRegistered(locId, victims);

        // Approve the PayVictims contract to spend the treasury's mockUSDC
        mockUSDC.approve(address(payVictims), totalAmount);
        emit ApprovalGranted(totalAmount);

        // Pay victims
        payVictims.payVictims(locId, totalAmount);
        emit VictimsPaid(locId, totalAmount);

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

    function testRegisterPotentialVictims() public {
        // Setup - Define some mock victim addresses and a location ID
        address[] memory victims = new address[](3);
        victims[0] = address(3);
        victims[1] = address(4);
        uint locId = 1;

        // Call the registerPotentialVictims function
        payVictims.registerPotentialVictims(victims, locId);
        //victims[2] = (address(5));
        // Assertions to check if the victims are registered correctly
        for (uint i = 0; i < victims.length; i++) {
            // Check if each victim is registered
            assertTrue(payVictims.isRegisteredVictim(victims[i]), "Victim should be registered");

            // Check if each victim's location ID is set correctly
            assertEq(payVictims.victimToLocationId(victims[i]), locId, "Victim location ID should be set correctly");

            /* Check if each victim is added to the locationIdToVictims mapping
            address[] memory registeredVictims = payVictims.locationIdToVictims(locId);
            bool isVictimRegisteredAtLocation = false;
            for (uint j = 0; j < registeredVictims.length; j++) {
                if (registeredVictims[j] == victims[i]) {
                    isVictimRegisteredAtLocation = true;
                    break;
                }
            }
            assertTrue(isVictimRegisteredAtLocation, "Victim should be registered at the correct location");
            */
        }
    }


}


