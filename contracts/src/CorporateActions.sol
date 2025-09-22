// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "./access/Roles.sol";
import "./CompliantSecurityToken.sol";

/**
 * @title CorporateActions
 * @dev Corporate Actions (Coupons & Principal)
 */
contract CorporateActions is Roles, Pausable {
    IERC20 public usdc;
    CompliantSecurityToken public secToken;

    mapping(uint256 => uint256) public couponBpsByCycle; // cycleId => annualized bps (e.g., 500 = 5%)
    mapping(uint256 => uint256) public paidAt;           // timestamp paid

    event CouponPaid(uint256 indexed cycleId, uint256 totalPaid);

    constructor(address _usdc, address _sec) {
        usdc = IERC20(_usdc);
        secToken = CompliantSecurityToken(_sec);
    }

    // Simple pro-rata by total supply across both partitions; enterprises can extend to per-partition accruals
    function payCoupon(uint256 cycleId, uint256 amountUSDC) external onlyAdmin whenNotPaused {
        require(paidAt[cycleId] == 0, "ALREADY");

        uint256 ts = secToken.totalSupply();
        require(ts > 0, "NO_SUPPLY");

        // NOTE: for scale, we would stream or use Merkle claims; here we do a simple pull loop via events off-chain
        paidAt[cycleId] = block.timestamp;
        emit CouponPaid(cycleId, amountUSDC);

        require(usdc.transferFrom(msg.sender, address(this), amountUSDC), "FUND_FAIL");
    }
}