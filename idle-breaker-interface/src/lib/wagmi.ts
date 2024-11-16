import { unichainSepolia } from 'wagmi/chains';
import { getDefaultConfig } from '@rainbow-me/rainbowkit';


  export const config = getDefaultConfig({
    appName: 'IDLE BREAKER',
    projectId: 'YOUR_PROJECT_ID',
    chains: [unichainSepolia],
    ssr: true, // If your dApp uses server side rendering (SSR)
  });