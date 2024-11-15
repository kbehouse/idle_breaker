## steps

for local

```
just deploy_USDC
just deploy_weth9
just deploy_DAI
just deploy_uniswapv3
just usdc_mint
just weth_deposit
just weth_deposit
just uni3_create_pool
just uni3_add_liquidity
just swap_usdc_to_eth

just deploy_swap_rounter
```


### Pool Price & Tick & Fee (500: 0.05%)
get pool to know price and tick
```
just uni3_slot0 
```

```
# ABI in abi/UniswapV3Pool.json

# function slot0()
#         external
#         view
#         returns (
#             uint160 sqrtPriceX96,
#             int24 tick,
#             uint16 observationIndex,
#             uint16 observationCardinality,
#             uint16 observationCardinalityNext,
#             uint8 feeProtocol,
#             bool unlocked
#         );
```

price formula:
```
 uint256 price = (uint256(sqrtPriceX96) * uint256(sqrtPriceX96)) >> 192;
        // console.log("Price: ", price);
        // # 1/(399973827/10^18*10^6) = 2500 USDC
        priceUSDC = 1  * 10**12 / price;
```



### User tick


get user upper & lower tick

```
just get_position_info
```

```
# ABI in abi/NonfungiblePositionManager.json

# struct Position {
#         // the nonce for permits
#         uint96 nonce;
#         // the address that is approved for spending this token
#         address operator;
#         // the ID of the pool with which this token is connected
#         uint80 poolId;
#         // the tick range of the position
#         int24 tickLower;
#         int24 tickUpper;
#         // the liquidity of the position
#         uint128 liquidity;
#         // the fee growth of the aggregate position as of the last action on the individual position
#         uint256 feeGrowthInside0LastX128;
#         uint256 feeGrowthInside1LastX128;
#         // how many uncollected tokens are owed to the position, as of the last computation
#         uint128 tokensOwed0;
#         uint128 tokensOwed1;
#     }
```

Show in range or out of range

### Saving (Lend)


ABI in abi/ERC20Saving.json


(Fake USDC: decimal = 6)

supply amount
```
just saving_supply_amount
```


supply interest
```
just saving_calculateInterest
```

## Blockscout

Get token id from following
```
just blockscout_logs
```

Get position by token id
```
TOKEN_ID=11689 just get_position_info
```
