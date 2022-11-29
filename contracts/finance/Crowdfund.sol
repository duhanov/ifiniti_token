// SPDX-License-Identifier: UNLICENSED
// Ifiniti Contracts

pragma solidity ^0.8.0;



import "../utils/Context.sol";
import "../token/ERC20/ERC20.sol";

contract Crowdfund is Context {

    //erc20_token for trade
    address private _erc20Token;

    //start time
    uint _startTime;

   // End funding time
    uint private _endTime;

   // Min keys for buy
    uint256 private _minBuyKeys;

   // Max keys for buy
    uint256 private _maxBuyKeys;

    // Need Amount for end
    uint256 private _needAmount;

    //Price by one keys
    uint256 private _keyPrice;

    //Keys array
    string[] private _keys;

    //Count Open Keys
    uint256 private _countOpenKeys = 0;





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

    //check end time
    function _ended() internal view returns(bool){
        return (block.timestamp >= _endTime);
    }

    //return count open keys
    function _getCountOpenKeys() internal view returns(uint256){
        return _countOpenKeys;
    }

    //open order and get keys
    function _openOrder(uint256 orderId) internal{
        //exist order
        require(_orderExists(orderId), "Order not exist");
        //check end time
        require(!_ended(), "Crowdfund not ended");
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

     //order keypack
    function _order(uint256 countKeys) internal returns(uint256) {
        //Check endTime
        require(!_ended());
        //Min/Max count keys
        require(countKeys >= _minBuyKeys && countKeys <= _maxBuyKeys, "invalid countKeys");
        //transfer and check
        IERC20 token = IERC20(address(_erc20Token));  
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




    constructor(address erc20Token, uint256 needAmount, uint endTime, uint256 minBuyKeys, uint256 maxBuyKeys, uint256 keyPrice) {

        _erc20Token = erc20Token;
        _needAmount = needAmount;
        _endTime = endTime;

        _minBuyKeys = minBuyKeys;
        _maxBuyKeys = maxBuyKeys;
        _keyPrice = keyPrice;
        //save start time
        _startTime = block.timestamp;

    }
}