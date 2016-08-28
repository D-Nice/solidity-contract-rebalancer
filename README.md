#solidity-contract-rebalancer

Is a truffle-deployable smart contract that will round the balance of one of your accounts, and send the remainder to another specified account. It also provides the ability for you to do a manual send transaction, which costs less gas than the contract, and the contract provides a constant function, which will specify the exact wei amount you will need to send for your balance to be rounded down to the next ether.

Contains 2 test cases, 1 for the function where the contract does the rebalancing, and the other for the calculation of how much you would need to transfer to a regular address, to be rounded down.
