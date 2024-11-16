"use client";

import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Zap, Globe } from "lucide-react";
import { useAccount } from "wagmi";
import { useEffect } from "react";
import Header from "@/components/layout/header";
import { redirect } from "next/navigation";
import useViewTransition from "@/hooks/useViewTransition";
import HexagonButton from "@/app/_components/HexagonButton";
import Liquidity from "@/app/_components/Liquidity";
import Lending from "@/app/_components/Lending";

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
                  className="min-h-[300px] max-h-[450px] overflow-y-auto scrollbar-thin scrollbar-thumb-gray-600 scrollbar-track-gray-900 hover:scrollbar-thumb-gray-500"
                >
                  {activeView === "liquidity" && <Liquidity />}

                  {activeView === "lending" && (
                    <Lending />
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
