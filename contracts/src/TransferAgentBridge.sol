// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.24;

import "./access/Roles.sol";
import "./AttestationRegistry.sol";

/**
 * @title TransferAgentBridge
 * @dev Records off-chain DTC cap-table mirrors, force actions, and audit anchors
 */
contract TransferAgentBridge is Roles {
    AttestationRegistry public immutable attest;

    event DTCCapTableHash(string period, string cid, bytes32 key);

    constructor(address _att) {
        attest = AttestationRegistry(_att);
    }

    function recordCapTable(string calldata period, string calldata cid, bytes32 key) external onlyAdmin {
        emit DTCCapTableHash(period, cid, key);
        attest.attest(string(abi.encodePacked("DTC_CAP_TABLE_", period)), cid, key);
    }
}