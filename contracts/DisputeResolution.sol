// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title DisputeResolution Contract
 * @dev Manages disputes within the ConciergeChain Services platform, providing mechanisms for raising and resolving conflicts. Inherits AccessControl for role-based permissions.
 */
contract DisputeResolution is AccessControl {
    bytes32 public constant ARBITRATOR_ROLE = keccak256("ARBITRATOR_ROLE");

    struct Dispute {
        uint256 id;
        address plaintiff;
        address defendant;
        string reason;
        bool resolved;
        string resolution;
    }

    uint256 private nextDisputeId;
    mapping(uint256 => Dispute) public disputes;

    event DisputeRaised(uint256 indexed disputeId, address indexed plaintiff, address indexed defendant, string reason);
    event DisputeResolved(uint256 indexed disputeId, string resolution);

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /**
     * @notice Allows users or providers to raise a dispute over a service.
     * @dev Stores the dispute details and emits a DisputeRaised event.
     * @param defendant Address of the user or provider the dispute is against.
     * @param reason Description of the dispute reason.
     * @return disputeId The id of the raised dispute.
     */
    function raiseDispute(address defendant, string memory reason) external returns (uint256 disputeId) {
        disputeId = nextDisputeId++;
        disputes[disputeId] = Dispute(disputeId, msg.sender, defendant, reason, false, "");
        emit DisputeRaised(disputeId, msg.sender, defendant, reason);
    }

    /**
     * @notice Allows an admin or designated arbitrator to resolve a dispute based on evidence provided.
     * @dev Marks the dispute as resolved and stores the resolution. Emits a DisputeResolved event.
     * @param disputeId Id of the dispute to resolve.
     * @param resolution Description of the dispute resolution.
     */
    function resolveDispute(uint256 disputeId, string memory resolution) external onlyRole(ARBITRATOR_ROLE) {
        Dispute storage dispute = disputes[disputeId];
        require(!dispute.resolved, "Dispute already resolved");

        dispute.resolved = true;
        dispute.resolution = resolution;
        emit DisputeResolved(disputeId, resolution);
    }

    // Additional functions to get dispute details or list disputes could be implemented here.

}
