# Complete production verification suite
# Run this after executing the launch sequence to verify everything is ready

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "JINBI PRODUCTION VERIFICATION SUITE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$RPC = "https://polygon-rpc.com"
$allGood = $true

# 1. Contract ownership verification
Write-Host "1. VERIFYING CONTRACT OWNERSHIP..." -ForegroundColor Yellow
$contracts = @(
    "0xA715acA24f83b08B786911c4d2fB194132D138D2", # CompliantSecurityToken
    "0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D", # DvPSettlement
    "0x6651995eB8Bb86a551f7951DFc8dDa5070251768", # CorporateActions
    "0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3", # ComplianceOracle
    "0x4FDF91216009835684233dc69da697BD9FF19F32", # ComplianceRegistry
    "0x73C36D0F747386978d0a0cD93f1d674937e42542"  # AttestationRegistry
)

foreach($c in $contracts){
    try {
        $owner = cast call $c "owner()(address)" --rpc-url $RPC 2>$null
        Write-Host "  $c -> $owner" -ForegroundColor Green
        # Note: You'll need to specify your Safe address here
        # if ($owner.ToLower() -ne "YOUR_SAFE_ADDRESS") { $allGood = $false }
    } catch {
        Write-Host "  ERROR checking $c : $($_.Exception.Message)" -ForegroundColor Red
        $allGood = $false
    }
}

# 2. Pause functionality
Write-Host "`n2. VERIFYING PAUSE FUNCTIONALITY..." -ForegroundColor Yellow
$token = "0xA715acA24f83b08B786911c4d2fB194132D138D2"
try {
    $paused = cast call $token "paused()(bool)" --rpc-url $RPC
    Write-Host "  Token paused: $paused" -ForegroundColor Green
    if ($paused -ne "false") {
        Write-Host "  WARNING: Token is currently paused" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ERROR checking pause state: $($_.Exception.Message)" -ForegroundColor Red
    $allGood = $false
}

# 3. Parameter verification
Write-Host "`n3. VERIFYING CONTRACT PARAMETERS..." -ForegroundColor Yellow
$usdc = "0x2791Bca1F2de4661ED88A30C99A7a9449Aa84174"
$expectedToken = "0xA715acA24f83b08B786911c4d2fB194132D138D2"

# Check DvPSettlement
try {
    $dvpToken = cast call "0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D" "token()(address)" --rpc-url $RPC
    $dvpUsdc = cast call "0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D" "usdc()(address)" --rpc-url $RPC
    Write-Host "  DvPSettlement token: $dvpToken" -ForegroundColor Green
    Write-Host "  DvPSettlement USDC:  $dvpUsdc" -ForegroundColor Green

    if ($dvpToken.ToLower() -ne $expectedToken.ToLower() -or $dvpUsdc.ToLower() -ne $usdc.ToLower()) {
        $allGood = $false
    }
} catch {
    Write-Host "  ERROR checking DvPSettlement: $($_.Exception.Message)" -ForegroundColor Red
    $allGood = $false
}

# Check CorporateActions
try {
    $caToken = cast call "0x6651995eB8Bb86a551f7951DFc8dDa5070251768" "token()(address)" --rpc-url $RPC
    $caUsdc = cast call "0x6651995eB8Bb86a551f7951DFc8dDa5070251768" "usdc()(address)" --rpc-url $RPC
    Write-Host "  CorporateActions token: $caToken" -ForegroundColor Green
    Write-Host "  CorporateActions USDC:  $caUsdc" -ForegroundColor Green

    if ($caToken.ToLower() -ne $expectedToken.ToLower() -or $caUsdc.ToLower() -ne $usdc.ToLower()) {
        $allGood = $false
    }
} catch {
    Write-Host "  ERROR checking CorporateActions: $($_.Exception.Message)" -ForegroundColor Red
    $allGood = $false
}

# 4. Token identity
Write-Host "`n4. VERIFYING TOKEN IDENTITY..." -ForegroundColor Yellow
try {
    $name = cast call $token "name()(string)" --rpc-url $RPC
    $symbol = cast call $token "symbol()(string)" --rpc-url $RPC
    $decimals = cast call $token "decimals()(uint8)" --rpc-url $RPC

    Write-Host "  Name: $name" -ForegroundColor Green
    Write-Host "  Symbol: $symbol" -ForegroundColor Green
    Write-Host "  Decimals: $decimals" -ForegroundColor Green

    if ($name -notlike "*JINBI*" -or $symbol -notlike "*BOND*") {
        Write-Host "  WARNING: Token identity may be incorrect" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ERROR checking token identity: $($_.Exception.Message)" -ForegroundColor Red
    $allGood = $false
}

# 5. RPC connectivity
Write-Host "`n5. VERIFYING RPC CONNECTIVITY..." -ForegroundColor Yellow
try {
    $blockNumber = cast block-number --rpc-url $RPC
    Write-Host "  Current block: $blockNumber" -ForegroundColor Green
} catch {
    Write-Host "  ERROR with RPC: $($_.Exception.Message)" -ForegroundColor Red
    $allGood = $false
}

Write-Host "`n========================================" -ForegroundColor Cyan
if ($allGood) {
    Write-Host "✅ ALL VERIFICATION CHECKS PASSED" -ForegroundColor Green
    Write-Host "🚀 SYSTEM READY FOR PRODUCTION" -ForegroundColor Green
} else {
    Write-Host "❌ ISSUES FOUND - REVIEW OUTPUT ABOVE" -ForegroundColor Red
    Write-Host "🔧 ADDRESS ISSUES BEFORE GO-LIVE" -ForegroundColor Red
}
Write-Host "========================================" -ForegroundColor Cyan