const ERC20SavingABI = [
    {
      inputs: [{ type: "address", name: "account" }],
      name: "deposits",
      outputs: [{ type: "uint256" }],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [{ type: "address", name: "account" }],
      name: "calculateInterest",
      outputs: [{ type: "uint256" }],
      stateMutability: "view",
      type: "function",
    }
  ] as const;
  
export default ERC20SavingABI;