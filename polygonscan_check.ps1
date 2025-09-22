$SCAN = $env:POLYGONSCAN_API_KEY
if (-not $SCAN) { 
    Write-Host "POLYGONSCAN_API_KEY not set - skipping API verification" -ForegroundColor Yellow
    Write-Host "You can check manually at: https://polygonscan.com/address/<ADDRESS>" -ForegroundColor Cyan
    exit
}

Write-Host "Step 4: Polygonscan Verification Status" -ForegroundColor Cyan

$addresses = @(
    @{ name="AttestationRegistry"; addr="0x73C36D0F747386978d0a0cD93f1d674937e42542" },
    @{ name="ComplianceRegistry"; addr="0x4FDF91216009835684233dc69da697BD9FF19F32" },
    @{ name="ComplianceOracle"; addr="0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3" },
    @{ name="VaultProofNFT"; addr="0x7a54c01413353088DD64239A75dBcfa8E1E8314a" },
    @{ name="CompliantSecurityToken"; addr="0xA715acA24f83b08B786911c4d2fB194132D138D2" },
    @{ name="CorporateActions"; addr="0x6651995eB8Bb86a551f7951DFc8dDa5070251768" },
    @{ name="DvPSettlement"; addr="0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D" },
    @{ name="ChainlinkPriceRouter"; addr="0xB3940e869Def6C07191056659889018Ebac10cB3" },
    @{ name="ChainlinkProofAdapter"; addr="0x2b5B28D60b123C0b7cFb9C84a26559683d9edB39" },
    @{ name="TransferAgentBridge"; addr="0x1AC482B0585BedA95BEee90BA623FAd876F48fE2" }
)

Write-Host "`nChecking verification status on Polygonscan..." -ForegroundColor Green

foreach($contract in $addresses) {
    $uri = "https://api.polygonscan.com/api?module=contract&action=getsourcecode&address=$($contract.addr)&apikey=$SCAN"
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Get
        $verified = if($response.result[0].ABI -and $response.result[0].ABI -ne "Contract source code not verified"){"VERIFIED"}else{"UNVERIFIED"}
        $contractName = $response.result[0].ContractName
        Write-Host ("{0,-24} {1} {2} {3}" -f $contract.name, $contract.addr, $verified, $contractName) -ForegroundColor $(if($verified -eq "VERIFIED"){"Green"}else{"Red"})
    } catch {
        Write-Host ("{0,-24} {1} ERROR" -f $contract.name, $contract.addr) -ForegroundColor Red
    }
    Start-Sleep -Milliseconds 200  # Rate limiting
}

Write-Host "`nPolygonscan verification check complete!" -ForegroundColor Green