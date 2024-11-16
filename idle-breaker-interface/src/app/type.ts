export interface Token {
  address: string;
  circulating_market_cap: number | null;
  decimals: number | null;
  exchange_rate: number | null;
  holders: string;
  icon_url: string | null;
  name: string;
  symbol: string;
  total_supply: string;
  type: string;
  volume_24h: number | null;
}

export interface TokenMetadata {
  description: string;
  image: string;
  name: string;
}

export interface TokenInstance {
  animation_url: string | null;
  external_app_url: string | null;
  id: string;
  image_url: string;
  is_unique: boolean | null;
  metadata: TokenMetadata;
  owner: string | null;
  token: Token | null;
  token_type: string;
  value: string | null;
}

export interface NFTItem {
  amount: string;
  token: Token;
  token_instances: TokenInstance[];
}

export interface NFTResponse {
  items: NFTItem[];
}
