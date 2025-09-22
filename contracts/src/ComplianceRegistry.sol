// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.24;

import "./access/Roles.sol";

/**
 * @title ComplianceRegistry
 * @dev On-chain registry of investors and their eligibility flags
 */
contract ComplianceRegistry is Roles {
    struct Flags {
        bool kyc;            // passed KYC/AML
        bool qib;            // qualifies as QIB (144A)
        bool nonUS;          // non-U.S. person (Reg S)
        bool pepClear;       // politically exposed cleared
        bool sanctionsClear; // OFAC/FATF cleared
    }

    mapping(address => Flags) public flags;
    mapping(address => bool) public blocked; // manual blocklist

    event FlagsSet(address indexed who, Flags flags);
    event Blocked(address indexed who, bool blocked);

    function setFlags(address who, Flags calldata f) external onlyAdmin {
        flags[who] = f;
        emit FlagsSet(who, f);
    }

    function setBlocked(address who, bool b) external onlyAdmin {
        blocked[who] = b;
        emit Blocked(who, b);
    }

    function isCompliant144A(address who) public view returns (bool) {
        Flags memory f = flags[who];
        return f.kyc && f.qib && f.sanctionsClear && !blocked[who];
    }

    function isCompliantRegS(address who) public view returns (bool) {
        Flags memory f = flags[who];
        return f.kyc && f.nonUS && f.sanctionsClear && !blocked[who];
    }
}