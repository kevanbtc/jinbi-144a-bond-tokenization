// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.24;

i          CompliantSecurityToken securityToken = new CompliantSecurityToken(
            "International Agency $5B Series B 144A Bond",
            "INTL-5B-BOND",
            address(complianceOracle),
            "US87225HAB42", // 144A ISIN
            "87255H AB4",   // 144A CUSIP
            "BSP9000TAA83", // Reg S ISINforge-std/Script.sol";
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
 * @title DeployPolygon
 * @dev Polygon-optimized deployment script for International Agency $5B Series B bond tokenization system
 */
contract DeployPolygon is Script {
    // Polygon USDC (native USDC.e)
    address constant USDC_POLYGON = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;

    // Polygon Chainlink feeds
    address constant XAU_USD_FEED_POLYGON = 0x0C466540B2ee1a31b441671eac0ca886e051E410;
    address constant USDC_USD_FEED_POLYGON = 0xfE4A8cc5b5B2366C1B58Bea3858e81843581b2F7;
    address constant MATIC_USD_FEED_POLYGON = 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("=== INTERNATIONAL AGENCY $5B BOND POLYGON DEPLOYMENT ===");
        console.log("Chain ID:", block.chainid);
        console.log("Deployer:", deployer);
        console.log("Deployer MATIC balance:", deployer.balance / 1e18, "MATIC");

        require(block.chainid == 137, "MUST_BE_POLYGON_MAINNET");
        require(deployer.balance >= 10 ether, "INSUFFICIENT_MATIC_FOR_DEPLOYMENT");

        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy AttestationRegistry
        console.log("\n1. Deploying AttestationRegistry...");
        AttestationRegistry attestationRegistry = new AttestationRegistry();
        console.log("[OK] AttestationRegistry:", address(attestationRegistry));

        // 2. Deploy ComplianceRegistry
        console.log("\n2. Deploying ComplianceRegistry...");
        ComplianceRegistry complianceRegistry = new ComplianceRegistry();
        console.log("[OK] ComplianceRegistry:", address(complianceRegistry));

        // 3. Deploy ComplianceOracle
        console.log("\n3. Deploying ComplianceOracle...");
        ComplianceOracle complianceOracle = new ComplianceOracle(address(complianceRegistry));
        console.log("[OK] ComplianceOracle:", address(complianceOracle));

        // 4. Deploy VaultProofNFT
        console.log("\n4. Deploying VaultProofNFT...");
        VaultProofNFT vaultProofNFT = new VaultProofNFT();
        console.log("[OK] VaultProofNFT:", address(vaultProofNFT));

        // 5. Deploy CompliantSecurityToken
        console.log("\n5. Deploying CompliantSecurityToken...");
        CompliantSecurityToken securityToken = new CompliantSecurityToken(
            "JINBI Gold Bond 144A/RegS",
            "JINBI",
            address(complianceOracle),
            "US87225HAB42", // 144A ISIN
            "87225H AB4",   // 144A CUSIP
            "BSP9000TAA83", // Reg S ISIN
            "P9000T AA8"    // Reg S CUSIP
        );
        console.log("[OK] CompliantSecurityToken:", address(securityToken));

        // 6. Deploy CorporateActions
        console.log("\n6. Deploying CorporateActions...");
        CorporateActions corporateActions = new CorporateActions(USDC_POLYGON, address(securityToken));
        console.log("[OK] CorporateActions:", address(corporateActions));

        // 7. Deploy DvPSettlement
        console.log("\n7. Deploying DvPSettlement...");
        DvPSettlement dvpSettlement = new DvPSettlement(USDC_POLYGON, address(securityToken));
        console.log("[OK] DvPSettlement:", address(dvpSettlement));

        // 8. Deploy ChainlinkPriceRouter
        console.log("\n8. Deploying ChainlinkPriceRouter...");
        ChainlinkPriceRouter priceRouter = new ChainlinkPriceRouter();
        console.log("[OK] ChainlinkPriceRouter:", address(priceRouter));

        // 9. Deploy ChainlinkProofAdapter
        console.log("\n9. Deploying ChainlinkProofAdapter...");
        ChainlinkProofAdapter proofAdapter = new ChainlinkProofAdapter();
        console.log("[OK] ChainlinkProofAdapter:", address(proofAdapter));

        // 10. Deploy TransferAgentBridge
        console.log("\n10. Deploying TransferAgentBridge...");
        TransferAgentBridge taBridge = new TransferAgentBridge(address(attestationRegistry));
        console.log("[OK] TransferAgentBridge:", address(taBridge));

        // Configure Polygon price feeds
        console.log("\n=== CONFIGURING POLYGON PRICE FEEDS ===");
        priceRouter.setFeed(keccak256("XAU/USD"), XAU_USD_FEED_POLYGON);
        priceRouter.setFeed(keccak256("USDC/USD"), USDC_USD_FEED_POLYGON);
        priceRouter.setFeed(keccak256("MATIC/USD"), MATIC_USD_FEED_POLYGON);
        console.log("[OK] Configured XAU/USD feed:", XAU_USD_FEED_POLYGON);
        console.log("[OK] Configured USDC/USD feed:", USDC_USD_FEED_POLYGON);
        console.log("[OK] Configured MATIC/USD feed:", MATIC_USD_FEED_POLYGON);

        // Grant admin roles
        console.log("\n=== SETTING UP PERMISSIONS ===");
        securityToken.setAdmin(address(dvpSettlement), true);
        securityToken.setAdmin(address(corporateActions), true);
        console.log("[OK] Granted admin role to DvPSettlement");
        console.log("[OK] Granted admin role to CorporateActions");

        vm.stopBroadcast();

        // Output deployment summary
        console.log("\n=== POLYGON DEPLOYMENT COMPLETE ===");
        console.log("Network: Polygon Mainnet (Chain ID: 137)");
        console.log("USDC Address:", USDC_POLYGON);
        console.log("Deployer balance after: ", deployer.balance / 1e18, "MATIC");

        console.log("\n=== CONTRACT ADDRESSES ===");
        console.log("AttestationRegistry   :", address(attestationRegistry));
        console.log("ComplianceRegistry    :", address(complianceRegistry));
        console.log("ComplianceOracle      :", address(complianceOracle));
        console.log("VaultProofNFT         :", address(vaultProofNFT));
        console.log("CompliantSecurityToken:", address(securityToken));
        console.log("CorporateActions      :", address(corporateActions));
        console.log("DvPSettlement         :", address(dvpSettlement));
        console.log("ChainlinkPriceRouter  :", address(priceRouter));
        console.log("ChainlinkProofAdapter :", address(proofAdapter));
        console.log("TransferAgentBridge   :", address(taBridge));

        console.log("\n=== NEXT STEPS ===");
        console.log("1. Verify contracts on Polygonscan");
        console.log("2. Set up compliance flags for investors");
        console.log("3. Upload legal documents to IPFS");
        console.log("4. Test primary allocation system");
        console.log("5. Configure OTC market integration");

        // Contract addresses logged above for manual .env.deployed creation
        console.log("\n[OK] All contracts deployed successfully!");
    }
}