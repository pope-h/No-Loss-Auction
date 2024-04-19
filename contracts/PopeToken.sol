// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract PopeToken {
    string public name;
    string public symbol;
    uint public decimals;
    uint public totalSupply;
    mapping(address => uint) balanceOfAddr;
    mapping(address => mapping(address => uint)) public allowance;
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Balance(uint indexed _balance);
    event Burn(address _from, uint256 _amount);

    constructor(uint _initialSupply) {
        name = "Pope Token";
        symbol = "PTK";
        decimals = 18;

        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balanceOfAddr[msg.sender] += totalSupply;

        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        require(_owner != address(0), "Caller Error");

        return balanceOfAddr[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0), "Zero address should not spend");
        require(balanceOfAddr[msg.sender] >= _value, "Insufficient Funds");
        require(_value > 0, "Please pass in a value greater than 0");

        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "You can't send to zero address");
        require(_value > 0, "Invalid amount to be sent");
        require(balanceOfAddr[msg.sender] >= _value, "Insufficient Balance");

        balanceOfAddr[msg.sender] -= _value;
        uint256 _burnAmount = _value / 10;
        totalSupply -= _burnAmount;
        emit Transfer(msg.sender, address(0), _value);
        balanceOfAddr[_to] += _value;
        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "You can't send to zero address");
        require(_from != address(0), "You can't send from zero address");
        require(_value > 0, "Invalid amount to be sent");
        require(allowance[_from][msg.sender] >= _value || balanceOfAddr[_from] >= _value, "Insufficient Balance");

        allowance[_from][msg.sender] -= _value;
        balanceOfAddr[_from] -= _value;
        uint256 _burnAmount = _value / 10;
        emit Balance(totalSupply);
        totalSupply -= _burnAmount;
        emit Transfer(msg.sender, address(0), _burnAmount);
        emit Balance(totalSupply);
        balanceOfAddr[_to] += _value;
        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function burn(uint256 _amount) external {
        require(balanceOfAddr[msg.sender] >= _amount, "Insufficient balance");
        balanceOfAddr[msg.sender] -= _amount;
        totalSupply -= _amount;
        emit Burn(msg.sender, _amount);
    }
}