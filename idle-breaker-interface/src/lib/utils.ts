import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}


export const formatAmount = (amount: bigint) => {
  const humanReadable = Number(amount) / Math.pow(10, 6);
  return humanReadable.toFixed(2);
}