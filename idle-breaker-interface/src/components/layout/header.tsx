"use client";

import { motion } from "framer-motion";
import { ConnectButton } from "@rainbow-me/rainbowkit";

const Header = () => {
  return (
    <motion.div
      className="flex justify-between items-center mb-8 fixed top-0 w-full bg-transparent z-50 px-4 py-2"
      initial={{ opacity: 0, y: -50 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5 }}
    >
      <h1 className="text-4xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-blue-400 to-purple-600">
        IDLE BREAKER
      </h1>
      <ConnectButton />
    </motion.div>
  );
};

export default Header;
