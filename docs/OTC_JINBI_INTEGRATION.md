# JINBI OTC Market Integration

## Overview

This document outlines the integration between the JINBI 144A/Reg S tokenized bond system and OTC market makers, with particular focus on the JINBI OTC desk for secondary market liquidity.

## Market Structure

### Primary Market (DvP Settlement)
- **Issuer** → **DvPSettlement Contract** → **Investors**
- USDC settlement for new bond issuances
- Compliance-gated allocation and minting
- Partition-aware (144A vs Reg S)

### Secondary Market (OTC Integration)
- **JINBI OTC Desk** as authorized market maker
- Compliant peer-to-peer transfers via `transferByPartition()`
- Price discovery through Chainlink price feeds
- Institutional-only participation

## JINBI OTC Desk Onboarding

### 1. Compliance Setup
```bash
# Whitelist JINBI OTC desk wallets
COMPLIANCE_REGISTRY=0x... \
JINBI_DESK_WALLET=0x742C9B63B5c59DC28b5e8F6aC1aC1FFc0f29f2f1 \
# Set as both QIB (for 144A) and institutional dealer
COMPLIANCE_FLAGS='{"kyc":true,"qib":true,"nonUS":false,"pepClear":true,"sanctionsClear":true}' \
forge script scripts/ops/whitelist_dealer.s.sol --rpc-url $RPC_URL --broadcast
```

### 2. Market Maker Designation
```solidity
// Grant special dealer status in ComplianceRegistry
complianceRegistry.setDealerStatus(jinbiDeskWallet, true);
```

### 3. Risk Limits and Controls
- Maximum position limits per ISIN/CUSIP
- Daily trading volume limits
- Automated compliance monitoring
- Real-time sanctions screening

## Trading Workflow

### 1. Price Discovery
```bash
# Get current gold price and USDC rate
PRICE_ROUTER=0x... \
XAU_USD=$(cast call $PRICE_ROUTER "peek(bytes32)" $(cast keccak "XAU/USD") --rpc-url $RPC_URL)
USDC_USD=$(cast call $PRICE_ROUTER "peek(bytes32)" $(cast keccak "USDC/USD") --rpc-url $RPC_URL)

# Calculate fair value for bond
echo "XAU/USD: $XAU_USD"
echo "USDC/USD: $USDC_USD"
```

### 2. Negotiated Trading

#### Client Interest
1. **Client** contacts JINBI desk with buy/sell interest
2. **JINBI Desk** checks client compliance status
3. **JINBI Desk** provides live quote based on Chainlink feeds
4. **Client** accepts or negotiates price

#### Trade Execution
```bash
# Example: Client selling 1000 bonds to JINBI desk
COMPLIANT_SECURITY_TOKEN=0x... \
PARTITION_144A=$(cast keccak "/144A") \
CLIENT_ADDRESS=0x8B8e8F6aC1aC1FFc0f29f2f1742C9B63B5c59DC2 \
JINBI_DESK=0x742C9B63B5c59DC28b5e8F6aC1aC1FFc0f29f2f1 \
AMOUNT=1000000000000000000000 \

# Client initiates transfer to JINBI desk
cast send $COMPLIANT_SECURITY_TOKEN "transferByPartition(bytes32,address,uint256)" \
  $PARTITION_144A $JINBI_DESK $AMOUNT \
  --from $CLIENT_ADDRESS --private-key $CLIENT_KEY --rpc-url $RPC_URL

# JINBI desk settles in USDC (off-chain coordination)
```

### 3. Settlement Coordination
- **T+0 Settlement**: Atomic token transfer + USDC payment
- **Trade Confirmation**: Both parties confirm via secure channels
- **Reporting**: Trade details logged for regulatory compliance

## Risk Management

### Position Limits
```solidity
// Example position limit enforcement
contract JinbiDeskRiskManager {
    mapping(bytes32 => uint256) public maxPosition; // per ISIN
    mapping(bytes32 => uint256) public currentPosition;
    
    modifier withinLimits(bytes32 isin, uint256 amount) {
        require(currentPosition[isin] + amount <= maxPosition[isin], "POSITION_LIMIT");
        _;
    }
}
```

