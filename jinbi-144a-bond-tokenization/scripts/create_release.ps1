# 4A) Tag and checksums
# Usage: .\create_release.ps1 -Version "v1.0.0" -Message "Production hardening complete"

param(
    [Parameter(Mandatory=$true)]
    [string]$Version,

    [Parameter(Mandatory=$true)]
    [string]$Message
)

Write-Host "=== CREATING RELEASE $Version ===" -ForegroundColor Cyan
Write-Host "Message: $Message" -ForegroundColor Cyan
Write-Host ""

# Checksums of critical files
Write-Host "Generating checksums..." -ForegroundColor Yellow
$files = @(
    "contracts/src/*.sol",
    "docs/*.md",
    "AUDIT_REPORT.md",
    "PRODUCTION_READINESS_CHECKLIST.md"
)

$hashes = @()
foreach ($pattern in $files) {
    try {
        $matchedFiles = Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue
        foreach ($file in $matchedFiles) {
            $hash = Get-FileHash -Algorithm SHA256 $file.FullName
            $hashes += [PSCustomObject]@{
                File = $file.Name
                SHA256 = $hash.Hash
            }
            Write-Host "$($file.Name): $($hash.Hash)" -ForegroundColor Green
        }
    } catch {
        Write-Host "Warning: Could not process $pattern" -ForegroundColor Yellow
    }
}

# Save checksums to file
$hashes | Export-Csv -NoTypeInformation "release_checksums_$Version.csv"
Write-Host "`nChecksums saved to release_checksums_$Version.csv" -ForegroundColor Green

# Git tag
Write-Host "`nCreating git tag..." -ForegroundColor Yellow
try {
    git tag -a $Version -m $Message
    Write-Host "Tag $Version created locally" -ForegroundColor Green

    Write-Host "Pushing tag to origin..." -ForegroundColor Yellow
    git push origin $Version
    Write-Host "Tag pushed to origin" -ForegroundColor Green
} catch {
    Write-Host "ERROR with git operations: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== RELEASE $Version CREATED ===" -ForegroundColor Green
Write-Host "Tag: $Version" -ForegroundColor Green
Write-Host "Checksums: release_checksums_$Version.csv" -ForegroundColor Green