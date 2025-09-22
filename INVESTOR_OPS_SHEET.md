# JINBI Bond Tokenization - Investor Operations Sheet
## 5-Minute DvP Settlement Guide

**For Trading Desks & Institutional Investors**

---

## 🚀 Quick Start

### 1. Verify Eligibility (2 minutes)
```powershell
# Check if your wallet is eligible for 144A partition
cast call 0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3 "isEligible(address,bytes32)(bool)" YOUR_WALLET 0x3134344100000000000000000000000000000000000000000000000000000000 --rpc-url https://polygon-rpc.com
```
**Expected:** `true` (or coordinate with compliance for attestation)

### 2. Check Token Details (1 minute)
```powershell
# Verify token identity
cast call 0xA715acA24f83b08B786911c4d2fB194132D138D2 "name()(string)" --rpc-url https://polygon-rpc.com
cast call 0xA715acA24f83b08B786911c4d2fB194132D138D2 "symbol()(string)" --rpc-url https://polygon-rpc.com
cast call 0xA715acA24f83b08B786911c4d2fB194132D138D2 "decimals()(uint8)" --rpc-url https://polygon-rpc.com
```
**Expected:** `JINBI International Agency Bond 2030`, `JINBI-BOND-2030`, `18`

### 3. Prepare USDC (1 minute)
- Ensure your wallet holds sufficient USDC on Polygon
- USDC Contract: `0x2791Bca1F2de4661ED88A30C99A7a9449Aa84174`
- Approve DvPSettlement contract for USDC transfer

---

## 💰 Settlement Process

### Primary Issuance (DvP)
1. **Submit Settlement Request** (via JINBI ops or direct contract call)
2. **Verify Compliance** (oracle checks eligibility)
3. **Atomic Settlement** (USDC received → tokens minted)

### Settlement Commands
```powershell
# Check settlement status (if provided settlement ID)
cast call 0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D "settlementStatus(uint256)(uint8)" SETTLEMENT_ID --rpc-url https://polygon-rpc.com

# Monitor your token balance
cast call 0xA715acA24f83b08B786911c4d2fB194132D138D2 "balanceOf(address)(uint256)" YOUR_WALLET --rpc-url https://polygon-rpc.com
```

---

## 📊 Key Addresses

| Component | Address | Purpose |
|-----------|---------|---------|
| **Token** | 0xA715acA24f83b08B786911c4d2fB194132D138D2 | Bond tokens |
| **DvP Settlement** | 0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D | Primary issuance |
| **Compliance Oracle** | 0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3 | Eligibility checks |
| **USDC** | 0x2791Bca1F2de4661ED88A30C99A7a9449Aa84174 | Settlement currency |

---

## ⚠️ Important Notes

- **Partitions:** 144A (US QIBs) / Reg S (International)
- **Transfers:** Only between eligible wallets in same partition
- **Emergency:** All contracts can be paused by Safe multisig
- **Support:** Contact ops for settlement assistance

### Compliance Requirements
- **144A:** Must be Qualified Institutional Buyer
- **Reg S:** Non-US investor with proper attestation
- **Verification:** Required before settlement

### Monitoring
- **Polygonscan:** https://polygonscan.com/
- **RPC:** https://polygon-rpc.com (or your preferred endpoint)
- **Status:** Check contract pause state before operations

---

## 📞 Emergency Contacts

- **Technical Issues:** [REDACTED]@jinbi.agency
- **Compliance:** [REDACTED]@jinbi.agency
- **Settlement Support:** [REDACTED]@jinbi.agency

---

*For full documentation, see the complete data room at: .\data-room\README.md*