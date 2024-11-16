"use client";

import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Zap, Globe } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { useAccount } from "wagmi";
import { useEffect } from "react";
import Header from "@/components/layout/header";
import { redirect } from "next/navigation";
import useViewTransition from "@/hooks/useViewTransition";
import HexagonButton from "@/app/_components/HexagonButton";
import Liquidity from "@/app/_components/Liquidity";


export default function Web3Interface() {
  const { isConnected } = useAccount();
  const [activeView, setActiveView] = useState("liquidity");
  const viewTransition = useViewTransition();

  const handleViewChange = (view: string) => {
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
        <div className="container mx-auto p-4 relative z-10 flex flex-col items-center justify-center min-h-[calc(100vh-4rem)]">
          {isConnected && (
            <>
              <motion.div
                className="flex justify-center space-x-4 mb-8"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ duration: 0.5, delay: 0.2 }}
              >
                <HexagonButton
                  icon={Zap}
                  label="Liquidity"
                  onClick={() => handleViewChange("liquidity")}
                  isActive={activeView === "liquidity"}
                />
                <HexagonButton
                  icon={Globe}
                  label="Lending"
                  onClick={() => handleViewChange("lending")}
                  isActive={activeView === "lending"}
                />
              </motion.div>

              <AnimatePresence mode="wait">
                <motion.div
                  key={activeView}
                  initial={{ opacity: 0, scale: 0.9 }}
                  animate={{ opacity: 1, scale: 1 }}
                  exit={{ opacity: 0, scale: 0.9 }}
                  transition={{ duration: 0.3 }}
                  // className=""
                >
                  {activeView === "liquidity" && <Liquidity />}

                  {activeView === "lending" && (
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                      <Card className="bg-gradient-to-br from-blue-600 to-purple-600 text-white">
                        <CardContent className="p-6">
                          <h3 className="text-lg font-semibold mb-2">Supply</h3>
                          <p className="text-3xl font-bold">$1,750,000</p>
                        </CardContent>
                      </Card>
                      <Card className="bg-gradient-to-br from-green-500 to-teal-500 text-white">
                        <CardContent className="p-6">
                          <h3 className="text-lg font-semibold mb-2">
                            Interest Rate
                          </h3>
                          <p className="text-3xl font-bold">+12.5%</p>
                        </CardContent>
                      </Card>
                      <Card className="bg-gradient-to-br from-yellow-400 to-orange-500 text-white">
                        <CardContent className="p-6">
                          <h3 className="text-lg font-semibold mb-2">
                            Interest
                          </h3>
                          <p className="text-3xl font-bold">$523,890</p>
                        </CardContent>
                      </Card>
                    </div>
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
