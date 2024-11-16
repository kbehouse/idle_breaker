// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {IHooks} from "v4-core/src/interfaces/IHooks.sol";
import {Hooks} from "v4-core/src/libraries/Hooks.sol";
import {PoolManager} from "v4-core/src/PoolManager.sol";
import {IPoolManager} from "v4-core/src/interfaces/IPoolManager.sol";
import {TickMath} from "v4-core/src/libraries/TickMath.sol";
import {CurrencyLibrary, Currency} from "v4-core/src/types/Currency.sol";
import {AfterswapHook} from "../src/AfterswapHook.sol";
import {HookMiner} from "../test/utils/HookMiner.sol";
import {PoolKey} from "v4-core/src/types/PoolKey.sol";

/// @notice Forge script for deploying v4 & hooks to **anvil**
/// @dev This script only works on an anvil RPC because v4 exceeds bytecode limits
contract DeployAfterswapHook is Script {
    // IPoolManager manager = IPoolManager(address(0x322813Fd9A801c5507c9de605d63CEA4f2CE6c44));

    address constant CREATE2_DEPLOYER = address(0x4e59b44847b379578588920cA78FbF26c0B4956C);

    function setUp() public {}

    function getPrecomputedHookAddress(IPoolManager pm, bytes32 salt) public view returns (address) {
        bytes32 bytecodeHash = keccak256(abi.encodePacked(type(AfterswapHook).creationCode, abi.encode(pm)));
        bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff), address(this), salt, bytecodeHash));
        return address(uint160(uint256(hash)));
    }

    function deployHooks(IPoolManager poolManager) internal returns (bytes32 salt, address hookAddress) {
        for (uint256 i = 0; i < 7000; i++) {
            salt = bytes32(i);
            address expectedAddress = getPrecomputedHookAddress(poolManager, salt);
            // console2.log("expectedAddress", expectedAddress);
            // console2.log("uint160(Hooks.AFTER_SWAP_FLAG)", uint160(Hooks.AFTER_SWAP_FLAG));
            console2.log("i= ", i);
            if ((uint160(expectedAddress) & uint160(0x3fff)) == uint160(Hooks.AFTER_SWAP_FLAG)) {
                console2.log("found expectedAddress", expectedAddress);
                console2.log("i= ", i);
                return (salt, expectedAddress);
            }
        }
        return (bytes32(0), address(0));
    }

    function deployAfterswapHook(IPoolManager manager) public {
        console2.log("msg.sender:", msg.sender);

        console2.log("broadcasted with msg.sender:", msg.sender);
        // hook contracts must have specific flags encoded in the address
        uint160 permissions = uint160(Hooks.AFTER_SWAP_FLAG);

        // Mine a salt that will produce a hook address with the correct permissions
        (address hookAddress, bytes32 salt) = HookMiner.find(
            CREATE2_DEPLOYER, permissions, type(AfterswapHook).creationCode, abi.encode(address(manager))
        );

        // (bytes32 salt, address hookAddress) = deployHooks(manager);
        console2.log("target hookAddress:", hookAddress);

        // ----------------------------- //
        // Deploy the hook using CREATE2 //
        // ----------------------------- //
        console2.log("deploying hook...");
        vm.startBroadcast();
        AfterswapHook myHook = new AfterswapHook{salt: salt}(manager);
        console2.log("myHook:", address(myHook));
        require(address(myHook) == hookAddress, "AfterswapHook: hook address mismatch");
    }

    function initV4PoolSelf(IPoolManager manager, address hook, uint24 fee, address token0, address token1) public {
        vm.broadcast();
        IPoolManager manager = deployPoolManager();
        int24 tickSpacing;
        uint160 sqrtPriceX96 = uint160(1584563250300000000000000000000000);
        // v3 pools don't allow overwriting existing fees, 500, 3000, 10000 are set by default in the constructor
        if (fee == 500) tickSpacing = 10;
        else if (fee == 3000) tickSpacing = 60;
        else if (fee == 10000) tickSpacing = 200;

        PoolKey memory key_ =
            PoolKey(Currency.wrap(token0), Currency.wrap(token1), fee, tickSpacing, IHooks(address(hook)));
        console2.log("before brocast");

        console2.log("Before  manager.initialize");
        console2.log("manager: ", address(manager));
        manager.initialize(key_, sqrtPriceX96);
        console2.log("after  manager.initialize");
    }

    function initV4Pool(IPoolManager manager, address hook, uint24 fee, address token0, address token1) public {
        int24 tickSpacing;
        uint160 sqrtPriceX96 = uint160(1584563250300000000000000000000000);
        // v3 pools don't allow overwriting existing fees, 500, 3000, 10000 are set by default in the constructor
        if (fee == 500) tickSpacing = 10;
        else if (fee == 3000) tickSpacing = 60;
        else if (fee == 10000) tickSpacing = 200;

        PoolKey memory key_ =
            PoolKey(Currency.wrap(token0), Currency.wrap(token1), fee, tickSpacing, IHooks(address(hook)));
        console2.log("before brocast");

        console2.log("Before  manager.initialize");
        console2.log("manager: ", address(manager));
        vm.broadcast();
        manager.initialize(key_, sqrtPriceX96);
        console2.log("after  manager.initialize");
    }

    function deployPoolManager() internal returns (IPoolManager) {
        return IPoolManager(address(new PoolManager(address(0))));
    }
}
