# 3) On-chain receipts (attest the hardening package)
# Usage: .\attest_audit.ps1 -AuditCID "Qm...AUDIT_REPORT.md" -ChecklistCID "Qm...PRODUCTION_READINESS_CHECKLIST.md"

param(
    [Parameter(Mandatory=$true)]
    [string]$AuditCID,

    [Parameter(Mandatory=$true)]
    [string]$ChecklistCID
)

$RPC = "https://polygon-rpc.com"
$AR = "0x73C36D0F747386978d0a0cD93f1d674937e42542" # AttestationRegistry

Write-Host "=== ATTESTING AUDIT PACKAGE TO CHAIN ===" -ForegroundColor Cyan
Write-Host "AttestationRegistry: $AR" -ForegroundColor Cyan
Write-Host "RPC: $RPC" -ForegroundColor Cyan
Write-Host ""

# Attest audit report
Write-Host "Attesting AUDIT_REPORT..." -ForegroundColor Yellow
try {
    $tx = cast send $AR "attest(string,string,bytes32)" "AUDIT_REPORT" $AuditCID "0x41554449545f5245504f5254" --rpc-url $RPC
    Write-Host "Audit attestation TX: $tx" -ForegroundColor Green
} catch {
    Write-Host "ERROR attesting audit: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Attest production readiness checklist
Write-Host "Attesting PRODUCTION_READINESS..." -ForegroundColor Yellow
try {
    $tx = cast send $AR "attest(string,string,bytes32)" "PRODUCTION_READINESS" $ChecklistCID "0x50524f44554354494f4e5f52454144494e455353" --rpc-url $RPC
    Write-Host "Checklist attestation TX: $tx" -ForegroundColor Green
} catch {
    Write-Host "ERROR attesting checklist: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== ATTESTATION COMPLETE ===" -ForegroundColor Green
Write-Host "These transaction hashes are your immutable compliance receipts" -ForegroundColor Green
Write-Host "Include them in your investor documentation" -ForegroundColor Green