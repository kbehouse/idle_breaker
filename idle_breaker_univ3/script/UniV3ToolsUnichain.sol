// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.7.6;
pragma abicoder v2;

import "forge-std/Script.sol";

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import {PoolAddress} from "@uniswap/v3-periphery/contracts/libraries/PoolAddress.sol";
import {LiquidityAmounts} from "@uniswap/v3-periphery/contracts/libraries/LiquidityAmounts.sol";
import "@uniswap/v3-core/contracts/libraries/TickMath.sol";
import {INonfungiblePositionManager} from "@uniswap/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol";
import {IPoolInitializer} from "@uniswap/v3-periphery/contracts/interfaces/IPoolInitializer.sol";
import {IERC20} from "forge-std/interfaces/IERC20.sol";
// REFER IT!
import {UniswapV3Pool} from "@uniswap/v3-core/contracts/UniswapV3Pool.sol";
import {UniswapV3Minter} from "../src/UniswapV3Minter.sol";
import {SqrtPriceMath} from "@uniswap/v3-core/contracts/libraries/SqrtPriceMath.sol";
import {ISwapRouter} from "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
// from https://docs.uniswap.org/contracts/v3/guides/swaps/single-swaps
import {SwapExamples} from "../src/SwapExamples.sol";
// import {UniswapV3Liquidity} from "../src/UniswapV3Liquidity.sol";

address constant DAI = 0x5FbDB2315678afecb367f032d93F642f64180aa3;
address constant USDC = 0x65cbd6B0c3282BA6FB86a72d4f2361b02E5A710D;
address constant WETH = 0x848D91e44c486bdeb20E69dfaB28071a6DAE5203;


address constant NONFUNGIBLE_POSITION_MANAGER = 0xB7F724d6dDDFd008eFf5cc2834edDE5F9eF0d075;
uint24 constant UNISWAP_V3_POOL_FEE = 500;

address constant UNISWAP_V3_FACTORY = 0x1F98431c8aD98523631AE4a59f267346ea31F984;

address constant UNISWAP_V3_LIQUIDITY = 0xa513E6E4b8f2a923D98304ec87F64353C4D5C853;

address constant SWAP_ROUTER02 = 0xd1AAE39293221B77B0C71fBD6dCb7Ea29Bb5B166;

// self deployed
address constant SWAP_EXAMPLES = 0xc3e53F4d16Ae77Db1c982e75a937B9f60FE63690;

address constant MY_SWAP_ROUTER = 0x9b4539c312744c2fed34C29D58999133Aca4e9A1;


interface IUniswapV3Liquidity {
    function mintNewPosition(uint256 amount0ToAdd, uint256 amount1ToAdd)
        external
        returns (uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1);
}

