// SPDX-License-Identifier: UNLICENSED
// Ifiniti Contracts

pragma solidity ^0.8.0;



import "../utils/Context.sol";
import "../token/ERC20/ERC20.sol";

contract Crowdfund is Context {

    //erc20_token for trade
    address private _erc20_token;

    //Count CrowdFunds
    uint256 private _countCrowdFunds = 0;

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

    //Count user orders
    uint256 private _countOrders;

    mapping(uint256 => address) private _orderOwners;

    //User orders. crowfundId -> User Id -> Order
    mapping(uint256 => mapping(address => uint256)) private _orderBalances;

    mapping(uint256 => mapping(address => uint256)) private _orderCountTokens;

 
    function _getErc20Token() internal view returns(address){
        return _erc20_token;
    }



    //get price of keypack
    function _getKeypackPrice(uint256 crowdfundId, uint256 countKeys) internal view returns (uint256){
        //Exist croudfund
        require(_exists(crowdfundId), "crowdfundId not exist");
        return _keyPrices[crowdfundId] * countKeys;
    }

    //Get Min keys four buying
    function _getMinKeys(uint256 crowdfundId) internal view returns(uint256){
        //Exist croudfund
        require(_exists(crowdfundId), "crowdfundId not exist");
        return _minKeys[crowdfundId];
    }

    //Get Min keys four buying
    function _getMaxKeys(uint256 crowdfundId) internal view returns(uint256){
        //Exist croudfund
        require(_exists(crowdfundId), "crowdfundId not exist");
        return _maxKeys[crowdfundId];
    }

    //order keypack
    function _orderKeyPack(uint256 crowdfundId, uint256 countKeys) internal returns(uint256) {
        //Exist croudfund
        require(_exists(crowdfundId), "crowdfundId not exist");
        //Min/Max count keys
        require(countKeys >= _minKeys[crowdfundId] && countKeys <= _maxKeys[crowdfundId], "invalid countKeys");
        //Require balance
        IERC20 token = IERC20(address(_erc20_token));  
        //Require transfer tokens
        require(token.transferFrom(_msgSender(), address(this), _getKeypackPrice(crowdfundId, countKeys)), "Cant transfer tokens");


        _countOrders +=1;
        return _countOrders-1;

    }

    //create Crowdfund 
    //amount - amount for complete 
    //maxDays - maxDays long time crowfunding

    function _createCrowdfund(uint256 needAmount, uint256 maxDays, uint256 minKeys, uint256 maxKeys, uint256 keyPrice) internal returns (uint256) {

        //save creator
        _owners[_countCrowdFunds] = _msgSender();
        //save _needAmount
        _needAmounts[_countCrowdFunds] = needAmount;
        //balancce
        _balances[_countCrowdFunds] = 0;
        //save parameters
        _maxDays[_countCrowdFunds] = maxDays;
        _minKeys[_countCrowdFunds] = minKeys;
        _maxKeys[_countCrowdFunds] = maxKeys;
        _keyPrices[_countCrowdFunds] = keyPrice;

        //increase counter
        _countCrowdFunds += 1;
        //Return id croundFind
        return _countCrowdFunds-1;
    }



    //Exist crowdfund
    function _exists(uint256 croudfundId) internal view returns (bool) {
        return _ownerOf(croudfundId) != address(0);
    }

    //Exist crowdfund
    function _orderExists(uint256 orderId) internal view returns (bool) {
        return _ownerOfOrder(orderId) != address(0);
    }



    //Owners crowdfund
    function _ownerOf(uint256 croudfundId) internal view returns (address) {
        return _owners[croudfundId];
    }

    
    //Owners order
    function _ownerOfOrder(uint256 orderId) internal view returns (address) {
        return _orderOwners[orderId];
    }
    

    constructor(address erc20_token) {
        _erc20_token = erc20_token;
    }
}