"use client";

import { useQuery } from "@tanstack/react-query";
import type { NFTResponse } from "@/app/type";
import CardInfo from "./CardInfo";
import NonfungiblePositionManager from "@/abi/NonfungiblePositionManager";
import { useReadContracts } from "wagmi";
import { useMemo } from "react";
import { useAccount } from "wagmi";

export default function Liquidity() {
  const { address } = useAccount();
  const { data, error } = useQuery<NFTResponse>({
    queryKey: ["nfts"],
    enabled: !!address,
    queryFn: () =>
      fetch(`/api/collections/${address}`).then((res) => res.json()),
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

  const filterData = useMemo(() => {
    const zeroPotionIndexes = positions
      ?.map((position, index) =>
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        (position?.result as any)[7] === 0n ? index : null
      )
      .filter((index) => index !== null);

    const items = data?.items.map((item) => {
      const { token_instances } = item;
      return {
        ...item,
        token_instances: token_instances.filter(
          (instance, index) => !zeroPotionIndexes?.includes(index)
        ),
      };
    });
    return { items: items ?? [] };
  }, [data?.items, positions]);

  if (positionsLoading) return <div>Loading...</div>;
  if (error) return <div>Error loading data</div>;
  if (!filterData.items.length) return <div>No data available</div>;

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
      {filterData.items.map((item) =>
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
