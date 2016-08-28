import "Rounder.sol";

contract Rebalancer is Rounder {
    uint constant cheapRebCallGas = 29697;
    uint constant cheapRebGas = 6969;
    uint constant rebGas = 13830;

    function returnManualRebalance(address _acctToRound, uint _gasPrice) public constant returns (uint) {
        return calcExactRebalance(_acctToRound.balance - (21000 * _gasPrice));
    }

    function calcExactRebalance(uint _bal) private constant returns (uint) {
        uint figureDiff = findFigures(_bal) - 18;
        return (_bal - uintFloor(_bal, figureDiff));
    }

    function rebalance(address _sendRemainderTo) external {
        //need at least 1 eth to ensure balance is properly rounded
        if(msg.value < 1 ether || _sendRemainderTo == 0)
            throw;

        uint amtToSendForRounding = calcAmtToSend(rebGas);
//13830 testnet
//
        if(! msg.sender.send(amtToSendForRounding))
            throw;

        if(! _sendRemainderTo.send(msg.value - amtToSendForRounding))
            throw;
    }

    function saferRebalance(address _sendRemainderTo) external {
        if(msg.value < 1 ether || _sendRemainderTo == 0 || _sendRemainderTo.balance == 0)
            throw;

        uint amtToSendForRounding = calcAmtToSend(rebGas);

        if(! msg.sender.send(amtToSendForRounding))
            throw;
        if(! _sendRemainderTo.send(msg.value - amtToSendForRounding))
            throw;

    }

    function calcAmtToSend(uint _futureGas) private constant returns (uint) {
        uint figureDiff = findFigures(msg.sender.balance) - 18;
        uint roundedUpBalance = uintCeil(msg.sender.balance, figureDiff);
        return roundedUpBalance - msg.sender.balance - (msg.gas*tx.gasprice) + (_futureGas*tx.gasprice);
    }
}
