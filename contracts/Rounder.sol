//Rounder won't compile now without this
contract neededToCompile {
    bytes1 temp;
}

contract Rounder {
    function uintCeil(uint _number, uint _roundTo) internal constant returns (uint) {
        uint _unit = findFigures(_number);
        if (_number == 0 || _unit <= _roundTo)
            return _number;
        return recursiveCeil(_number, _roundTo, _unit);
    }
    function uintFloor(uint _number, uint _roundTo) internal constant returns (uint) {
        uint _unit = findFigures(_number);
        if (_number == 0 || _unit <= _roundTo)
            return _number;
        return recursiveFloor(_number, _roundTo, _unit);
    }
    function recursiveCeil(uint _number, uint _roundTo, uint _unit) private constant returns (uint) {
        uint expUnit = power10(_unit);
        uint rounded = _number / expUnit;
        if (rounded >= 1 * power10(_roundTo))
            return rounded * expUnit + (1 * expUnit);
        else
            return recursiveCeil(_number, _roundTo, _unit - 1);
    }
    function recursiveFloor(uint _number, uint _roundTo, uint _unit) private constant returns (uint) {
        uint expUnit = power10(_unit);
        uint rounded = _number / expUnit;
        if (rounded >= 1 * power10(_roundTo))
            return rounded * expUnit;
        else
            return recursiveFloor(_number, _roundTo, _unit - 1);
    }
    function findFigures(uint _number, uint _unit) private constant returns (uint) {
        if (_number / power10(_unit) < 10)
            return _unit;
        else
            return findFigures(_number, _unit + 1);
    }

    function findFigures(uint _number) internal constant returns (uint) {
        return findFigures(_number, 1);
    }

    function power10(uint _number) private constant returns (uint) {
        return (10**_number) / 10;
    }
}
