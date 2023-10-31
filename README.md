"Gradual Token Distribution: A Detailed Overview of the Vesting Contract"


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
