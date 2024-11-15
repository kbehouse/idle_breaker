// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FakeUSDC is ERC20, Ownable {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _setupDecimals(6);
    }

    // Mint function that can only be called by the owner (using OpenZeppelin's Ownable)
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
