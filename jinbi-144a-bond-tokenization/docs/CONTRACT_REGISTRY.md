# JINBI 144A/Reg S Bond Tokenization - Contract Registry

## 🌐 **Deployment Information**

**Network**: Polygon Mainnet (Chain ID: 137)
**Deployment Date**: September 21, 2024
**Deployer**: 0x9Dc918deBA2d3fc7128A59852b6699CCb2dC0EDB
**Total Gas Used**: ~6.5 MATIC

---

## 📋 **Core Contract Addresses**

### 1. AttestationRegistry
**Address**: `0x73C36D0F747386978d0a0cD93f1d674937e42542`
**Purpose**: Document and audit trail management
**Description**: Stores IPFS CIDs for legal documents, indenture agreements, custodian letters, audit reports, and compliance attestations. Provides immutable proof of document authenticity.

**Key Functions**:
- `attest(string docType, string cid, bytes32 key)` - Store document attestation
- `attestationByHash(bytes32)` - Retrieve attestation details

**View on Polygonscan**: https://polygonscan.com/address/0x73C36D0F747386978d0a0cD93f1d674937e42542

---

### 2. ComplianceRegistry
**Address**: `0x4FDF91216009835684233dc69da697BD9FF19F32`
**Purpose**: Investor eligibility and compliance tracking
**Description**: Maintains KYC/AML status, QIB qualification, non-U.S. person status, PEP clearance, and sanctions screening for all investors.

**Key Functions**:
- `setFlags(address who, Flags flags)` - Update investor compliance status
- `setBlocked(address who, bool blocked)` - Emergency investor blocking
- `isCompliant144A(address)` - Check 144A eligibility
- `isCompliantRegS(address)` - Check Reg S eligibility

**View on Polygonscan**: https://polygonscan.com/address/0x4FDF91216009835684233dc69da697BD9FF19F32

---

### 3. ComplianceOracle
**Address**: `0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3`
**Purpose**: Real-time transfer compliance validation
**Description**: Enforces transfer restrictions, lockup periods, and compliance checks before any token transfer. Includes 40-day Reg S lockup enforcement.

**Key Functions**:
- `canTransfer(address from, address to, bytes32 partition)` - Validate transfer eligibility
- `setLockup(address who, bytes32 partition, uint256 until)` - Set lockup periods

**View on Polygonscan**: https://polygonscan.com/address/0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3

---

### 4. VaultProofNFT
**Address**: `0x7a54c01413353088DD64239A75dBcfa8E1E8314a`
**Purpose**: Custodial proof and ISIN/CUSIP binding
**Description**: ERC-721 NFT that links digital tokens to underlying physical gold MTN, custodian documentation, and regulatory identifiers.

**Bond Identifiers**:
- **144A ISIN**: US87225HAB42
- **144A CUSIP**: 87225H AB4
- **Reg S ISIN**: BSP9000TAA83
- **Reg S CUSIP**: P9000T AA8

**Key Functions**:
- `mint(address to, VaultMeta calldata meta)` - Mint vault proof NFT
- `meta(uint256 tokenId)` - Get vault metadata

**View on Polygonscan**: https://polygonscan.com/address/0x7a54c01413353088DD64239A75dBcfa8E1E8314a

---

### 5. CompliantSecurityToken (MAIN TOKEN)
**Address**: `0xA715acA24f83b08B786911c4d2fB194132D138D2`
**Purpose**: Main tokenized bond with partition support
**Description**: ERC-20 compliant security token with `/144A` and `/RegS` partitions. Includes compliance-gated transfers, emergency pause functionality, and force transfer capabilities.

**Token Details**:
- **Name**: JINBI Gold Bond 144A/RegS
- **Symbol**: JINBI
- **Decimals**: 18
- **Total Supply**: Variable (minted on demand)

**Key Functions**:
- `mintPartition(bytes32 partition, address to, uint256 amount)` - Mint to partition
- `transferByPartition(bytes32 partition, address to, uint256 amount)` - Partition transfer
- `forceTransfer(bytes32 partition, address from, address to, uint256 amount)` - Emergency transfer

**View on Polygonscan**: https://polygonscan.com/address/0xA715acA24f83b08B786911c4d2fB194132D138D2

---

### 6. CorporateActions
**Address**: `0x6651995eB8Bb86a551f7951DFc8dDa5070251768`
**Purpose**: Automated coupon and principal payments
**Description**: Manages quarterly coupon distributions (5% annual) and principal repayments in USDC. Supports pro-rata distributions based on token holdings.

