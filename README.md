#solidity-contract-rebalancer

Is a truffle-deployable smart contract that will round the balance of one of your accounts, and send the remainder to another specified account.

Contains 2 test cases, optimized with testrpc. The first for the function where the contract does the rebalancing, and the other for the calculation of how much you would need to transfer to a regular address, to be rounded down.

##List of functions:
###rebalance
Takes an address parameter that is set as the address where any leftover after the rounding is sent to. Need to send a minimum of 1 ether, no ether is kept by the contract, it redistributes the ether sent, to the sender so their balance gets rounded to the nearest ether, after discounting the actual amount sent from the balance and gas costs, and the remainder after rounding gets sent to the specified address.

 e.g. The address you're sending from currently is 0xabc and its current balance is 52.3 ether. You call the rebalance function, set the address parameter as 0x123, which is one of your other accounts, and send 8 ether in the call. Since your balance now is ~44.3 ether, the contract will send you back 0.7 ether to round your balance to 45 ether exactly, and the remainder which is ~7.3 ether gets sent to the set address parameter.

###saferRebalance
A variant of the above function, which basically acts in the same way, except it has an extra check on the address parameter, ensuring the address parameter you input, has a non-zero balance (aka is not empty) to ensure you don't exactly mistype your address and have ether burnt.

###returnManualRebalance
This is a constant function, which simply returns the amount in wei you need to send out of a certain address for it to be rounded down to the nearest ether.

Takes 2 parameters, the first is the account's balance you're looking to round down, the second is the transaction gas price you'll be sending the transaction with (currently 20 gwei/shannon).
