// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title Review Contract
 * @dev Manages the submission and retrieval of reviews and ratings for services on the platform, enhancing trust and transparency.
 */
contract ReviewContract is Ownable, AccessControl {
    struct Review {
        uint256 serviceId;
        address reviewer;
        string content;
        uint8 rating;
    }

    // Mapping of service ID to a list of reviews
    mapping(uint256 => Review[]) private serviceReviews;

    event ReviewSubmitted(uint256 indexed serviceId, address indexed reviewer, uint8 rating, string content);

    /**
     * @notice Submits a review for a service.
     * @dev Stores the review in the contract and emits an event for the new review submission.
     * @param serviceId The ID of the service being reviewed.
     * @param rating The rating given to the service (e.g., 1 to 5 stars).
     * @param content The written content of the review.
     */
    function submitReview(uint256 serviceId, uint8 rating, string calldata content) external {
        require(rating >= 1 && rating <= 5, "Invalid rating: must be between 1 and 5");
        serviceReviews[serviceId].push(Review(serviceId, msg.sender, content, rating));
        emit ReviewSubmitted(serviceId, msg.sender, rating, content);
    }

    /**
     * @notice Fetches reviews for a particular service.
     * @dev Returns a list of reviews for the specified service ID.
     * @param serviceId The ID of the service for which to retrieve reviews.
     * @return reviews An array of reviews for the specified service.
     */
    function getReviews(uint256 serviceId) external view returns (Review[] memory reviews) {
        return serviceReviews[serviceId];
    }

    // Additional functionalities like editing or deleting reviews, if necessary, could also be implemented here, ensuring proper access control and permissions.
}
