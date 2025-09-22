# JINBI International Agency $5B Series B Bond Tokenization

[![Production Ready](https://img.shields.io/badge/status-production--ready-green.svg)](https://github.com/kevanbtc/jinbi-144a-bond-tokenization)
[![Security Audited](https://img.shields.io/badge/security-audited-blue.svg)](AUDIT_REPORT.md)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

Institution-grade tokenized bond system with full regulatory compliance for 144A and Regulation S offerings. **Production-hardened** with emergency controls, CI/CD security gates, and institutional operability.

## 🔥 What's New (v1.0.0)

- ✅ **Security Hardened**: CEI pattern fixes, emergency pause controls, reentrancy protection
- ✅ **CI/CD Pipeline**: Automated Slither analysis blocking security regressions
- ✅ **Production Launch**: Copy-paste deployment scripts with institutional guardrails
- ✅ **Audit Package**: Comprehensive security report with on-chain attestations
- ✅ **Investor Bundle**: Complete data room with settlement flows and compliance guides
- ✅ **Monitoring Suite**: RPC failover, incident runbooks, price feed heartbeat guards

---

## 🏗️ Architecture Overview

This system provides a complete institutional bond tokenization platform featuring:

### Core Security Components
- **Partitioned Security Tokens** (ERC-20 with `/144A` and `/RegS` partitions)
- **Compliance Oracle** with KYC/AML, QIB verification, and lockup enforcement
- **Emergency Pause Controls** on all contracts (Safe multisig governance)
- **Reentrancy Protection** via CEI pattern implementation

### Settlement & Operations
- **DvP Settlement** with USDC for institutional primary markets
- **Corporate Actions** for automated coupon distributions
- **Vault Proof NFTs** linking on-chain tokens to custodial documentation
- **Chainlink Integration** for price feeds and custodian attestations

### Institutional Features
- **Safe Multisig Ownership** across all contracts
- **On-chain Audit Attestation** with IPFS receipts
- **RPC Failover** and monitoring capabilities
- **Incident Response Runbooks** for operational resilience

---

## 🚀 Production Launch Sequence

### Prerequisites
- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [PowerShell](https://docs.microsoft.com/en-us/powershell/) (for launch scripts)
- Safe multisig wallet
- IPFS/Pinata account for audit attestation

### 1. Setup Environment
```bash
# Clone and setup
git clone git@github.com:kevanbtc/jinbi-144a-bond-tokenization.git
cd jinbi-144a-bond-tokenization

# Install dependencies
forge install

# Configure environment
cp .env.example .env
# Edit .env with your Polygon RPC, private keys, Safe address
```

### 2. Security Verification
```bash
# Run comprehensive security tests
forge test

# Verify no vulnerabilities (Slither analysis included in CI)
forge build
```

### 3. Execute Launch Sequence
```powershell
# Run the complete institutional launch sequence
.\LAUNCH_SEQUENCE.ps1

# Individual steps:
.\scripts\transfer_ownership.ps1 -Safe "0xYOUR_SAFE_ADDRESS"
.\scripts\pause_drill.ps1
.\scripts\verify_params.ps1
.\scripts\attest_audit.ps1 -AuditCID "Qm...AUDIT" -ChecklistCID "Qm...CHECKLIST"
.\scripts\create_release.ps1 -Version "v1.0.0" -Message "Production launch"
.\scripts\production_verification.ps1
```

### 4. Deploy to Production
```bash
# Deploy all contracts to Polygon mainnet
forge script contracts/script/Deploy.s.sol --rpc-url $POLYGON_RPC_URL --broadcast --verify

# Verify deployment with production checklist
.\scripts\production_verification.ps1
```

---

## 📋 Core Components

| Contract | Address (Polygon) | Purpose | Security Features |
|----------|------------------|---------|-------------------|
| **CompliantSecurityToken** | [0xA715...D2](https://polygonscan.com/address/0xA715acA24f83b08B786911c4d2fB194132D138D2) | Partitioned bond token | Pause, CEI, Access Control |
| **DvPSettlement** | [0x0b6e...5D](https://polygonscan.com/address/0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D) | Primary issuance DvP | Pause, CEI, Authorization |
| **CorporateActions** | [0x6651...68](https://polygonscan.com/address/0x6651995eB8Bb86a551f7951DFc8dDa5070251768) | Coupon payments | Pause, CEI, Only Admin |
| **ComplianceOracle** | [0x9A26...c3](https://polygonscan.com/address/0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3) | Transfer validation | Pause, Registry integration |
| **ComplianceRegistry** | [0x4FDF...32](https://polygonscan.com/address/0x4FDF91216009835684233dc69da697BD9FF19F32) | Investor KYC/AML | Registry management |
| **AttestationRegistry** | [0x73C3...42](https://polygonscan.com/address/0x73C36D0F747386978d0a0cD93f1d674937e42542) | Document anchoring | On-chain receipts |
| **VaultProofNFT** | [0x7a54...4a](https://polygonscan.com/address/0x7a54c01413353088DD64239A75dBcfa8E1E8314a) | Custody proofs | ERC-721, Pause |

---

## 🎯 Key Features

### 🔒 Security & Compliance
- **Emergency Pause**: All contracts pausable by Safe multisig
- **Reentrancy Protection**: CEI pattern on all external calls
- **Access Control**: Role-based permissions via OpenZeppelin
- **Audit Trail**: On-chain attestations with IPFS receipts
- **Regulatory Compliance**: 144A/Reg S partition enforcement

### 💰 Institutional Settlement
- **USDC DvP**: Atomic settlement with stablecoin
- **Compliance Gates**: Oracle-based transfer validation
- **Automated Coupons**: Pro-rata distribution system
- **Custodian Integration**: NFT-backed vault proofs

### 📊 Monitoring & Operations
- **RPC Failover**: Multi-provider endpoint rotation
- **Price Feed Guards**: Chainlink staleness monitoring
- **Incident Runbooks**: Pause → snapshot → recovery procedures
- **Health Checks**: Automated contract verification

---

## 📊 Bond Specifications

### Security Details
- **Issuer**: JINBI International Agency
- **Face Value**: $5,000,000,000
- **Coupon**: 5.00% per annum (semi-annual)
- **Maturity**: December 31, 2030
- **Currency**: USD (USDC settlement)

### Partition Structure
| Partition | Investors | Restrictions | ISIN | CUSIP |
|-----------|-----------|--------------|------|-------|
| **144A** | QIBs only | Rule 144, no general solicitation | US87255HAA12 | 87255H AA1 |
| **Reg S** | Non-US persons | 40-day lockup, no US investors | US87255HAB94 | 87255H AB9 |

---

## 🛠️ Development

### Testing
```bash
# Run full test suite
forge test

# Run specific test file
forge test --match-path test/ComplianceTest.t.sol

# Run with gas reporting
forge test --gas-report
```

### Security Analysis
```bash
# Slither static analysis (CI automated)
slither contracts/src/

# Build verification
forge build
```

### Deployment Scripts
```bash
# Local deployment
forge script contracts/script/Deploy.s.sol --fork-url $POLYGON_RPC_URL

# Mainnet deployment
forge script contracts/script/Deploy.s.sol --rpc-url $POLYGON_RPC_URL --broadcast --verify
```

---

## 📚 Documentation

### For Institutions
- **[Investor Data Room](data-room/README.md)** - Complete term sheet, settlement flows, compliance requirements
- **[Operations Sheet](INVESTOR_OPS_SHEET.md)** - 5-minute DvP settlement guide for trading desks
- **[Audit Report](AUDIT_REPORT.md)** - Comprehensive security audit with findings and fixes
- **[Production Checklist](PRODUCTION_READINESS_CHECKLIST.md)** - Deployment verification steps

### For Developers
- **[Deployment Guide](DEPLOYMENT_CHECKLIST.md)** - Step-by-step production deployment
- **[Launch Sequence](LAUNCH_SEQUENCE.ps1)** - Institutional go-live procedures
- **[API Documentation](docs/)** - Technical specifications and integration guides

### Security & Compliance
- **Emergency Procedures**: Pause controls, incident response, recovery protocols
- **Monitoring Setup**: RPC failover, price feed alerts, health checks
- **Audit Trail**: On-chain attestations, IPFS receipts, immutable documentation

---

## � Security Measures

### Implemented Fixes
- **Reentrancy Protection**: CEI pattern applied to all affected functions
- **Authorization Checks**: Proper access control on sensitive operations
- **Input Validation**: Comprehensive parameter validation
- **Emergency Controls**: Pause functionality on all contracts

### CI/CD Security Gates
- **Automated Analysis**: Slither static analysis on every PR
- **Vulnerability Blocking**: Critical issues prevent deployment
- **Dependency Scanning**: Supply chain security monitoring
- **Code Quality**: Linting and formatting enforcement

### Operational Security
- **Multi-sig Governance**: Safe wallet ownership across all contracts
- **Immutable Receipts**: On-chain audit attestations
- **Failover Systems**: RPC endpoint redundancy
- **Monitoring Alerts**: Price feed staleness, contract health

---

## 🚨 Important Notices

- **⚖️ Legal Review Required**: Securities lawyers must approve all documentation
- **🏢 Institutional Use Only**: Enterprise-grade key management and custody required
- **🔍 Audit Required**: Smart contracts audited by leading security firms
- **📋 Compliance Critical**: Follow all SEC regulations and jurisdictional requirements
- **🔐 Security First**: Never commit private keys or sensitive configuration

---

## 🤝 Contributing

This is a production system for institutional finance. Contributions require:

1. Security audit approval
2. Legal compliance review
3. Institutional stakeholder sign-off
4. Comprehensive testing coverage

### Development Workflow
```bash
# Create feature branch
git checkout -b feature/security-enhancement

# Make changes with tests
forge test

# Security analysis
slither contracts/src/

# Submit PR with audit documentation
```

---

## 📞 Support & Contact

### Technical Operations
- **Security Issues**: Report via GitHub Security tab
- **Technical Support**: [REDACTED]@jinbi.agency
- **Documentation**: [GitHub Repository](https://github.com/kevanbtc/jinbi-144a-bond-tokenization)

### Institutional Contacts
- **Compliance**: [REDACTED]@jinbi.agency
- **Investor Relations**: [REDACTED]@jinbi.agency
- **Settlement Operations**: [REDACTED]@jinbi.agency

---

## 📈 Roadmap

- **Phase 1** ✅ Production launch with full security hardening
- **Phase 2** 🔄 Multi-chain expansion (Arbitrum, Optimism)
- **Phase 3** 📋 Enhanced compliance automation
- **Phase 4** 🔗 Cross-border settlement integration

---

## 🏆 Built With

- **Solidity 0.8.24** - Smart contract development
- **Foundry** - Testing, deployment, and development framework
- **OpenZeppelin** - Battle-tested contract libraries
- **Slither** - Static security analysis
- **Chainlink** - Decentralized oracle infrastructure
- **IPFS** - Decentralized document storage
- **Safe** - Institutional multi-signature wallets

---

*Built for institutional bond tokenization with enterprise-grade security, compliance, and operability. Production-ready for the $5B JINBI International Agency Series B offering.*

<!-- GitHub README refresh test -->
