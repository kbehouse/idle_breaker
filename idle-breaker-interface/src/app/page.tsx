"use client";

import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Zap, TrendingUp, Activity, Globe } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { useAccount } from "wagmi";
import { useEffect } from "react";
import Header from "@/components/layout/header";
import { redirect } from "next/navigation";
import useViewTransition from "@/hooks/useViewTransition";
import HexagonButton from "@/app/_components/HexagonButton";



export default function Web3Interface() {
  const { isConnected, address } = useAccount();
  const [activeView, setActiveView] = useState("overview");
  const viewTransition = useViewTransition();

  const handleViewChange = (view) => {
    viewTransition(() => {
      setActiveView(view);
    });
  };

  useEffect(() => {
    if (!isConnected) {
      redirect("/login");
    }
  }, [isConnected]);

  return (
    <>
      <Header />
      <div className="min-h-screen overflow-hidden relative text-white bg-gradient-to-t from-gray-950 via-gray-900 to-gray-800">
        <div className="container mx-auto p-4 relative z-10">
          {isConnected && (
            <>
              <motion.div
                className="flex justify-center space-x-4 mb-8"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ duration: 0.5, delay: 0.2 }}
              >
                <HexagonButton
                  icon={Globe}
                  label="Overview"
                  onClick={() => handleViewChange("overview")}
                  isActive={activeView === "overview"}
                />
                <HexagonButton
                  icon={Zap}
                  label="LP Pools"
                  onClick={() => handleViewChange("pools")}
                  isActive={activeView === "pools"}
                />
                <HexagonButton
                  icon={TrendingUp}
                  label="ETF"
                  onClick={() => handleViewChange("etf")}
                  isActive={activeView === "etf"}
                />
                <HexagonButton
                  icon={Activity}
                  label="Activity"
                  onClick={() => handleViewChange("activity")}
                  isActive={activeView === "activity"}
                />
              </motion.div>

              <AnimatePresence mode="wait">
                <motion.div
                  key={activeView}
                  initial={{ opacity: 0, scale: 0.9 }}
                  animate={{ opacity: 1, scale: 1 }}
                  exit={{ opacity: 0, scale: 0.9 }}
                  transition={{ duration: 0.3 }}
                  className="bg-gray-800 bg-opacity-30 backdrop-filter backdrop-blur-lg rounded-3xl p-6 shadow-2xl"
                >
                  {activeView === "overview" && (
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                      <Card className="bg-gradient-to-br from-blue-600 to-purple-600 text-white">
                        <CardContent className="p-6">
                          <h3 className="text-lg font-semibold mb-2">
                            Total Value Locked
                          </h3>
                          <p className="text-3xl font-bold">$1,750,000</p>
                        </CardContent>
                      </Card>
                      <Card className="bg-gradient-to-br from-green-500 to-teal-500 text-white">
                        <CardContent className="p-6">
                          <h3 className="text-lg font-semibold mb-2">
                            24h Volume
                          </h3>
                          <p className="text-3xl font-bold">$523,890</p>
                        </CardContent>
                      </Card>
                      <Card className="bg-gradient-to-br from-yellow-400 to-orange-500 text-white">
                        <CardContent className="p-6">
                          <h3 className="text-lg font-semibold mb-2">
                            ETF Performance
                          </h3>
                          <p className="text-3xl font-bold">+12.5%</p>
                        </CardContent>
                      </Card>
                    </div>
                  )}

                  {activeView === "pools" && (
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                      {[
                        {
                          name: "ETH-USDC",
                          liquidity: "1,000,000",
                          apy: "5.2%",
                          color: "from-blue-500 to-green-400",
                        },
                        {
                          name: "WBTC-ETH",
                          liquidity: "500,000",
                          apy: "4.8%",
                          color: "from-orange-500 to-yellow-400",
                        },
                        {
                          name: "LINK-ETH",
                          liquidity: "250,000",
                          apy: "6.1%",
                          color: "from-purple-500 to-pink-400",
                        },
                      ].map((pool) => (
                        <Card
                          key={pool.name}
                          className={`bg-gradient-to-br ${pool.color} text-white`}
                        >
                          <CardContent className="p-6">
                            <h3 className="text-lg font-semibold mb-2">
                              {pool.name}
                            </h3>
                            <p className="text-2xl font-bold mb-2">
                              ${pool.liquidity}
                            </p>
                            <p className="text-sm">APY: {pool.apy}</p>
                          </CardContent>
                        </Card>
                      ))}
                    </div>
                  )}

                  {activeView === "etf" && (
                    <Card className="bg-gradient-to-br from-yellow-400 to-orange-500 text-white">
                      <CardContent className="p-6">
                        <h2 className="text-2xl font-bold mb-4">
                          ETF Performance
                        </h2>
                        <p className="text-lg mb-2">Current Value: $10,500</p>
                        <p className="text-lg mb-2">24h Change: +5.2%</p>
                        <p className="text-lg">7d Change: +12.5%</p>
                      </CardContent>
                    </Card>
                  )}

                  {activeView === "activity" && (
                    <Card className="bg-gradient-to-br from-red-500 to-pink-500 text-white">
                      <CardContent className="p-6">
                        <h2 className="text-2xl font-bold mb-4">
                          Recent Activity
                        </h2>
                        <ul className="space-y-2">
                          <li>ETH-USDC Swap: 10 ETH for 18,500 USDC</li>
                          <li>Added Liquidity: 5 ETH + 9,250 USDC</li>
                          <li>ETF Rebalance: -2% LINK, +2% AAVE</li>
                        </ul>
                      </CardContent>
                    </Card>
                  )}
                </motion.div>
              </AnimatePresence>
            </>
          )}
        </div>
      </div>
    </>
  );
}
