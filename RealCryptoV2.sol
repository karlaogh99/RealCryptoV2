// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RealCryptoV2 is ERC20, Ownable {
    uint256 public rewardRate = 100; // Tokens por día
    uint256 public inactivityLimit = 30 days;
    uint256 public inactivityPenalty = 1; // 1%

    struct StakeInfo {
        uint256 amount;
        uint256 timestamp;
    }

    struct ActivityInfo {
        uint256 lastTransfer;
    }

    mapping(address => StakeInfo) public stakes;
    mapping(address => ActivityInfo) public activity;

    constructor() ERC20("RealCryptoV2", "RCV2") Ownable(msg.sender) {
        _mint(msg.sender, 1_000_000 * 10 ** decimals());
    }

    // --------------------
    // OVERRIDE TRANSFER TO TRACK ACTIVITY
    // --------------------

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _checkInactivity(msg.sender);
        activity[msg.sender].lastTransfer = block.timestamp;
        return super.transfer(recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _checkInactivity(sender);
        activity[sender].lastTransfer = block.timestamp;
        return super.transferFrom(sender, recipient, amount);
    }

    // --------------------
    // STAKING FUNCTIONS
    // --------------------

    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be > 0");
        require(balanceOf(msg.sender) >= amount, "Not enough tokens");

        _transfer(msg.sender, address(this), amount);

        if (stakes[msg.sender].amount > 0) {
            uint256 reward = calculateReward(msg.sender);
            _mint(msg.sender, reward);
        }

        stakes[msg.sender].amount += amount;
        stakes[msg.sender].timestamp = block.timestamp;
    }

    function unstake() external {
        require(stakes[msg.sender].amount > 0, "No tokens staked");

        uint256 reward = calculateReward(msg.sender);
        uint256 amountToReturn = stakes[msg.sender].amount;

        delete stakes[msg.sender];

        _mint(msg.sender, reward);
        _transfer(address(this), msg.sender, amountToReturn);
    }

    function calculateReward(address user) public view returns (uint256) {
        StakeInfo memory info = stakes[user];
        if (info.amount == 0) return 0;

        uint256 timeStaked = block.timestamp - info.timestamp;
        uint256 daysStaked = timeStaked / 1 days;

        return daysStaked * rewardRate;
    }

    // --------------------
    // INACTIVITY PENALTY
    // --------------------

    function _checkInactivity(address user) internal {
        if (activity[user].lastTransfer == 0) return;

        if (block.timestamp - activity[user].lastTransfer > inactivityLimit) {
            uint256 balance = balanceOf(user);
            uint256 penaltyAmount = (balance * inactivityPenalty) / 100;
            if (penaltyAmount > 0) {
                _burn(user, penaltyAmount);
            }
        }
    }
}
