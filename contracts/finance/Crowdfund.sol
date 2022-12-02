// SPDX-License-Identifier: UNLICENSED
// Ifiniti Contracts

pragma solidity ^0.8.0;



import "../utils/Context.sol";
import "../token/ERC20/ERC20.sol";

contract Crowdfund is Context {

    //erc20_token for trade
    address private _erc20Token;

    //creation date
    uint _createdAt;

    //start time
    uint _startTime;

   // End funding time
    uint private _endTime;

    uint private _endConfirmTime;
    uint private _cancelTime;

   // Min keys for buy
    uint256 private _minBuyKeys;

   // Max keys for buy
    uint256 private _maxBuyKeys;

    // Need Amount for end
    uint256 private _needAmount;

    uint256 private _amount=0;

    //Price by one keys
    uint256 private _keyPrice;

    //Keys array
    string[] private _keys;

    //Count Open Keys
    uint256 private _countOpenKeys = 0;

    //Confirm of end of crowdfund
    bool private _ended = false;

    //crowdfund cancel?
    bool _canceled = false;

    /*
    ORDERS
    */

    //Count user orders
    uint256 private _countOrders = 0;

    mapping(uint256 => address) private _orderOwners;

    //Order Amount
    mapping(uint256 => uint256) private _orderAmounts;

    //CountKeys in order
    mapping(uint256 => uint256) private _orderCountKeys;

    //save order times
    mapping(uint256 => uint) private _orderTimes;
    
    //order opens
    mapping(uint256 => bool) private _orderOpens;
    
    //order startKey index
    mapping(uint256 => uint256) private _orderStartKeyIndexes;

    //Get Count Keys
    function _getCountKeys() internal view returns (uint256){
        return _keys.length;
    }

    function _getAmount() internal view returns (uint256){
        return _amount;
    }

    //Push key
    function _pushKey(string memory key) internal{
        _keys.push(key);
    }

    //return start time
    function _getStartTime() internal view returns(uint){
        return _startTime;
    }

    //return start time
    function _getEndTime() internal view returns(uint){
        return _endTime;
    }

    //return created at
    function _getCreatedAt() internal view returns(uint){
        return _createdAt;
    }
    
    //Ended
    function _getEnded() internal view returns(bool){
        return _ended;
    }

    //check time end
    function _timeEnded() internal view returns(bool){
        return (block.timestamp >= _endTime);
    }


    function _timeStarted() internal view returns(bool){
        return (block.timestamp >= _startTime);
    }

    //Back tokens and cancel orders
    function _cancelAll() internal{
        require(!_canceled, "Already canceled.");
        require(!_ended, "Crowdfund ended.");
        require(_timeEnded(), "Time not ended");

        //return orders
        IERC20 token = IERC20(address(_erc20Token));        
        for(uint256 orderId=0; orderId < _countOrders; orderId++){
            token.transfer(_orderOwners[orderId], _orderAmounts[orderId]);
        }

        //save is canceled
        _canceled = true;
        _cancelTime = block.timestamp;

    }

    function _getCanceled() internal view returns(bool){
        return _canceled;
    }

    //confirm end
    function _endConfirm() internal  {
        //check canceled
        require(!_canceled, "Crowdfund canceled");
        //check Amount
        require(_amountComplete(), "Amount not complete");
        //check end time
        require(_timeEnded(), "Time not ended");
        //check count keys in system
        require(_getCountKeys() >= _needCountKeys(), "Need more keys for end");
        
        _ended = true;    
        _endConfirmTime = block.timestamp;
    }

    //return count open keys
    function _getCountOpenKeys() internal view returns(uint256){
        return _countOpenKeys;
    }

    //open order and get keys
    function _openOrder(uint256 orderId) internal{
        //exist order
        require(_orderExists(orderId), "Order not exist");
        //check ended
        require(_ended, "Crowdfund not confirm end");
        //check owner order
        require(_ownerOfOrder(orderId) == _msgSender(), "Invalid owner");
        if(_orderOpens[orderId] == false){
            //save order is open
            _orderOpens[orderId] = true;
            //Save start key index for order
            _orderStartKeyIndexes[orderId] = _countOpenKeys;
            //Update count open keys
            _countOpenKeys = _countOpenKeys + _orderCountKeys[orderId];
        }
    }

    //get order count keys
    function _getOrderCountKeys(uint256 orderId) internal view returns(uint256){
        //exist order
        require(_orderExists(orderId), "Order not exist");
        return _orderCountKeys[orderId];
    }

    //get order amount
    function _getOrderAmount(uint256 orderId) internal view returns(uint256){
        //exist order
        require(_orderExists(orderId), "Order not exist");
        return _orderAmounts[orderId];
    }

    //Get open order key
    function _getOrderKey(uint256 orderId, uint256 keyNumber) internal view returns(string memory){
        //exist order
        require(_orderExists(orderId), "Order not exist");
        //order opened
        require(_orderOpens[orderId], "Order not opened");
        //check keyNumber
        require(keyNumber >= 0 && keyNumber < _orderCountKeys[orderId]);

        return _keys[_orderStartKeyIndexes[orderId] + keyNumber];
    }

    function _amountComplete() internal view returns(bool){
        return _amount >= _needAmount;
    }
    
     //order keypack
    function _order(uint256 countKeys) internal returns(uint256) {
        //check cancel
        require(!_canceled, "Crowdfund was canceled");
        //check amount
        require(!_amountComplete(), "Amount complete");
        //Check end
        require(!_ended, "Crowdfund ended");
        //check cancel
        require(!_canceled, "Crowdfund was canceled");
        //Check startTime
        require(_timeStarted(), "Time not started");
        //Check endTime
        require(!_timeEnded(), "Time ended");
        

        //Min/Max count keys
        require(countKeys >= _minBuyKeys && countKeys <= _maxBuyKeys, "invalid countKeys");
        //transfer and check
        IERC20 token = IERC20(address(_erc20Token));  
        //get price for countKeys keys
        uint256 orderAmount = _getKeypackPrice(countKeys);
        //Require transfer tokens
        require(token.transferFrom(_msgSender(), address(this), orderAmount), "Cant transfer tokens");

        //save order info
        _orderOwners[_countOrders] = _msgSender();
        _orderAmounts[_countOrders] = orderAmount;
        _orderCountKeys[_countOrders] = countKeys;
        _orderTimes[_countOrders] = block.timestamp;
        _orderOpens[_countOrders] = false;
        //inrease counter
        _countOrders +=1;
        return _countOrders-1;

    }

    function _getErc20Token() internal view returns(address){
        return _erc20Token;
    }



    //get price of keypack
    function _getKeypackPrice(uint256 countKeys) internal view returns (uint256){
        return _keyPrice * countKeys;
    }

    //Get Min keys four buying
    function _getBuyMinKeys() internal view returns(uint256){
        return _minBuyKeys;
    }

    //Get Min keys four buying
    function _getMaxBuyKeys() internal view returns(uint256){
        return _maxBuyKeys;
    }




    //Exist order
    function _orderExists(uint256 orderId) internal view returns (bool) {
        return _ownerOfOrder(orderId) != address(0);
    }

    
    //Owners order
    function _ownerOfOrder(uint256 orderId) internal view returns (address) {
        return _orderOwners[orderId];
    }

    //calculate count tokens for complete
    function _needCountKeys() internal view returns (uint256){
        return _needAmount / _keyPrice;
    }
    
    //check count keys for complete
    function _checkCountKeys() internal view returns (bool){
        return (_needCountKeys() <= _keys.length);
    }




    constructor(address erc20Token, uint256 needAmount, uint startTime, uint endTime, uint256 minBuyKeys, uint256 maxBuyKeys, uint256 keyPrice) {

        _erc20Token = erc20Token;
        _needAmount = needAmount;
        _startTime = startTime;
        _endTime = endTime;

        _minBuyKeys = minBuyKeys;
        _maxBuyKeys = maxBuyKeys;
        _keyPrice = keyPrice;
        //save start time
        _createdAt = block.timestamp;

    }
}