import { motion } from "framer-motion";

interface HexagonButtonProps {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  icon: any;
  label: string;
  onClick: () => void;
  isActive: boolean;
}

const HexagonButton = ({ icon: Icon, label, onClick, isActive }: HexagonButtonProps) => (
  <motion.button
    className={`relative w-24 h-28 ${
      isActive ? "text-blue-400" : "text-gray-400"
    } hover:text-blue-300 transition-colors duration-300`}
    onClick={onClick}
    whileHover={{ scale: 1.1 }}
    whileTap={{ scale: 0.95 }}
  >
    <svg
      className="absolute inset-0"
      viewBox="0 0 100 100"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
    >
      <path
        d="M50 0L93.3 25V75L50 100L6.7 75V25L50 0Z"
        fill="currentColor"
        fillOpacity="0.1"
      />
      <path
        d="M50 0L93.3 25V75L50 100L6.7 75V25L50 0Z"
        stroke="currentColor"
        strokeWidth="2"
      />
    </svg>
    <div className="absolute inset-0 flex flex-col items-center justify-center">
      <Icon className="w-8 h-8 mb-2" />
      <span className="text-xs">{label}</span>
    </div>
  </motion.button>
);

export default HexagonButton;
