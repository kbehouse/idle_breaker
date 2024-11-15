// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract ERC20Saving {
    IERC20 public token; // ERC-20 token used for deposits
    uint256 public interestRate; // 5% interest rate
    uint256 public constant RATE_DIVISOR = 10000; // For basis points calculations

    struct Deposit {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => Deposit) public deposits;

    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress);
        interestRate = 500; // 5% interest rate in basis points
    }

    // Supply tokens to the contract
    function supply(uint256 amount) external {
        require(amount > 0, "Must supply more than zero");

        // Transfer tokens from user to contract
        require(token.transferFrom(msg.sender, address(this), amount), "Token transfer failed");

        // Calculate interest on previous deposit
        uint256 owedInterest = calculateInterest(msg.sender);

        // Update user's deposit with new amount and accrued interest
        deposits[msg.sender].amount += amount + owedInterest;
        deposits[msg.sender].timestamp = block.timestamp;
    }

    // Withdraw supplied tokens with accrued interest
    function withdraw() external {
        uint256 depositAmount = deposits[msg.sender].amount;
        require(depositAmount > 0, "No funds to withdraw");

        uint256 owedInterest = calculateInterest(msg.sender);
        uint256 totalWithdrawal = depositAmount + owedInterest;

        // Reset user's deposit
        deposits[msg.sender].amount = 0;
        deposits[msg.sender].timestamp = 0;

        // Transfer tokens back to the user
        require(token.transfer(msg.sender, totalWithdrawal), "Token transfer failed");
    }

    // Calculate accrued interest based on time since last deposit or withdrawal
    function calculateInterest(address user) public view returns (uint256) {
        Deposit memory userDeposit = deposits[user];
        if (userDeposit.amount == 0) return 0;

        uint256 timeElapsed = block.timestamp - userDeposit.timestamp;
        uint256 annualInterest = (userDeposit.amount * interestRate) / RATE_DIVISOR;

        // Annual interest rate, simplified for demonstration (not compounding)
        uint256 accruedInterest = (annualInterest * timeElapsed) / 365 days;
        return accruedInterest;
    }

    // Get the contract's token balance
    function getContractTokenBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }
}