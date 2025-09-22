const fs = require('fs');
const path = require('path');
const axios = require('axios');
const FormData = require('form-data');

// Load environment variables
require('dotenv').config();

const PINATA_API_KEY = process.env.PINATA_API_KEY;
const PINATA_SECRET_KEY = process.env.PINATA_SECRET_KEY;

if (!PINATA_API_KEY || !PINATA_SECRET_KEY) {
    console.error('❌ Missing Pinata credentials in .env file');
    process.exit(1);
}

async function uploadToPinata(filePath, fileName, description) {
    try {
        const formData = new FormData();
        formData.append('file', fs.createReadStream(filePath));

        const metadata = JSON.stringify({
            name: fileName,
            keyvalues: {
                description: description,
                project: 'JINBI-Bond-Tokenization',
                version: '1.0',
                network: 'Polygon',
                timestamp: new Date().toISOString()
            }
        });
        formData.append('pinataMetadata', metadata);

        const options = JSON.stringify({
            cidVersion: 0,
        });
        formData.append('pinataOptions', options);

        const response = await axios.post('https://api.pinata.cloud/pinning/pinFileToIPFS', formData, {
            maxBodyLength: 'Infinity',
            headers: {
                'Content-Type': `multipart/form-data; boundary=${formData._boundary}`,
                pinata_api_key: PINATA_API_KEY,
                pinata_secret_api_key: PINATA_SECRET_KEY,
            },
        });

        return {
            success: true,
            ipfsHash: response.data.IpfsHash,
            pinSize: response.data.PinSize,
            timestamp: response.data.Timestamp
        };
    } catch (error) {
        console.error(`❌ Failed to upload ${fileName}:`, error.response?.data || error.message);
        return { success: false, error: error.message };
    }
}

async function uploadJSONToPinata(jsonData, fileName, description) {
    try {
        const response = await axios.post('https://api.pinata.cloud/pinning/pinJSONToIPFS', {
            pinataContent: jsonData,
            pinataMetadata: {
                name: fileName,
                keyvalues: {
                    description: description,
                    project: 'JINBI-Bond-Tokenization',
                    version: '1.0',
                    network: 'Polygon',
                    timestamp: new Date().toISOString()
                }
            },
            pinataOptions: {
                cidVersion: 0
            }
        }, {
            headers: {
                'Content-Type': 'application/json',
                pinata_api_key: PINATA_API_KEY,
                pinata_secret_api_key: PINATA_SECRET_KEY,
            },
        });

        return {
            success: true,
            ipfsHash: response.data.IpfsHash,
            pinSize: response.data.PinSize,
            timestamp: response.data.Timestamp
        };
    } catch (error) {
        console.error(`❌ Failed to upload ${fileName}:`, error.response?.data || error.message);
        return { success: false, error: error.message };
    }
}

