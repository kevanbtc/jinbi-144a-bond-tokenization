# JINBI Operations Runbook

## Daily Operations

### Morning Checklist
- [ ] Check all smart contract balances and total supplies
- [ ] Verify USDC balances in corporate actions contract
- [ ] Review overnight transfer activity and compliance alerts
- [ ] Confirm Chainlink price feed updates (XAU/USD, USDC/USD)
- [ ] Check custodian attestation updates

### Sanctions and Compliance Monitoring
```bash
# Daily sanctions screening update
COMPLIANCE_REGISTRY=0x... \
forge script scripts/ops/update_sanctions.s.sol --rpc-url $RPC_URL --broadcast
```

### Price Feed Validation
```bash
# Verify price feeds are updating
forge script scripts/ops/check_price_feeds.s.sol --rpc-url $RPC_URL
```

## Primary Issuance Procedures

### 1. Investor Onboarding
```bash
# Set compliance flags for new investor
COMPLIANCE_REGISTRY=0x... \
INVESTOR_ADDRESS=0x... \
KYC_STATUS=true \
QIB_STATUS=true \
forge script scripts/ops/set_compliance_flags.s.sol --rpc-url $RPC_URL --broadcast
```

### 2. Allocation Booking
```bash
# Book primary allocation
DVP_SETTLEMENT=0x... \
PARTITION=144A \
INVESTOR_ADDRESS=0x... \
BOND_AMOUNT=1000000000000000000000 \
BOND_PRICE=1000000 \
forge script scripts/ops/allocate_primary.s.sol --rpc-url $RPC_URL --broadcast
```

### 3. Settlement Monitoring
- Monitor `Booked` events from DvPSettlement
- Track investor `settle()` transactions
- Verify USDC transfers and token minting
- Update internal allocation tracking

## Corporate Actions

### Quarterly Coupon Payments

#### 1. Calculate Coupon Amount
```bash
# Get total supply for pro-rata calculation
TOTAL_SUPPLY=$(cast call $COMPLIANT_SECURITY_TOKEN "totalSupply()" --rpc-url $RPC_URL)
QUARTERLY_RATE=125 # 1.25% quarterly (5% annual)
COUPON_AMOUNT=$((TOTAL_SUPPLY * QUARTERLY_RATE / 10000))
```

#### 2. Fund Corporate Actions Contract
```bash
# Approve and transfer USDC to corporate actions
cast send $USDC_ADDRESS "approve(address,uint256)" $CORPORATE_ACTIONS $COUPON_AMOUNT --private-key $PRIVATE_KEY --rpc-url $RPC_URL
```

#### 3. Execute Coupon Payment
```bash
CORPORATE_ACTIONS=0x... \
USDC_ADDRESS=0x... \
CYCLE_ID=1 \
COUPON_AMOUNT=50000000000 \
forge script scripts/ops/schedule_coupon.s.sol --rpc-url $RPC_URL --broadcast
```

#### 4. Verify Distribution
- Check `CouponPaid` event emission
- Verify USDC transfer to corporate actions contract
- Monitor off-chain distribution to token holders
- Generate coupon statements for investors

## Transfer Agent Operations

### Cap Table Reconciliation
```bash
# Record DTC cap table snapshot
TRANSFER_AGENT_BRIDGE=0x... \
PERIOD="Q4-2024" \
CID="QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG" \
KEY=$(cast keccak "Q4-2024") \
forge script scripts/ops/record_cap_table.s.sol --rpc-url $RPC_URL --broadcast
```

### Force Transfer (Emergency Only)
```bash
# Execute force transfer (court order)
COMPLIANT_SECURITY_TOKEN=0x... \
PARTITION=/144A \
FROM_ADDRESS=0x... \
TO_ADDRESS=0x... \
AMOUNT=1000000000000000000000 \
forge script scripts/ops/force_transfer.s.sol --rpc-url $RPC_URL --broadcast
```

## Compliance Management

### Reg S Lockup Management
```bash
# Set Reg S lockup period (40 days)
COMPLIANCE_ORACLE=0x... \
INVESTOR_ADDRESS=0x... \
LOCKUP_END=$(($(date +%s) + 3456000)) # 40 days
forge script scripts/ops/set_lockup.s.sol --rpc-url $RPC_URL --broadcast
```

### Sanctions List Updates
```bash
# Block sanctioned address
COMPLIANCE_REGISTRY=0x... \
BLOCKED_ADDRESS=0x... \
forge script scripts/ops/block_address.s.sol --rpc-url $RPC_URL --broadcast
```

## Custodian Operations

### Vault Proof Updates
```bash
# Update custodian attestation
CHAINLINK_PROOF_ADAPTER=0x... \
SCOPE="monthly-custody" \
CID="QmNewCustodyReport123..." \
KEY=$(cast keccak "monthly-custody-$(date +%Y%m)") \
forge script scripts/ops/update_custody_proof.s.sol --rpc-url $RPC_URL --broadcast
```

### Asset Verification
- Verify underlying MTN custody with custodian
- Update vault proof NFT metadata if required
- Reconcile on-chain token supply with custodial holdings

## Emergency Procedures

### System Pause
```bash
# Pause all transfers (emergency only)
COMPLIANT_SECURITY_TOKEN=0x... \
forge script scripts/ops/emergency_pause.s.sol --rpc-url $RPC_URL --broadcast
```

### Unpause After Review
```bash
# Unpause after emergency resolved
COMPLIANT_SECURITY_TOKEN=0x... \
forge script scripts/ops/unpause_system.s.sol --rpc-url $RPC_URL --broadcast
```

### Oracle Failure Response
1. Monitor Chainlink price feed health
2. Implement manual price updates if required
3. Document any manual interventions
4. Notify relevant stakeholders

## Monitoring and Alerts

### Key Metrics to Monitor
- Total token supply vs. underlying bond value
- Daily transfer volume and compliance rejections
- USDC balance in corporate actions contract
- Price feed staleness and deviations
- Failed transaction rates

### Alert Triggers
- Compliance oracle rejection rate > 5%
- Price feed not updated in 1 hour
- Large transfer attempts (>$1M equivalent)
- New sanctions list updates
- Smart contract pause events

### Dashboard URLs
- Etherscan: `https://etherscan.io/address/${CONTRACT_ADDRESS}`
- Token metrics: Custom dashboard
- Compliance reports: Internal portal

## Month-End Procedures

### Financial Reconciliation
1. Reconcile on-chain balances with internal records
2. Generate investor statements with coupon history
3. Update cap table snapshots
4. Prepare regulatory reports
5. Archive transaction logs and compliance records

### Compliance Review
1. Review all transfer rejections and approvals
2. Update investor compliance status as needed
3. Generate compliance report for regulators
4. Document any exceptional transactions

### System Health
1. Review smart contract gas usage and optimization
2. Update operational procedures if needed
3. Plan for any system upgrades or improvements
4. Backup critical operational data

## Contact Information

### Emergency Contacts
- **System Administrator**: [Contact]
- **Compliance Officer**: [Contact]
- **Transfer Agent**: [Contact]
- **Custodian**: [Contact]
- **Legal Counsel**: [Contact]

### Service Providers
- **Chainlink**: Technical support for price feeds
- **USDC Support**: Circle for USDC issues
- **Network Support**: Ethereum/Polygon support

This runbook should be updated regularly as procedures evolve and new operational requirements emerge.
