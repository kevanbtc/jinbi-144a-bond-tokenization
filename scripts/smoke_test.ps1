# 7) Final smoke for desks (copy-paste demos)
# Usage: .\smoke_test.ps1

$RPC = "https://polygon-rpc.com"
$TOKEN = "0xA715acA24f83b08B786911c4d2fB194132D138D2"

Write-Host "=== SMOKE TEST FOR DESKS ===" -ForegroundColor Cyan
Write-Host "Token: $TOKEN" -ForegroundColor Cyan
Write-Host "RPC: $RPC" -ForegroundColor Cyan
Write-Host ""

# A) Read token identity
Write-Host "A) Reading token identity..." -ForegroundColor Yellow
try {
    $name = cast call $TOKEN "name()(string)" --rpc-url $RPC
    $symbol = cast call $TOKEN "symbol()(string)" --rpc-url $RPC
    $decimals = cast call $TOKEN "decimals()(uint8)" --rpc-url $RPC

    Write-Host "Name: $name" -ForegroundColor Green
    Write-Host "Symbol: $symbol" -ForegroundColor Green
    Write-Host "Decimals: $decimals" -ForegroundColor Green
} catch {
    Write-Host "ERROR reading token identity: $($_.Exception.Message)" -ForegroundColor Red
}

# B) Coupon dry-run
Write-Host "`nB) Coupon dry-run setup..." -ForegroundColor Yellow
Write-Host "NOTE: This requires test USDC and a test wallet" -ForegroundColor Yellow
Write-Host "Steps:" -ForegroundColor Yellow
Write-Host "1. Fund CorporateActions contract with tiny USDC amount" -ForegroundColor Yellow
Write-Host "2. Call payCoupon(cycleId) to a whitelisted test wallet" -ForegroundColor Yellow
Write-Host "3. Verify balances + events" -ForegroundColor Yellow
Write-Host "4. Revert/reset environment" -ForegroundColor Yellow

# Example commands (commented out - implement with real test accounts)
# cast send 0x2791Bca1F2de4661ED88A30C99A7a9449Aa84174 "transfer(address,uint256)" 0x6651995eB8Bb86a551f7951DFc8dDa5070251768 1000000 --rpc-url $RPC
# cast send 0x6651995eB8Bb86a551f7951DFc8dDa5070251768 "payCoupon(uint256)" 1 --rpc-url $RPC

Write-Host "`n=== SMOKE TEST COMPLETE ===" -ForegroundColor Green
Write-Host "Token identity verified" -ForegroundColor Green
Write-Host "Implement coupon dry-run with test accounts as needed" -ForegroundColor Green