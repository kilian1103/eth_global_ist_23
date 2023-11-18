// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// contract that pays ERC20 token victims of natural disasters if natural disaster event is incoming

contract PayVictims {


    mapping(address => uint256) public balances;
    address public treasury;
    event NaturalDisaster(string disasterType, uint256 victims, uint256 amount);
    event Payment(address victim, uint256 amount);
    mapping(address => bool) public isVictim; // victim claim eligibility
    mapping(address => uint) public victimToLocationId; // victim to location id mapping
    mapping(uint => string) public locationIdToArea; // location id to area mapping

    constructor(address _treasury) {
        treasury = _treasury;
        balances[treasury] = 0;

    }


    function registerNewTreasury(address newTreasury) public {
        //change treasury address
        //register treasury
        require(msg.sender == treasury, "only current treasury can register new treasury");
        treasury = newTreasury;
        balances[treasury] = 0;
    }

    function fillTreasury(){
        //fill treasury with ERC20 tokens
        //only treasury can fill treasury
        require(msg.sender == treasury, "only treasury can fill treasury");
        balances[treasury] += msg.value;
    }




    function registerVictims(address[] memory victims, uint locId) public {
        //register potential victims to treasury
        require(msg.sender == treasury, "only treasury can register victims");
        for (uint256 i = 0; i < victims.length; i++) {
            if (balances[victims[i]] != 0) {
                isVictim[victims[i]] = true;
                victimToLocationId[victims[i]] = locId;
                continue;
            }
            balances[victims[i]] = 0;
            isVictim[victims[i]] = true;
            victimToLocationId[victims[i]] = locId;
        }
    }


    function validateVictim(address victim) internal returns (bool){
        //validate victim claim
        require(msg.sender == treasury, "only treasury can validate victims");
        return isVictim[victim];
    }



    function payVictims(string memory disasterType, uint256 amount, address[] victims, uint locId) public {
        //pay victims of natural disaster when validation is complete
        require(msg.sender == treasury, "only treasury can pay victims");
        require(_validateNaturalDisaster(disasterType, victims, amount), "natural disaster is not valid");
        // pay logic

    }


}
