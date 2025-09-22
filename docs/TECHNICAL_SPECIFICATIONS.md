# JINBI Technical Specifications

## 🏗️ **System Architecture**

### Core Components
```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│  Compliance     │────│  Security Token  │────│  Settlement     │
│  Oracle         │    │  (ERC-20)        │    │  (DvP)          │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                        │                        │
         ▼                        ▼                        ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│  KYC Registry   │    │  Corporate       │    │  Price Router   │
│  (Flags)        │    │  Actions         │    │  (Chainlink)    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### Data Flow
1. **Investor Onboarding** → Compliance Registry → Oracle Validation
2. **Primary Issuance** → DvP Settlement → Token Minting → Partition Assignment
3. **Secondary Trading** → Compliance Check → Transfer Execution → Audit Trail
4. **Corporate Actions** → Coupon Distribution → USDC Payment → Record Keeping

---

## 🔧 **Smart Contract Specifications**

### CompliantSecurityToken (Main Token)
```solidity
// Core Token Details
Name: "JINBI Gold Bond 144A/RegS"
Symbol: "JINBI"
Decimals: 18
Standard: ERC-20 + ERC-20Permit + Pausable

// Partition Structure
bytes32 public constant P144A = keccak256("/144A");   // QIB partition
bytes32 public constant PREGS = keccak256("/RegS");   // Non-US partition

// Key Mappings
mapping(address => mapping(bytes32 => uint256)) public balanceOfPartition;
mapping(bytes32 => uint256) public totalSupplyPartition;

// Compliance Integration
ComplianceOracle public oracle;
```

### Compliance System
```solidity
// ComplianceRegistry Flags
struct Flags {
    bool kyc;            // KYC/AML passed
    bool qib;            // Qualified Institutional Buyer
    bool nonUS;          // Non-U.S. person (Reg S)
    bool pepClear;       // Politically Exposed Person cleared
    bool sanctionsClear; // OFAC/FATF sanctions clear
}

// Transfer Validation Logic
function canTransfer(address from, address to, bytes32 partition)
    returns (bool ok, string memory reason)
```

### DvP Settlement Engine
```solidity
// Allocation Structure
struct Allocation {
    bytes32 partition;   // 144A or RegS
    address investor;    // Buyer address
    uint256 amount;      // Bond quantity
    uint256 price;       // USDC price per bond
    bool settled;        // Settlement status
}

// Settlement Process
1. bookAllocation() - Admin books allocation
2. settle() - Investor executes DvP
3. USDC transferred + Tokens minted
```

---

## 🔐 **Security Architecture**

### Access Control
```solidity
// Role Hierarchy
Owner (Deployer)
├── Admin (Multiple addresses)
│   ├── Mint permissions
│   ├── Compliance updates
│   └── Price feed management
├── Transfer Agent
│   ├── Force transfer authority
│   ├── Emergency powers
│   └── Court order execution
└── Compliance Signer
    ├── KYC flag updates
    ├── Sanctions screening
    └── Lockup management
```

### Emergency Controls
- **Pause Mechanism**: Global transfer halt
- **Force Transfer**: Transfer agent override
- **Compliance Override**: Emergency investor blocking
- **Oracle Updates**: Price feed emergency stops

### Audit Trail
```solidity
// Key Events
event TransferByPartition(bytes32 partition, address from, address to, uint256 value, bytes data);
event FlagsSet(address who, Flags flags);
event CouponPaid(uint256 cycleId, uint256 totalPaid);
event Settled(uint256 allocationId);
```

---

## 🌐 **Network Configuration**

### Polygon Mainnet
- **Chain ID**: 137
- **Block Time**: ~2 seconds
- **Finality**: ~10 seconds
- **Gas Token**: MATIC
- **RPC Endpoints**:
  - https://polygon-rpc.com
  - https://rpc-mainnet.matic.network

### Gas Optimization
- **Via IR Compilation**: Reduced bytecode size
- **Optimizer Runs**: 200
- **Typical Gas Costs**:
  - Token Transfer: ~65,000 gas (~$0.01)
  - DvP Settlement: ~150,000 gas (~$0.02)
  - Compliance Update: ~45,000 gas (~$0.006)

---

## 📊 **Data Standards**

### Token Metadata
```json
{
  "name": "JINBI Gold Bond 144A/RegS",
  "symbol": "JINBI",
  "decimals": 18,
  "partitions": ["/144A", "/RegS"],
  "identifiers": {
    "144A": {
      "isin": "US87225HAB42",
      "cusip": "87225H AB4"
    },
    "RegS": {
      "isin": "BSP9000TAA83",
      "cusip": "P9000T AA8"
    }
  }
}
```

### IPFS Document Structure
```json
{
  "docType": "INDENTURE_AGREEMENT",
  "version": "1.0",
  "cid": "QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG",
  "timestamp": "2024-09-21T15:42:00Z",
  "hash": "0x...",
  "signatures": ["0x..."]
}
```

---

## 🔗 **Integration Interfaces**

### Price Feed Integration
```solidity
// Chainlink Aggregator Interface
interface IAggregatorV3 {
    function latestRoundData() external view returns (
        uint80 roundId,
        int256 price,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    );
}

