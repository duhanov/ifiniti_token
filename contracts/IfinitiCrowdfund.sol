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

    


    //get start time
    function getStartTime() public view returns(uint){
        return _getStartTime();
    }

    //get end time
    function getEndTime() public view returns(uint){
        return _getEndTime();
    }

    //get cur time
   function getTime() public view returns(uint){
        return _getTime();
    }

    function timeStarted() public view returns(bool){
        return _timeStarted();
    }


    //get asset buyprice 
    function getAssetBuyPrice(uint256 assetId) public view returns(uint256){
        return _getAssetBuyPrice(assetId);
    }

    //get asset buyprice 
    function getAssetSellPrice(uint256 assetId) public view returns(uint256){
        return _getAssetSellPrice(assetId);
    }

    function getOrderPrice(uint256 assetId, uint256 countAssets) public view returns(uint256){
       return _getOrderPrice(assetId, countAssets);
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


    function getCountOrders() public view returns(uint256){
        return _getCountOrders();
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

    //balance tokens on smartcontract
    function balance() public view returns(uint256){
        return _balance();
    }


    //balance tokens on smartcontract
    function backOrderNeedTokens(uint256 count) public view returns(uint256){
        return _backOrderNeedTokens(count);
    }

    //back order to company, and money to user
    function backOrders(uint256 count) public onlyOwner{
        _backOrders(count);
    }
    

    //add asset
    function addAsset(string memory name, uint256 amount, uint256 minBuy, uint256 maxBuy, uint256 buyPrice, uint256 sellPrice, uint startTime, uint endTime, uint payoutStartTime, uint payoutEndTime) public onlyOwner returns (uint256){
        return _addAsset(name, amount, minBuy, maxBuy, buyPrice, sellPrice, startTime, endTime, payoutStartTime, payoutEndTime);
    }
    
    



    //withdraw
    function withdraw(address to, uint256 amount) public onlyOwner{
        _withdraw(to, amount);
    }


    function getOrderOwner(uint256 orderId) public view returns(address){
        return _getOrderOwner(orderId);
    }

    function getOrderAmount(uint256 orderId) public view returns(uint256){
        return _getOrderAmount(orderId);
    }

    function getOrderCountAssets(uint256 orderId) public view returns(uint256){
        return _getOrderCountAssets(orderId);
    }

    function getOrderAssetId(uint256 orderId) public view returns(uint256){
        return _getOrderAssetId(orderId);
    }

    function getOrderTimes(uint256 orderId) public view returns(uint256){
        return _getOrderTimes(orderId);
    }


}