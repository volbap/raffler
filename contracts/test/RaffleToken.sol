// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @dev A token used as currency for the raffle in local environments.
contract RaffleToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Raffle Token", "RTK") {
        _mint(msg.sender, initialSupply);
    }

    function decimals() public view virtual override returns (uint8) {
        return 6; // Let's use 6 decimals, similar to USDC and other stable coins
    }
}
