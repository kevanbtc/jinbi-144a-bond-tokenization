# JINBI International Agency $5B Series B Bond Tokenization
## Investor Data Room

**Last Updated:** September 21, 2025
**Version:** v1.0.0

---

## 📋 Term Sheet

- **Issuer:** JINBI International Agency
- **Security:** 5% Secured Medium-Term Note (MTN)
- **Maturity:** December 31, 2030
- **Face Value:** $5,000,000,000
- **Coupon:** 5.00% per annum, paid semi-annually
- **Settlement:** Delivery vs Payment (DvP) with tokenized custody
- **Partitions:** 144A (US) / Regulation S (International)
- **Currency:** USD (backed by USDC)
- **Blockchain:** Polygon Mainnet

---

## 🆔 Identifiers

- **ISIN:** US87255HAA12 (144A) / US87255HAB94 (Reg S)
- **CUSIP:** 87255H AA1 (144A) / 87255H AB9 (Reg S)
- **Token Symbol:** JINBI-BOND-2030
- **Token Name:** JINBI International Agency Bond 2030

**Note:** CUSIP root updated from 87225H to 87255H for production deployment.

---

## 🔗 Contract Addresses (Polygon Mainnet)

| Contract | Address | Polygonscan |
|----------|---------|-------------|
| CompliantSecurityToken | 0xA715acA24f83b08B786911c4d2fB194132D138D2 | [View](https://polygonscan.com/address/0xA715acA24f83b08B786911c4d2fB194132D138D2) |
| DvPSettlement | 0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D | [View](https://polygonscan.com/address/0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D) |
| CorporateActions | 0x6651995eB8Bb86a551f7951DFc8dDa5070251768 | [View](https://polygonscan.com/address/0x6651995eB8Bb86a551f7951DFc8dDa5070251768) |
| ComplianceOracle | 0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3 | [View](https://polygonscan.com/address/0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3) |
| ComplianceRegistry | 0x4FDF91216009835684233dc69da697BD9FF19F32 | [View](https://polygonscan.com/address/0x4FDF91216009835684233dc69da697BD9FF19F32) |
| AttestationRegistry | 0x73C36D0F747386978d0a0cD93f1d674937e42542 | [View](https://polygonscan.com/address/0x73C36D0F747386978d0a0cD93f1d674937e42542) |
| VaultProofNFT | 0x7a54c01413353088DD64239A75dBcfa8E1E8314a | [View](https://polygonscan.com/address/0x7a54c01413353088DD64239A75dBcfa8E1E8314a) |

**USDC Address:** 0x2791Bca1F2de4661ED88A30C99A7a9449Aa84174

---

## 💰 Settlement Flow

### Primary Issuance (DvP Settlement)
1. **Investor** provides USDC to `DvPSettlement` contract
2. **Contract** verifies compliance eligibility via `ComplianceOracle`
3. **Contract** mints tokens to investor's wallet
4. **Settlement** completes atomically (USDC received ↔ tokens minted)

### Required Signers
- **Settlement Authority:** Safe multisig wallet (owners)
- **Compliance Admin:** Designated compliance officer via roles

### Settlement Commands
```powershell
# Check settlement status
cast call 0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D "settlementStatus(uint256)(uint8)" <settlementId> --rpc-url https://polygon-rpc.com

# Execute settlement (admin only)
cast send 0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D "settle(uint256,address,uint256)" <settlementId> <investor> <amount> --rpc-url https://polygon-rpc.com
```

---

## ✅ Compliance Onboarding

### For Qualified Institutional Buyers (144A)
1. **Submit QIB Certification** to compliance team
2. **Receive Attestation** from `ComplianceOracle`
3. **Wallet Address** added to eligible partition
4. **Settlement** enabled for 144A partition transfers

### For Regulation S Investors
1. **Confirm Non-US Status** via KYC process
2. **Receive Attestation** from `ComplianceOracle`
3. **Wallet Address** added to Reg S partition
4. **Settlement** enabled for Reg S partition transfers

### Compliance Verification
```powershell
# Check investor eligibility
cast call 0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3 "isEligible(address,bytes32)(bool)" <investor> <partition> --rpc-url https://polygon-rpc.com
```

---

## 🔒 Audit & Security

### Security Audit
- **Auditor:** [REDACTED] (Leading DeFi Security Firm)
- **Date:** September 2025
- **Scope:** All contracts, reentrancy fixes, authorization controls
- **Result:** No critical vulnerabilities
- **Report:** [AUDIT_REPORT.md](../AUDIT_REPORT.md)

### On-Chain Attestations
- **Audit Report:** IPFS CID - [Qm...AUDIT_REPORT.md](https://ipfs.io/ipfs/Qm...)
- **Attestation TX:** [0x...](https://polygonscan.com/tx/0x...)
- **Production Readiness:** IPFS CID - [Qm...CHECKLIST.md](https://ipfs.io/ipfs/Qm...)
- **Attestation TX:** [0x...](https://polygonscan.com/tx/0x...)

### Security Features
- **Emergency Pause:** All contracts pausable by Safe multisig
- **Reentrancy Protection:** CEI pattern implemented
- **Access Control:** Role-based permissions via OpenZeppelin
- **Compliance Gates:** Oracle-based transfer validation
- **CI/CD Security:** Automated Slither analysis on all PRs

---

## 📅 Corporate Actions

### Coupon Payments
- **Frequency:** Semi-annual (June 30, December 31)
- **Rate:** 5.00% per annum
- **Payment Method:** Automatic via `CorporateActions.payCoupon()`
- **Currency:** USDC

### Payment Schedule
- **Coupon 1:** June 30, 2025 - 2.50% (prorated)
- **Coupon 2:** December 31, 2025 - 2.50%
- **Coupon 3:** June 30, 2026 - 2.50%
- **...continues to maturity**

### Manual Coupon Payment
```powershell
# Pay coupon (admin only)
cast send 0x6651995eB8Bb86a551f7951DFc8dDa5070251768 "payCoupon(uint256)" <cycleId> --rpc-url https://polygon-rpc.com
```

### Failure Modes
- **Insufficient Funds:** Contract must hold adequate USDC
- **Network Issues:** Payments can be retried
- **Emergency:** Pause contract and resolve manually

---

## 📞 Contact & Escalation

### Primary Contacts
- **Technical Operations:** [REDACTED]@jinbi.agency
- **Compliance:** [REDACTED]@jinbi.agency
- **Investor Relations:** [REDACTED]@jinbi.agency

### Emergency Escalation
1. **Technical Issue:** Email ops + call [REDACTED]
2. **Security Incident:** Call [REDACTED] immediately
3. **Compliance Issue:** Email compliance + legal

### Monitoring
- **Block Explorer:** https://polygonscan.com/
- **RPC Endpoints:** Polygon mainnet (multiple providers)
- **Status Page:** [TBD]

---

## 📋 Additional Documentation

- [AUDIT_REPORT.md](../AUDIT_REPORT.md) - Complete security audit
- [PRODUCTION_READINESS_CHECKLIST.md](../PRODUCTION_READINESS_CHECKLIST.md) - Deployment verification
- [DEPLOYMENT_CHECKLIST.md](../DEPLOYMENT_CHECKLIST.md) - Deployment procedures
- [GitHub Repository](https://github.com/kevanbtc/jinbi-144a-bond-tokenization) - Source code
- [API Documentation](../docs/) - Technical specifications

---

*This data room contains confidential information. Access is restricted to authorized personnel only.*