async function main() {
    console.log('🚀 Starting JINBI Documentation Upload to IPFS via Pinata...\n');

    const results = [];

    // 1. Upload Contract Registry
    console.log('📋 Uploading Contract Registry...');
    const contractRegistry = await uploadToPinata(
        'docs/CONTRACT_REGISTRY.md',
        'JINBI-Contract-Registry.md',
        'Complete registry of all JINBI smart contracts deployed on Polygon mainnet'
    );
    if (contractRegistry.success) {
        console.log(`✅ Contract Registry: https://ipfs.io/ipfs/${contractRegistry.ipfsHash}`);
        results.push({ type: 'Contract Registry', cid: contractRegistry.ipfsHash });
    }

    // 2. Upload Investor Onboarding Guide
    console.log('\n📖 Uploading Investor Onboarding Guide...');
    const onboardingGuide = await uploadToPinata(
        'docs/INVESTOR_ONBOARDING.md',
        'JINBI-Investor-Onboarding.md',
        'Comprehensive investor onboarding guide for JINBI 144A/Reg S bonds'
    );
    if (onboardingGuide.success) {
        console.log(`✅ Onboarding Guide: https://ipfs.io/ipfs/${onboardingGuide.ipfsHash}`);
        results.push({ type: 'Investor Onboarding', cid: onboardingGuide.ipfsHash });
    }

    // 3. Upload Technical Specifications
    console.log('\n🔧 Uploading Technical Specifications...');
    const techSpecs = await uploadToPinata(
        'docs/TECHNICAL_SPECIFICATIONS.md',
        'JINBI-Technical-Specifications.md',
        'Detailed technical specifications for JINBI smart contract system'
    );
    if (techSpecs.success) {
        console.log(`✅ Technical Specs: https://ipfs.io/ipfs/${techSpecs.ipfsHash}`);
        results.push({ type: 'Technical Specifications', cid: techSpecs.ipfsHash });
    }

    // 4. Upload Legal Checklist
    console.log('\n⚖️ Uploading Legal Checklist...');
    const legalChecklist = await uploadToPinata(
        'docs/LEGAL_CHECKLIST.md',
        'JINBI-Legal-Checklist.md',
        'Legal compliance checklist for JINBI bond tokenization'
    );
    if (legalChecklist.success) {
        console.log(`✅ Legal Checklist: https://ipfs.io/ipfs/${legalChecklist.ipfsHash}`);
        results.push({ type: 'Legal Checklist', cid: legalChecklist.ipfsHash });
    }

    // 5. Upload Operations Runbook
    console.log('\n📊 Uploading Operations Runbook...');
    const opsRunbook = await uploadToPinata(
        'docs/OPERATIONS_RUNBOOK.md',
        'JINBI-Operations-Runbook.md',
        'Daily operations and management procedures for JINBI system'
    );
    if (opsRunbook.success) {
        console.log(`✅ Operations Runbook: https://ipfs.io/ipfs/${opsRunbook.ipfsHash}`);
        results.push({ type: 'Operations Runbook', cid: opsRunbook.ipfsHash });
    }

    // 6. Create and upload Contract Metadata JSON
    console.log('\n📄 Creating Contract Metadata...');
    const contractMetadata = {
        name: "JINBI Gold Bond 144A/RegS",
        symbol: "JINBI",
        description: "Institutional-grade tokenized gold bond with 144A and Regulation S compliance",
        image: "https://ipfs.io/ipfs/QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG",
        external_url: "https://jinbi.com",
        seller_fee_basis_points: 50,
        fee_recipient: "0x9Dc918deBA2d3fc7128A59852b6699CCb2dC0EDB",
        attributes: [
            { trait_type: "Asset Class", value: "Fixed Income" },
            { trait_type: "Underlying", value: "Gold MTN" },
            { trait_type: "Coupon Rate", value: "5% Annual" },
            { trait_type: "Maturity", value: "2030" },
            { trait_type: "Currency", value: "USDC" },
            { trait_type: "Network", value: "Polygon" },
            { trait_type: "Compliance", value: "144A/Reg S" }
        ],
        properties: {
            category: "Security Token",
            partitions: ["/144A", "/RegS"],
            identifiers: {
                "144A_ISIN": "US87225HAB42",
                "144A_CUSIP": "87225H AB4",
                "RegS_ISIN": "BSP9000TAA83",
                "RegS_CUSIP": "P9000T AA8"
            },
            contracts: {
                token: "0xA715acA24f83b08B786911c4d2fB194132D138D2",
                settlement: "0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D",
                oracle: "0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3"
            }
        }
    };

    const metadataUpload = await uploadJSONToPinata(
        contractMetadata,
        'JINBI-Contract-Metadata.json',
        'ERC-20 and NFT compatible metadata for JINBI security token'
    );
    if (metadataUpload.success) {
        console.log(`✅ Contract Metadata: https://ipfs.io/ipfs/${metadataUpload.ipfsHash}`);
        results.push({ type: 'Contract Metadata', cid: metadataUpload.ipfsHash });
    }

    // 7. Create and upload Deployment Summary
    console.log('\n📊 Creating Deployment Summary...');
    const deploymentSummary = {
        project: "JINBI 144A/Reg S Bond Tokenization",
        network: "Polygon Mainnet",
        chainId: 137,
        deploymentDate: "2024-09-21T15:42:00Z",
        deployer: "0x9Dc918deBA2d3fc7128A59852b6699CCb2dC0EDB",
        totalGasUsed: "6.5 MATIC",
        contracts: {
            AttestationRegistry: "0x73C36D0F747386978d0a0cD93f1d674937e42542",
            ComplianceRegistry: "0x4FDF91216009835684233dc69da697BD9FF19F32",
            ComplianceOracle: "0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3",
            VaultProofNFT: "0x7a54c01413353088DD64239A75dBcfa8E1E8314a",
            CompliantSecurityToken: "0xA715acA24f83b08B786911c4d2fB194132D138D2",
            CorporateActions: "0x6651995eB8Bb86a551f7951DFc8dDa5070251768",
            DvPSettlement: "0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D",
            ChainlinkPriceRouter: "0xB3940e869Def6C07191056659889018Ebac10cB3",
            ChainlinkProofAdapter: "0x2b5B28D60b123C0b7cFb9C84a26559683d9edB39",
            TransferAgentBridge: "0x1AC482B0585BedA95BEee90BA623FAd876F48fE2"
        },
        configuration: {
            usdc: "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174",
            priceFeeds: {
                "XAU/USD": "0x0C466540B2ee1a31b441671eac0ca886e051E410",
                "USDC/USD": "0xfE4A8cc5b5B2366C1B58Bea3858e81843581b2F7",
                "MATIC/USD": "0xAB594600376Ec9fD91F8e885dADF0CE036862dE0"
            }
        },
        documentation: results,
        status: "Deployed and Operational",
        version: "1.0.0"
    };

    const summaryUpload = await uploadJSONToPinata(
        deploymentSummary,
        'JINBI-Deployment-Summary.json',
        'Complete deployment summary with all contract addresses and configuration'
    );
    if (summaryUpload.success) {
        console.log(`✅ Deployment Summary: https://ipfs.io/ipfs/${summaryUpload.ipfsHash}`);
        results.push({ type: 'Deployment Summary', cid: summaryUpload.ipfsHash });
    }

    // 8. Save results to file
    const timestamp = new Date().toISOString();
    const ipfsRegistry = {
        timestamp: timestamp,
        project: "JINBI Bond Tokenization",
        network: "Polygon Mainnet",
        total_documents: results.length,
        documents: results.map(doc => ({
            type: doc.type,
            cid: doc.cid,
            url: `https://ipfs.io/ipfs/${doc.cid}`,
            gateway_url: `https://gateway.pinata.cloud/ipfs/${doc.cid}`
        }))
    };

    fs.writeFileSync('ipfs-registry.json', JSON.stringify(ipfsRegistry, null, 2));

    console.log('\n🎉 IPFS Upload Complete!');
    console.log('📄 IPFS Registry saved to: ipfs-registry.json');
    console.log(`📊 Total Documents Uploaded: ${results.length}`);
    console.log('\n🔗 Quick Access URLs:');
    results.forEach(doc => {
        console.log(`   ${doc.type}: https://ipfs.io/ipfs/${doc.cid}`);
    });
}

main().catch(console.error);