# Idle Breaker

A DeFi project based on Uniswap V3/V4 for optimizing idle fund management.

## Project Structure

This project consists of three main components:
- UniswapV4 Hooks Implementation
- UniswapV3 Integration
- Web Interface

## Quick Start

### UniswapV4 Hooks

Implementation of custom trading logic using UniswapV4 hooks.

```bash
cd idle_breaker_hooks
forge build
```

For detailed configuration and usage, please refer to `idle_breaker_hooks/README.md`

### UniswapV3 Integration

The UniswapV3 integration module handles interactions with the Uniswap V3 protocol.

```bash
cd idle_breaker_univ3
forge build
```

For detailed instructions, please refer to `idle_breaker_univ3/README.md`

### Web Interface

The user interface is built with Next.js.

```bash
cd idle-breaker-interface
bun install
bun dev
```

For detailed instructions, please refer to `idle-breaker-interface/README.md`

## Tech Stack

- Solidity
- Foundry
- Next.js
- TypeScript
- Uniswap V3/V4 SDK

## Prerequisites

- Node.js >= 18
- Foundry
- Git

## Contributing

Pull requests and issues are welcome.

## License

MIT
