// SPDX-License-Identifier: MIT
pragma solidity 0.8.27; // stating version type

import "./IERC20.sol";

contract PiggyBank {

    address public owner;

    mapping(address => mapping(address => uint256)) savings;

    event Deposit(address indexed user, address indexed token, uint256 amount);
    event Withdrawal(address indexed user, address indexed token, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function deposit(uint256 _amount, address _tokenAddress) external {
        require(_tokenAddress != address(0), "Cannot deposit to address zero");
        require(_amount > 0, "amount must be greater than zero");

        savings[msg.sender][_tokenAddress] += _amount; 
        uint256 _userBalance = IERC20(_tokenAddress).balanceOf(msg.sender);
        require(_userBalance >= _amount, "insufficient fund");

        IERC20(_tokenAddress).transferFrom(msg.sender, address(this), _amount);

        emit Deposit(msg.sender, _tokenAddress, _amount);
    }

    function withdraw(uint256 _amount, address _tokenAddress) external {
        require(_tokenAddress != address(0), "Cannot deposit to address zero");
        require(_amount > 0, "amount must be greater than zero");

        uint256 _userSavings = savings[msg.sender][_tokenAddress];
        require(_amount <= _userSavings, "Insufficient funds");
        savings[msg.sender][_tokenAddress] -= _amount;

        IERC20(_tokenAddress).transfer(msg.sender, _amount);

        emit Withdrawal(msg.sender, _tokenAddress, _amount);
    }

    function getUserSavings(address _user, address _tokenAddress) external view returns (uint256) {
        return savings[_user][_tokenAddress];
    }

     function getContractTokenBalance(address _tokenAddress) external view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }
}