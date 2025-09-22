# Branch Protection & Security Configuration

## 🚨 CRITICAL: Enable Branch Protection Immediately

Your master branch is currently **unprotected**. For a production institutional system, this is a critical security risk. Follow these steps to secure your repository:

### 1. Enable Branch Protection Rules

Go to: **Settings** → **Branches** → **Add rule**

**Branch name pattern:** `master`

**Protection Rules:**
- ✅ **Require a pull request before merging**
  - Required approvals: **2**
  - Dismiss stale pull request approvals when new commits are pushed
  - Require review from Code Owners
  - Restrict who can dismiss pull request reviews

- ✅ **Require status checks to pass before merging**
  - Require branches to be up to date before merging
  - Status checks found in the last week for this repository:
    - `security-audit` (from CI workflow)

- ✅ **Require conversation resolution before merging**

- ✅ **Include administrators**
  - Enforce all configured restrictions above for administrators

- ✅ **Restrict pushes that create matching branches**
- ✅ **Allow force pushes**: ❌ **UNCHECKED** (force pushes disabled)
- ✅ **Allow deletions**: ❌ **UNCHECKED** (branch deletion disabled)

### 2. Required Status Checks

The following checks must pass before any merge to master:

- `security-audit` - Complete security analysis (Slither + tests)
- `build` - Foundry compilation
- `test` - Full test suite execution
- `lint` - Code formatting and style checks

### 3. Code Owners Setup

Create `.github/CODEOWNERS` file:

```
# Global owners (security-critical changes)
* @kevanbtc @security-reviewer

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