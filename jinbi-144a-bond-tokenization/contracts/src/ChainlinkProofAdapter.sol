// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.24;

import "./access/Roles.sol";

/**
 * @title ChainlinkProofAdapter
 * @dev For custodian proofs, transfer agent confirmations, etc.
 * NOTE: Placeholder interface; wire up in frontend/off-chain node using Chainlink Functions/Any API
 */
contract ChainlinkProofAdapter is Roles {
    struct Proof {
        string scope;
        string cid;
        uint256 ts;
    }

    mapping(bytes32 => Proof) public proofs; // key = keccak256(scope||date)

    event ProofSet(bytes32 key, string scope, string cid, uint256 ts);

    function setProof(bytes32 key, string calldata scope, string calldata cid) external onlyAdmin {
        proofs[key] = Proof(scope, cid, block.timestamp);
        emit ProofSet(key, scope, cid, block.timestamp);
    }
}