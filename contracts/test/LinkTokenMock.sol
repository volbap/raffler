// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LinkTokenMock is ERC20 {
    constructor(uint256 initialSupply) ERC20("Link Token Mock", "LINKMOCK") {
        _mint(msg.sender, initialSupply);
    }
}
