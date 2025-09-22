// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "./access/Roles.sol";
import "./ComplianceOracle.sol";

/**
 * @title CompliantSecurityToken
 * @dev Minimal ERC20 with partition events + compliance checks
 * Partitioned Security Token for 144A/Reg S bonds
 */
contract CompliantSecurityToken is ERC20, ERC20Permit, Pausable, Roles {
    // Partitions: /144A, /RegS
    ComplianceOracle public oracle;
    bytes32 public constant P144A = keccak256("/144A");
    bytes32 public constant PREGS = keccak256("/RegS");

    string public isin144a;
    string public cusip144a;
    string public isinRegs;
    string public cusipRegs;

    // partitioned balances
    mapping(address => mapping(bytes32 => uint256)) public balanceOfPartition;
    mapping(bytes32 => uint256) public totalSupplyPartition;

    event TransferByPartition(
        bytes32 indexed partition,
        address indexed from,
        address indexed to,
        uint256 value,
        bytes data
    );

    constructor(
        string memory name_,
        string memory symbol_,
        address _oracle,
        string memory _isin144a,
        string memory _cusip144a,
        string memory _isinRegs,
        string memory _cusipRegs
    ) ERC20(name_, symbol_) ERC20Permit(name_) {
        oracle = ComplianceOracle(_oracle);
        isin144a = _isin144a;
        cusip144a = _cusip144a;
        isinRegs = _isinRegs;
        cusipRegs = _cusipRegs;
    }

    function pause() external onlyAdmin {
        _pause();
    }

    function unpause() external onlyAdmin {
        _unpause();
    }

    // Mint into a partition
    function mintPartition(bytes32 p, address to, uint256 amount) external onlyAdmin {
        (bool ok, string memory r) = oracle.canTransfer(address(0), to, p);
        require(ok, r);

        _mint(to, amount);
        balanceOfPartition[to][p] += amount;
        totalSupplyPartition[p] += amount;

        emit TransferByPartition(p, address(0), to, amount, "");
    }

    // Transfer within a partition
    function transferByPartition(bytes32 p, address to, uint256 amount)
        external
        whenNotPaused
        returns (bool)
    {
        (bool ok, string memory r) = oracle.canTransfer(msg.sender, to, p);
        require(ok, r);
        require(balanceOfPartition[msg.sender][p] >= amount, "INSUFFICIENT_PART_BAL");

        _transfer(msg.sender, to, amount);
        balanceOfPartition[msg.sender][p] -= amount;
        balanceOfPartition[to][p] += amount;

        emit TransferByPartition(p, msg.sender, to, amount, "");
        return true;
    }

    // Force-transfer by TA (court order, error correction)
    function forceTransfer(bytes32 p, address from, address to, uint256 amount) external {
        require(transferAgent[msg.sender] || admin[msg.sender], "NO_TA");
        // no compliance check on destination beyond lockups assumed handled off-chain/legal
        require(balanceOfPartition[from][p] >= amount, "INSUFFICIENT");

        _transfer(from, to, amount);
        balanceOfPartition[from][p] -= amount;
        balanceOfPartition[to][p] += amount;

        emit TransferByPartition(p, from, to, amount, "FORCE");
    }
}