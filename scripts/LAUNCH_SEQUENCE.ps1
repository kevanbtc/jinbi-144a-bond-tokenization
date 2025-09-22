# JINBI Bond Tokenization - Production Launch Sequence
# Execute these scripts in order for institutional-grade deployment

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "JINBI BOND TOKENIZATION - LAUNCH SEQUENCE" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# 1) Freeze control surface
Write-Host "1) FREEZE CONTROL SURFACE" -ForegroundColor Yellow
Write-Host "   A) Transfer ownership to Safe" -ForegroundColor White
Write-Host "      .\scripts\transfer_ownership.ps1 -Safe '0xYOUR_SAFE_ADDRESS'" -ForegroundColor Gray
Write-Host ""
Write-Host "   B) Run pause/unpause drill" -ForegroundColor White
Write-Host "      .\scripts\pause_drill.ps1" -ForegroundColor Gray
Write-Host ""
Write-Host "   C) Check role sanity (manual - inspect AccessControl events)" -ForegroundColor White
Write-Host "      cast call <addr> 'hasRole(bytes32,address)(bool)' 0x<ROLE> 0x<actor> --rpc-url https://polygon-rpc.com" -ForegroundColor Gray
Write-Host ""

# 2) Verify immutable parameters
Write-Host "2) VERIFY IMMUTABLE PARAMETERS" -ForegroundColor Yellow
Write-Host "   .\scripts\verify_params.ps1" -ForegroundColor Gray
Write-Host ""

# 3) On-chain receipts
Write-Host "3) ATTEST AUDIT PACKAGE" -ForegroundColor Yellow
Write-Host "   .\scripts\attest_audit.ps1 -AuditCID 'Qm...AUDIT_REPORT.md' -ChecklistCID 'Qm...CHECKLIST.md'" -ForegroundColor Gray
Write-Host ""

# 4) Release cut
Write-Host "4) CREATE RELEASE" -ForegroundColor Yellow
Write-Host "   .\scripts\create_release.ps1 -Version 'v1.0.0' -Message 'Production hardening complete'" -ForegroundColor Gray
Write-Host ""

# 5) Monitoring setup
Write-Host "5) MONITORING & RUNBOOKS" -ForegroundColor Yellow
Write-Host "   A) Test RPC failover" -ForegroundColor White
Write-Host "      .\scripts\check_rpc_failover.ps1" -ForegroundColor Gray
Write-Host ""
Write-Host "   B) Price feed monitoring (document staleness thresholds)" -ForegroundColor White
Write-Host "   C) Incident runbook: pause → snapshot → postmortem → unpause" -ForegroundColor White
Write-Host ""

# 6) Data room
Write-Host "6) INVESTOR DATA ROOM" -ForegroundColor Yellow
Write-Host "   Complete: .\data-room\README.md" -ForegroundColor Green
Write-Host ""

# 7) Smoke tests
Write-Host "7) SMOKE TESTS FOR DESKS" -ForegroundColor Yellow
Write-Host "   .\scripts\smoke_test.ps1" -ForegroundColor Gray
Write-Host ""

# 8) Go-live checklist
Write-Host "8) GO-LIVE GUARDRAILS" -ForegroundColor Yellow
Write-Host "   □ Owners = Safe everywhere" -ForegroundColor White
Write-Host "   □ Pause works & documented" -ForegroundColor White
Write-Host "   □ All constructor params verified on Polygonscan" -ForegroundColor White
Write-Host "   □ Compliance gates block non-eligible" -ForegroundColor White
Write-Host "   □ Feeds staleness policy set" -ForegroundColor White
Write-Host "   □ CI is green; tag cut; IPFS attested; release notes published" -ForegroundColor White
Write-Host ""

Write-Host "=========================================" -ForegroundColor Green
Write-Host "EXECUTE SCRIPTS IN ORDER ABOVE" -ForegroundColor Green
Write-Host "VERIFY EACH STEP BEFORE PROCEEDING" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green