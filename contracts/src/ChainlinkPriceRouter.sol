// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.24;

import "./interfaces/IAggregatorV3.sol";
import "./access/Roles.sol";

/**
 * @title ChainlinkPriceRouter
 * @dev Chainlink Price Router for XAU/USD and other feeds
 */
contract ChainlinkPriceRouter is Roles {
    mapping(bytes32 => address) public feeds; // e.g., keccak256("XAU/USD") => feed

    event FeedSet(bytes32 key, address feed);

    function setFeed(bytes32 key, address feed) external onlyAdmin {
        feeds[key] = feed;
        emit FeedSet(key, feed);
    }

    function peek(bytes32 key) external view returns (int256 price, uint256 updatedAt) {
        IAggregatorV3 f = IAggregatorV3(feeds[key]);
        (, int256 p,, uint256 t,) = f.latestRoundData();
        return (p, t);
    }
}