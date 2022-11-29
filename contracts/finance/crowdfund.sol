// SPDX-License-Identifier: UNLICENSED
// Ifiniti Contracts

pragma solidity ^0.8.0;

import "../utils/Context.sol";
import "../access/Ownable.sol";

contract Crowdfund is Context {

    //Count CrowdFunds
    uint256 private _counter = 0;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Max days of froundfunding
    mapping(uint256 => uint256) private _maxDays;

    // Max days of froundfunding
    mapping(uint256 => uint256) private _needAmounts;


    // min count Keys for buying
    mapping(uint256 => uint256) private _minKeys;

    // max count Keys for buying
    mapping(uint256 => uint256) private _maxKeys;

    // price one Key
    mapping(uint256 => uint256) private _keyPrices;

    //Total balance croudfund
    mapping(uint256 => uint256) private _balances;

    //User balance in CrowdFund
    mapping(uint256 => mapping(address => uint256)) private _userBalances;

 


    //
    function _getCrowdfundBalance(uint256 croudfundId, address userAddress) internal virtual returns(uint256){

    }
    //create Crowdfund 
    //amount - amount for complete 
    //maxDays - maxDays long time crowfunding

    function _createCrowdfund(uint256 needAmount, uint256 maxDays, uint256 minKeys, uint256 maxKeys, uint256 keyPrice) internal  virtual returns (uint256) {

        //save creator
        _owners[_counter] = _msgSender();
        //save _needAmount
        _needAmounts[_counter] = needAmount;
        //balancce
        _balances[_counter] = 0;
        //save parameters
        _maxDays[_counter] = maxDays;
        _minKeys[_counter] = minKeys;
        _maxKeys[_counter] = maxKeys;
        _keyPrices[_counter] = keyPrice;

        //increase counter
        _counter += 1;
        //Return id croundFind
        return _counter-1;
    }



    //Exist crowdfund
    function _exists(uint256 croudfundId) internal view virtual returns (bool) {
        return _ownerOf(croudfundId) != address(0);
    }

    //Owners crowdfund
    function _ownerOf(uint256 croudfundId) internal view virtual returns (address) {
        return _owners[croudfundId];
    }

    

    constructor() {
    }
}