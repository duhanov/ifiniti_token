
// SPDX-License-Identifier: UNLICENSED
// Ifiniti Contracts

pragma solidity ^0.8.0;

import "../IERC20.sol";


interface IERC20Metadata is IERC20 {
    /**
     * name of the token.
     */
    function name() external view returns (string memory);

    /**
     * symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * decimals places of the token.
     */
    function decimals() external view returns (uint8);
}