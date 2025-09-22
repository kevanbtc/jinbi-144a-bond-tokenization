// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.24;

import "./access/Roles.sol";

/**
 * @title AttestationRegistry
 * @dev Stores IPFS CIDs + doc types (indenture, custodian letters, ISIN bind, audit seals)
 */
contract AttestationRegistry is Roles {
    struct Attestation {
        string docType;
        string cid;
        uint256 timestamp;
    }

    mapping(bytes32 => Attestation) public attestationByHash; // hash(docType||version)

    event Attested(string docType, string cid, bytes32 key, uint256 ts);

    function attest(string calldata docType, string calldata cid, bytes32 key) external onlyAdmin {
        attestationByHash[key] = Attestation(docType, cid, block.timestamp);
        emit Attested(docType, cid, key, block.timestamp);
    }
}