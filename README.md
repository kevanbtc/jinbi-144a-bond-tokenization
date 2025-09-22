# International Agency — $5B Series B 144A/Reg S Bond Tokenization (Polygon)
[![CI](https://github.com/kevanbtc/jinbi-144a-bond-tokenization/actions/workflows/ci.yml/badge.svg)](https://github.com/kevanbtc/jinbi-144a-bond-tokenization/actions/workflows/ci.yml)
[![Deploy](https://github.com/kevanbtc/jinbi-144a-bond-tokenization/actions/workflows/deploy.yml/badge.svg)](https://github.com/kevanbtc/jinbi-144a-bond-tokenization/actions/workflows/deploy.yml)
[![Security Policy](https://img.shields.io/badge/security-policy-blue)](SECURITY.md)
[![Release](https://img.shields.io/github/v/release/kevanbtc/jinbi-144a-bond-tokenization?display_name=tag)](https://github.com/kevanbtc/jinbi-144a-bond-tokenization/releases)
![Security Status](https://img.shields.io/badge/security-CEI%20hardened-green)
![Audit Attested](https://img.shields.io/badge/audit-attested-blue)
![Chain](https://img.shields.io/badge/chain-Polygon%20Mainnet-8247e5)
![CI Gates](https://img.shields.io/badge/CI-tests%20%2B%20slither%20gates-brightgreen)
![License](https://img.shields.io/badge/license-Commercial-lightgrey)

**Institutional, compliant, production-ready infrastructure** for a secured medium-term note (5%, due 2030) offered under **Rule 144A** with **Reg S** distribution, settled in **USDC** via **DvP**, with **compliance-gated transfers**, **corporate actions**, **Chainlink** price references, and **on-chain audit attestations**.

**Quick Links:** • **Data Room:** [`/data-room/README.md`](data-room/README.md) • **Investor Ops (5-min DvP):** [`INVESTOR_OPS_SHEET.md`](INVESTOR_OPS_SHEET.md) • **Audit Report:** [`AUDIT_REPORT.md`](AUDIT_REPORT.md) • **Readiness Checklist:** [`PRODUCTION_READINESS_CHECKLIST.md`](PRODUCTION_READINESS_CHECKLIST.md) • **CI Status:** [Actions → CI](https://github.com/kevanbtc/jinbi-144a-bond-tokenization/actions/workflows/ci.yml) • **Latest Release:** [Releases](https://github.com/kevanbtc/jinbi-144a-bond-tokenization/releases)

---

## Table of Contents
1. [Overview](#overview)
2. [Live Addresses (Polygon Mainnet)](#live-addresses-polygon-mainnet)
3. [Architecture](#architecture)
4. [Security Posture](#security-posture)
5. [Compliance Model (144a--reg-s)](#compliance-model-144a--reg-s)
6. [DvP Settlement Flow](#dvp-settlement-flow)
7. [Corporate Actions](#corporate-actions)
8. [Quick Start (Ops)](#quick-start-ops)
9. [Launch & Verification](#launch--verification)
10. [Monitoring & Incident Response](#monitoring--incident-response)
11. [Documentation Bundle](#documentation-bundle)
12. [Disclaimers](#disclaimers)

---

## Overview
This repository contains the **smart contracts**, **runbooks**, and **automation scripts** to operate a tokenized, secured institutional bond on **Polygon Mainnet**. The system enforces **investor eligibility** (144A/Reg S), settles primary allocations and redemptions **DvP in USDC**, and automates **coupon distributions**. It is hardened with **Checks-Effects-Interactions**, **pause controls**, **multisig ownership**, and **CI security gates**.

**Key capabilities**
- **CompliantSecurityToken** with partitions **/144A** and **/RegS**
- **Compliance Oracle** + **Registry** for real-time KYC/sanctions eligibility
- **DvPSettlement (USDC)** for atomic primary issuance/redemption
- **CorporateActions** for coupon accrual, distribution, and events
- **VaultProofNFT** for reserve documentation anchoring (IPFS)
- **Chainlink** feeds (e.g., XAU/USD, MATIC/USD) via Price Router
- **AttestationRegistry** for **on-chain audit & document receipts**

---

## Live Addresses (Polygon Mainnet)
> If you redeploy, replace below with the verified production set and add Polygonscan name tags.

| Contract                | Address                                      | Notes                      |
|-------------------------|----------------------------------------------|----------------------------|
| **CompliantSecurityToken** | [`0xA715acA24f83b08B786911c4d2fB194132D138D2`](https://polygonscan.com/address/0xA715acA24f83b08B786911c4d2fB194132D138D2) | Main security token (18d)  |
| **DvPSettlement**       | [`0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D`](https://polygonscan.com/address/0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D) | USDC DvP engine            |
| **CorporateActions**    | [`0x6651995eB8Bb86a551f7951DFc8dDa5070251768`](https://polygonscan.com/address/0x6651995eB8Bb86a551f7951DFc8dDa5070251768) | Coupons & events           |
| **ComplianceOracle**    | [`0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3`](https://polygonscan.com/address/0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3) | Eligibility checks         |
| **ComplianceRegistry**  | [`0x4FDF91216009835684233dc69da697BD9FF19F32`](https://polygonscan.com/address/0x4FDF91216009835684233dc69da697BD9FF19F32) | KYC/SDN registry           |
| **ChainlinkPriceRouter**| [`0xB3940e869Def6C07191056659889018Ebac10cB3`](https://polygonscan.com/address/0xB3940e869Def6C07191056659889018Ebac10cB3) | Price lookups              |
| **VaultProofNFT**       | [`0x7a54c01413353088DD64239A75dBcfa8E1E8314a`](https://polygonscan.com/address/0x7a54c01413353088DD64239A75dBcfa8E1E8314a) | Reserve proofs             |
| **AttestationRegistry** | [`0x73C36D0F747386978d0a0cD93f1d674937e42542`](https://polygonscan.com/address/0x73C36D0F747386978d0a0cD93f1d674937e42542) | On-chain receipts          |
| **ChainlinkProofAdapter** | [`0x2b5B28D60b123C0b7cFb9C84a26559683d9edB39`](https://polygonscan.com/address/0x2b5B28D60b123C0b7cFb9C84a26559683d9edB39) | Proof integrations         |
| **TransferAgentBridge** | [`0x1AC482B0585BedA95BEee90BA623FAd876F48fE2`](https://polygonscan.com/address/0x1AC482B0585BedA95BEee90BA623FAd876F48fE2) | Transfer agent sync        |
| **USDC (Polygon)**      | [`0x2791Bca1F2de4661ED88A30C99A7a9449Aa84174`](https://polygonscan.com/address/0x2791Bca1F2de4661ED88A30C99A7a9449Aa84174) | Settlement currency        |

### Offering Identifiers
- **144A**: CUSIP `87255H AB4` • ISIN `US87255HAB42`
- **Reg S**: CUSIP `P9000T AA8` • ISIN `BSP9000TAA83`

> **Consistency Check:** Ensure CUSIP/ISIN roots align. Apply **Polygonscan Name Tags** and repo/site links before investor distribution.

### On-Chain Receipts (fill once available)
- **Audit Attestation TX:** [`0x…`](https://polygonscan.com/tx/0x…)
- **Readiness Attestation TX:** [`0x…`](https://polygonscan.com/tx/0x…)
- **Audit Report CID:** [`ipfs://…`](https://ipfs.io/ipfs/…)
- **Readiness Checklist CID:** [`ipfs://…`](https://ipfs.io/ipfs/…)

---

## Architecture
**Core flows**
- **Transfers:** partition-aware checks via **ComplianceOracle** (/144A, /RegS)
- **Primary issuance/redemption:** **DvPSettlement** against **USDC**
- **Coupons:** **CorporateActions** schedules & distributes
- **Documents:** **VaultProofNFT** + **AttestationRegistry** (IPFS receipts)
- **Prices:** **Chainlink** feeds through **PriceRouter**

**Trust boundaries**
- **Issuer/TA (multisig):** admin actions (pause, role mgmt)
- **Oracle Operators:** update eligibility from off-chain KYC
- **Investors:** receive tokens on eligible partitions; invalid paths revert

---

## Security Posture
- **CEI** enforced on all value paths (reentrancy-safe)
- **Pause controls** on critical modules; **Safe multisig** governance
- **Immutables** for critical wiring (USDC, token refs, registries) where applicable
- **CI gates:** Foundry tests + Slither + secrets scan + contract size guard
- **On-chain attestations:** audit/report CIDs via **AttestationRegistry**

**Risk & Controls**
| Risk Vector              | Control                                                |
|--------------------------|--------------------------------------------------------|
| Reentrancy on payouts    | CEI across coupon/cash flows                           |
| Unauthorized DvP         | `NOT_AUTHORIZED` checks + RBAC                         |
| Key compromise           | Safe multisig + pause guardian                         |
| Oracle staleness         | Chainlink heartbeat monitoring; pause on breach        |
| Misrouted settlement     | USDC immutables + DvP atomicity                        |
| Regression risk          | CI gates (coverage ≥95%, Slither, size, secrets)       |

---

## Compliance Model (144A / Reg S)
- **Eligibility:** wallet must be **attested** (QIB for 144A; non-US & permitted for Reg S)
- **Partitions:** **/144A** & **/RegS** branches gate transfers
- **Oracle + Registry:** transfers call oracle; non-eligible **revert**
- **Audit Trail:** decisions and docs pinned to IPFS; receipts on-chain

> This repo provides **technical enforcement**. **Legal offering and distribution** are handled by issuer counsel & TA.

---

## DvP Settlement Flow
1. **Whitelist** investor via **ComplianceOracle/Registry**
2. **Book** allocation in **DvPSettlement** (amount & partition)
3. **Transfer USDC** from investor to settlement contract
4. **Atomic DvP:** USDC received ⇒ tokens delivered; else revert
5. **Record** event/receipt (optionally via **AttestationRegistry**)

All steps are **transactional** with full revert on mismatch.

---

## Corporate Actions
- **Schedule** coupon cycles (e.g., quarterly) in **CorporateActions**
- **Fund** USDC and **distribute** to eligible partition holders
- **Emit** events; optionally pin statements to IPFS

---

## Quick Start (Ops)
> Requires: Foundry, PowerShell (Windows), funded deployer or Safe.

```powershell
# 0) From repo root
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# 1) Environment
Copy-Item .env.example .env
# Populate PRIVATE_KEY or configure Safe; set POLYGON_RPC_URL & POLYGONSCAN_API_KEY

# 2) One-shot launch sequence (verifies & attests)
.\LAUNCH_SEQUENCE.ps1
```

**Automation scripts**

* `scripts/transfer_ownership.ps1` → move owners to **Safe**
* `scripts/pause_drill.ps1` → verify **pause/unpause**
* `scripts/verify_params.ps1` → assert USDC/token wiring & oracle registry
* `scripts/attest_audit.ps1` → pin IPFS docs & **anchor** receipts on-chain
* `scripts/create_release.ps1` → tag + **SHA256** checksums
* `scripts/check_rpc_failover.ps1` → multi-provider health
* `scripts/smoke_test.ps1` → identity + coupon dry-run
* `scripts/production_verification.ps1` → **final READY gate**

---

## Launch & Verification

### One-Minute Verification (copy/paste)

```powershell
$RPC = "https://polygon-rpc.com"

# Token identity
cast call 0xA715acA24f83b08B786911c4d2fB194132D138D2 "name()(string)"    --rpc-url $RPC
cast call 0xA715acA24f83b08B786911c4d2fB194132D138D2 "symbol()(string)"  --rpc-url $RPC
cast call 0xA715acA24f83b08B786911c4d2fB194132D138D2 "decimals()(uint8)" --rpc-url $RPC

# Wiring sanity
cast call 0x6651995eB8Bb86a551f7951DFc8dDa5070251768 "usdc()(address)"   --rpc-url $RPC
cast call 0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D "token()(address)"  --rpc-url $RPC

# Oracle → Registry
cast call 0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3 "registry()(address)" --rpc-url $RPC
```

**Polygonscan**

* Verify all contracts with constructor args
* Apply **Public Name Tags** (link to docs & site)

**On-Chain Attestations (examples)**

* `AUDIT_REPORT` → `ipfs://…`
* `PRODUCTION_READINESS` → `ipfs://…`

**Release Provenance**

* Git tag `v1.0.0` (signed)
* Attach `checksums.txt` + attestation TX hashes in release notes

---

## Monitoring & Incident Response

* **RPC failover:** Alchemy + public RPC rotation
* **Price feed staleness:** alert if Chainlink heartbeat breached → **pause**
* **Runbooks:** see `docs/` + `data-room/README.md`
* **Emergency:** multisig signers execute `pause()`; publish incident note to IPFS + attest

**Emergency Pause (30s)**

1. Safe executes `pause()` on Security Token (and DvP/CorporateActions if needed)
2. Publish incident note to IPFS → add CID to `AttestationRegistry`
3. Impact assessment + fix path; quorum sign-off
4. `unpause()` after postmortem attached

---

## Documentation Bundle

* `README.md` (this doc)
* `data-room/README.md` (investor data room: term sheet, flows, links)
* `INVESTOR_OPS_SHEET.md` (5-minute DvP guide)
* `DEPLOYMENT_CHECKLIST.md` (institutional cutover)
* `AUDIT_REPORT.md` (security analysis & fixes)
* `PRODUCTION_READINESS_CHECKLIST.md` (go/no-go controls)
* `.github/BRANCH_PROTECTION_GUIDE.md`, `CODEOWNERS`, `SECURITY.md`

---

## Disclaimers

This repository provides **technology** to enforce transfer restrictions, DvP settlement, and corporate actions for a tokenized bond. It is **not** an offer to sell or a solicitation to buy securities. **Offering terms, disclosures, eligibility, and regulatory compliance** are governed by issuer documentation and applicable law. Obtain **legal review** and an **independent smart-contract audit** prior to production.

---

**Contact (Operations & Listings):** *Add official issuer/TA contact (email + phone).*
For security disclosures, see **SECURITY.md**.
