// SPDX-License-Identifier: UNLICENSED
// Ifiniti Contracts

pragma solidity ^0.8.9;

import "./finance/Crowdfund.sol";
import "./access/Ownable.sol";




contract IfinitiCrowdfund is Ownable, Crowdfund {
 

    //create crowdfund
    constructor(address erc20Token, uint256 needAmount, uint endTime, uint256 minBuyKeys, uint256 maxBuyKeys, uint256 keyPrice) Crowdfund(erc20Token, needAmount, endTime, minBuyKeys, maxBuyKeys, keyPrice) {
    }

    //get token for work
    function getErc20Token() public view returns(address){
        return _getErc20Token();
    }

    

    //return count pushed keys
    function getCountKeys() public view returns(uint256){
        return _getCountKeys();
    }


    //Push new key
    function pushKey(string memory key) public onlyOwner{
        _pushKey(key);
    }

    //Get Min keys four buying
    function getBuyMinKeys() public view returns(uint256){
        return _getBuyMinKeys();
    }

    //Get Max keys four buying
    function getMaxBuyKeys() public view returns(uint256){
        return _getMaxBuyKeys();
    }

    //order
    function order(uint256 countKeys) public returns(uint256) {
        return _order(countKeys);
    }

    //get count keys in contract for complete
    function needCountKeys() public view onlyOwner returns(uint256) {
        return _needCountKeys();
    }

    //get count keys in contract for complete
    function checkCountKeys() public view onlyOwner returns(bool) {
        return _checkCountKeys();
    }

    //Cancel Crowdfund
    function cancelAll() public onlyOwner {
        _cancelAll();
    }

    //confirm end crowdfund
    function endConfirm() public onlyOwner {
        return _endConfirm();
    }


 
    //crowfund canceled?
    function getCanceled() public view returns(bool){
        return _getCanceled();
    }

    function getEnded() public view returns(bool){
        return _getEnded();
    }
    
    

    //get  count keys in order
    function getOrderCountKeys(uint256 orderId) public view returns(uint256){
        return _getOrderCountKeys(orderId);
    }

    //get  count keys in order
    function getOrderAmount(uint256 orderId) public view returns(uint256){
        return _getOrderAmount(orderId);
    }

}