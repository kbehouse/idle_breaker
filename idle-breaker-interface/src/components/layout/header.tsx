"use client";

import { motion } from "framer-motion";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import Image from "next/image";
const Header = () => {
  return (
    <motion.div
      className="flex justify-between items-center mb-8 fixed top-0 w-full bg-transparent z-50 px-4 py-2"
      initial={{ opacity: 0, y: -50 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5 }}
    >
      <Image
        src="/logo.png"
        alt="Logo"
        width={80}
        height={80}
        className="mr-[20px]"
        />
      <ConnectButton />
    </motion.div>
  );
};

export default Header;
