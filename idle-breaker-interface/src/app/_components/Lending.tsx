import { Card, CardContent } from "@/components/ui/card";
import { useReadContract } from "wagmi";
import { Skeleton } from "@/components/ui/skeleton";
import { formatAmount } from "@/lib/utils";
import ERC20SavingABI from "@/abi/ERC20SavingABI";

const Lending = () => {

  const { data: depositAmount, isLoading } = useReadContract({
    address: "0xf8915e6896FB575a95246793b150C56e2666dA11",
    abi: ERC20SavingABI,
    functionName: "deposits",
    args: ["0x914171a48aa2c306DD2D68c6810D6E2B4F4ACdc7"], // TODO: user address
    query: {
      retry: 3,
      retryDelay: 1500,
      staleTime: 10000,
    },
  });

  const { data: interestAmount, isLoading: interestLoading } = useReadContract({
    address: "0xf8915e6896FB575a95246793b150C56e2666dA11",
    abi: ERC20SavingABI,
    functionName: "calculateInterest",
    args: ["0x914171a48aa2c306DD2D68c6810D6E2B4F4ACdc7"], // TODO: user address
    query: {
      retry: 3,
      retryDelay: 1500,
      staleTime: 10000,
    },
  });


  return (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
      <Card className="bg-gradient-to-br from-blue-600 to-purple-600 text-white">
        <CardContent className="p-6">
          <h3 className="text-lg font-semibold mb-2">Supply</h3>
          {isLoading ? (
            <Skeleton className="h-9 w-32 bg-white/20" />
          ) : (
            <p className="text-3xl font-bold">
              {`$${formatAmount(depositAmount || 0n)}` || "-"}
            </p>
          )}
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
          {interestLoading ? (
            <Skeleton className="h-9 w-32 bg-white/20" />
          ) : (
            <p className="text-3xl font-bold">{`$${formatAmount(interestAmount || 0n)}` || "-"}</p>
          )}
        </CardContent>
      </Card>
    </div>
  );
};

export default Lending;
