"use client";

import { useQuery } from "@tanstack/react-query";
import type { NFTResponse } from "@/app/type";
import CardInfo from "./CardInfo";
import NonfungiblePositionManager from "@/abi/NonfungiblePositionManager";
import { useReadContracts } from "wagmi";

export default function Liquidity() {
  const { data, isLoading, error } = useQuery<NFTResponse>({
    queryKey: ["nfts"],
    queryFn: () =>
      fetch(`/api/collections/0x914171a48aa2c306DD2D68c6810D6E2B4F4ACdc7`).then(
        (res) => res.json()
      ),
  });

  const tokenIds =
    data?.items.flatMap((item) =>
      item.token_instances.map((instance) => BigInt(instance.id))
    ) || [];

  const { data: positions, isLoading: positionsLoading } = useReadContracts({
    contracts: tokenIds.map((id) => ({
      address: "0xB7F724d6dDDFd008eFf5cc2834edDE5F9eF0d075" as `0x${string}`,
      abi: NonfungiblePositionManager,
      functionName: "positions",
      args: [id],
    })),
    query: {
      retry: 3,
      retryDelay: 1500,
      staleTime: 10000,
    },
  });
  console.log("positions", positions, positionsLoading);

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error loading data</div>;
  if (!data) return <div>No data available</div>;

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
      {data.items.map((item) =>
        item.token_instances.map((instance) => (
          <CardInfo
            key={instance.id}
            image_url={instance?.image_url}
            token_type={instance?.token_type}
            token_address={item?.token.address}
            token_id={instance?.id}
          />
        ))
      )}
    </div>
  );
}
