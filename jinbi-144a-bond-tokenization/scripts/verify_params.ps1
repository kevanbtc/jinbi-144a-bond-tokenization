# 2) Immutable parameters & compliance gates verification
# Usage: .\verify_params.ps1

$RPC = "https://polygon-rpc.com"
$USDC = "0x2791Bca1F2de4661ED88A30C99A7a9449Aa84174"

$contracts = @{
    "CorporateActions" = "0x6651995eB8Bb86a551f7951DFc8dDa5070251768"
    "DvPSettlement" = "0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D"
    "ComplianceOracle" = "0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3"
    "ComplianceRegistry" = "0x4FDF91216009835684233dc69da697BD9FF19F32"
    "CompliantSecurityToken" = "0xA715acA24f83b08B786911c4d2fB194132D138D2"
}

Write-Host "=== VERIFYING IMMUTABLE PARAMETERS ===" -ForegroundColor Cyan
Write-Host "RPC: $RPC" -ForegroundColor Cyan
Write-Host "Expected USDC: $USDC" -ForegroundColor Cyan
Write-Host ""

$allGood = $true

# A) USDC and token wiring
Write-Host "A) Checking USDC and token wiring..." -ForegroundColor Yellow

foreach ($name in $contracts.Keys) {
    $addr = $contracts[$name]

    if ($name -eq "CorporateActions" -or $name -eq "DvPSettlement") {
        try {
            $tokenAddr = cast call $addr "token()(address)" --rpc-url $RPC
            $usdcAddr = cast call $addr "usdc()(address)" --rpc-url $RPC

            Write-Host "$name token: $tokenAddr" -ForegroundColor Green
            Write-Host "$name usdc:  $usdcAddr" -ForegroundColor Green

            $expectedToken = $contracts["CompliantSecurityToken"]
            if ($tokenAddr.ToLower() -ne $expectedToken.ToLower()) {
                Write-Host "  ERROR: Expected token $expectedToken, got $tokenAddr" -ForegroundColor Red
                $allGood = $false
            }

            if ($usdcAddr.ToLower() -ne $USDC.ToLower()) {
                Write-Host "  ERROR: Expected USDC $USDC, got $usdcAddr" -ForegroundColor Red
                $allGood = $false
            }
        } catch {
            Write-Host "ERROR checking $name : $($_.Exception.Message)" -ForegroundColor Red
            $allGood = $false
        }
    }
    Write-Host ""
}

# B) ComplianceOracle → Registry
Write-Host "B) Checking ComplianceOracle → Registry..." -ForegroundColor Yellow
try {
    $registryAddr = cast call $contracts["ComplianceOracle"] "registry()(address)" --rpc-url $RPC
    $expectedRegistry = $contracts["ComplianceRegistry"]

    Write-Host "ComplianceOracle registry: $registryAddr" -ForegroundColor Green

    if ($registryAddr.ToLower() -ne $expectedRegistry.ToLower()) {
        Write-Host "  ERROR: Expected registry $expectedRegistry, got $registryAddr" -ForegroundColor Red
        $allGood = $false
    }
} catch {
    Write-Host "ERROR checking registry: $($_.Exception.Message)" -ForegroundColor Red
    $allGood = $false
}
Write-Host ""

# C) Partition enforcement smoke test
Write-Host "C) Partition enforcement smoke test..." -ForegroundColor Yellow
Write-Host "NOTE: Implement transfer test that should fail (non-eligible → 144A)" -ForegroundColor Yellow
Write-Host "Expected: Revert with 'NOT_ELIGIBLE' or compliance revert" -ForegroundColor Yellow
Write-Host "Document the revert reason in your runbook" -ForegroundColor Yellow
# Example:
# cast send $contracts["CompliantSecurityToken"] "transfer(address,uint256)" 0xNON_ELIGIBLE_ADDRESS 1000000000000000000 --rpc-url $RPC

Write-Host ""
if ($allGood) {
    Write-Host "=== ALL PARAMETERS VERIFIED SUCCESSFULLY ===" -ForegroundColor Green
} else {
    Write-Host "=== ISSUES FOUND - CHECK OUTPUT ABOVE ===" -ForegroundColor Red
}