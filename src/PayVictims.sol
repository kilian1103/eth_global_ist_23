// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// contract that pays ERC20 token victims of natural disasters if natural disaster event is incoming

contract PayVictims {

    address public treasury;
    IERC20 public USDCtoken;

    mapping(address => uint256) public balances;
    mapping(address => uint) public victimToLocationId; // victim to location id mapping
    mapping(uint => address[]) public locationIdToVictims; // location id to victims mapping

    event PayVictimsEvent(string disasterType, uint256 amount, address[] victims, uint locId);

    constructor(address _treasury, address _USDCtoken) {
        treasury = _treasury;
        USDCtoken = IERC20(_USDCtoken);
        balances[treasury] = 0;
    }


    function registerNewTreasury(address newTreasury) public {
        //change treasury address
        //register treasury
        require(msg.sender == treasury, "only current treasury can register new treasury");
        uint treasuryBalance = balances[treasury];
        balances[treasury] = 0;
        balances[newTreasury] = treasuryBalance;
        USDCtoken.transferFrom(msg.sender, address(this), treasuryBalance);

    }

    function fillTreasury(uint amount) public {
        balances[treasury] += amount;
        USDCtoken.transferFrom(msg.sender, address(this), amount);
    }




    function registerPotentialVictims(address[] memory victims, uint locId) public {
        //register potential victims to treasury
        require(msg.sender == treasury, "only treasury can register victims");
        for (uint256 i = 0; i < victims.length; i++) {
            if (balances[victims[i]] != 0) {
                // if victim exists, user moved to new place
                uint oldLocId = victimToLocationId[victims[i]];
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




    function payVictims(uint locId, uint totalAmount) public {
        //pay victims of natural disaster when validation is complete
        require(msg.sender == treasury, "only treasury can pay victims");
        require(balances[treasury] >= totalAmount, "treasury balance is not enough");
        address[] memory victims = locationIdToVictims[locId];
        uint256 amount = totalAmount / victims.length;
        for (uint256 i = 0; i < victims.length; i++) {
            balances[victims[i]] += amount;
            USDCtoken.transferFrom(address(this), victims[i], amount);
        }

    }


}
