// SPDX-License-Identifier: UNLICENSED
// Ifiniti Contracts

pragma solidity ^0.8.9;

import "./token/ERC20/ERC20.sol";
import "./access/Ownable.sol";

contract IfinitiToken is ERC20, Ownable {
    constructor() ERC20("IfinitiToken", "IFG") {
        _mint(msg.sender, 280000000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }


}