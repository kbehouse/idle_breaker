import { Card, CardContent } from "@/components/ui/card";
import { useReadContract } from 'wagmi';
import { useEffect } from 'react';

// ABI 只需要包含 saving_supply_amount 函数
const ERC20SavingABI = [
  {
    inputs: [],
    name: "deposits",
    outputs: [{ type: "uint256" }],
    stateMutability: "view",
    type: "function"
  }
] as const;

const Lending = () => {
  const result = useReadContract({
    address: '0xf8915e6896FB575a95246793b150C56e2666dA11', // ERC20_SAVING address
    abi: ERC20SavingABI,
    functionName: 'deposits',
  });

  useEffect(() => {
    if (result.data) {
      console.log('Saving supply amount:', result.data); // BigInt
    }
    if (result.error) {
      console.error('Error fetching saving supply amount:', result.error);
    }
  }, [result.data, result.error]);
    
  console.log('result',result);

  return (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
      <Card className="bg-gradient-to-br from-blue-600 to-purple-600 text-white">
        <CardContent className="p-6">
          <h3 className="text-lg font-semibold mb-2">Supply</h3>
          <p className="text-3xl font-bold">$25,000</p>
        </CardContent>
      </Card>
      <Card className="bg-gradient-to-br from-green-500 to-teal-500 text-white">
        <CardContent className="p-6">
          <h3 className="text-lg font-semibold mb-2">Interest Rate</h3>
          <p className="text-3xl font-bold">5%</p>
        </CardContent>
      </Card>
      <Card className="bg-gradient-to-br from-yellow-400 to-orange-500 text-white">
        <CardContent className="p-6">
          <h3 className="text-lg font-semibold mb-2">Interest</h3>
          <p className="text-3xl font-bold">$30.69</p>
        </CardContent>
      </Card>
    </div>
  );
};

export default Lending;
