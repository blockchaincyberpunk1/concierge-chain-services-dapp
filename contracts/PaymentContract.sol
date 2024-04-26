// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Payment Contract for ConciergeChain Services
 * @dev Manages payment functionalities, ensuring secure transactions between users and service providers.
 * Utilizes the ERC20 interface for token interactions. Inherits from OpenZeppelin's Ownable for ownership management.
 */
contract PaymentContract is Ownable {
    IERC20 public paymentToken;

    mapping(uint256 => Payment) public payments;
    uint256 public nextPaymentId;

    struct Payment {
        address payer;
        address payee;
        uint256 amount;
        bool isReleased;
        bool isRefunded;
    }

    event PaymentCreated(uint256 indexed paymentId, address indexed payer, address indexed payee, uint256 amount);
    event PaymentReleased(uint256 indexed paymentId, address indexed payee);
    event PaymentRefunded(uint256 indexed paymentId, address indexed payer);

    /**
     * @dev Sets the payment token used for transactions.
     * @param _paymentToken Address of the ERC20 token to be used for payments.
     */
    constructor(IERC20 _paymentToken) {
        paymentToken = _paymentToken;
    }

    /**
     * @notice Creates a payment from a user to a service provider.
     * @dev Stores the payment details and transfers the tokens to this contract.
     * @param payee Address of the service provider receiving the payment.
     * @param amount Amount of tokens to be paid.
     * @return paymentId The id of the created payment.
     */
    function makePayment(address payee, uint256 amount) external returns (uint256 paymentId) {
        paymentId = nextPaymentId++;
        payments[paymentId] = Payment(msg.sender, payee, amount, false, false);

        require(paymentToken.transferFrom(msg.sender, address(this), amount), "Payment failed");

        emit PaymentCreated(paymentId, msg.sender, payee, amount);
    }

    /**
     * @notice Releases a payment to the service provider upon service completion.
     * @dev Can only be called by the owner (platform admin).
     * @param paymentId Id of the payment to release.
     */
    function releasePayment(uint256 paymentId) external onlyOwner {
        Payment storage payment = payments[paymentId];
        require(!payment.isReleased, "Payment already released");
        require(!payment.isRefunded, "Payment already refunded");

        payment.isReleased = true;
        require(paymentToken.transfer(payment.payee, payment.amount), "Release failed");

        emit PaymentReleased(paymentId, payment.payee);
    }

    /**
     * @notice Refunds a payment back to the user in case of cancellation or dispute resolution.
     * @dev Can only be called by the owner (platform admin).
     * @param paymentId Id of the payment to refund.
     */
    function refundPayment(uint256 paymentId) external onlyOwner {
        Payment storage payment = payments[paymentId];
        require(!payment.isRefunded, "Payment already refunded");
        require(!payment.isReleased, "Payment already released");

        payment.isRefunded = true;
        require(paymentToken.transfer(payment.payer, payment.amount), "Refund failed");

        emit PaymentRefunded(paymentId, payment.payer);
    }
}
