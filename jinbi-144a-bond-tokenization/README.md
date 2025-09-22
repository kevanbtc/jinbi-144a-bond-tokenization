# JINBI 144A/Reg S Bond Tokenization

Institution-grade tokenized bond system with full regulatory compliance for 144A and Regulation S offerings.

## 🏗️ Architecture Overview

This system provides a complete institutional bond tokenization platform featuring:

- **Partitioned Security Tokens** (ERC-20 with `/144A` and `/RegS` partitions)
- **Compliance Oracle** with KYC/AML, QIB verification, and lockup enforcement  
- **DvP Settlement** with USDC for institutional primary markets
- **Corporate Actions** for automated coupon distributions
- **Vault Proof NFTs** linking on-chain tokens to custodial documentation
- **Chainlink Integration** for price feeds and custodian attestations

## 🚀 Quick Start

### Prerequisites
- [Foundry](https://book.getfoundry.sh/getting-started/installation)

### 1. Setup
```bash
cp .env.example .env
# Edit .env with your configuration
```

### 2. Install Dependencies
```bash
forge install
```

### 3. Compile & Test
```bash
forge build
forge test
```

### 4. Deploy
```bash
forge script contracts/script/Deploy.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --verify
```

## 📋 Core Components

1. **AttestationRegistry** - Document anchoring
2. **ComplianceRegistry** - Investor KYC/AML flags  
3. **ComplianceOracle** - Transfer compliance checking
4. **VaultProofNFT** - Custodian documentation
5. **CompliantSecurityToken** - Partitioned bond token
6. **CorporateActions** - Coupon payments
7. **DvPSettlement** - Primary issuance DvP
8. **ChainlinkPriceRouter** - Price feeds
9. **TransferAgentBridge** - DTC mirroring

## 🎯 Key Features

### Regulatory Compliance
- **144A**: QIB-only with Rule 144 restrictions
- **Reg S**: Non-US with 40-day lockup
- **Transfer Oracle**: Real-time compliance checks
- **Force Transfer**: TA emergency powers

### Settlement & Operations
- **USDC DvP**: Institution-grade settlement
- **Automated Coupons**: Pro-rata distributions
- **IPFS Documentation**: Immutable legal docs
- **Chainlink Proofs**: Custodian attestations

## 📊 Bond Details

### 144A Tranche
- **ISIN**: US87225HAB42
- **CUSIP**: 87225H AB4
- **Investors**: QIBs only

### Reg S Tranche  
- **ISIN**: BSP9000TAA83
- **CUSIP**: P9000T AA8
- **Investors**: Non-U.S. persons

## ⚠️ Important

- **Legal Review Required**: Securities lawyers must approve
- **Institutional Use Only**: Enterprise key management required
- **Audit Required**: Smart contracts must be audited
- **Compliance Critical**: Follow all securities regulations

Built for institutional bond tokenization with enterprise-grade security.
