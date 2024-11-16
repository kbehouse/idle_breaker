'use client'

import { useQuery } from "@tanstack/react-query";
import type { NFTResponse } from '@/app/type'
import CardInfo from "./CardInfo";


export default function Liquidity() {

  const { data, isLoading, error } = useQuery<NFTResponse>({
    queryKey: ['nfts'],
    queryFn: () => 
      fetch(`/api/collections/0x914171a48aa2c306DD2D68c6810D6E2B4F4ACdc7`)
        .then((res) => res.json()),
  })

  if (isLoading) return <div>Loading...</div>
  if (error) return <div>Error loading data</div>
  if (!data) return <div>No data available</div>

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
      {data.items.map((item) => (
        item.token_instances.map((instance) => (
          <CardInfo key={instance.id} image_url={instance?.image_url} token_type={instance?.token_type} 
            token_address={item?.token.address}
            token_id={instance?.id}
          />
        ))
      ))}
    </div>
  )
}
