// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.24;

/**
 * @title Roles
 * @dev Access control contract for managing various roles in the JINBI system
 */
abstract contract Roles {
    address public owner;
    mapping(address => bool) public admin;
    mapping(address => bool) public transferAgent;  // TA can force-transfer per court order/indenture
    mapping(address => bool) public complianceSigner; // entities allowed to sign compliance updates

    event OwnerTransferred(address indexed oldOwner, address indexed newOwner);
    event AdminSet(address indexed who, bool enabled);
    event TransferAgentSet(address indexed who, bool enabled);
    event ComplianceSignerSet(address indexed who, bool enabled);

    modifier onlyOwner() {
        require(msg.sender == owner, "NOT_OWNER");
        _;
    }

    modifier onlyAdmin() {
        require(admin[msg.sender] || msg.sender == owner, "NOT_ADMIN");
        _;
    }

    constructor() {
        owner = msg.sender;
        admin[msg.sender] = true;
    }

    function setOwner(address newOwner) external onlyOwner {
        emit OwnerTransferred(owner, newOwner);
        owner = newOwner;
    }

    function setAdmin(address who, bool enabled) external onlyOwner {
        admin[who] = enabled;
        emit AdminSet(who, enabled);
    }

    function setTransferAgent(address who, bool enabled) external onlyOwner {
        transferAgent[who] = enabled;
        emit TransferAgentSet(who, enabled);
    }

    function setComplianceSigner(address who, bool enabled) external onlyOwner {
        complianceSigner[who] = enabled;
        emit ComplianceSignerSet(who, enabled);
    }
}