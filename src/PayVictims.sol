// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// contract that pays ERC20 token victims of natural disasters if natural disaster event is incoming

contract PayVictims {
    mapping(address => uint256) public balances;
    address public treasury;
    event NaturalDisaster(string disasterType, uint256 victims, uint256 amount);
    event Payment(address victim, uint256 amount);

    constructor(address _treasury) {
        treasury = _treasury;
        balances[treasury] = 0;

    }


    function registerTreasury(address newTreasury) public {
        //change treasury address
        //register treasury
        require(msg.sender == treasury, "only treasury can register treasury");
        treasury = newTreasury;
    }

    function fillTreasury(){
        //fill treasury with ERC20 tokens
        //only treasury can fill treasury
        require(msg.sender == treasury, "only treasury can fill treasury");
        balances[treasury] += msg.value;
    }




    function registerVictims(address[] memory victims) public {
        //register victims to treasury
        require(msg.sender == treasury, "only treasury can register victims");
        for (uint256 i = 0; i < victims.length; i++) {
            if (balances[victims[i]] != 0) {
                continue;
            }
            balances[victims[i]] = 0;
        }
    }

    function validateVictims(address[] memory victims) public pure returns (bool) {
        //function to check if victim is valid claimer
        return true;
    }


    function _validateNaturalDisaster(string memory disasterType, uint256 victims, uint256 amount) public pure returns (bool) {
        //check if natural disaster is valid
        return true;
    }




    function payVictims(string memory disasterType, uint256 amount) public {
        //pay victims of natural disaster when validation is complete
        require(msg.sender == treasury, "only treasury can pay victims");
        require(_validateNaturalDisaster(disasterType, victims, amount), "natural disaster is not valid");
        emit NaturalDisaster(disasterType, victims, amount);
        uint256 payment = amount / victims;
        for (uint256 i = 0; i < victims; i++) {
            balances[treasury] -= payment;
            emit Payment(msg.sender, payment);
        }
    }


}