contract UniV3ToolsUnichain is Script {
    IERC20 private constant dai = IERC20(DAI);
    IERC20 private constant usdc = IERC20(USDC);
    IERC20 private constant weth = IERC20(WETH);

    INonfungiblePositionManager public nonfungiblePositionManager =
        INonfungiblePositionManager(NONFUNGIBLE_POSITION_MANAGER);

    IUniswapV3Liquidity public uniswapV3Liquidity = IUniswapV3Liquidity(UNISWAP_V3_LIQUIDITY);

    function createPool() public {
        vm.startBroadcast();
        // from https://support.uniswap.org/hc/en-us/articles/21068898875661-How-to-convert-a-price-to-a-tick-that-can-be-initialized
        // target price = 2500 USDC/ETH
        // token 2 / token 1 = 1*10^18 / 2500*10^6 = 400,000,000
        // sqrt(400,000,000) * 2^96
        uint160 sqrtPriceX96 = uint160(1584563250300000000000000000000000);
        nonfungiblePositionManager.createAndInitializePoolIfNecessary(
            address(usdc), address(weth), UNISWAP_V3_POOL_FEE, sqrtPriceX96
        );
    }

    function addLiquidityMyCB(uint256 amountUSDC, uint256 amountETH) public {
        vm.startBroadcast();

        // Create minter contract
        UniswapV3Minter minter = new UniswapV3Minter(UNISWAP_V3_FACTORY, UNISWAP_V3_POOL_FEE, USDC, WETH);

        // Approve tokens
        usdc.approve(address(minter), amountUSDC);
        weth.approve(address(minter), amountETH);

        // Calculate ticks around current price
        IUniswapV3Pool pool = getPool(USDC, WETH);
        int24 tickSpacing = pool.tickSpacing();
        (, int24 currentTick,,,,,) = pool.slot0();
        console.log("currentTick: ", currentTick);
        console.log("tickSpacing: ", tickSpacing);
        currentTick = currentTick - (currentTick % tickSpacing);
        int24 tickLower = currentTick - tickSpacing * 10; // 10 tick spacings below current
        int24 tickUpper = currentTick + tickSpacing * 10; // 10 tick spacings above current
        console.log("tickLower: ", tickLower);
        console.log("tickUpper: ", tickUpper);
        // Mint position
        (uint128 liquidity, uint256 amount0, uint256 amount1) =
            minter.mintPosition(tickLower, tickUpper, amountUSDC, amountETH);

        console.log("Minted position:");
        console.log("Liquidity:", uint256(liquidity));
        console.log("USDC used:", amount0);
        console.log("WETH used:", amount1);
    }

    function addLiquidity(uint256 amountUSDC, uint256 amountETH, address recipient) public {
        vm.startBroadcast();

        console.log("--------------------addLiquidity---------------------");
        
        // console.log("Approve USDC");
        usdc.approve(address(nonfungiblePositionManager), type(uint256).max);
        // console.log("Approve WETH");
        weth.approve(address(nonfungiblePositionManager), type(uint256).max);


        //---------------------DEBUG check------------------//
        IUniswapV3Pool pool = getPool(USDC, WETH);
        int24 tickSpacing = pool.tickSpacing();
        (uint160 sqrtPriceX96, int24 currentTick,,,,,) = pool.slot0();
        console.log("currentTick: ", currentTick);
        console.log("tickSpacing: ", tickSpacing);
        currentTick = currentTick - (currentTick % tickSpacing);
        int24 tickLower = currentTick - tickSpacing * 100; // 10 tick spacings below current
        int24 tickUpper = currentTick + tickSpacing * 100; // 10 tick spacings above current
        console.log("tickLower: ", tickLower);
        console.log("tickUpper: ", tickUpper);

        console.log("sqrtPriceX96: ", uint256(sqrtPriceX96));

        uint160 sqrtRatioAX96 = TickMath.getSqrtRatioAtTick(tickLower);
        uint160 sqrtRatioBX96 = TickMath.getSqrtRatioAtTick(tickUpper);

        uint128 liquidity =
            LiquidityAmounts.getLiquidityForAmounts(sqrtPriceX96, sqrtRatioAX96, sqrtRatioBX96, amountUSDC, amountETH);

        int256 amount0Pool = SqrtPriceMath.getAmount0Delta(
            TickMath.getSqrtRatioAtTick(tickLower), TickMath.getSqrtRatioAtTick(tickUpper), int128(liquidity)
        );
        int256 amount1Pool = SqrtPriceMath.getAmount1Delta(
            TickMath.getSqrtRatioAtTick(tickLower), TickMath.getSqrtRatioAtTick(tickUpper), int128(liquidity)
        );

        console.log("amount0: ", amount0Pool);
        console.log("amount1: ", amount1Pool);
        // console.log("sqrtRatioAX96: ", int256(sqrtRatioAX96));
        // console.log("sqrtRatioBX96: ", int256(sqrtRatioBX96));

        // console.log("liquidity: ", int256(liquidity));

        INonfungiblePositionManager.MintParams memory params = INonfungiblePositionManager.MintParams({
            token0: USDC,
            token1: WETH,
            fee: UNISWAP_V3_POOL_FEE,
            // 198079 from uniswap v3 pool slot0().tick
            // tick calculated from https://support.uniswap.org/hc/en-us/articles/21068898875661-How-to-convert-a-price-to-a-tick-that-can-be-initialized
            tickLower: tickLower,
            tickUpper: tickUpper,
            amount0Desired: uint256(amount0Pool),
            amount1Desired: uint256(amount1Pool), // Set to amount1Desired instead of 0
            amount0Min: 0,
            amount1Min: 0,
            recipient: recipient,
            deadline: block.timestamp + 60000
        });
        nonfungiblePositionManager.mint(params);
        // Note that the pool defined by DAI/USDC and fee tier 0.3% must already be created and initialized in order to mint
        // (uint256 tokenId, uint256 retLiquidity, uint256 amount0, uint256 amount1) =
        //     nonfungiblePositionManager.mint(params);
        // console.log("tokenId: ", tokenId);
        // console.log("retLiquidity: ", retLiquidity);
        // console.log("amount0: ", amount0);
        // console.log("amount1: ", amount1);

        // console.log("after addLiquidity, usdc balance: ", usdc.balanceOf(msg.sender));
        // console.log("after addLiquidity, weth balance: ", weth.balanceOf(msg.sender));
    }

    /// @dev Returns the pool for the given token pair and fee. The pool contract may or may not exist.
    function getPool(address tokenA, address tokenB) private pure returns (IUniswapV3Pool) {
        return IUniswapV3Pool(
            PoolAddress.computeAddress(UNISWAP_V3_FACTORY, PoolAddress.getPoolKey(tokenA, tokenB, UNISWAP_V3_POOL_FEE))
        );
    }

    function getTickPrice(int24 tick) external pure returns (uint256 price) {
        // Calculate the square root price at the current tick
        uint160 sqrtPriceX96 = TickMath.getSqrtRatioAtTick(tick);

        // Convert the square root price to a regular price
        // price = (sqrtPriceX96 * sqrtPriceX96) / (2**192)
        price = (uint256(sqrtPriceX96) * uint256(sqrtPriceX96)) >> 192; // Right shift to account for the fixed point scaling
    }

    function getTick_ETH_USDC_Price(int24 tick) external pure returns (uint256 priceUSDC) {
        // Calculate the square root price at the current tick
        uint160 sqrtPriceX96 = TickMath.getSqrtRatioAtTick(tick);

        // Convert the square root price to a regular price
        // price = (sqrtPriceX96 * sqrtPriceX96) / (2**192)
        uint256 price = (uint256(sqrtPriceX96) * uint256(sqrtPriceX96)) >> 192;
        priceUSDC = 1  * 10**12 / price;
    }

    function ethPrice() external view returns (uint256 priceUSDC) {
        IUniswapV3Pool pool = getPool(USDC, WETH);
        (uint160 sqrtPriceX96,,,,,,) = pool.slot0();
        uint256 price = (uint256(sqrtPriceX96) * uint256(sqrtPriceX96)) >> 192;
        // console.log("Price: ", price);
        // # 1/(399973827/10^18*10^6) = 2500 USDC
        priceUSDC = 1  * 10**12 / price;
    }


    function swapUSDCForWETH(uint256 amountIn) external {
        vm.startBroadcast();
        console.log("--------------------swapUSDCForWETH---------------------");
        console.log("before swapUSDCForWETH, usdc balance: ", usdc.balanceOf(msg.sender));
        console.log("before swapUSDCForWETH, weth balance: ", weth.balanceOf(msg.sender));
        // Approve the router to spend USDC
        IERC20(USDC).approve(address(MY_SWAP_ROUTER), amountIn*2);

        console.log("amountUSDC: ", amountIn);
        ISwapRouter swapRouter = ISwapRouter(MY_SWAP_ROUTER); 
        // Set up the swap parameters
        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: USDC,
                tokenOut: WETH,
                fee: UNISWAP_V3_POOL_FEE, // Uniswap V3 pool fee tier
                recipient: msg.sender,
                deadline: block.timestamp + 3600, // 1 hour from now
                amountIn: amountIn,
                amountOutMinimum: 0, // for test, No minimum amount of WETH
                sqrtPriceLimitX96: 0 // No price limit
            });

        // Execute the swap
        uint256 amountOut = swapRouter.exactInputSingle(params);
        console.log("amountOut: ", amountOut);
        // Emit event or handle the amountOut as needed

        console.log("after swapUSDCForWETH, usdc balance: ", usdc.balanceOf(msg.sender));
        console.log("after swapUSDCForWETH, weth balance: ", weth.balanceOf(msg.sender));
    }

    
    function swapUSDCForWETHUsingSwapExample(uint256 amountIn) external {
        vm.startBroadcast();
        console.log("msg.sender:", msg.sender);
        console.log("msgSender balance of usdc: ", usdc.balanceOf(msg.sender));
        // Approve the router to spend USDC
        usdc.approve(address(SWAP_EXAMPLES), amountIn);

        SwapExamples swapExamples = SwapExamples(SWAP_EXAMPLES);
        console.log("amountUSDC: ", amountIn);
        
        // Execute the swap
        uint256 amountOut = swapExamples.swapUSDC2ETH(amountIn);
        console.log("amountOut: ", amountOut);
        // Emit event or handle the amountOut as needed
        vm.stopBroadcast();
    }

    function removeAllLiquidity(
        uint256 tokenId
    ) external {
        vm.startBroadcast();
        console.log("--------------------removeAllLiquidity---------------------");
        console.log("Before remove liquidity, usdc balance: ", usdc.balanceOf(msg.sender));

        INonfungiblePositionManager manager = INonfungiblePositionManager(NONFUNGIBLE_POSITION_MANAGER);

          (, , , , , , , uint128 liquidity, , , , ) = manager.positions(tokenId);

      
        // Step 2: Collect tokens
        INonfungiblePositionManager.CollectParams memory collectParams =
            INonfungiblePositionManager.CollectParams({
                tokenId: tokenId,
                recipient: msg.sender,
                amount0Max: type(uint128).max,
                amount1Max: type(uint128).max
            });

        (uint256 feeAmount0_, uint256 feeAmount1_) = manager.collect(collectParams);
        console.log("feeAmount0_: ", feeAmount0_);
        console.log("feeAmount1_: ", feeAmount1_);
        console.log("after first collect, usdc balance: ", usdc.balanceOf(msg.sender));

        

        // Step 1: Decrease liquidity
        INonfungiblePositionManager.DecreaseLiquidityParams memory decreaseParams =
            INonfungiblePositionManager.DecreaseLiquidityParams({
                tokenId: tokenId,
                liquidity: liquidity,
                amount0Min: 0,
                amount1Min: 0,
                deadline: block.timestamp+3600
            });

        (uint256 amount0, uint256 amount1) = manager.decreaseLiquidity(decreaseParams);

        console.log("amount0: ", amount0);
        console.log("amount1: ", amount1);

        console.log("after decreaseLiquidity, usdc balance: ", usdc.balanceOf(msg.sender));

        

        (uint256 feeAmount0, uint256 feeAmount1) = manager.collect(collectParams);
        console.log("feeAmount0: ", feeAmount0);
        console.log("feeAmount1: ", feeAmount1);
        console.log("after second collect, usdc balance: ", usdc.balanceOf(msg.sender));

    }

}
