# 💰 RealCryptoV2

**RealCryptoV2** is an advanced ERC20 token built with Solidity that goes beyond basic token functionality. It includes a **native staking system**, **inactivity penalties**, and **automatic reward distribution**, making it a perfect educational project to understand smart contract development and crypto tokenomics.

---

## ✨ Key Features

- ✅ Based on OpenZeppelin’s ERC20 standard
- 🪙 Native **staking system** (no external contracts)
- 💤 Automatic **penalty for inactivity**
- 🎁 Daily **staking rewards** based on time locked
- 🔐 Ownership control via `Ownable`
- 📚 Designed for learning and experimentation with Solidity

---

## 📦 Contract Overview

| Function | Description |
|----------|-------------|
| `stake(uint256 amount)` | Allows users to lock their tokens and start earning rewards. |
| `unstake()` | Withdraw staked tokens and receive rewards based on staking duration. |
| `calculateReward(address user)` | View the accumulated reward for a given staker. |
| `transfer()` / `transferFrom()` | Overridden to check user activity and apply penalties if needed. |
| `_checkInactivity(address user)` | Internal function to burn 1% of a user's balance if inactive for 30+ days. |

---

## 🧠 What You’ll Learn

This project helps you understand:

- How to extend ERC20 functionality
- How to use structs and timestamps
- How to implement staking logic without external contracts
- How to enforce behavior using activity tracking
- How to reward or penalize users automatically

---

## 🛠️ Tech Stack

- **Solidity v0.8.24**
- **OpenZeppelin Contracts**
- Compatible with **Hardhat**, **Foundry**, or **Remix**

---

## 🚀 Getting Started

1. Clone the repository
2. Install dependencies (`npm install` if using Hardhat)
3. Deploy the contract to a local or testnet environment
4. Interact via Remix
---

## 📜 License

This project is licensed under **LGPL-3.0-only**. Refer to the header in the Solidity file or the [GNU Lesser General Public License](https://spdx.org/licenses/LGPL-3.0-only.html) documentation for more details.
