# --- paste your raw addresses here exactly as currently listed (even broken ones) ---
$raw = @"
AttestationRegistry    : 0x73C36D0F747386978d0a0cD93f1d674937e42542
ComplianceRegistry     : 0x4FDF91216009835684233dc69da697BD9FF19F32
ComplianceOracle       : 0x9A26e4B30C372e10695e5713b3FF0E7ff45ca3c3
VaultProofNFT          : 0x7a54c01413353088DD64239A75dBcfa8E1E8314a
CompliantSecurityToken : 0xA715acA24f83b08B786911c4d2fB194132D138D2
CorporateActions       : 0x6651995eB8Bb86a551f7951DFc8dDa5070251768
DvPSettlement          : 0x0b6e35549B8Bbf67885A8d41e65d044540fc9A5D
ChainlinkPriceRouter   : 0xB3940e869Def6C07191056659889018Ebac10cB3
ChainlinkProofAdapter  : 0x2b5B28D60b123C0b7cFb9C84a26559683d9edB39
TransferAgentBridge    : 0x1AC482B0585BedA95BEee90BA623FAd876F48fE2
"@

# Try environment variable first, fallback to public RPC
$RPC = $env:POLYGON_RPC_URL
if (-not $RPC) { 
    Write-Host "POLYGON_RPC_URL not set, using public Polygon RPC..." -ForegroundColor Yellow
    $RPC = "https://polygon-rpc.com"
}

Write-Host "Step 1: Normalizing and checksum-validating addresses..." -ForegroundColor Cyan

# Parse "Name : 0x..." lines
$lines = $raw -split "`n" | Where-Object { $_.Trim() -ne "" }
$results = @()

foreach($ln in $lines){
  if ($ln -notmatch '^\s*([A-Za-z0-9]+)\s*:\s*(0x[0-9a-fA-F]+)\s*$') {
    Write-Host "WARN: can't parse -> $ln" -ForegroundColor Yellow
    continue
  }
  $name = $matches[1].Trim()
  $addr = $matches[2].Trim()

  # normalize: remove hidden spaces/newlines (already trimmed) & validate length
  $hex = $addr.Substring(2)
  $okLen = ($hex.Length -eq 40)
  $okHex = ($hex -match '^[0-9a-fA-F]{40}$')

  $checksum = $null
  $code = $null
  $isContract = $false

  if ($okLen -and $okHex) {
    try {
      $checksum = (cast --to-checksum-address $addr)
      $code = (cast code $addr --rpc-url $RPC)
      $isContract = ($code -ne "0x" -and $code.Length -gt 2)
    } catch { 
      Write-Host "ERROR querying $name ($addr): $($_.Exception.Message)" -ForegroundColor Red
      $code = "<err>"
      $isContract = $false 
    }
  }

  $results += [pscustomobject]@{
    Name       = $name
    InputAddr  = $addr
    Checksum   = $checksum
    HexOK      = $okHex
    LenOK      = $okLen
    IsContract = $isContract
    CodeBytes  = if($code -and $code -ne "0x" -and $code -ne "<err>"){ ($code.Length-2)/2 } else { 0 }
  }
}

Write-Host "`nValidation Results:" -ForegroundColor Green
$results | Format-Table -AutoSize

$results | Export-Csv -NoTypeInformation addr_validation.csv
Write-Host "`nSaved validation to addr_validation.csv" -ForegroundColor Green

# Summary check
$allValid = ($results | Where-Object { $_.HexOK -and $_.LenOK -and $_.IsContract }).Count -eq $results.Count
if ($allValid) {
    Write-Host "`nALL ADDRESSES VALIDATED SUCCESSFULLY!" -ForegroundColor Green
    Write-Host "All contracts show HexOK=True, LenOK=True, IsContract=True" -ForegroundColor Green
} else {
    $failed = $results | Where-Object { -not ($_.HexOK -and $_.LenOK -and $_.IsContract) }
    Write-Host "`nISSUES FOUND WITH:" -ForegroundColor Yellow
    $failed | ForEach-Object { Write-Host "  - $($_.Name): HexOK=$($_.HexOK), LenOK=$($_.LenOK), IsContract=$($_.IsContract)" -ForegroundColor Yellow }
}