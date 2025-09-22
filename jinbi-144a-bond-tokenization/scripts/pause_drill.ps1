# 1B) Pause / unpause drill (prove the circuit breaker)
# Usage: .\pause_drill.ps1

$RPC = "https://polygon-rpc.com"
$TOKEN = "0xA715acA24f83b08B786911c4d2fB194132D138D2" # CompliantSecurityToken

Write-Host "=== PAUSE/UNPAUSE DRILL ===" -ForegroundColor Cyan
Write-Host "Token: $TOKEN" -ForegroundColor Cyan
Write-Host "RPC: $RPC" -ForegroundColor Cyan
Write-Host ""

# Check initial pause state
Write-Host "1. Checking initial pause state..." -ForegroundColor Yellow
try {
    $paused = cast call $TOKEN "paused()(bool)" --rpc-url $RPC
    Write-Host "Initial paused state: $paused" -ForegroundColor Green
} catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Pause the token
Write-Host "`n2. Pausing token..." -ForegroundColor Yellow
try {
    cast send $TOKEN "pause()" --rpc-url $RPC
    Write-Host "Pause transaction sent" -ForegroundColor Green
} catch {
    Write-Host "ERROR pausing: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Verify paused
Start-Sleep -Seconds 2
try {
    $paused = cast call $TOKEN "paused()(bool)" --rpc-url $RPC
    Write-Host "Paused state after pause: $paused" -ForegroundColor Green
    if ($paused -ne "true") {
        Write-Host "WARNING: Token should be paused but shows $paused" -ForegroundColor Yellow
    }
} catch {
    Write-Host "ERROR checking pause state: $($_.Exception.Message)" -ForegroundColor Red
}

# Try a transfer (should fail) - You'll need to implement this based on your test accounts
Write-Host "`n3. Testing transfer while paused (should fail)..." -ForegroundColor Yellow
Write-Host "NOTE: Implement transfer test here with test accounts" -ForegroundColor Yellow
# Example:
# cast send $TOKEN "transfer(address,uint256)" 0xTEST_ADDRESS 1000000000000000000 --rpc-url $RPC
# Should revert with "Pausable: paused"

# Unpause
Write-Host "`n4. Unpausing token..." -ForegroundColor Yellow
try {
    cast send $TOKEN "unpause()" --rpc-url $RPC
    Write-Host "Unpause transaction sent" -ForegroundColor Green
} catch {
    Write-Host "ERROR unpausing: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Verify unpaused
Start-Sleep -Seconds 2
try {
    $paused = cast call $TOKEN "paused()(bool)" --rpc-url $RPC
    Write-Host "Paused state after unpause: $paused" -ForegroundColor Green
    if ($paused -ne "false") {
        Write-Host "WARNING: Token should be unpaused but shows $paused" -ForegroundColor Yellow
    }
} catch {
    Write-Host "ERROR checking pause state: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== DRILL COMPLETE ===" -ForegroundColor Green
Write-Host "Document the revert messages in your runbook" -ForegroundColor Green
Write-Host "Expected: Transfers/settlements/coupons should revert when paused" -ForegroundColor Green