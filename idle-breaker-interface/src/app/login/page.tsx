"use client";

import BackgroundEffect from "./_components/BackgroundEffect";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { motion } from "framer-motion";
import Image from "next/image";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import { useAccount } from "wagmi";
import { useEffect } from "react";
import { redirect } from "next/navigation";
const LoginPage = () => {
  const { isConnected } = useAccount();
  useEffect(() => {
    if (isConnected) {
      redirect("/");
    }
  }, [isConnected]);
  return (
    <div className="min-h-screen flex items-center justify-center p-4">
      <BackgroundEffect />
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
      >
        <Card className="w-[350px] shadow-lg bg-gray-900/50 border-gray-800 backdrop-blur-sm">
          <CardHeader className="flex items-center justify-center pb-2">
            <div className="flex flex-col items-center space-y-2">
              <Image
                src="/logo.png"
                alt="Logo"
                width={80}
                height={80}
                className="mb-2"
              />
              <h2 className="text-xl font-semibold bg-gradient-to-r from-gray-200 to-gray-400 bg-clip-text text-transparent">
                IDLE BREAKER 🔨
              </h2>
            </div>
          </CardHeader>
          <CardContent>
            <div className="flex justify-center">
              <ConnectButton />
            </div>
          </CardContent>
        </Card>
      </motion.div>
    </div>
  );
};

export default LoginPage;
