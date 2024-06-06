// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Instance} from "../src/L0HelloEthernaut.sol";

contract L0HelloEthernautAttack is Script {
    // Your instance address
    Instance public instance = Instance(0x61c36a8d610163660E21a8b7359e1Cac0C9133e1);

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        string memory PASSWORD = instance.password();
        instance.authenticate(PASSWORD);
        vm.stopBroadcast();
    }
}
