# 5A) RPC failover monitoring
# Usage: .\check_rpc_failover.ps1

$RPCs = @(
    "https://polygon-mainnet.g.alchemy.com/v2/YOUR_API_KEY",  # Replace with your Alchemy key
    "https://polygon-rpc.com"
)

Write-Host "=== RPC FAILOVER CHECK ===" -ForegroundColor Cyan

$workingRPC = $null
foreach ($rpc in $RPCs) {
    Write-Host "Testing $rpc ..." -ForegroundColor Yellow
    try {
        $blockNumber = cast block-number --rpc-url $rpc
        Write-Host "  Block number: $blockNumber" -ForegroundColor Green
        Write-Host "  $rpc OK" -ForegroundColor Green
        $workingRPC = $rpc
        break
    } catch {
        Write-Host "  $rpc FAILED: $($_.Exception.Message)" -ForegroundColor Red
    }
}

if ($workingRPC) {
    Write-Host "`nActive RPC: $workingRPC" -ForegroundColor Green
    Write-Host "Use this RPC for your operations" -ForegroundColor Green
} else {
    Write-Host "`nCRITICAL: No RPC endpoints working!" -ForegroundColor Red
    exit 1
}

Write-Host "`n=== RPC CHECK COMPLETE ===" -ForegroundColor Green