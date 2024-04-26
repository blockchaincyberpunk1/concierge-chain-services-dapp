// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title Admin Contract for ConciergeChain Services
 * @dev Provides administrative functions to manage the platform effectively,
 * such as updating fees or resolving critical disputes. Utilizes OpenZeppelin's
 * Ownable and AccessControl for secure access management.
 */
contract AdminContract is Ownable, AccessControl {
    bytes32 public constant BAN_ROLE = keccak256("BAN_ROLE");

    // Fee structure
    struct Fees {
        uint256 serviceFee;
        uint256 transactionFee;
    }

    Fees public fees;

    // Mapping to track banned users
    mapping(address => bool) private _bannedUsers;

    event FeesUpdated(uint256 serviceFee, uint256 transactionFee);
    event UserBanned(address indexed user);
    event UserUnbanned(address indexed user);

    /**
     * @dev Initializes the contract by setting up roles and initial fee values.
     * @param initialOwner Address of the initial owner.
     * @param serviceFee Initial service fee.
     * @param transactionFee Initial transaction fee.
     */
    constructor(
        address initialOwner,
        uint256 serviceFee,
        uint256 transactionFee
    ) Ownable(initialOwner) {
        _setupRole(DEFAULT_ADMIN_ROLE, initialOwner);
        _setupRole(BAN_ROLE, initialOwner);
        fees = Fees(serviceFee, transactionFee);
    }

    /**
     * @notice Updates the fees for services and transactions on the platform.
     * @dev Restricted to the contract owner.
     * @param serviceFee New fee for services.
     * @param transactionFee New fee for transactions.
     */
    function updateFees(uint256 serviceFee, uint256 transactionFee) public onlyOwner {
        fees.serviceFee = serviceFee;
        fees.transactionFee = transactionFee;
        emit FeesUpdated(serviceFee, transactionFee);
    }

    /**
     * @notice Bans a user from using the platform.
     * @dev Restricted to addresses with BAN_ROLE.
     * @param user Address of the user to ban.
     */
    function banUser(address user) public onlyRole(BAN_ROLE) {
        require(!_bannedUsers[user], "Admin: User already banned");
        _bannedUsers[user] = true;
        emit UserBanned(user);
    }

    /**
     * @notice Unbans a user, allowing them to use the platform again.
     * @dev Restricted to addresses with BAN_ROLE.
     * @param user Address of the user to unban.
     */
    function unbanUser(address user) public onlyRole(BAN_ROLE) {
        require(_bannedUsers[user], "Admin: User not banned");
        _bannedUsers[user] = false;
        emit UserUnbanned(user);
    }

    /**
     * @notice Checks if a user is banned from the platform.
     * @param user Address of the user to check.
     * @return bool True if the user is banned, false otherwise.
     */
    function isUserBanned(address user) public view returns (bool) {
        return _bannedUsers[user];
    }
}
