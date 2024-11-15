// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;

import {IUniswapV3MintCallback} from "@uniswap/v3-core/contracts/interfaces/callback/IUniswapV3MintCallback.sol";
import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {IUniswapV3Pool} from "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import {PoolAddress} from "@uniswap/v3-periphery/contracts/libraries/PoolAddress.sol";
import {LiquidityAmounts} from "@uniswap/v3-periphery/contracts/libraries/LiquidityAmounts.sol";
import {TickMath} from "@uniswap/v3-core/contracts/libraries/TickMath.sol";
import {IUniswapV3Factory} from "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";

import {console} from "forge-std/console.sol";

contract UniswapV3Minter is IUniswapV3MintCallback {
    address public immutable token0;
    address public immutable token1;
    IUniswapV3Pool public pool;

    constructor(address _factory, uint24 _fee, address _token0, address _token1) {
        token0 = _token0;
        token1 = _token1;
        // Get pool from factory
        address poolAddress = IUniswapV3Factory(_factory).getPool(_token0, _token1, _fee);
        require(poolAddress != address(0), "Pool does not exist");
        // pool = IUniswapV3Pool(PoolAddress.computeAddress(_factory, PoolAddress.getPoolKey(_token0, _token1, _fee)));
        pool = IUniswapV3Pool(poolAddress);
        console.log("UniswapV3Minter pool: ", address(pool));
    }

    // Minting function that initiates a mint on the Uniswap V3 pool
    // refer v3-periphery LiquidityManagement.addLiquidity()
    function mintPosition(int24 tickLower, int24 tickUpper, uint256 amount0Desired, uint256 amount1Desired)
        public
        returns (uint128 liquidity, uint256 amount0, uint256 amount1)
    {
        console.log("hi");
        // Assuming you have a way to call the Uniswap V3 pool's mint function
        // e.g., IUniswapV3Pool(pool).mint(...)
        // This would initiate the mint and then call `uniswapV3MintCallback`

        {
            (uint160 sqrtPriceX96,,,,,,) = pool.slot0();
            console.log("sqrtPriceX96: ", uint256(sqrtPriceX96));
            uint160 sqrtRatioAX96 = TickMath.getSqrtRatioAtTick(tickLower);
            uint160 sqrtRatioBX96 = TickMath.getSqrtRatioAtTick(tickUpper);

            console.log("sqrtPriceX96: ", uint256(sqrtPriceX96));
            console.log("sqrtRatioAX96: ", int256(sqrtRatioAX96));
            console.log("sqrtRatioBX96: ", int256(sqrtRatioBX96));

            liquidity = LiquidityAmounts.getLiquidityForAmounts(
                sqrtPriceX96, sqrtRatioAX96, sqrtRatioBX96, amount0Desired, amount1Desired
            );
        }

        console.log("liquidity: ", uint256(liquidity));
        console.log("pool address: ", address(pool));
        try pool.mint(msg.sender, tickLower, tickUpper, liquidity, "") returns (uint256 _amount0, uint256 _amount1) {
            amount0 = _amount0;
            amount1 = _amount1;
        } catch Error(string memory reason) {
            revert(reason);
        } catch (bytes memory reason) {
            revert(string(reason));
        }
    }

    // UniswapV3MintCallback implementation
    function uniswapV3MintCallback(uint256 amount0Owed, uint256 amount1Owed, bytes calldata data) external override {
        require(msg.sender == address(pool), "Unauthorized callback");

        console.log("uniswapV3MintCallback");
        console.log("amount0Owed", amount0Owed);
        console.log("amount1Owed", amount1Owed);
        console.log("data:");
        console.logBytes(data);
        // if (amount0Owed > 0) {
        //     require(IERC20(token0).transferFrom(msg.sender, address(pool), amount0Owed), "Token0 transfer failed");
        // }

        // if (amount1Owed > 0) {
        //     require(IERC20(token1).transferFrom(msg.sender, pool, amount1Owed), "Token1 transfer failed");
        // }
    }
}
