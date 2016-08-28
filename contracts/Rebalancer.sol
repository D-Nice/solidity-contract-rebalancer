import "Rounder.sol";

contract Rebalancer is Rounder {
    uint constant cheapRebGas = 6969;
    uint constant rebGas = 13830;

    //automated rebalance function
    function rebalance(address _sendRemainderTo) external {
        //need at least 1 eth to ensure balance is properly rounded
        //need to specify a remainder address
        if(msg.value < 1 ether || _sendRemainderTo == 0)
            throw;

        //calculates amount the contract needs to send back to sender for a rounded balance
        uint amtToSendForRounding = calcAmtToSend(rebGas);

        if(! msg.sender.send(amtToSendForRounding))
            throw;
        //send whatever remains to specified remainder address
        if(! _sendRemainderTo.send(msg.value - amtToSendForRounding))
            throw;
    }

    //'safer' variant of the automated rebalance function
    //ensures the set remainder account has a balance before sending
    //should help avoid mistyping addresses
    function saferRebalance(address _sendRemainderTo) external {
        //same initial checks + ensure the remainder balance isnt empty
        if(msg.value < 1 ether || _sendRemainderTo == 0 || _sendRemainderTo.balance == 0)
            throw;

        uint amtToSendForRounding = calcAmtToSend(rebGas);

        if(! msg.sender.send(amtToSendForRounding))
            throw;
        if(! _sendRemainderTo.send(msg.value - amtToSendForRounding))
            throw;
    }

    //constant function for users that would just like to send directly from their address to another
    //returns the wei amount that needs to be sent to round down the balance
    function returnManualRebalance(address _acctToRound, uint _gasPrice) public constant returns (uint) {
        return calcExactRebalance(_acctToRound.balance - (21000 * _gasPrice));
    }

    //Intra-contract helper functions

    //function for calculating amount that needs to be sent for rounding
    function calcAmtToSend(uint _futureGas) private constant returns (uint) {
        uint figureDiff = findFigures(msg.sender.balance) - 18;
        uint roundedUpBalance = uintCeil(msg.sender.balance, figureDiff);
        return roundedUpBalance - msg.sender.balance - (msg.gas * tx.gasprice) + (_futureGas * tx.gasprice);
    }

    function calcExactRebalance(uint _bal) private constant returns (uint) {
        uint figureDiff = findFigures(_bal) - 18;
        return (_bal - uintFloor(_bal, figureDiff));
    }
}
