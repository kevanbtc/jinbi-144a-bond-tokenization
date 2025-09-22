// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/AttestationRegistry.sol";
import "../src/ComplianceRegistry.sol";
import "../src/ComplianceOracle.sol";
import "../src/VaultProofNFT.sol";
import "../src/CompliantSecurityToken.sol";
import "../src/CorporateActions.sol";
import "../src/DvPSettlement.sol";
import "../src/ChainlinkPriceRouter.sol";
import "../src/ChainlinkProofAdapter.sol";
import "../src/TransferAgentBridge.sol";

/**
 * @title Deploy
 * @dev Main deployment script for JINBI 144A/Reg S tokenization system
 *
 * Deploy order:
 * 1) AttestationRegistry
 * 2) ComplianceRegistry
 * 3) ComplianceOracle(registry)
 * 4) VaultProofNFT (mint vault NFT with ISIN/CUSIP doc CID + custodian)
 * 5) CompliantSecurityToken (pass both 144A/RegS identifiers)
 * 6) CorporateActions(USDC, token)
 * 7) DvPSettlement(USDC, token)
 * 8) ChainlinkPriceRouter (set XAU/USD and USDC/USD feeds)
 * 9) ChainlinkProofAdapter (wire to Chainlink node off-chain)
 * 10) TransferAgentBridge(attestation)
 */
contract Deploy is Script {
    // USDC addresses for different networks
    address constant USDC_MAINNET = 0xA0b86a33E6417c1F2c3c3F6C5fC7e4b9d4Cb9F2E;
    address constant USDC_POLYGON = 0x2791Bca1F2de4661ED88A30C99A7a9449Aa84174;
    address constant USDC_BASE = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913;
    address constant USDC_SEPOLIA = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238; // test USDC

    // Chainlink feed addresses (mainnet)
    address constant XAU_USD_FEED = 0x214eD9Da11D2fbe465a6fc601a91E62EbEc1a0D6;
    address constant USDC_USD_FEED = 0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        console.log("Deploying JINBI contracts with deployer:", deployer);
        console.log("Deployer balance:", deployer.balance);

        // 1. Deploy AttestationRegistry
        AttestationRegistry attestationRegistry = new AttestationRegistry();
        console.log("AttestationRegistry deployed at:", address(attestationRegistry));

        // 2. Deploy ComplianceRegistry
        ComplianceRegistry complianceRegistry = new ComplianceRegistry();
        console.log("ComplianceRegistry deployed at:", address(complianceRegistry));

        // 3. Deploy ComplianceOracle
        ComplianceOracle complianceOracle = new ComplianceOracle(address(complianceRegistry));
        console.log("ComplianceOracle deployed at:", address(complianceOracle));

        // 4. Deploy VaultProofNFT
        VaultProofNFT vaultProofNFT = new VaultProofNFT();
        console.log("VaultProofNFT deployed at:", address(vaultProofNFT));

        // 5. Deploy CompliantSecurityToken
        CompliantSecurityToken securityToken = new CompliantSecurityToken(
            "JINBI Gold Bond 144A/RegS",
            "JINBI",
            address(complianceOracle),
            "US87225HAB42", // 144A ISIN
            "87225H AB4",   // 144A CUSIP
            "BSP9000TAA83", // Reg S ISIN
            "P9000T AA8"    // Reg S CUSIP
        );
        console.log("CompliantSecurityToken deployed at:", address(securityToken));

        // Get USDC address for current network
        address usdcAddress = getUSDCAddress();
        console.log("Using USDC at:", usdcAddress);

        // 6. Deploy CorporateActions
        CorporateActions corporateActions = new CorporateActions(usdcAddress, address(securityToken));
        console.log("CorporateActions deployed at:", address(corporateActions));

        // 7. Deploy DvPSettlement
        DvPSettlement dvpSettlement = new DvPSettlement(usdcAddress, address(securityToken));
        console.log("DvPSettlement deployed at:", address(dvpSettlement));

        // 8. Deploy ChainlinkPriceRouter
        ChainlinkPriceRouter priceRouter = new ChainlinkPriceRouter();
        console.log("ChainlinkPriceRouter deployed at:", address(priceRouter));

        // 9. Deploy ChainlinkProofAdapter
        ChainlinkProofAdapter proofAdapter = new ChainlinkProofAdapter();
        console.log("ChainlinkProofAdapter deployed at:", address(proofAdapter));

        // 10. Deploy TransferAgentBridge
        TransferAgentBridge taBridge = new TransferAgentBridge(address(attestationRegistry));
        console.log("TransferAgentBridge deployed at:", address(taBridge));

        // Set up price feeds (if on mainnet)
        if (block.chainid == 1) {
            priceRouter.setFeed(keccak256("XAU/USD"), XAU_USD_FEED);
            priceRouter.setFeed(keccak256("USDC/USD"), USDC_USD_FEED);
            console.log("Price feeds configured for mainnet");
        }

        // Grant admin roles to DvPSettlement for minting tokens
        securityToken.setAdmin(address(dvpSettlement), true);
        console.log("Granted admin role to DvPSettlement for token minting");

        vm.stopBroadcast();

        // Output deployment addresses for verification
        console.log("\n=== DEPLOYMENT SUMMARY ===");
        console.log("AttestationRegistry:", address(attestationRegistry));
        console.log("ComplianceRegistry:", address(complianceRegistry));
        console.log("ComplianceOracle:", address(complianceOracle));
        console.log("VaultProofNFT:", address(vaultProofNFT));
        console.log("CompliantSecurityToken:", address(securityToken));
        console.log("CorporateActions:", address(corporateActions));
        console.log("DvPSettlement:", address(dvpSettlement));
        console.log("ChainlinkPriceRouter:", address(priceRouter));
        console.log("ChainlinkProofAdapter:", address(proofAdapter));
        console.log("TransferAgentBridge:", address(taBridge));
    }

    function getUSDCAddress() internal view returns (address) {
        if (block.chainid == 1) return USDC_MAINNET;      // Ethereum mainnet
        if (block.chainid == 137) return USDC_POLYGON;    // Polygon
        if (block.chainid == 8453) return USDC_BASE;      // Base
        if (block.chainid == 11155111) return USDC_SEPOLIA; // Sepolia testnet

        // Default to mainnet USDC for unknown networks
        return USDC_MAINNET;
    }
}