$RPC = $env:POLYGON_RPC_URL
if (-not $RPC) { 
    Write-Host "POLYGON_RPC_URL not set, using public Polygon RPC..." -ForegroundColor Yellow
    $RPC = "https://polygon-rpc.com"
}

Write-Host "Step 3: Contract Sanity Checks" -ForegroundColor Cyan

$TOKEN = "0xA715acA24f83b08B786911c4d2fB194132D138D2"
$ORACLE = "0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3"
$REGISTRY = "0x4FDF91216009835684233dc69da697BD9FF19F32"
$CORPORATE = "0x6651995eB8Bb86a551f7951DFc8dDa5070251768"
$DVP = "0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D"

Write-Host "`n=== Token Identity Checks ===" -ForegroundColor Green
Write-Host "CompliantSecurityToken ($TOKEN):" -ForegroundColor White
cast call $TOKEN 'name()(string)' --rpc-url $RPC
cast call $TOKEN 'symbol()(string)' --rpc-url $RPC  
cast call $TOKEN 'decimals()(uint8)' --rpc-url $RPC

Write-Host "`n=== Owner Checks ===" -ForegroundColor Green
cast call "0x73C36D0F747386978d0a0cD93f1d674937e42542" 'owner()(address)' --rpc-url $RPC
cast call $REGISTRY 'owner()(address)' --rpc-url $RPC
cast call $ORACLE 'owner()(address)' --rpc-url $RPC
cast call "0x7a54c01413353088DD64239A75dBcfa8E1E8314a" 'owner()(address)' --rpc-url $RPC
cast call $TOKEN 'owner()(address)' --rpc-url $RPC

Write-Host "`n=== Cross-Reference Checks ===" -ForegroundColor Green
Write-Host "Oracle registry reference:" -ForegroundColor White
cast call $ORACLE 'registry()(address)' --rpc-url $RPC

Write-Host "`nCorporate Actions references:" -ForegroundColor White
cast call $CORPORATE 'token()(address)' --rpc-url $RPC
cast call $CORPORATE 'usdc()(address)' --rpc-url $RPC

Write-Host "`nAll checks complete!" -ForegroundColor Green