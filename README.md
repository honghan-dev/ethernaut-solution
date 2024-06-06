# Solution to Ethernaut CTF

## Introduction

Welcome to the repository containing solutions to the [Ethernaut CTF](https://github.com/OpenZeppelin/ethernaut) a smart contract hacking game by OpenZeppelin. Ethernaut challenges players to exploit vulnerabilities in Ethereum smart contracts, providing a hands-on way to learn about smart contract security.

## Prerequisites

- Make sure you have `make` installed on your system. If not, you can install it using:
  - On macOS: `brew install make`
  - On Ubuntu: `sudo apt-get install make`
  - On Windows: Use a package manager like [Chocolatey](https://chocolatey.org/) to install `make`.

## Setup

- Create .env file

```javascript
PRIVATE_KEY = your_private_key;
ANVIL_RPC_URL = your_rpc_url;
```

### Install Dependencies

This project uses Foundry for script execution. You can install Foundry and its dependencies using the Makefile provided. Run the following command to ensure Foundry is installed:

```sh
make install
```

### Deploy solution script

```sh
make script FILENAME=TheLevelFunctionName

# Level 0
make script FILENAME=L0HelloEthernautAttack
```
