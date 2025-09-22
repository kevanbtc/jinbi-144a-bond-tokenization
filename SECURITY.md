# Security Policy

## 🔒 Security Overview

This repository contains production code for institutional financial systems. Security is our highest priority.

## 🚨 Reporting Security Vulnerabilities

**DO NOT** report security vulnerabilities through public GitHub issues.

### For Critical Security Issues:
- **Email:** security@jinbi.agency (encrypted)
- **PGP Key:** Available at https://jinbi.agency/security
- **Response Time:** Within 24 hours
- **Bounty Program:** Available for qualifying disclosures

### For General Security Questions:
- **Email:** security@jinbi.agency
- **Documentation:** See AUDIT_REPORT.md for known security measures

## 🛡️ Security Measures

### Code Security
- **Automated Analysis:** Slither static analysis on every commit
- **Test Coverage:** Minimum 95% required
- **Reentrancy Protection:** CEI pattern implemented
- **Access Control:** Role-based permissions with Safe multisig governance

### Infrastructure Security
- **Branch Protection:** Force pushes and deletions disabled
- **Code Review:** Required for all changes
- **CI/CD Gates:** Security checks must pass before merge
- **Dependency Scanning:** Automated vulnerability detection

### Operational Security
- **Emergency Pause:** All contracts can be paused by Safe multisig
- **Incident Response:** Documented procedures for security events
- **Audit Trail:** On-chain attestations for all security-related actions

## 🔍 Security Audit Status

### Current Audit
- **Auditor:** Leading DeFi Security Firm
- **Date:** September 2025
- **Scope:** All smart contracts and security controls
- **Result:** No critical vulnerabilities
- **Report:** See AUDIT_REPORT.md

### Ongoing Monitoring
- **Automated Scanning:** Daily security analysis
- **Dependency Updates:** Automated patch management
- **Code Reviews:** Required for security-critical changes

## 📋 Security Checklist for Contributors

### Before Submitting Code:
- [ ] Run `forge test` - All tests pass
- [ ] Run `slither .` - No security issues
- [ ] Check test coverage - Minimum 95%
- [ ] Code formatting - `forge fmt --check` passes
- [ ] No hardcoded secrets or private keys

### For Security-Critical Changes:
- [ ] Security review required
- [ ] Additional testing performed
- [ ] Documentation updated
- [ ] Emergency procedures reviewed

## 🚫 Prohibited Actions

- **Force Pushes:** Disabled on protected branches
- **Direct Commits:** All changes must go through PR
- **Secret Commits:** Never commit private keys or sensitive data
- **Unreviewed Code:** Security-critical changes require review

## 📞 Contact Information

- **Security Team:** security@jinbi.agency
- **Compliance:** compliance@jinbi.agency
- **Technical Support:** support@jinbi.agency

## 📜 Responsible Disclosure

We appreciate security researchers who follow responsible disclosure practices:

1. **Report privately** using the contact information above
2. **Allow time** for fixes (90 days for non-critical issues)
3. **Avoid public disclosure** until fixes are deployed
4. **Include details** to help us understand and fix the issue

## 🏆 Recognition

Security researchers who help improve our security will be:
- **Acknowledged** in security advisories (with permission)
- **Eligible for bounties** based on severity
- **Listed as contributors** in our security hall of fame

---

*This security policy applies to all JINBI institutional systems and repositories.*