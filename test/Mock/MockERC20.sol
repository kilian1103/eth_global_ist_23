// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor(string memory name, string memory symbol)
        ERC20(name, symbol)
    {
        // Mint 1,000,000 tokens to the address deploying the contract
        _mint(address(this), 1000000 * 10 ** uint(decimals()));
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
