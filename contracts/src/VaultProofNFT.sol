// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title VaultProofNFT
 * @dev Links the underlying MTN, custodian, and legal docs
 */
contract VaultProofNFT is ERC721, Ownable {
    struct VaultMeta {
        string isin;
        string cusip;
        string cid;
        string custodian;
    }

    mapping(uint256 => VaultMeta) public meta;
    uint256 public nextId = 1;

    event Minted(uint256 id, string isin, string cusip, string cid, string custodian);

    constructor() ERC721("VaultProof", "VPROOF") Ownable(_msgSender()) {}

    function mint(address to, VaultMeta calldata v) external onlyOwner returns (uint256 id) {
        id = nextId++;
        meta[id] = v;
        emit Minted(id, v.isin, v.cusip, v.cid, v.custodian);
        _safeMint(to, id);
    }
}