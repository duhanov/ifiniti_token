// SPDX-License-Identifier: UNLICENSED
// Ifiniti Contracts

pragma solidity ^0.8.9;

import "./finance/Crowdfund.sol";
import "./access/Ownable.sol";




contract IfinitiCrowdfund is Ownable, Crowdfund {
 

    //create crowdfund
    constructor(address erc20Token, uint256 minAmount, uint256 maxAmount, uint startTime, uint endTime, uint payoutStartTime, uint payoutEndTime) Crowdfund(erc20Token, minAmount, maxAmount, startTime, endTime, payoutStartTime, payoutEndTime) {
    }


    //get token for work
    function getErc20Token() public view returns(address){
        return _getErc20Token();
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
    function order(uint256 assetId, uint256 countAssets) public returns(uint256) {
        return _order(assetId, countAssets);
    }




    //Cancel Crowdfund
    function cancelAll() public onlyOwner {
        _cancelAll();
    }

    //confirm end crowdfund
    function endConfirm() public onlyOwner {
        return _endConfirm();
    }

    //Open Order
    function openOrder(uint256 orderId) public{
        return _openOrder(orderId);
    }
 
    //crowfund canceled?
    function getCanceled() public view returns(bool){
        return _getCanceled();
    }

    function getEnded() public view returns(bool){
        return _getEnded();
    }

    //get count assets
    function getCountAssets() public view returns(uint256){
        return _getCountAssets();
    }

    //add asset
    function addAsset(string memory name, uint256 amount, uint256 minBuy, uint256 maxBuy, uint256 buyPrice, uint256 sellPrice, uint startTime, uint endTime, uint payoutStartTime, uint payoutEndTime) public onlyOwner returns (uint256){
        _addAsset(name, amount, minBuy, maxBuy, buyPrice, sellPrice, startTime, endTime, payoutStartTime, payoutEndTime);
        uint256 assetId = _getCountAssets() - 1;

        return assetId;
    }
    
    

    //get  count keys in order
    function getOrderCountAssets(uint256 orderId) public view returns(uint256){
        return _getOrderCountAssets(orderId);
    }

    //get  count keys in order
    function getOrderAmount(uint256 orderId) public view returns(uint256){
        return _getOrderAmount(orderId);
    }

    //withdraw
    function withdraw(address to, uint256 amount) public onlyOwner{
        _withdraw(to, amount);
    }

}