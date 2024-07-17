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
contract L23Dex2Attack is Script, Broadcast {
    // Replace this address with your instance address
    address constant instanceAddress = 0xe8A9EC3C730f0911e52462b915A516254272Aa16;

    DexTwo dex = DexTwo(instanceAddress);
    SwappableTokenTwo token1 = new SwappableTokenTwo(address(dex), "Token 1", "T1", 200);
    SwappableTokenTwo token2 = new SwappableTokenTwo(address(dex), "Token 2", "T2", 200);

    function run() public {}
}
