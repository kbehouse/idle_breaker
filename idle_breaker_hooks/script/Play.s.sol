// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

import "forge-std/Script.sol";
import {Deployers} from "v4-core/test/utils/Deployers.sol";
import {Currency} from "v4-core/src/types/Currency.sol";
import {Fuzzers} from "v4-core/src/test/Fuzzers.sol";
import {IHooks} from "v4-core/src/interfaces/IHooks.sol";
import {Hooks} from "v4-core/src/libraries/Hooks.sol";
import {IPoolManager} from "v4-core/src/interfaces/IPoolManager.sol";
import {BalanceDelta, BalanceDeltaLibrary, toBalanceDelta} from "v4-core/src/types/BalanceDelta.sol";
import {PoolSwapTest} from "v4-core/src/test/PoolSwapTest.sol";
import {PoolKey} from "v4-core/src/types/PoolKey.sol";
import {SqrtPriceMath} from "v4-core/src/libraries/SqrtPriceMath.sol";
import {TickMath} from "v4-core/src/libraries/TickMath.sol";
import {SafeCast} from "v4-core/src/libraries/SafeCast.sol";
import {LiquidityAmounts} from "v4-core/test/utils/LiquidityAmounts.sol";
import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {V4OnV3Router} from "../src/V4OnV3Router.sol";

contract Play is Script {
    address user;
    V4OnV3Router v4onV3Router = V4OnV3Router(0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0);
    IHooks myHook = IHooks(0xD760B02dD1132c40E54D84009704236886120040);

    function swap(address token0, address token1) public {
        vm.startBroadcast();
        user = msg.sender;
        int128 swapAmount = 2500_000_000;
        bool zeroForOne = true;

        // int256 sqrtPriceX96seed = 1584563250300000000000000000000000;
        // (IUniswapV3Pool pool, PoolKey memory key_, uint160 sqrtPriceX96) =
        //     initPools(feeSeed, tickSpacingSeed, sqrtPriceX96seed);
        // addLiquidity(pool, key_, sqrtPriceX96, lowerTickUnsanitized, upperTickUnsanitized, liquidityDeltaUnbound, false);

        // currency0.transfer(user, 1000 ether);
        Currency currency0 = Currency.wrap(token0);
        Currency currency1 = Currency.wrap(token1);

        uint256 balance0Before = currency0.balanceOf(user);
        uint256 balance1Before = currency1.balanceOf(user);
        console2.log("balance0 before:", balance0Before);
        console2.log("balance1 before:", balance1Before);

        // vm.startPrank(user);
        // IERC20(Currency.unwrap(currency0)).approve(address(pool), 1000 ether);
        // IERC20(Currency.unwrap(currency0)).approve(address(swapRouter), 1000 ether);
        console2.log("balance0 after approve");
        PoolKey memory key_ = PoolKey(currency0, currency1, 500, 10, myHook);
        v4onV3Router.swap(key_, zeroForOne, swapAmount);
        // vm.stopPrank();
        uint256 balance0After = currency0.balanceOf(user);
        uint256 balance1After = currency1.balanceOf(user);

        console2.log("balance0 after:", balance0After);
        console2.log("balance1 after:", balance1After);
    }
}
