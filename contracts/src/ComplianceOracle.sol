// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.24;

import "./access/Roles.sol";
import "./ComplianceRegistry.sol";

/**
 * @title ComplianceOracle
 * @dev Stateless checker + lockup dates per partition
 */
contract ComplianceOracle is Roles {
    ComplianceRegistry public immutable registry;

    // lockups per address/partition (e.g., 40-day Reg S)
    mapping(address => mapping(bytes32 => uint256)) public lockupUntil; // partition => timestamp

    event LockupSet(address indexed who, bytes32 indexed partition, uint256 until);

    constructor(address _reg) {
        registry = ComplianceRegistry(_reg);
    }

    function setLockup(address who, bytes32 partition, uint256 until) external onlyAdmin {
        lockupUntil[who][partition] = until;
        emit LockupSet(who, partition, until);
    }

    function canTransfer(address from, address to, bytes32 partition)
        public
        view
        returns (bool ok, string memory reason)
    {
        if (from == address(0)) { // mint
            if (partition == keccak256("/144A")) {
                if (!registry.isCompliant144A(to)) return (false, "DEST_NOT_QIB_OR_SANCTIONED");
                return (true, "");
            } else if (partition == keccak256("/RegS")) {
                if (!registry.isCompliantRegS(to)) return (false, "DEST_NOT_REGS_ELIGIBLE");
                return (true, "");
            } else {
                return (false, "UNKNOWN_PARTITION");
            }
        }

        // transfer
        if (block.timestamp < lockupUntil[from][partition]) return (false, "SOURCE_LOCKED");

        if (partition == keccak256("/144A")) {
            if (!registry.isCompliant144A(to)) return (false, "DEST_NOT_QIB_OR_SANCTIONED");
            return (true, "");
        }

        if (partition == keccak256("/RegS")) {
            if (!registry.isCompliantRegS(to)) return (false, "DEST_NOT_REGS_ELIGIBLE");
            return (true, "");
        }

        return (false, "UNKNOWN_PARTITION");
    }
}