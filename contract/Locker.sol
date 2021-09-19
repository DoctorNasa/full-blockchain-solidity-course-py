pragma solidity >=0.8.0;

contract Locker {
    event Deposit (address indexed sender, uint256 id);
    event Withdraw (address indexed sender, uint256 id);

    struct Item{
        address owner;
        uint256 amount;
        bool withdraw;
    }

    mapping (uint256 => Item) public items;
    uint256 public itemLength;

    function deposit() external payable returns (uint256) {
        require(msg.value > 0, "empty value please check");

        uint256 id = itemLength;
        itemLength++;

        items[id] = Item(
            msg.sender,
            msg.value,
            false
        );

        emit Deposit(msg.sender, id);
        return id;
    }

    function withdraw(uint256 id) external {
        Item storage it = items[id];
        require(it.owner == msg.sender, "!owner");
        require(!it.withdraw, "already withdraw");
        (bool success,) = msg.sender.call{value: it.amount}("");
        require(success, "!sucess");
        
        it.withdraw = true;

        emit Withdraw(msg.sender, id);
    }
}