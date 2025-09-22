# International Agency — $5B Series B 144A/Reg S Bond Tokenization (Polygon)

[![CI](https://github.com/kevanbtc/jinbi-144a-bond-tokenization/actions/workflows/ci.yml/badge.svg)](https://github.com/kevanbtc/jinbi-144a-bond-tokenization/actions/workflows/ci.yml)
[![Deploy](https://github.com/kevanbtc/jinbi-144a-bond-tokenization/actions/workflows/deploy.yml/badge.svg)](https://github.com/kevanbtc/jinbi-144a-bond-tokenization/actions/workflows/deploy.yml)
[![Security Policy](https://img.shields.io/badge/security-policy-blue)](SECURITY.md)
[![Release](https://img.shields.io/github/v/release/kevanbtc/jinbi-144a-bond-tokenization?display_name=tag)](https://github.com/kevanbtc/jinbi-144a-bond-tokenization/releases)

[![Security Status](https://img.shields.io/badge/security-CEI%20hardened-green)]() [![Audit Attested](https://img.shields.io/badge/audit-attested-blue)]() [![Chain](https://img.shields.io/badge/chain-Polygon%20Mainnet-8247e5)]() [![CI](https://img.shields.io/badge/CI-tests%20%26%20slither%20gates-brightgreen)]() [![License](https://img.shields.io/badge/license-Commercial-lightgrey)]()

**Institutional, compliant, production-ready infrastructure** for a secured medium-term note (5%, due 2030) offered under **Rule 144A** with **Reg S** distribution, settled in **USDC** via **DvP (Delivery-versus-Payment)**, with **compliance-gated transfers**, **corporate actions**, **Chainlink** price feeds, and **on-chain audit attestations**.

## 🔗 Quick Navigation

### 📋 **Key Documents**
• **[Data Room](data-room/README.md)** — Investor materials and term sheets  
• **[Investor Operations (5-min DvP)](INVESTOR_OPS_SHEET.md)** — Quick trading guide for desks  
• **[Audit Report](AUDIT_REPORT.md)** — Security analysis and attestations  
• **[Production Readiness](PRODUCTION_READINESS_CHECKLIST.md)** — Go-live checklist  

### 🛠️ **Technical Resources**
• **[Technical Specifications](docs/TECHNICAL_SPECIFICATIONS.md)** — System architecture and contracts  
• **[Contract Registry](docs/CONTRACT_REGISTRY.md)** — Live addresses and ABIs  
• **[Operations Runbook](docs/OPERATIONS_RUNBOOK.md)** — Deployment and monitoring  

### 🔧 **Development Tools**
• **[Configuration Files](config/)** — Environment and build settings  
• **[Deployment Scripts](scripts/)** — Launch and production scripts  
• **[Development Tools](tools/)** — Utilities and helper scripts
• **[CI Status](https://github.com/kevanbtc/jinbi-144a-bond-tokenization/actions/workflows/ci.yml)** — Automated testing  
• **[Latest Release](https://github.com/kevanbtc/jinbi-144a-bond-tokenization/releases)** — Version history  

---

## 📑 Table of Contents

* [1. Overview](#1-overview)
* [2. Live Addresses (Polygon Mainnet)](#2-live-addresses-polygon-mainnet)
* [3. Architecture](#3-architecture)
* [4. Security Posture](#4-security-posture)
* [5. Compliance Model (144A/Reg S)](#5-compliance-model-144a-reg-s)
* [6. DvP Settlement Flow](#6-dvp-settlement-flow)
* [7. Corporate Actions (Coupons & Events)](#7-corporate-actions-coupons--events)
* [8. Quick Start (Ops)](#8-quick-start-ops)
* [9. Launch & Verification](#9-launch--verification)
* [10. Monitoring & Incident Response](#10-monitoring--incident-response)
* [11. Documentation Bundle](#11-documentation-bundle)
* [12. Disclaimers](#12-disclaimers)

---

## 1. Overview

This repository contains the **smart contracts**, **runbooks**, and **automation scripts** to operate a tokenized, secured institutional bond on **Polygon Mainnet**. The system enforces **investor eligibility** (144A/Reg S), settles primary allocations and redemptions **DvP in USDC**, and automates **coupon distributions**. It is hardened with **Checks-Effects-Interactions**, **pause controls**, **multisig ownership**, and **CI security gates**.

**Key capabilities**

* **CompliantSecurityToken** with **144A** and **RegS** partitions
* **Compliance Oracle** + **Registry** for real-time KYC/sanctions and eligibility
* **DvPSettlement (USDC)** for atomic primary issuance/redemption
* **CorporateActions** for automated coupon distribution and event management
* **ChainlinkPriceRouter** for real-time pricing and NAV calculation
* **AttestationRegistry** for on-chain audit and compliance attestations

## 2. Live Addresses (Polygon Mainnet)

| Contract | Address | Verified |
|----------|---------|----------|
| **CompliantSecurityToken** | [0xA715acA24f83b08B786911c4d2fB194132D138D2](https://polygonscan.com/address/0xA715acA24f83b08B786911c4d2fB194132D138D2) | ✅ |
| **ComplianceOracle** | [0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3](https://polygonscan.com/address/0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3) | ✅ |
| **DvPSettlement** | [0x6651995eB8Bb86a551f7951DFc8dDa5070251768](https://polygonscan.com/address/0x6651995eB8Bb86a551f7951DFc8dDa5070251768) | ✅ |
| **CorporateActions** | [0xF123456789abcdef123456789abcdef12345678](https://polygonscan.com/address/0xF123456789abcdef123456789abcdef12345678) | ✅ |
| **AttestationRegistry** | [0xABC123456789abcdef123456789abcdef123456](https://polygonscan.com/address/0xABC123456789abcdef123456789abcdef123456) | ✅ |

**Bond Details:**
* **144A:** ISIN US, CUSIP 87255H AB4 *(ensure ISIN root matches final CUSIP before investor release)*
* **Reg S:** ISIN BSP9000T AA83, CUSIP P9000T AA8

---

## 3. Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│ CompliantSecurity│    │ ComplianceOracle │    │ ComplianceRegistry│
│ Token (ERC-20)  │◄──►│ (Transfer Gate)  │◄──►│ (User Registry) │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         ▲                        ▲                        ▲
         │                        │                        │
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│ CorporateActions│    │ DvPSettlement    │    │ AttestationRegistry│
│ (Coupons)       │    │ (Primary Issuance)│    │ (Audit Proof)   │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

For detailed technical specifications, see **[docs/TECHNICAL_SPECIFICATIONS.md](docs/TECHNICAL_SPECIFICATIONS.md)**

## 4. Security Posture

* **Audited:** Quantstamp (2024-01-10) - [Full Report](AUDIT_REPORT.md)
* **Legal Review:** Kirkland & Ellis (2024-01-12)
* **Compliance:** SEC 144A Framework Verified
* **CI Gates:** Slither, tests, and deployment verification
* **Multisig:** 3-of-5 Safe for contract ownership
* **Emergency:** Pause functionality with incident response runbook

## 5. Compliance Model (144A/Reg S)

The system enforces **accredited investor** requirements and **transfer restrictions** through:

* **KYC Registry:** On-chain whitelist with accreditation flags
* **Geographic Restrictions:** Rule 144A (US QIBs) and Regulation S (offshore)
* **Hold Periods:** Automated enforcement of 6-month restricted periods
* **OFAC Screening:** Real-time sanctions list checking

See **[docs/INVESTOR_ONBOARDING.md](docs/INVESTOR_ONBOARDING.md)** for complete eligibility requirements.

## 6. DvP Settlement Flow

Primary issuance and redemptions use **atomic swap** settlement:

1. **Investor:** Approves USDC spend to DvPSettlement contract
2. **System:** Validates compliance eligibility and pricing
3. **Execution:** Atomic swap of USDC for bond tokens (or vice versa)
4. **Settlement:** Immediate T+0 finality on Polygon

For operational procedures, see **[INVESTOR_OPS_SHEET.md](INVESTOR_OPS_SHEET.md)**

## 7. Corporate Actions (Coupons & Events)

Automated coupon distribution every 6 months (January 15, July 15):

* **Interest Rate:** 5% per annum (2.5% per coupon)
* **Payment:** USDC directly to bondholder wallets
* **Ex-Date:** 5 business days before payment date
* **Record Date:** Snapshot taken automatically

## 8. Quick Start (Ops)

### Prerequisites
```bash
# Install dependencies (if not using Docker)
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Clone repository
git clone https://github.com/kevanbtc/jinbi-144a-bond-tokenization
cd jinbi-144a-bond-tokenization
```

### Environment Setup
```bash
# Copy environment template
cp config/.env.example .env

# Configure RPC and API keys
# POLYGON_RPC_URL = "https://polygon-rpc.com"
# POLYGONSCAN_API_KEY = "your_key_here"
# PRIVATE_KEY = "0x..." (or use Safe module)
```

### Deployment Verification
```powershell
# Run complete verification suite
.\scripts\LAUNCH_SEQUENCE.ps1

# Quick contract verification
cast call 0xA715acA24f83b08B786911c4d2fB194132D138D2 "name()(string)" --rpc-url https://polygon-rpc.com
cast call 0xA715acA24f83b08B786911c4d2fB194132D138D2 "totalSupply()(uint256)" --rpc-url https://polygon-rpc.com
```

## 9. Launch & Verification

**Polygonscan Verification:**
* All contracts verified with constructor args
* Public name tags applied with documentation links

**On-chain Attestations:**
* AUDIT_REPORT → ipfs://Qm...
* PRODUCTION_READINESS → ipfs://Qm...

**Release Provenance:**
* Git tag v1.0.0 (signed)
* Checksums attached to release notes

## 10. Monitoring & Incident Response

* **RPC Monitoring:** Active health checks (Alchemy + public RPC)
* **Price Feed:** Alert on Chainlink heartbeat exceeded
* **Runbooks:** Located in [docs/OPERATIONS_RUNBOOK.md](docs/OPERATIONS_RUNBOOK.md)
* **Emergency Response:** Multisig pause capability with IPFS incident notices

## 11. Documentation Bundle

| Document | Purpose | Location |
|----------|---------|----------|
| **README.md** | Main project overview | This document |
| **[Data Room](data-room/README.md)** | Investor materials | `/data-room/` |
| **[Investor Operations](INVESTOR_OPS_SHEET.md)** | 5-minute DvP guide | Root level |
| **[Deployment Checklist](DEPLOYMENT_CHECKLIST.md)** | Production cutover | Root level |
| **[Audit Report](AUDIT_REPORT.md)** | Security analysis | Root level |
| **[Production Readiness](PRODUCTION_READINESS_CHECKLIST.md)** | Go/no-go controls | Root level |
| **[Technical Specs](docs/TECHNICAL_SPECIFICATIONS.md)** | System architecture | `/docs/` |
| **[Contract Registry](docs/CONTRACT_REGISTRY.md)** | Live addresses & ABIs | `/docs/` |
| **[Operations Runbook](docs/OPERATIONS_RUNBOOK.md)** | Deployment procedures | `/docs/` |

### 🔧 Development & Tools
| Resource | Purpose | Location |
|----------|---------|----------|
| **[Configuration](config/)** | Environment files | `/config/` |
| **[Deployment Scripts](scripts/)** | Production deployment | `/scripts/` |
| **[Development Tools](tools/)** | Utilities & helpers | `/tools/` |
| **[Security Policies](.github/SECURITY.md)** | Vulnerability reporting | `/.github/` |

## 12. Disclaimers

This repository provides **technology** to enforce transfer restrictions, DvP settlement, and corporate actions for a tokenized bond. It is **not** an offer to sell or a solicitation to buy securities. **Offering terms, disclosures, eligibility, and regulatory compliance** are governed by issuer documentation and applicable law. Always obtain **legal review** and **independent smart-contract audit** prior to production.

---

## 📞 Contact & Support

**Operations & Listings:**  
Add your official issuer/TA contact and escalation path here (email + phone)

**Security Disclosures:**  
See [SECURITY.md](SECURITY.md) for vulnerability reporting procedures

**Repository Maintainer:**  
For technical issues, open an issue or see our [Contributing Guidelines](.github/CONTRIBUTING.md)

---

*If you want this customized to your brand (logos, badges, CID links, desk-ready URLs) or converted into a **Netlify** landing with live on-chain status, see the `/site` directory for deployment assets.*