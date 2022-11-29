// SPDX-License-Identifier: UNLICENSED
// Ifiniti Contracts

pragma solidity ^0.8.9;

import "./finance/crowdfund.sol";
import "./access/Ownable.sol";




contract IfinitiCrowdfund is Ownable, Crowdfund {
 
    constructor(address erc20token) Crowdfund(erc20token) {
    }

    //create crowdfund
    function createCrowdfund(uint256 needAmount, uint256 maxDays, uint256 minKeys, uint256 maxKeys, uint256 keyPrice) public onlyOwner  returns (uint256) {
        return _createCrowdfund(needAmount, maxDays, minKeys, maxKeys, keyPrice);
    }
    //get token for work
    function getErc20Token() public view returns(address){
        return _getErc20Token();
    }
    
}