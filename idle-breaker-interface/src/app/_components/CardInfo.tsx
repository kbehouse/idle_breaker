"use client";

import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import Link from "next/link";

interface TradingCardProps {
  image_url: string;
  token_type: string;
  token_address?: string;
  token_id?: string;
}

export default function CardInfo({
  token_type = "ERC-721",
  image_url,
  token_address,
  token_id,
}: TradingCardProps) {
  const explorerUrl = token_address && token_id 
    ? `https://unichain-sepolia.blockscout.com/token/${token_address}/instance/${token_id}`
    : "#";

  return (
    <div className="flex gap-4 bg-gray-800 bg-opacity-30 backdrop-filter backdrop-blur-lg rounded-3xl p-6 shadow-2xl">
      <Link href={explorerUrl} target="_blank" rel="noopener noreferrer">
        <Card className="relative w-[300px] h-[510px] bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 border-gray-800 overflow-hidden rounded-[40px] transition-transform duration-300 hover:scale-105 cursor-pointer">
          <div
            className="relative p-4 flex justify-between items-start h-full bg-no-repeat bg-cover bg-center"
            style={{ backgroundImage: `url(${image_url || ""})` }}
          >
            <Badge className="absolute top-4 right-4 bg-white text-black hover:bg-white/90">
              {token_type}
            </Badge>
          </div>
        </Card>
      </Link>
    </div>
  );
}
