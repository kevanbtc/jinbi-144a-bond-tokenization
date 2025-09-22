# Branch Protection Setup Script
$OWNER = "kevanbtc"
$REPO = "jinbi-144a-bond-tokenization"
$BRANCH = "master"

Write-Host "Setting up branch protection for $BRANCH branch..."

# 1) Create/update branch protection with PR requirements
$prReviews = @{
    dismiss_stale_reviews = $true
    required_approving_review_count = 2
    require_code_owner_reviews = $true
}

$body = @{
    required_pull_request_reviews = $prReviews
    enforce_admins = $true
    restrictions = $null
    required_linear_history = $true
    allow_force_pushes = $false
    allow_deletions = $false
}

$jsonBody = $body | ConvertTo-Json -Depth 10
Write-Host "JSON Body: $jsonBody"

try {
    $response = Invoke-RestMethod -Uri "https://api.github.com/repos/$OWNER/$REPO/branches/$BRANCH/protection" -Method Put -Headers @{
        "Accept" = "application/vnd.github+json"
        "Authorization" = "Bearer $env:GITHUB_TOKEN"
        "X-GitHub-Api-Version" = "2022-11-28"
    } -Body $jsonBody -ContentType "application/json"

    Write-Host "✅ Branch protection rules set successfully!"
    Write-Host "Response: $($response | ConvertTo-Json -Depth 5)"
} catch {
    Write-Host "❌ Failed to set branch protection: $($_.Exception.Message)"
    Write-Host "Response: $($_.Exception.Response)"
}