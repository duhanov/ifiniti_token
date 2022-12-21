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

    //Payouts Times
    uint private _payoutStartTime;
    uint private _payoutEndTime;

    uint private _endConfirmTime;
    uint private _cancelTime;


    // Need Amount for end
    uint256 private _minAmount;
    uint256 private _maxAmount;

    uint256 private _amount=0;

    //Price by one keys
    uint256 private _keyPrice;

    //Keys array
    string[] private _keys;

    //Count Open Keys
//    uint256 private _countOpenKeys = 0;

    //Confirm of end of crowdfund
    bool private _ended = false;

    //index for backOrder
    uint256 private _backOrderIndex = 0;

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

    //Order Assets
    mapping(uint256 => uint256) private _orderAssets;


    //Count assets in order
    mapping(uint256 => uint256) private _orderCountAssets;

    //save order times
    mapping(uint256 => uint) private _orderTimes;
    
    //order opens
    mapping(uint256 => bool) private _orderOpens;
    
    //order startKey index
    mapping(uint256 => uint256) private _orderStartKeyIndexes;

    //Get Count Keys
//    function _getCountKeys() internal view returns (uint256){
  //      return _keys.length;
    //}

    function getCountOrders() internal view returns(uint256){
        return _countOrders;
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

    function _getTime() internal view returns(uint){
        return block.timestamp;
    }

    function _timeStarted() internal view returns(bool){
        return (block.timestamp >= _startTime);
    }
    function _assetTimeStarted(uint256 assetId) internal view returns(bool){
        return (block.timestamp >= _assetStartTime[assetId]);
    }

    function _assetTimeEnded(uint256 assetId) internal view returns(bool){
        return (block.timestamp > _assetEndTime[assetId]);
    }

    //calculate how tokens need for back
    function _backOrderNeedTokens(uint256 count) internal view returns(uint256){
        require(_countOrders >= _backOrderIndex + count, "Invalid count");
        uint256 price = 0;

        for(uint256 orderId=_backOrderIndex; orderId < _backOrderIndex + count; orderId++){
            //order not opened
            if(_orderOpens[orderId] == false){
                uint256 backPrice = _assetSellPrice[_orderAssets[orderId]] * _orderCountAssets[orderId];
                price = price + backPrice;
            }
        }
        return price;
    }

//    Return orders to company and money back users
    function _backOrders(uint256 count) internal{
        require(_ended, "Crowfund not ended.");
        require(_countOrders >= _backOrderIndex + count, "Invalid _count");
        require(_balance() >= _backOrderNeedTokens(count), "Invalid Balance");
        IERC20 token = IERC20(address(_erc20Token));        
        //cycle by orders
        for(uint256 orderId=_backOrderIndex; orderId < _backOrderIndex + count; orderId++){
            //order not opened
            if(_orderOpens[orderId] == false){
                uint256 backPrice = _assetSellPrice[_orderAssets[orderId]] * _orderCountAssets[orderId];
                token.transfer(_orderOwners[orderId], backPrice);
            }
        }

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
        //require(_getCountKeys() >= _needCountKeys(), "Need more keys for end");
        
        _ended = true;    
        _endConfirmTime = block.timestamp;
    }

    //return count open keys
//    function _getCountOpenKeys() internal view returns(uint256){
  //      return _countOpenKeys;
    //}

    //open order and get keys
    function _openOrder(uint256 orderId) internal{
        //exist order
        require(_orderExists(orderId), "Order not exist");
        //check ended
        require(_ended, "Crowdfund not confirm end");
        //check owner order
        require(_ownerOfOrder(orderId) == _msgSender(), "Invalid owner");
        if(_orderOpens[orderId] == false){
  //          //save order is open
            _orderOpens[orderId] = true;
            //Save start key index for order
      //      _orderStartKeyIndexes[orderId] = _countOpenKeys;
            //Update count open keys
            //_countOpenKeys = _countOpenKeys + _orderCountKeys[orderId];
        }
    }



    //Get open order key
//    function _getOrderKey(uint256 orderId, uint256 keyNumber) internal view returns(string memory){
        //exist order
  //      require(_orderExists(orderId), "Order not exist");
        //order opened
      //  require(_orderOpens[orderId], "Order not opened");
    //    //check keyNumber
        //require(keyNumber >= 0 && keyNumber < _orderCountKeys[orderId]);

//        return _keys[_orderStartKeyIndexes[orderId] + keyNumber];
  //  }

    function _amountComplete() internal view returns(bool){
        return _amount >= _minAmount;
    }
    
    function _maxAmountComplete() internal view returns(bool){
        return _amount >= _maxAmount;
    }

    function _minAmountComplete() internal view returns(bool){
        return _amount >= _minAmount;
    }

    function _getAssetBuyPrice(uint256 assetId) internal view returns(uint256){
        return _assetBuyPrice[assetId];
    }

    function _getAssetSellPrice(uint256 assetId) internal view returns(uint256){
        return _assetSellPrice[assetId];
    }

    function _getOrderPrice(uint256 assetId, uint256 countAssets) internal view returns(uint256){
       return _assetBuyPrice[assetId] * countAssets;
    }

     //order keypack
    function _order(uint256 assetId, uint256 countAssets) internal returns(uint256) {
        //check cancel
        require(!_canceled, "Crowdfund was canceled");
        //check max amount
        require(!_maxAmountComplete(), "Crowfund ended by Amount complete");
        //Check end
        require(!_ended, "Crowdfund ended");
        //Check startTime
        require(_timeStarted(), "Crowdfund time not started");
        //Check endTime
        require(!_timeEnded(), "Crowdfund time ended!");

        //Check Asset
        //Check Asset Found
        require(_assetExist[assetId], "Asset not found");
        //check asset time
        require(_assetTimeStarted(assetId), "Asset time not started");
        require(!_assetTimeEnded(assetId), "Asset time ended!");    
        //Min/Max count assets
        require(countAssets >= _assetMinBuy[assetId] && countAssets <= _assetMaxBuy[assetId], "invalid countAssets");
        //check amount buyed/total
        require(countAssets + _assetBuyedAmount[assetId] <= _assetAmount[assetId], "Asset ended!");

        //transfer and check
        IERC20 token = IERC20(address(_erc20Token));  
        //get price for countKeys keys
        uint256 orderAmount = _assetBuyPrice[assetId] * countAssets;
        //Require transfer tokens
        require(token.transferFrom(_msgSender(), address(this), orderAmount), "Cant transfer tokens");

        //save order info
        _assetBuyedAmount[assetId] += countAssets;//save how many buyed
        _orderOwners[_countOrders] = _msgSender();//save who buy
        _orderAmounts[_countOrders] = orderAmount;//save order price
        _orderCountAssets[_countOrders] = countAssets;//save how many assets in order
        _orderAssets[_countOrders] = assetId;//save asset_id 
        _orderTimes[_countOrders] = block.timestamp;//save time order
        _orderOpens[_countOrders] = false;//order not opened
        //inrease counter
        _countOrders +=1;
        //save total amount
        _amount = _amount + orderAmount;
        emit OrderCreated(_countOrders - 1);
        return _countOrders-1;

    }

    function _getOrderOwner(uint256 orderId) internal view returns(address){
        require(_orderExists(orderId), "Order not exist");
        return _orderOwners[orderId];
    }

    function _getOrderAmount(uint256 orderId) internal view returns(uint256){
        require(_orderExists(orderId), "Order not exist");
        return _orderAmounts[orderId];
    }

    function _getOrderCountAssets(uint256 orderId) internal view returns(uint256){
        require(_orderExists(orderId), "Order not exist");
        return _orderCountAssets[orderId];
    }

    function _getOrderAssetId(uint256 orderId) internal view returns(uint256){
        require(_orderExists(orderId), "Order not exist");
        return _orderAssets[orderId];
    }

    function _getOrderTimes(uint256 orderId) internal view returns(uint256){
        require(_orderExists(orderId), "Order not exist");
        return _orderTimes[orderId];
    }


    function _getErc20Token() internal view returns(address){
        return _erc20Token;
    }



    //get price of keypack
//    function _getKeypackPrice(uint256 countKeys) internal view returns (uint256){
  //      return _keyPrice * countKeys;
    //}





    //Exist order
    function _orderExists(uint256 orderId) internal view returns (bool) {
        return _ownerOfOrder(orderId) != address(0);
    }

    
    //Owners order
    function _ownerOfOrder(uint256 orderId) internal view returns (address) {
        return _orderOwners[orderId];
    }

    //calculate count tokens for complete
    //function _needCountKeys() internal view returns (uint256){
     //   return _needAmount / _keyPrice;
   // }
    
    //check count keys for complete
   // function _checkCountKeys() internal view returns (bool){
     //   return (_needCountKeys() <= _keys.length);
   // }

    //withdraw ERC20 tokens
    function _withdraw(address to, uint256 amount) internal {
        IERC20 token = IERC20(address(_erc20Token));        
        require(token.balanceOf(address(this)) >= amount, "Balance is low");
        token.transfer(to, amount);
    }

    //balance tokens on contract
    function _balance() internal view returns(uint256){
        IERC20 token = IERC20(address(_erc20Token));        
        return token.balanceOf(address(this));
    }
 
    mapping(address => uint256) private _countUserAssets;

    //-- Assets
    uint256 private _countAssets = 0;
    //Name
    mapping(uint256 => string) private _assetName;
    //total amount for sell
    mapping(uint256 => uint256) private _assetAmount;
    //how many buyed assets
    mapping(uint256 => uint256) private _assetBuyedAmount;

    
    mapping(uint256 => bool) private _assetExist;
    mapping(uint256 => uint256) private _assetMinBuy;
    mapping(uint256 => uint256) private _assetMaxBuy;
    mapping(uint256 => uint256) private _assetBuyPrice;
    mapping(uint256 => uint256) private _assetSellPrice;
    mapping(uint256 => uint) private _assetStartTime;
    mapping(uint256 => uint) private _assetEndTime;
    mapping(uint256 => uint) private _assetPayoutStartTime;
    mapping(uint256 => uint) private _assetPayoutEndTime;


    event AssetAdded(uint256 AssetId);
    event OrderCreated(uint256 OrderId);

    function _getCountAssets() internal view returns (uint256){
        return _countAssets;
    }

    //Add asset to contract
    function _addAsset(string memory name, uint256 amount, uint256 minBuy, uint256 maxBuy, uint256 buyPrice, uint256 sellPrice, uint startTime, uint endTime, uint payoutStartTime, uint payoutEndTime) internal returns (uint256){
        _assetExist[_countAssets] = true;
        _assetAmount[_countAssets] = amount;
        _assetBuyedAmount[_countAssets] = 0;
        _assetName[_countAssets] = name;
        _assetMinBuy[_countAssets] = minBuy;
        _assetMaxBuy[_countAssets] = maxBuy;
        _assetBuyPrice[_countAssets] = buyPrice;
        _assetSellPrice[_countAssets] = sellPrice;
        _assetStartTime[_countAssets] = startTime;
        _assetEndTime[_countAssets] = endTime;
        _assetPayoutStartTime[_countAssets] = payoutStartTime;
        _assetPayoutEndTime[_countAssets] = payoutEndTime;
        _countAssets +=1;
        emit AssetAdded(_countAssets-1);
        return _countAssets - 1;
    }

    function _removeAsset(uint256 assetId) internal{
        _assetExist[assetId] = true;
    }

    constructor(address erc20Token, uint256 minAmount, uint256 maxAmount, uint startTime, uint endTime, uint payoutStartTime, uint payoutEndTime) {

        _erc20Token = erc20Token;
        _minAmount = minAmount;
        _maxAmount = maxAmount;

        _startTime = startTime;
        _endTime = endTime;

        _payoutStartTime = payoutStartTime;
        _payoutEndTime = payoutEndTime;

        //save start time
        _createdAt = block.timestamp;

    }
}