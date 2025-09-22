# JINBI Contract Validation Script
# Validates all deployed contracts and extracts key information

$ErrorActionPreference = "Continue"

# Contract addresses
$contracts = @{
    "AttestationRegistry"    = "0x73C36D0F747386978d0a0cD93f1d674937e42542"
    "ComplianceRegistry"     = "0x4FDF91216009835684233dc69da697BD9FF19F32"
    "ComplianceOracle"       = "0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3"
    "VaultProofNFT"          = "0x7a54c01413353088DD64239A75dBcfa8E1E8314a"
    "CompliantSecurityToken" = "0xA715acA24f83b08B786911c4d2fB194132D138D2"
    "CorporateActions"       = "0x6651995eB8Bb86a551f7951DFc8dDa5070251768"
    "DvPSettlement"          = "0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D"
    "ChainlinkPriceRouter"   = "0xB3940e869Def6C07191056659889018Ebac10cB3"
    "ChainlinkProofAdapter"  = "0x2b5B28D60b123C0b7cFb9C84a26559683d9edB39"
    "TransferAgentBridge"    = "0x1AC482B0585BedA95BEee90BA623FAd876F48fE2"
}

$RPC = $env:POLYGON_RPC_URL
if (-not $RPC) {
    Write-Host "❌ POLYGON_RPC_URL not set" -ForegroundColor Red
    exit 1
}

Write-Host "🔍 Validating JINBI Contracts on Polygon Mainnet..." -ForegroundColor Yellow
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Yellow

$results = @()

foreach ($contract in $contracts.GetEnumerator()) {
    $name = $contract.Key
    $address = $contract.Value

    Write-Host "`n📋 Checking $name..." -ForegroundColor Cyan

    # Check if address has contract code
    try {
        $code = cast code $address --rpc-url $RPC
        $hasCode = ($code -ne "0x" -and $code.Length -gt 2)
        $codeSize = if ($hasCode) { ($code.Length - 2) / 2 } else { 0 }

        Write-Host "   ✅ Contract exists (${codeSize} bytes)" -ForegroundColor Green
    }
    catch {
        Write-Host "   ❌ Failed to get code: $($_.Exception.Message)" -ForegroundColor Red
        $hasCode = $false
        $codeSize = 0
    }

    # Try to get owner (most contracts have this)
    $owner = $null
    try {
        $owner = cast call $address "owner()(address)" --rpc-url $RPC
        Write-Host "   📍 Owner: $owner" -ForegroundColor White
    }
    catch {
        Write-Host "   ⚠️  No owner() function or failed to call" -ForegroundColor Yellow
    }

    # Add to results
    $results += [PSCustomObject]@{
        Name = $name
        Address = $address
        HasCode = $hasCode
        CodeSize = $codeSize
        Owner = $owner
        PolygonscanUrl = "https://polygonscan.com/address/$address"
    }
}

Write-Host "`n" + "="*80 -ForegroundColor Yellow
Write-Host "📊 VALIDATION SUMMARY" -ForegroundColor Yellow
Write-Host "="*80 -ForegroundColor Yellow

$results | Format-Table -AutoSize

# Save to CSV
$csvPath = "contract-validation-results.csv"
$results | Export-Csv -Path $csvPath -NoTypeInformation
Write-Host "💾 Results saved to: $csvPath" -ForegroundColor Green

# Token-specific checks
Write-Host "`n🪙 TOKEN-SPECIFIC VALIDATION" -ForegroundColor Yellow
Write-Host "="*50 -ForegroundColor Yellow

$tokenAddr = $contracts["CompliantSecurityToken"]

try {
    $name = cast call $tokenAddr "name()(string)" --rpc-url $RPC
    $symbol = cast call $tokenAddr "symbol()(string)" --rpc-url $RPC
    $decimals = cast call $tokenAddr "decimals()(uint8)" --rpc-url $RPC
    $totalSupply = cast call $tokenAddr "totalSupply()(uint256)" --rpc-url $RPC

    Write-Host "   Name: $name" -ForegroundColor White
    Write-Host "   Symbol: $symbol" -ForegroundColor White
    Write-Host "   Decimals: $decimals" -ForegroundColor White
    Write-Host "   Total Supply: $totalSupply" -ForegroundColor White
}
catch {
    Write-Host "   ❌ Failed to get token details: $($_.Exception.Message)" -ForegroundColor Red
}

# Check USDC reference in DvP and CorporateActions
Write-Host "`n💰 USDC INTEGRATION CHECK" -ForegroundColor Yellow
Write-Host "="*40 -ForegroundColor Yellow

$expectedUSDC = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174"

foreach ($contractName in @("DvPSettlement", "CorporateActions")) {
    $addr = $contracts[$contractName]
    try {
        $usdc = cast call $addr "usdc()(address)" --rpc-url $RPC
        $matches = ($usdc -eq $expectedUSDC)
        $status = if ($matches) { "✅" } else { "❌" }
        Write-Host "   $contractName USDC: $usdc $status" -ForegroundColor White
    }
    catch {
        Write-Host "   $contractName: ❌ Failed to get USDC address" -ForegroundColor Red
    }
}

Write-Host "`n🎉 Contract validation complete!" -ForegroundColor Green
Write-Host "📍 GitHub: https://github.com/kevanbtc/jinbi-144a-bond-tokenization" -ForegroundColor Cyan
Write-Host "🌐 Main Token: https://polygonscan.com/address/$tokenAddr" -ForegroundColor Cyan