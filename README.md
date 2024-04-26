# ConciergeChain Services DApp Smart Contracts

## Admin Contract
- **File**: `dapp-projects/concierge-chain-services-dapp/contracts/AdminContract.sol`
- **Description**: Provides administrative functions to manage the platform effectively, such as updating fees or resolving critical disputes. Utilizes OpenZeppelin's Ownable and AccessControl for secure access management.

## ConciergeService Contract
- **File**: `dapp-projects/concierge-chain-services-dapp/contracts/ConciergeService.sol`
- **Description**: Manages the creation, listing, booking, cancellation, and rating of concierge services. Inherits Ownable for ownership management and AccessControl for role-based access control.

## DisputeResolution Contract
- **File**: `dapp-projects/concierge-chain-services-dapp/contracts/DisputeResolution.sol`
- **Description**: Manages disputes within the ConciergeChain Services platform, providing mechanisms for raising and resolving conflicts. Inherits AccessControl for role-based permissions.

## Membership Contract
- **File**: `dapp-projects/concierge-chain-services-dapp/contracts/MembershipContract.sol`
- **Description**: Manages membership tiers, allowing users and providers to subscribe and update memberships. Utilizes OpenZeppelin's Ownable and AccessControl for secure role management.

## Payment Contract
- **File**: `dapp-projects/concierge-chain-services-dapp/contracts/PaymentContract.sol`
- **Description**: Manages payment functionalities, ensuring secure transactions between users and service providers. Utilizes the ERC20 interface for token interactions and inherits from OpenZeppelin's Ownable for ownership management.

## Review Contract
- **File**: `dapp-projects/concierge-chain-services-dapp/contracts/ReviewContract.sol`
- **Description**: Manages the submission and retrieval of reviews and ratings for services on the platform, enhancing trust and transparency.

## Rewards Contract
- **File**: `dapp-projects/concierge-chain-services-dapp/contracts/RewardsContract.sol`
- **Description**: Manages the loyalty and reward programs for users and providers on the platform, encouraging active participation and high-quality services.
