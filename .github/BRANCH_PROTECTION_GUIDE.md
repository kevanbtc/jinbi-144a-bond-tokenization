# Branch Protection & Security Configuration

## 🚨 CRITICAL: Enable Branch Protection Immediately

Your master branch is currently **unprotected**. For a production institutional system, this is a critical security risk. Follow these steps to secure your repository:

### Fastest Path — GitHub UI (90 seconds)

**Settings** → **Branches** → **"Add rule"**

* **Branch name pattern:** `master`
* ✅ **Require a pull request before merging**
  * ✅ **Require approvals:** **2**
  * ✅ **Dismiss stale approvals**
  * ✅ **Require review from Code Owners**
* ✅ **Require status checks to pass before merging**
  * Add these (match your workflow job names):
    * `security-audit` (from CI workflow)
  * ✅ **Require branches to be up to date**
* ✅ **Require signed commits** (optional but recommended)
* ✅ **Require linear history**
* ✅ **Do not allow bypassing the above settings**
* ✅ **Include administrators**
* 🔒 **Restrict who can push to matching branches** → **No one** (PRs only)
* 🚫 **Prevent force pushes**
* 🚫 **Prevent deletions**

### One-Shot via GitHub CLI

```powershell
# Authenticate first
gh auth login

# Set up branch protection
gh api -X PUT repos/kevanbtc/jinbi-144a-bond-tokenization/branches/master/protection `
  -H "Accept: application/vnd.github+json" `
  -F required_pull_request_reviews.dismiss_stale_reviews=true `
  -F required_pull_request_reviews.required_approving_review_count=2 `
  -F required_pull_request_reviews.require_code_owner_reviews=true `
  -F enforce_admins=true `
  -F required_linear_history=true `
  -F allow_force_pushes=false `
  -F allow_deletions=false

# Add status checks
gh api -X PATCH repos/kevanbtc/jinbi-144a-bond-tokenization/branches/master/protection/required_status_checks `
  -H "Accept: application/vnd.github+json" `
  -F strict=true `
  -F contexts='["security-audit"]'
```

### Required Status Checks

The following checks must pass before any merge to master:

- `security-audit` - Complete security analysis (Slither + tests + coverage)
- Foundry build and deployment validation
- Contract size and security checks

### Code Owners Setup

Your `.github/CODEOWNERS` file should include:

```
# Contracts require security + protocol review
/contracts/**            @kevanbtc @aider-chat-bot

# CI, workflows, security policy
/.github/**              @kevanbtc

# Scripts used to operate production
/scripts/**              @kevanbtc
```

### Testing Branch Protection

1. **Create a test PR** to master
2. **Verify you cannot merge** until:
   - 2 approvals given (one must be a CODEOWNER)
   - All required checks pass (`security-audit`)
   - Branch is up-to-date with master
3. **Try to push directly to master** → should fail

### Additional Security Hardening

**Repository Settings:**
- **Actions** → **General** → **Require approval for external PRs**
- **Secrets and variables** → **Actions** → **Disable** "Allow GitHub Actions to create PRs"
- **Code security** → **Enable** Dependabot alerts & security updates

**Environment Protection:**
- Create `production` environment
- Add Safe multisig signers as required reviewers
- Restrict deployment branches to `master` only

### Compliance Verification

This configuration ensures:
- ✅ **No direct pushes** to master (PRs only)
- ✅ **2-person rule** for all changes
- ✅ **Security gates** enforced before merge
- ✅ **Audit trail** of all changes
- ✅ **Administrator enforcement** (no bypasses)

**Status:** Branch protection is **REQUIRED** for institutional production systems.

# Contract changes require security review
contracts/src/*.sol @kevanbtc @security-reviewer

# CI/CD changes
.github/workflows/*.yml @kevanbtc

# Documentation changes (less restrictive)
*.md @kevanbtc
```

### 4. Security Scanning Integration

Consider adding these additional security layers:

#### Dependabot
- **Settings** → **Security** → **Code security and analysis**
- ✅ Enable Dependabot alerts
- ✅ Enable Dependabot security updates
- ✅ Enable Dependabot version updates

#### CodeQL Analysis
Add to your CI workflow:

```yaml
- name: Initialize CodeQL
  uses: github/codeql-action/init@v3
  with:
    languages: javascript, solidity

- name: Perform CodeQL Analysis
  uses: github/codeql-action/analyze@v3
```

### 5. Repository Security Settings

**Settings** → **Security**:

- ✅ **Private vulnerability reporting**: Enable
- ✅ **Require vulnerability reports**: Enable
- ✅ **Allow auto-merge**: ❌ Disable
- ✅ **Automatically delete head branches**: Enable

### 6. Access Control

**Settings** → **Collaborators and teams**:

- Use teams instead of individual users
- Implement least-privilege access
- Require 2FA for all contributors
- Regular access reviews

---

## 🔍 Verification Checklist

After setup, verify:

- [ ] Cannot force push to master
- [ ] Cannot delete master branch
- [ ] All commits require PR with 2 approvals
- [ ] CI checks must pass before merge
- [ ] Administrators are restricted
- [ ] Code owners are configured
- [ ] Security scanning is enabled

---

## 🚨 Emergency Procedures

If security incident occurs:

1. **Immediate**: Disable all deployments
2. **Assess**: Review recent commits and access logs
3. **Contain**: Restrict repository access if needed
4. **Recover**: Create hotfix branch with security fixes
5. **Audit**: Review and document incident response

---

## 📊 Monitoring

Monitor repository security:

- **Security tab**: Review vulnerability alerts
- **Audit log**: Monitor sensitive actions
- **Branch protection**: Verify rules are enforced
- **CI/CD**: Ensure security checks run on every PR

---

**Priority**: Complete this setup before any production deployment. Unprotected master branches are unacceptable for institutional financial systems.