### Real-time Monitoring
- **Concentration Risk**: Monitor exposure by partition and client
- **Market Risk**: Delta hedging against XAU/USD movements
- **Liquidity Risk**: Maintain USDC reserves for client liquidity
- **Compliance Risk**: Continuous KYC/AML monitoring

## Regulatory Compliance

### Trade Reporting
```bash
# Generate trade report for regulators
TRADE_ID="TXN-$(date +%Y%m%d)-001" \
CLIENT_ID="CLIENT-12345" \
AMOUNT=1000000000000000000000 \
PRICE=1000000 \
PARTITION="144A" \
forge script scripts/ops/report_trade.s.sol --rpc-url $RPC_URL
```

### Audit Trail
- All trades recorded on-chain via `TransferByPartition` events
- Off-chain trade details stored with immutable timestamps
- Price basis documented with Chainlink proof of price
- Client compliance status archived at trade time

## Market Making Strategies

### 1. Two-Way Quotes
```json
{
  "isin": "US87225HAB42",
  "partition": "144A",
  "bid": {
    "price": 999000,
    "size": 5000000000000000000000,
    "valid_until": "2024-12-31T15:30:00Z"
  },
  "ask": {
    "price": 1001000,
    "size": 5000000000000000000000,
    "valid_until": "2024-12-31T15:30:00Z"
  }
}
```

### 2. Block Trading
- Minimum block size: 1000 bonds ($1M+)
- Custom pricing for large orders
- Settlement coordination with institutional clients
- Reduced bid-ask spreads for volume

### 3. Liquidity Provision
- Maintain inventory across both partitions (144A/RegS)
- Provide client liquidity during volatile markets
- Cross-partition arbitrage opportunities
- Inventory management with underlying gold exposure

## Technology Integration

### API Endpoints
```bash
# JINBI desk API integration
curl -X GET "https://api.jinbi.com/v1/quote" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "isin": "US87225HAB42",
    "partition": "144A",
    "side": "buy",
    "amount": "1000000000000000000000"
  }'
```

### Smart Contract Interfaces
```solidity
interface IJinbiDesk {
    function requestQuote(
        bytes32 partition,
        uint256 amount,
        bool isBuy
    ) external view returns (uint256 price, uint256 validUntil);
    
    function executeTradeWithClient(
        address client,
        bytes32 partition,
        uint256 amount,
        uint256 agreedPrice
    ) external;
}
```

### Chainlink Integration
- **Price Feeds**: Real-time XAU/USD and USDC/USD
- **Proof of Reserve**: Custodian attestations via Chainlink Functions
- **Market Data**: Volume and volatility feeds for pricing models

## Client Onboarding

### Institutional Clients
1. **KYC/AML**: Enhanced due diligence for institutions
2. **Compliance Verification**: QIB status for 144A, non-US for RegS
3. **Wallet Setup**: Institutional custody integration (Fireblocks, BitGo)
4. **Trading Agreement**: Legal framework for OTC trading
5. **Technical Integration**: API access and settlement procedures

### Minimum Requirements
- **144A Clients**: QIB status, $100M+ AUM
- **RegS Clients**: Non-U.S. institutional status
- **Technology**: Institutional-grade wallet infrastructure
- **Legal**: Executed ISDA/derivatives agreement if applicable

## Fee Structure

### Trading Fees
- **144A Partition**: 0.10% per side (20bps round-trip)
- **RegS Partition**: 0.15% per side (30bps round-trip)
- **Block Trades**: Negotiated fees for >$10M
- **Market Making**: Reduced fees for two-way quotes

### Settlement Fees
- **USDC Transfer**: Gas costs + network fees
- **Compliance Verification**: $50 per trade
- **Reporting**: Included in trading fees

## Operational Procedures

### Daily Operations
1. **Market Open**: Update price feeds and inventory
2. **Quote Management**: Maintain competitive two-way markets
3. **Risk Monitoring**: Track positions and P&L
4. **Client Service**: Respond to RFQs within 30 seconds
5. **Market Close**: Reconcile trades and update positions

### Month-End
1. **Position Reporting**: Regulatory position reports
2. **Client Statements**: Monthly transaction summaries
3. **Compliance Review**: KYC refresh and sanctions screening
4. **Risk Assessment**: VaR and stress testing

This integration framework enables institutional clients to trade JINBI bonds efficiently while maintaining full regulatory compliance and audit trails.
