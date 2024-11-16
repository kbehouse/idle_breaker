// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
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
import {ISwapRouter} from "./v3/ISwapRouter.sol";
import {Currency} from "v4-core/src/types/Currency.sol";
import {console2} from "forge-std/console2.sol";

uint160 constant MIN_PRICE_LIMIT = TickMath.MIN_SQRT_PRICE + 1;
uint160 constant MAX_PRICE_LIMIT = TickMath.MAX_SQRT_PRICE - 1;

contract V4OnV3Router {
    uint24 constant UNISWAP_V3_POOL_FEE = 500;
    ISwapRouter swapRouter;
    PoolSwapTest swapRouterV4;

    constructor(address _swapRouter, address _swapRouterV4) {
        swapRouter = ISwapRouter(_swapRouter);
        swapRouterV4 = PoolSwapTest(_swapRouterV4);
    }

    function swap(PoolKey memory key_, bool zeroForOne, int128 amountSpecified) external {
        if (amountSpecified == 0) amountSpecified = 1;
        if (amountSpecified == type(int128).min) amountSpecified = type(int128).min + 1;
        // v3 swap
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: Currency.unwrap(key_.currency0),
            tokenOut: Currency.unwrap(key_.currency1),
            fee: UNISWAP_V3_POOL_FEE, // Uniswap V3 pool fee tier
            recipient: msg.sender,
            deadline: block.timestamp + 3600, // 1 hour from now
            amountIn: uint256(uint128(amountSpecified)),
            amountOutMinimum: 0, // for test, No minimum amount of WETH
            sqrtPriceLimitX96: 0 // No price limit
        });

        // Execute the swap
        swapRouter.exactInputSingle(params);
        // v4 swap
        IPoolManager.SwapParams memory swapParams = IPoolManager.SwapParams({
            zeroForOne: zeroForOne,
            amountSpecified: amountSpecified,
            sqrtPriceLimitX96: zeroForOne ? MIN_PRICE_LIMIT : MAX_PRICE_LIMIT
        });
        PoolSwapTest.TestSettings memory testSettings =
            PoolSwapTest.TestSettings({takeClaims: false, settleUsingBurn: false});

        BalanceDelta delta;
        try swapRouterV4.swap(key_, swapParams, testSettings, "") returns (BalanceDelta delta_) {
            delta = delta_;
        } catch (bytes memory reason) {
            console2.log("swap fail reason:");
            console2.logBytes(reason);
        }
    }
}
