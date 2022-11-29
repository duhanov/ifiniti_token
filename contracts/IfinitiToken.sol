// SPDX-License-Identifier: UNLICENSED
// Ifiniti Contracts

pragma solidity ^0.8.9;

import "./token/ERC20/ERC20.sol";
import "./access/Ownable.sol";
import "./finance/croudfund.sol";

contract IfinitiToken is ERC20, Ownable {
    constructor() ERC20("IfinitiToken", "IFT") {
        _mint(msg.sender, 280000000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }


    function createCrowdfund(uint256 needAmount, uint256 maxDays, uint256 minKeys, uint256 maxKeys, uint256 keyPrice) public onlyOwner  returns (uint256) {
        return _createCrowdfund(needAmount, maxDays, minKeys, maxKeys, keyPrice);
    }
}