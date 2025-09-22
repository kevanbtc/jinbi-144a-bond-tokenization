# 1A) Rotate owners to your Safe (or confirm)
# Usage: .\transfer_ownership.ps1 -Safe "0xYOUR_SAFE_ADDRESS"

param(
    [Parameter(Mandatory=$true)]
    [string]$Safe
)

$RPC = "https://polygon-rpc.com"

$contracts = @(
    "0xA715acA24f83b08B786911c4d2fB194132D138D2", # CompliantSecurityToken
    "0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D", # DvPSettlement
    "0x6651995eB8Bb86a551f7951DFc8dDa5070251768", # CorporateActions
    "0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3", # ComplianceOracle
    "0x4FDF91216009835684233dc69da697BD9FF19F32", # ComplianceRegistry
    "0x73C36D0F747386978d0a0cD93f1d674937e42542"  # AttestationRegistry
)

Write-Host "Checking current ownership and transferring to Safe: $Safe" -ForegroundColor Cyan
Write-Host "RPC: $RPC" -ForegroundColor Cyan
Write-Host ""

foreach($c in $contracts){
    try {
        $o = cast call $c "owner()(address)" --rpc-url $RPC 2>$null
        Write-Host "$c owner => $o" -ForegroundColor Yellow

        if ($o.ToLower() -ne $Safe.ToLower()) {
            Write-Host "  Transferring ownership to $Safe..." -ForegroundColor Green
            # This will prompt for confirmation/signer
            cast send $c "transferOwnership(address)" $Safe --rpc-url $RPC
            Write-Host "  Ownership transfer initiated for $c" -ForegroundColor Green
        } else {
            Write-Host "  Already owned by Safe" -ForegroundColor Green
        }
    } catch {
        Write-Host "ERROR checking $c : $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""
}

Write-Host "Ownership transfer process complete. Verify transactions in your Safe." -ForegroundColor Green