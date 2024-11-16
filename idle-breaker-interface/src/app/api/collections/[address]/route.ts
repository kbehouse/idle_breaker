import { NextRequest, NextResponse } from 'next/server'
import type { NFTResponse } from '@/app/type'

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ address: string }> }
): Promise<NextResponse> {
  try {
    const { address } = await params
    const response = await fetch(
      `https://unichain-sepolia.blockscout.com/api/v2/addresses/${address}/nft/collections?type=ERC-721%2CERC-404%2CERC-1155`,
      {
        headers: {
          'Accept': 'application/json',
        },
      }
    )

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }

    const data = await response.json() as NFTResponse
    return NextResponse.json(data)

  } catch (error) {
    console.error('Error fetching NFT collections:', error)
    return NextResponse.json(
      { error: 'Failed to fetch NFT collections' },
      { status: 500 }
    )
  }
}
