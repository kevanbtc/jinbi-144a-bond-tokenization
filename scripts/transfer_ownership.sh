# Safe Multisig Ownership Transfer Script

# This script demonstrates how to transfer ownership of all contracts
# to a Gnosis Safe multisig wallet for production deployment

#!/bin/bash

# Configuration
POLYGON_RPC_URL="https://polygon-rpc.com"
SAFE_ADDRESS="0x..."  # Replace with actual Safe address
DEPLOYER_PRIVATE_KEY="0x..."  # Replace with deployer key

# Contract addresses (replace with actual deployed addresses)
TOKEN_ADDRESS="0x..."
COMPLIANCE_REGISTRY_ADDRESS="0x..."
COMPLIANCE_ORACLE_ADDRESS="0x..."
CORPORATE_ACTIONS_ADDRESS="0x..."
DVP_SETTLEMENT_ADDRESS="0x..."
VAULT_PROOF_ADDRESS="0x..."

echo "🔐 Transferring ownership to Safe multisig: $SAFE_ADDRESS"

# Transfer CompliantSecurityToken ownership
echo "📋 Transferring CompliantSecurityToken ownership..."
cast send $TOKEN_ADDRESS \
  --rpc-url $POLYGON_RPC_URL \
  --private-key $DEPLOYER_PRIVATE_KEY \
  "transferOwnership(address)" $SAFE_ADDRESS

# Transfer ComplianceRegistry ownership
echo "📋 Transferring ComplianceRegistry ownership..."
cast send $COMPLIANCE_REGISTRY_ADDRESS \
  --rpc-url $POLYGON_RPC_URL \
  --private-key $DEPLOYER_PRIVATE_KEY \
  "transferOwnership(address)" $SAFE_ADDRESS

# Transfer ComplianceOracle ownership (inherits from Roles)
echo "📋 Transferring ComplianceOracle ownership..."
cast send $COMPLIANCE_ORACLE_ADDRESS \
  --rpc-url $POLYGON_RPC_URL \
  --private-key $DEPLOYER_PRIVATE_KEY \
  "transferOwnership(address)" $SAFE_ADDRESS

# Transfer CorporateActions ownership (inherits from Roles)
echo "📋 Transferring CorporateActions ownership..."
cast send $CORPORATE_ACTIONS_ADDRESS \
  --rpc-url $POLYGON_RPC_URL \
  --private-key $DEPLOYER_PRIVATE_KEY \
  "transferOwnership(address)" $SAFE_ADDRESS

# Transfer DvPSettlement ownership (inherits from Roles)
echo "📋 Transferring DvPSettlement ownership..."
cast send $DVP_SETTLEMENT_ADDRESS \
  --rpc-url $POLYGON_RPC_URL \
  --private-key $DEPLOYER_PRIVATE_KEY \
  "transferOwnership(address)" $SAFE_ADDRESS

# Transfer VaultProofNFT ownership (Ownable)
echo "📋 Transferring VaultProofNFT ownership..."
cast send $VAULT_PROOF_ADDRESS \
  --rpc-url $POLYGON_RPC_URL \
  --private-key $DEPLOYER_PRIVATE_KEY \
  "transferOwnership(address)" $SAFE_ADDRESS

echo "✅ Ownership transfer complete!"
echo "🔍 Verifying ownership transfers..."

# Verification calls
echo "CompliantSecurityToken owner: $(cast call $TOKEN_ADDRESS 'owner()(address)' --rpc-url $POLYGON_RPC_URL)"
echo "ComplianceRegistry owner: $(cast call $COMPLIANCE_REGISTRY_ADDRESS 'owner()(address)' --rpc-url $POLYGON_RPC_URL)"
echo "ComplianceOracle owner: $(cast call $COMPLIANCE_ORACLE_ADDRESS 'owner()(address)' --rpc-url $POLYGON_RPC_URL)"
echo "CorporateActions owner: $(cast call $CORPORATE_ACTIONS_ADDRESS 'owner()(address)' --rpc-url $POLYGON_RPC_URL)"
echo "DvPSettlement owner: $(cast call $DVP_SETTLEMENT_ADDRESS 'owner()(address)' --rpc-url $POLYGON_RPC_URL)"
echo "VaultProofNFT owner: $(cast call $VAULT_PROOF_ADDRESS 'owner()(address)' --rpc-url $POLYGON_RPC_URL)"

echo "🎉 All ownership transferred to Safe multisig successfully!"