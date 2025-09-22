// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "./access/Roles.sol";
import "./CompliantSecurityToken.sol";

/**
 * @title DvPSettlement
 * @dev DvP Primary Settlement
 */
contract DvPSettlement is Roles, Pausable {
    IERC20 public usdc;
    CompliantSecurityToken public sec;

    struct Allocation {
        bytes32 partition;
        address investor;
        uint256 amount;
        uint256 price;
        bool settled;
    }

    Allocation[] public book; // simplistic book; real deployment would use off-chain orderbook with signed intents

    event Booked(uint256 id, bytes32 partition, address investor, uint256 amount, uint256 price);
    event Settled(uint256 id);

    constructor(address _usdc, address _sec) {
        usdc = IERC20(_usdc);
        sec = CompliantSecurityToken(_sec);
    }

    function bookAllocation(bytes32 p, address investor, uint256 amount, uint256 price)
        external
        onlyAdmin
        whenNotPaused
        returns (uint256 id)
    {
        id = book.length;
        book.push(Allocation(p, investor, amount, price, false));
        emit Booked(id, p, investor, amount, price);
    }

    function settle(uint256 id) external whenNotPaused {
        Allocation storage a = book[id];
        require(!a.settled, "SETTLED");
        require(msg.sender == a.investor || admin[msg.sender] || msg.sender == owner, "NOT_AUTHORIZED");
        uint256 cost = (a.amount * a.price) / 1e6; // price in USDC 6dp per token par = 1e6
        a.settled = true;
        emit Settled(id);

        require(usdc.transferFrom(a.investor, address(this), cost), "USDC_PULL_FAIL");
        sec.mintPartition(a.partition, a.investor, a.amount);
    }
}