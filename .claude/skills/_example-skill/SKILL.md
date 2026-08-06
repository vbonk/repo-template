---
# =============================================================================
# EXAMPLE SKILL — Dependency Health Checker
# =============================================================================
# This is a working example. Customize it for your project or use it as-is.
#
# name: unique identifier for this skill
# description: CRITICAL — this is what Claude matches against when deciding
#   whether to use this skill. Include keywords that would appear in user
#   requests. Be specific, not vague.
# allowed-tools: (optional) restrict which tools this skill can suggest using.
#   Omit to allow all tools.
# =============================================================================
name: dependency-health
description: >-
  Check project dependencies for security vulnerabilities, outdated versions,
  and license compatibility issues. Use when reviewing dependencies, updating
  packages, running security checks, or when the user mentions "audit",
  "vulnerabilities", "outdated", or "dependencies".
allowed-tools: Bash, Read, Grep
---

# Dependency Health Checker

Check the project's dependencies for known vulnerabilities, outdated versions, and potential issues.

## When to Activate

- User asks about dependency security or vulnerabilities
- User is updating or adding dependencies
- User mentions "audit", "outdated", "vulnerable", or "dependencies"
- User is preparing for a release or deployment

## What to Check

### 1. Known Vulnerabilities

Run the appropriate audit command for the project's package manager:

```bash
# Node.js
npm audit --json 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Vulnerabilities: {d.get(\"metadata\",{}).get(\"vulnerabilities\",{})}')"

# Python
pip audit 2>/dev/null || echo "Install: pip install pip-audit"

# Go
govulncheck ./... 2>/dev/null || echo "Install: go install golang.org/x/vuln/cmd/govulncheck@latest"

# Rust
cargo audit 2>/dev/null || echo "Install: cargo install cargo-audit"
```

### 2. Outdated Dependencies

```bash
# Node.js
npm outdated 2>/dev/null

# Python
pip list --outdated 2>/dev/null

# Go
go list -m -u all 2>/dev/null

# Rust
cargo outdated 2>/dev/null
```

### 3. Report Format

Present findings as:

| Package | Current | Latest | Severity | Action |
|---------|---------|--------|----------|--------|
| express | 4.18.2 | 5.1.0 | Major | Review changelog before updating |
| lodash | 4.17.19 | 4.17.21 | Patch (security) | Update immediately |

### 4. Recommendations

- **Critical/High vulnerabilities:** Flag immediately, suggest specific update command
- **Outdated (major):** Note breaking changes, link to changelog
- **Outdated (minor/patch):** Suggest batch update
- **No issues found:** Confirm the project is healthy

## References

- [SECURITY.md](../../SECURITY.md) — vulnerability reporting
- [Dependabot config](../../.github/dependabot.yml) — automated updates
- [PROD_CHECKLIST.md](../../docs/PROD_CHECKLIST.md) — pre-deployment checklist
