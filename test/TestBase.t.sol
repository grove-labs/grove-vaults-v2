// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.25;

import { Test } from "forge-std/Test.sol";

import { ERC20Mock as MockERC20 } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import { ERC1967Proxy }           from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import { GroveVault } from "../src/GroveVault.sol";

contract GroveVaultTestBase is Test {

    uint256 constant ONE_PCT_VSR  = 1.000000000315522921573372069e27;
    uint256 constant FOUR_PCT_VSR = 1.000000001243680656318820312e27;
    uint256 constant MAX_VSR      = 1.000000021979553151239153027e27;  // 100% APY

    address admin  = makeAddr("admin");
    address setter = makeAddr("setter");
    address taker  = makeAddr("taker");

    bytes32 DEFAULT_ADMIN_ROLE = 0x00;
    bytes32 SETTER_ROLE        = keccak256("SETTER_ROLE");
    bytes32 TAKER_ROLE         = keccak256("TAKER_ROLE");

    MockERC20  asset;
    GroveVault vault;

    function setUp() public virtual {
        asset = new MockERC20();

        vault = GroveVault(
            address(new ERC1967Proxy(
                address(new GroveVault()),
                abi.encodeCall(
                    GroveVault.initialize,
                    (address(asset), "Grove Savings USDC V2", "grUSDC", admin)
                )
            ))
        );

        vm.startPrank(admin);
        vault.grantRole(SETTER_ROLE, setter);
        vault.grantRole(TAKER_ROLE,  taker);
        vault.setDepositCap(1_000_000e6);
        vm.stopPrank();
    }

}

