// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title Rewards Contract
 * @dev Manages the loyalty and reward programs for users and providers on the platform, encouraging active participation and high-quality services.
 */
contract RewardsContract is Ownable, AccessControl {
    struct Reward {
        uint256 pointsNeeded;
        string rewardDescription;
    }

    struct UserRewards {
        uint256 totalPoints;
        uint256 redeemedPoints;
    }

    mapping(address => UserRewards) public userRewards;
    mapping(uint256 => Reward) public rewardsCatalog;
    uint256 public nextRewardId;

    event PointsAccumulated(address indexed user, uint256 points);
    event RewardRedeemed(address indexed user, uint256 rewardId, uint256 points);

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /**
     * @notice Allows users to earn points for each transaction or activity on the platform.
     * @param user The address of the user earning points.
     * @param points The number of points earned.
     */
    function accumulatePoints(address user, uint256 points) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(user != address(0), "Invalid user address");
        userRewards[user].totalPoints += points;
        emit PointsAccumulated(user, points);
    }

    /**
     * @notice Allows users to redeem their points for various rewards or services within the platform.
     * @param user The address of the user redeeming points.
     * @param rewardId The ID of the reward being redeemed.
     */
    function redeemRewards(address user, uint256 rewardId) external {
        require(userRewards[user].totalPoints - userRewards[user].redeemedPoints >= rewardsCatalog[rewardId].pointsNeeded, "Not enough points");

        userRewards[user].redeemedPoints += rewardsCatalog[rewardId].pointsNeeded;
        emit RewardRedeemed(user, rewardId, rewardsCatalog[rewardId].pointsNeeded);
    }

    /**
     * @notice Adds a new reward to the rewards catalog.
     * @param pointsNeeded The number of points required to redeem the reward.
     * @param rewardDescription A description of the reward.
     * @return The ID of the new reward.
     */
    function addReward(uint256 pointsNeeded, string calldata rewardDescription) external onlyOwner returns (uint256) {
        uint256 rewardId = nextRewardId++;
        rewardsCatalog[rewardId] = Reward(pointsNeeded, rewardDescription);
        return rewardId;
    }

    // Additional functionalities like updating or removing rewards, and querying user points could also be implemented.
}
