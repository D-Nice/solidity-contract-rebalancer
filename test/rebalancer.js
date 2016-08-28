contract('Rebalancer', function(accounts) {
    it("rebalance test - should round account down and increase balance on remainder acct", function() {
        var reb = Rebalancer.deployed();
        //Enter any amount greater than or equal to 1 here for testing.
        var amtInEther = 1;

        var acctToTest = accounts[0];
        var acctRemainder = accounts[3];
        var estimatedCost = 43756;

        var amt = web3.toWei(amtInEther, 'ether');

        var bal = web3.eth.getBalance(acctToTest).minus(estimatedCost).minus(amt);
        var roundedBal = web3.toWei(Math.ceil(bal.valueOf() / web3.toWei(1, 'ether')), 'ether');
        var remainderBal = web3.eth.getBalance(acctRemainder);

        return reb.rebalance(acctRemainder, {from: acctToTest, value: amt}).then(function() {
            assert.equal(web3.eth.getBalance(acctToTest).valueOf(), roundedBal, "Balance was not rounded correctly");
            assert.isAbove(web3.eth.getBalance(acctRemainder).valueOf(), remainderBal, "Remainder account didn't receive any leftover balance.");
        });
    });
    it("returnManualRebalance test - should return wei amount that will round balance in transaction", function() {
        var reb = Rebalancer.deployed();

        var acctToTest = accounts[1];
        var bal = web3.eth.getBalance(acctToTest);
        bal = bal.minus(21000);

        var roundedBal = web3.toWei(Math.floor(bal.valueOf() / web3.toWei(1, 'ether')), 'ether');
        roundedBal = bal.minus(roundedBal).valueOf();

        return reb.returnManualRebalance(acctToTest, 1).then(function(amount) {
            assert.equal(amount.toNumber(), roundedBal, "Contract value returned is incorrect.");
        });
    });
});
