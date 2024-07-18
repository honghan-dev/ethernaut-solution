// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Broadcast} from "script/helper/Broadcast.sol";
import {CryptoVault, Forta, LegacyToken, DoubleEntryPoint, IDetectionBot, IForta} from "src/L26DoubleEntryPoint.sol";

// 0xf1Ff05db8575aE0aeC72d12B66CA48810DfC2c63 - DoubleEntryPoin token address

contract L26DoubleEntryPointAttack is Script, Broadcast {
    DoubleEntryPoint det = DoubleEntryPoint(0xf1Ff05db8575aE0aeC72d12B66CA48810DfC2c63);

    function run() public broadcast {
        Forta forta = det.forta();
        AlertBot alertBot = new AlertBot(address(det.cryptoVault()));
        forta.setDetectionBot(address(alertBot));
    }
}

contract AlertBot is IDetectionBot {
    address private cryptoVault;

    constructor(address _cryptoVault) {
        cryptoVault = _cryptoVault;
    }

    function handleTransaction(address user, bytes calldata /*msgData*/ ) external override {
        address origSender;
        assembly {
            origSender := calldataload(0xa8)
        }

        if (origSender == cryptoVault) {
            IForta(msg.sender).raiseAlert(user);
        }
    }
}
