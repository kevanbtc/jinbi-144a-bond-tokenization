# JINBI Contract Validation - Step 0 & 1: Environment and RPC Test
Write-Host "=== STEP 0: Loading Environment ===" -ForegroundColor Cyan

function Import-DotEnv([string]$p=".env") {
    if (Test-Path $p) {
        Get-Content $p | ForEach-Object {
            if ($_ -match '^\s*#' -or $_ -match '^\s*$') { return }
            $i = $_.IndexOf('=')
            if ($i -lt 1) { return }
            $k = $_.Substring(0, $i).Trim()
            $v = $_.Substring($i + 1).Trim()
            [Environment]::SetEnvironmentVariable($k, $v, "Process")
            Set-Item Env:$k $v
            Write-Host "  ✓ Set $k" -ForegroundColor Green
        }
    } else {
        Write-Host "  ⚠️  .env file not found" -ForegroundColor Yellow
    }
}

Import-DotEnv

$RPC = $env:POLYGON_RPC_URL
if (-not $RPC) { 
    Write-Host "  ❌ POLYGON_RPC_URL not set - using fallback" -ForegroundColor Red
    $RPC = "https://polygon-rpc.com"
} else {
    Write-Host "  ✅ POLYGON_RPC_URL loaded: $RPC" -ForegroundColor Green
}

# Test RPC connection
Write-Host "`n=== STEP 1: RPC Connection Test ===" -ForegroundColor Cyan
try {
    $blockNumber = cast block-number --rpc-url $RPC
    Write-Host "  ✅ RPC Connected - Latest block: $blockNumber" -ForegroundColor Green
} catch {
    Write-Host "  ❌ RPC Connection Failed: $($_.Exception.Message)" -ForegroundColor Red
    throw "Cannot continue without RPC connection"
}

Write-Host "`nEnvironment loaded and RPC verified!" -ForegroundColor Green