// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title ConciergeService Contract
 * @dev Manages the creation, listing, booking, cancellation, and rating of concierge services.
 * Inherits Ownable for ownership management and AccessControl for role-based access control.
 */
contract ConciergeService is Ownable, AccessControl, ReentrancyGuard {
    bytes32 public constant SERVICE_PROVIDER_ROLE = keccak256("SERVICE_PROVIDER_ROLE");

    struct Service {
        uint256 id;
        address provider;
        string description;
        uint256 price;
        bool active;
    }

    struct Booking {
        uint256 serviceId;
        address user;
        bool completed;
        bool cancelled;
    }

    uint256 private nextServiceId;
    uint256 private nextBookingId;

    mapping(uint256 => Service) public services;
    mapping(uint256 => Booking) public bookings;

    event ServiceAdded(uint256 indexed serviceId, address indexed provider, uint256 price);
    event ServiceBooked(uint256 indexed bookingId, uint256 indexed serviceId, address indexed user);
    event ServiceCompleted(uint256 indexed bookingId);
    event ServiceCancelled(uint256 indexed bookingId);

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /**
     * @notice Adds a new concierge service to the platform.
     * @dev Requires SERVICE_PROVIDER_ROLE. Emits a ServiceAdded event.
     * @param description Description of the service.
     * @param price Price of the service in the platform's token.
     */
    function addService(string memory description, uint256 price) external onlyRole(SERVICE_PROVIDER_ROLE) {
        uint256 serviceId = nextServiceId++;
        services[serviceId] = Service(serviceId, msg.sender, description, price, true);
        emit ServiceAdded(serviceId, msg.sender, price);
    }

    /**
     * @notice Books a service for the user.
     * @dev Non-reentrant to prevent reentrancy attacks. Emits a ServiceBooked event.
     * @param serviceId ID of the service to book.
     */
    function bookService(uint256 serviceId) external nonReentrant {
        require(services[serviceId].active, "Service is not active");
        uint256 bookingId = nextBookingId++;
        bookings[bookingId] = Booking(serviceId, msg.sender, false, false);
        emit ServiceBooked(bookingId, serviceId, msg.sender);
    }

    /**
     * @notice Marks a service as completed.
     * @dev Only callable by the service provider. Emits a ServiceCompleted event.
     * @param bookingId ID of the booking to mark as completed.
     */
    function completeService(uint256 bookingId) external {
        Booking storage booking = bookings[bookingId];
        require(services[booking.serviceId].provider == msg.sender, "Caller is not the service provider");
        booking.completed = true;
        emit ServiceCompleted(bookingId);
    }

    /**
     * @notice Cancels a booked service.
     * @dev Only callable by the user who booked the service or the service provider. Emits a ServiceCancelled event.
     * @param bookingId ID of the booking to cancel.
     */
    function cancelService(uint256 bookingId) external {
        Booking storage booking = bookings[bookingId];
        require(msg.sender == booking.user || services[booking.serviceId].provider == msg.sender, "Caller cannot cancel this booking");
        booking.cancelled = true;
        emit ServiceCancelled(bookingId);
    }
    
    // Additional functions like `rateService` can be implemented similarly,
    // following the design pattern of checking permissions and updating state accordingly.
}
