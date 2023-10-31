# Vesting Contract: Gradual Token Distribution System

The smart contract is a "Vesting Contract" meant to handle the gradual release of tokens to beneficiaries over a set period. Here are its main features:

1. **Vesting Period**: The vesting duration is set to 24 months after deploying it.
2. **Token**: It interacts with a specific ERC20 token, referred to as "sphericalsToken".
3. **Beneficiaries**: Each beneficiary has a total amount of tokens, an amount they've already claimed, and a start date for their vesting period. The contract keeps track of each beneficiary's details.
4. **Claimable Amounts**: Beneficiaries can check the total amount they're entitled to, the amount they've already claimed, and the amount they can currently claim based on the time elapsed.
5. **Adding & Removing Beneficiaries**: The owner can add beneficiaries, specifying the amount they're entitled to. They can also remove beneficiaries and change their allocated amounts.
6. **Claiming Tokens**: Beneficiaries can claim their tokens based on how much of their vesting period has elapsed. If they try to claim before any of their vesting period has elapsed, they will be denied.
7. **Total Tokens**: Anyone can check the total number of "sphericalsToken" currently held by the contract.
8. **Countdown**: The contract provides a countdown to the end of the vesting period.
9. **Rescue Tokens**: In case of any issues, the owner can rescue all the tokens from the contract.
10. **Beneficiary Info**: The owner can retrieve detailed information about any beneficiary, including their total claimable amount, the amount they've already claimed, and the amount they can currently claim.

The contract ensures that tokens are distributed fairly and transparently to beneficiaries over the set vesting period, providing mechanisms for both beneficiaries and the owner to interact with their allocations.


# Vesting Contract Usage Guide

## Table of Contents
- [Introduction](#introduction)
- [Deployment](#deployment)
- [Setting Up Beneficiaries](#setting-up-beneficiaries)
- [Beneficiaries Claiming Tokens](#beneficiaries-claiming-tokens)
- [Modifying Beneficiaries](#modifying-beneficiaries)
- [Events](#events)
- [Safety Tips](#safety-tips)

## Introduction
This contract allows an owner to set aside tokens for multiple beneficiaries with a vesting schedule. Beneficiaries can claim tokens based on the predetermined schedule. The owner can also update the amount or address for any beneficiary.

## Deployment
1. **Token Address**: Before deploying, obtain the address of the ERC-20 token that will be used for vesting.
2. **Deployment**: Deploy the contract on your desired Ethereum network using tools like Remix, Truffle, or Hardhat. Ensure you provide the token address as a constructor argument.

## Setting Up Beneficiaries
1. **Add Beneficiaries**: 
   - Call `addBeneficiaries` with the list of beneficiary addresses and their respective token amounts.
   - Token amounts should be in the token's smallest unit (e.g., wei for Ether). Use web3 utilities to convert human-readable amounts to this format.
2. **Review Beneficiaries**:
   - Use `getAllBeneficiaryAddresses` to retrieve all beneficiary addresses.
   - For specific beneficiary details, use `getBeneficiaryDetails` providing the beneficiary's address.

## Beneficiaries Claiming Tokens
1. **Check Available Tokens**: 
   - Beneficiaries can check tokens available for claiming by calling `claimableAmount`.
2. **Claim Tokens**: 
   - Beneficiaries can claim their tokens by invoking the `claim` function.
   - The contract will transfer the available tokens to the beneficiary's address.

## Modifying Beneficiaries
1. **Update Amount**:
   - The owner can adjust a beneficiary's total token amount by calling `updateBeneficiaryAmount`, providing the beneficiary's address and new amount.
2. **Change Beneficiary Address**:
   - The owner can update a beneficiary's address using `updateBeneficiaryAddress`. Provide the old and new addresses for this function.

## Events
Monitor the following events to track important actions:
   - `BeneficiaryAdded`: Emitted when a new beneficiary is added.
   - `TokensClaimed`: Emitted when tokens are claimed by a beneficiary.
   - `BeneficiaryAmountChanged`: Emitted when a beneficiary's token amount is updated.
   - `BeneficiaryAddressChanged`: Emitted when a beneficiary's address is updated.

## Safety Tips
1. **Test First**: Before deploying to the mainnet, always deploy on a testnet first to ensure everything works as expected.
2. **Gas Fees**: Be aware of gas fees. Every Ethereum network action requires gas, and its cost can vary.
3. **Permissions**: Only the owner can modify beneficiary details. Ensure the owner's private key is stored securely.
