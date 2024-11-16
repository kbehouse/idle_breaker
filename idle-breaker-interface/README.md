# Idle Breaker Interface

A Next.js-based web interface for the Idle Breaker DeFi protocol, enabling users to interact with Uniswap V3/V4 liquidity positions.

## Features

- Connect wallet and view liquidity positions
- Manage Uniswap V3/V4 positions
- Real-time token price updates
- Token instance management
- Responsive design for all devices

## Prerequisites

- Node.js >= 18
- npm, yarn, or pnpm
- MetaMask or other Web3 wallet

## Getting Started

1. Install dependencies:
```bash
npm install
# or
yarn install
# or
pnpm install
```

2. Set up environment variables:
```bash
cp .env.example .env.local
```

3. Run the development server:
```bash
npm run dev
# or
yarn dev
# or
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

## Project Structure

```
src/
├── app/                 # App router pages
├── _components/         # Shared components
│   ├── CardInfo/       # Token card components
│   ├── Liquidity/      # Liquidity management
│   └── ...
├── hooks/              # Custom React hooks
├── types/              # TypeScript type definitions
└── utils/              # Utility functions
```

## Key Components

- `Liquidity.tsx`: Main component for managing liquidity positions
- `CardInfo.tsx`: Display token information and metadata
- `WalletConnect`: Wallet connection management

## Technologies Used

- Next.js 14
- TypeScript
- TailwindCSS
- wagmi
- viem
- WalletConnect
- Rainbowkit
- blockscout API

## Development

The application auto-updates as you edit source files. The project uses:
- [`next/font`](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) for font optimization
- TailwindCSS for styling
- TypeScript for type safety

## Deployment

The application can be deployed using Vercel:

```bash
npm run build
# or
yarn build
# or
pnpm build
# or
bun run build
```

For production deployment, use the [Vercel Platform](https://vercel.com/new).

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

MIT

## Support

For support, please open an issue in the GitHub repository.
