// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract VestingContract {
    address public owner;
    IERC20 private sphericalsToken; // Token that will be vested
    uint256 public vestingDuration = 24 * 30 days; // Vesting duration set to 24 months
    uint256 public vestingStartTimestamp; // Timestamp when vesting starts
    uint256 public vestingEndTimestamp; // Timestamp when vesting ends
    uint256 private _totalClaimableTokens; // Total amount of tokens that can be claimed
    uint256 private _totalClaimed; // Track total claimed amount

    // Struct to represent a beneficiary with total vesting amount, amount already claimed, and the start date for vesting
    struct Beneficiary {
        uint256 totalAmount;
        uint256 claimedAmount;
        uint256 startDate;
    }

    // Map to store beneficiary details
    mapping(address => Beneficiary) private beneficiariesMap;
    address[] private beneficiaryAddresses; // List to track all beneficiary addresses

    event BeneficiaryAdded(address indexed beneficiary, uint256 amount);
    event BeneficiaryAddressChanged(address indexed oldAddress, address indexed newAddress);
    event BeneficiaryAmountChanged(address indexed beneficiary, uint256 newAmount);
    event AllTokensClaimed(address indexed beneficiary, uint256 amount);

    constructor() {
        owner = msg.sender;
        sphericalsToken = IERC20(REPLACE WITH YOUR TOKEN ADDRESS); // Replace with your token's address
        vestingStartTimestamp = block.timestamp;
        vestingEndTimestamp = vestingStartTimestamp + vestingDuration;
    }

    // Convert token value to a readable format
    function convertToReadable(uint256 value) internal pure returns (uint256) {
        return value / 10**18;
    }

    // Return the total amount of tokens that can be claimed
    function totalClaimableTokens() external view returns (uint256) {
        return convertToReadable(_totalClaimableTokens);
    }

    // Return the total amount of tokens already claimed
    function totalClaimed() external view returns (uint256) {
        return convertToReadable(_totalClaimed);
    }
    // Return the total claimable tokens for a specific beneficiary
    function getTotalClaimableBeneficiary(address _beneficiary) external view returns (uint256) {
        Beneficiary memory beneficiary = beneficiariesMap[_beneficiary];
        return convertToReadable(beneficiary.totalAmount);
    }

    // Return the amount of tokens already claimed by a specific beneficiary
    function getAlreadyClaimed(address _beneficiary) external view returns (uint256) {
        Beneficiary memory beneficiary = beneficiariesMap[_beneficiary];
        return convertToReadable(beneficiary.claimedAmount);
    }

    // Return the amount of tokens that can currently be claimed by a beneficiary
    function getCurrentlyClaimable(address _beneficiary) external view returns (uint256) {
        Beneficiary memory beneficiary = beneficiariesMap[_beneficiary];
        uint256 claimable;
        if (block.timestamp >= vestingEndTimestamp) {
            claimable = beneficiary.totalAmount - beneficiary.claimedAmount;
        } else {
            uint256 elapsedTime = block.timestamp - beneficiary.startDate;
            uint256 totalVestableAmount = (beneficiary.totalAmount * elapsedTime) / vestingDuration;
            claimable = totalVestableAmount - beneficiary.claimedAmount;
        }
        return convertToReadable(claimable);
    }

    // Add a new beneficiary to the contract
    function addBeneficiary(address _beneficiary, uint256 _amount) external onlyOwner {
        require(beneficiariesMap[_beneficiary].totalAmount == 0, "Beneficiary already added");
        uint256 adjustedAmount = _amount * 10**18; // Adjust the amount by multiplying with 10^18
        beneficiariesMap[_beneficiary] = Beneficiary({
            totalAmount: adjustedAmount,
            claimedAmount: 0,
            startDate: vestingStartTimestamp
        });
        beneficiaryAddresses.push(_beneficiary);
        _totalClaimableTokens += adjustedAmount;
        emit BeneficiaryAdded(_beneficiary, adjustedAmount);
    }

    // Remove a beneficiary from the contract
    function removeBeneficiary(address _beneficiary) external onlyOwner {
        require(beneficiariesMap[_beneficiary].totalAmount > 0, "Beneficiary does not exist");
        _totalClaimableTokens -= beneficiariesMap[_beneficiary].totalAmount;
        delete beneficiariesMap[_beneficiary];
        uint256 index;
        for (uint256 i = 0; i < beneficiaryAddresses.length; i++) {
            if (beneficiaryAddresses[i] == _beneficiary) {
                index = i;
                break;
            }
        }
        beneficiaryAddresses[index] = beneficiaryAddresses[beneficiaryAddresses.length - 1];
        beneficiaryAddresses.pop();
    }

    // A beneficiary claims vested tokens
    function claimTokens() external {
        require(block.timestamp > vestingStartTimestamp, "Vesting hasn't started yet");
        Beneficiary storage beneficiary = beneficiariesMap[msg.sender];
        require(beneficiary.totalAmount > 0, "Beneficiary does not exist");
        uint256 claimableAmount;
        if (block.timestamp >= vestingEndTimestamp) {
            claimableAmount = beneficiary.totalAmount - beneficiary.claimedAmount;
        } else {
            uint256 elapsedTime = block.timestamp - beneficiary.startDate;
            uint256 totalVestableAmount = (beneficiary.totalAmount * elapsedTime) / vestingDuration;
            claimableAmount = totalVestableAmount - beneficiary.claimedAmount;
        }
        require(claimableAmount > 0, "No claimable tokens available");
        beneficiary.claimedAmount += claimableAmount;
        _totalClaimed += claimableAmount;
        sphericalsToken.transfer(msg.sender, claimableAmount);
        emit AllTokensClaimed(msg.sender, claimableAmount);
    }

    // Transfer ownership of the contract to another address
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "New owner is a zero address");
        owner = newOwner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }
        // Update the vesting amount for a specific beneficiary
    function updateBeneficiaryAmount(address _beneficiary, uint256 _newAmount) external onlyOwner {
        require(beneficiariesMap[_beneficiary].totalAmount > 0, "Beneficiary does not exist");
        uint256 adjustedAmount = _newAmount * 10**18; // Adjust the amount by multiplying with 10^18
        _totalClaimableTokens = _totalClaimableTokens - beneficiariesMap[_beneficiary].totalAmount + adjustedAmount;
        beneficiariesMap[_beneficiary].totalAmount = adjustedAmount;
        emit BeneficiaryAmountChanged(_beneficiary, adjustedAmount);
    }

    // Update the beneficiary's address
    function updateBeneficiaryAddress(address _oldBeneficiary, address _newBeneficiary) external onlyOwner {
        require(beneficiariesMap[_oldBeneficiary].totalAmount > 0, "Old beneficiary does not exist");
        require(beneficiariesMap[_newBeneficiary].totalAmount == 0, "New beneficiary already exists");

        beneficiariesMap[_newBeneficiary] = beneficiariesMap[_oldBeneficiary];
        delete beneficiariesMap[_oldBeneficiary];

        for (uint256 i = 0; i < beneficiaryAddresses.length; i++) {
            if (beneficiaryAddresses[i] == _oldBeneficiary) {
                beneficiaryAddresses[i] = _newBeneficiary;
                break;
            }
        }

        emit BeneficiaryAddressChanged(_oldBeneficiary, _newBeneficiary);
    }

    // Get all beneficiary addresses
    function getAllBeneficiaryAddresses() external view returns (address[] memory) {
        return beneficiaryAddresses;
    }
}
