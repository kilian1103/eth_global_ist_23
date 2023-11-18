// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// contract that pays ERC20 token victims of natural disasters if natural disaster event is incoming

contract PayVictims {

    address public treasury;


    mapping(address => uint256) public balances;
    mapping(address => uint) public victimToLocationId; // victim to location id mapping
    mapping(uint => address[]) public locationIdToVictims; // location id to victims mapping

    event PayVictimsEvent(string disasterType, uint256 amount, address[] victims, uint locId);

    constructor(address _treasury) {
        treasury = _treasury;
        balances[treasury] = 0;

    }


    function registerNewTreasury(address newTreasury) public {
        //change treasury address
        //register treasury
        require(msg.sender == treasury, "only current treasury can register new treasury");
        uint treasuryBalance = balances[treasury];
        balances[treasury] = 0;
        treasury = newTreasury;
        balances[treasury] = treasuryBalance;
    }

    function fillTreasury(){
        //fill treasury with ERC20 tokens
        //only treasury can fill treasury
        require(msg.sender == treasury, "only treasury can fill treasury");
        balances[treasury] += msg.value;
    }




    function registerPotentialVictims(address[] memory victims, uint locId) public {
        //register potential victims to treasury
        require(msg.sender == treasury, "only treasury can register victims");
        for (uint256 i = 0; i < victims.length; i++) {
            if (balances[victims[i]] != 0) {
                // if victim exists, user moved to new place
                oldLocId = victimToLocationId[victims[i]];
                locationIdToVictims[oldLocId].remove(victims[i]);
                // update victim new loccation
                victimToLocationId[victims[i]] = locId;
                locationIdToVictims[locId].push(victims[i]);
                continue;
            }
            balances[victims[i]] = 0;
            victimToLocationId[victims[i]] = locId;
            locationIdToVictims[locId].push(victims[i]);
        }
    }




    function payVictims(uint locId) public {
        //pay victims of natural disaster when validation is complete
        require(msg.sender == treasury, "only treasury can pay victims");
        address[] memory victims = locationIdToVictims[locId];
        uint256 amount = balances[treasury] / victims.length;
        for (uint256 i = 0; i < victims.length; i++) {
            balances[victims[i]] += amount;
        }

    }


}
