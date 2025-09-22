const { execSync } = require('child_process');

// Contract addresses
const ATTESTATION_REGISTRY = "0x73C36D0F747386978d0a0cD93f1d674937e42542";

// IPFS CIDs from our uploaded documents
const documents = [
    {
        type: "CONTRACT_REGISTRY",
        cid: "Qmabg5nDj7C7AckXV3sgK8uZu7ogjrihzHfo7YWxFxPS6j",
        tag: "0x434f4e54524143545f5245474953545259" // "CONTRACT_REGISTRY" in hex
    },
    {
        type: "INVESTOR_ONBOARDING",
        cid: "QmNYHfC5q2GTJuuGroTmV9XPBaczgc9zR3N6nqo6XMTUJx",
        tag: "0x494e564553544f525f4f4e424f415244494e47" // "INVESTOR_ONBOARDING" in hex
    },
    {
        type: "TECHNICAL_SPECIFICATIONS",
        cid: "QmVDUvaHieEFa5jmDexg2pZi3tUf6u1ThuYgKmMRphgMGz",
        tag: "0x544543485f53504543494649434154494f4e53" // "TECH_SPECIFICATIONS" in hex
    },
    {
        type: "LEGAL_CHECKLIST",
        cid: "QmTNXiyyZaRMjgHEDqD8LFN65zgDL8YFnU194a3wNmR97w",
        tag: "0x4c4547414c5f434845434b4c495354" // "LEGAL_CHECKLIST" in hex
    },
    {
        type: "OPERATIONS_RUNBOOK",
        cid: "QmdhhRP9FUkGpCNo9co19ZQDx1qPaai2HGhbfm88dL4EUr",
        tag: "0x4f504552415449524e535f52554e424f4f4b" // "OPERATIONS_RUNBOOK" in hex
    },
    {
        type: "CONTRACT_METADATA",
        cid: "QmSXH5HU6tHVFCjmQxqM7qm5PEAusXbF1xoZGgFsVUBQyr",
        tag: "0x434f4e54524143545f4d45544144415441" // "CONTRACT_METADATA" in hex
    },
    {
        type: "DEPLOYMENT_SUMMARY",
        cid: "QmSQbu1WjJE7FniPe6GVbdvbwripixKDvE4DgxtiMzjFBq",
        tag: "0x4445504c4f594d454e545f53554d4d415259" // "DEPLOYMENT_SUMMARY" in hex
    }
];

async function anchorDocuments() {
    console.log('🔐 Anchoring IPFS documents on-chain via AttestationRegistry...\n');

    for (const doc of documents) {
        console.log(`📄 Anchoring ${doc.type}...`);
        console.log(`   CID: ${doc.cid}`);
        console.log(`   IPFS URL: https://ipfs.io/ipfs/${doc.cid}`);

        try {
            // Create the cast command
            const command = `cast send ${ATTESTATION_REGISTRY} "attest(string,string,bytes32)" "${doc.type}" "${doc.cid}" "${doc.tag}" --rpc-url $env:POLYGON_RPC_URL --private-key $env:PRIVATE_KEY`;

            console.log(`   Command: ${command}`);
            console.log('   ⏳ Executing transaction...');

            // Note: This would execute if we had the private key and RPC setup
            // const result = execSync(command, { encoding: 'utf-8' });
            // console.log(`   ✅ Transaction hash: ${result.trim()}`);

            console.log('   ℹ️  Command ready to execute (requires private key setup)');

        } catch (error) {
            console.log(`   ❌ Failed: ${error.message}`);
        }

        console.log('');
    }

    console.log('📋 Summary of documents to anchor:');
    console.log('═══════════════════════════════════════════');
    documents.forEach((doc, index) => {
        console.log(`${index + 1}. ${doc.type}`);
        console.log(`   CID: ${doc.cid}`);
        console.log(`   Gateway: https://gateway.pinata.cloud/ipfs/${doc.cid}`);
        console.log('');
    });

    console.log('🔗 To execute these transactions, ensure you have:');
    console.log('   ✓ POLYGON_RPC_URL environment variable set');
    console.log('   ✓ PRIVATE_KEY environment variable set (deployer key)');
    console.log('   ✓ Sufficient MATIC for gas fees');
    console.log('');
    console.log('💡 After anchoring, documents will be immutably linked to the blockchain');
    console.log('   and can be retrieved via AttestationRegistry.attestationByHash()');
}

// Run if called directly
if (require.main === module) {
    anchorDocuments().catch(console.error);
}

module.exports = { anchorDocuments, documents };