**Key Functions**:
- `payCoupon(uint256 cycleId, uint256 amountUSDC)` - Execute coupon payment
- `couponBpsByCycle(uint256)` - Get coupon rate for cycle
- `paidAt(uint256)` - Check payment timestamp

**View on Polygonscan**: https://polygonscan.com/address/0x6651995eB8Bb86a551f7951DFc8dDa5070251768

---

### 7. DvPSettlement
**Address**: `0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D`
**Purpose**: Primary issuance and DvP settlement
**Description**: Handles institutional bond purchases with delivery-versus-payment in USDC. Supports both 144A and Reg S allocations with compliance verification.

**Key Functions**:
- `bookAllocation(bytes32 partition, address investor, uint256 amount, uint256 price)` - Book allocation
- `settle(uint256 id)` - Execute DvP settlement
- `book(uint256)` - View allocation details

**View on Polygonscan**: https://polygonscan.com/address/0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D

---

### 8. ChainlinkPriceRouter
**Address**: `0xB3940e869Def6C07191056659889018Ebac10cB3`
**Purpose**: Decentralized price feeds
**Description**: Provides real-time price data for XAU/USD, USDC/USD, and MATIC/USD using Chainlink oracles for transparent bond valuation.

**Configured Feeds**:
- **XAU/USD**: 0x0C466540B2ee1a31b441671eac0ca886e051E410
- **USDC/USD**: 0xfE4A8cc5b5B2366C1B58Bea3858e81843581b2F7
- **MATIC/USD**: 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0

**Key Functions**:
- `peek(bytes32 key)` - Get latest price and timestamp
- `setFeed(bytes32 key, address feed)` - Configure price feed

**View on Polygonscan**: https://polygonscan.com/address/0xB3940e869Def6C07191056659889018Ebac10cB3

---

### 9. ChainlinkProofAdapter
**Address**: `0x2b5B28D60b123C0b7cFb9C84a26559683d9edB39`
**Purpose**: Custodian attestation oracle
**Description**: Receives and validates custodian proof updates, transfer agent confirmations, and third-party attestations via Chainlink Functions.

**Key Functions**:
- `setProof(bytes32 key, string scope, string cid)` - Store proof attestation
- `proofs(bytes32)` - Retrieve proof details

**View on Polygonscan**: https://polygonscan.com/address/0x2b5B28D60b123C0b7cFb9C84a26559683d9edB39

---

### 10. TransferAgentBridge
**Address**: `0x1AC482B0585BedA95BEee90BA623FAd876F48fE2`
**Purpose**: Traditional finance integration
**Description**: Bridges on-chain token data with DTC cap table requirements, enabling regulatory reporting and traditional transfer agent integration.

**Key Functions**:
- `recordCapTable(string period, string cid, bytes32 key)` - Record cap table snapshot
- Events: `DTCCapTableHash` for audit trails

**View on Polygonscan**: https://polygonscan.com/address/0x1AC482B0585BedA95BEee90BA623FAd876F48fE2

---

## 🔗 **External Dependencies**

### USDC (Polygon)
**Address**: `0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174`
**Purpose**: Settlement currency for all transactions
**Description**: Native USDC on Polygon used for bond purchases, coupon payments, and principal repayments.

---

## 🛡️ **Security Features**

✅ **Multi-signature Compatible**: All admin functions support multi-sig wallets
✅ **Compliance Gated**: All transfers require oracle approval
✅ **Emergency Controls**: Pause functionality and force transfers
✅ **Audit Trail**: Complete on-chain transaction history
✅ **Sanctions Screening**: Real-time OFAC/FATF compliance
✅ **Lockup Enforcement**: Automated Reg S 40-day restrictions

---

## 📊 **Operational Status**

- **Deployment**: ✅ Complete
- **Price Feeds**: ✅ Active
- **Compliance System**: ✅ Operational
- **Admin Permissions**: ✅ Configured
- **USDC Integration**: ✅ Ready
- **Verification Status**: ⏳ In Progress

---

## 🔗 **Quick Links**

- **Main Token**: https://polygonscan.com/token/0xA715acA24f83b08B786911c4d2fB194132D138D2
- **DvP Settlement**: https://polygonscan.com/address/0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D
- **Price Router**: https://polygonscan.com/address/0xB3940e869Def6C07191056659889018Ebac10cB3
- **Deployer Wallet**: https://polygonscan.com/address/0x9Dc918deBA2d3fc7128A59852b6699CCb2dC0EDB

This registry provides the complete technical reference for the JINBI institutional bond tokenization system deployed on Polygon mainnet.