// Configured Feeds
XAU/USD: 0x0C466540B2ee1a31b441671eac0ca886e051E410
USDC/USD: 0xfE4A8cc5b5B2366C1B58Bea3858e81843581b2F7
MATIC/USD: 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0
```

### USDC Integration
```solidity
// Standard ERC-20 Interface
IERC20 usdc = IERC20(0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174);

// Settlement Flow
1. usdc.approve(dvpContract, amount)
2. dvpSettlement.settle(allocationId)
3. USDC transferred + Tokens minted
```

### Transfer Agent Bridge
```solidity
// DTC Cap Table Integration
function recordCapTable(
    string calldata period,
    string calldata cid,
    bytes32 key
) external onlyAdmin

// Event Emission
event DTCCapTableHash(string period, string cid, bytes32 key);
```

---

## 📱 **Frontend Integration**

### Web3 Connection
```javascript
// Wagmi/Viem Configuration
import { polygon } from 'wagmi/chains'
import { createConfig, http } from 'wagmi'

const config = createConfig({
  chains: [polygon],
  transports: {
    [polygon.id]: http('https://polygon-rpc.com')
  }
})

// Contract Integration
const jinbiContract = {
  address: '0xA715acA24f83b08B786911c4d2fB194132D138D2',
  abi: JinbiABI,
  chainId: 137
}
```

### Key Functions
```javascript
// Read Functions
- balanceOfPartition(address, partition)
- totalSupply()
- canTransfer(from, to, partition)

// Write Functions
- transferByPartition(partition, to, amount)
- approve(spender, amount)
- settle(allocationId)
```

---

## 🔍 **Monitoring & Analytics**

### Event Monitoring
```javascript
// Transfer Tracking
contract.on('TransferByPartition', (partition, from, to, value, data) => {
  // Process partition transfer
});

// Compliance Monitoring
contract.on('FlagsSet', (who, flags) => {
  // Update investor status
});

// Corporate Actions
contract.on('CouponPaid', (cycleId, totalPaid) => {
  // Process coupon distribution
});
```

### Performance Metrics
- **Total Value Locked (TVL)**: Real-time USDC equivalent
- **Active Investors**: Unique token holders
- **Transaction Volume**: Daily/monthly volumes
- **Compliance Rate**: Successful vs rejected transfers
- **Price Performance**: Bond vs underlying gold price

---

## 🧪 **Testing Framework**

### Unit Tests
```bash
# Run contract tests
forge test

# Gas reporting
forge test --gas-report

# Coverage analysis
forge coverage
```

### Integration Tests
```javascript
// DvP Settlement Test
describe('DvP Settlement', () => {
  it('should complete USDC/Token exchange', async () => {
    // 1. Book allocation
    // 2. Approve USDC
    // 3. Execute settlement
    // 4. Verify token balance
  })
})
```

### Load Testing
- **Concurrent Transfers**: 100+ simultaneous
- **Gas Limit Testing**: Maximum transaction size
- **Oracle Failure Simulation**: Failover testing
- **Network Congestion**: High gas price scenarios

---

## 📈 **Scalability Considerations**

### Current Limitations
- **Ethereum L1**: Not suitable for high-frequency trading
- **Gas Costs**: Fixed per-transaction overhead
- **Oracle Latency**: 1-2 second price updates
- **Compliance Delays**: Manual KYC verification

### Future Enhancements
- **Layer 2 Scaling**: Arbitrum/Optimism deployment
- **Batch Processing**: Multiple transfers per transaction
- **Automated Compliance**: AI-powered KYC/AML
- **Cross-chain Bridges**: Multi-network support

---

## 🛠️ **Development Tools**

### Required Software
```bash
# Foundry Framework
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Node.js Dependencies
npm install @openzeppelin/contracts
npm install @chainlink/contracts

# Development Environment
git clone <repository>
cd jinbi-144a-bond-tokenization
cp .env.example .env
forge install
```

### Deployment Commands
```bash
# Compile contracts
forge build

# Deploy to Polygon
forge script contracts/script/DeployPolygon.s.sol \
  --rpc-url $POLYGON_RPC_URL \
  --broadcast \
  --verify

# Verify contracts
forge verify-contract <address> <contract> --chain polygon
```

This technical specification provides the complete implementation details for the JINBI institutional bond tokenization system.