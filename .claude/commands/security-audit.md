# Security Audit

Run a comprehensive security posture check on this repository.

## Steps

### 1. Run the hardening script in audit mode

```bash
bash scripts/secure-repo.sh
```

This checks GitHub settings (Dependabot, branch protection, tag protection, Actions permissions) and local protections (pre-commit hooks, forbidden tokens, .gitattributes, commit signing). Outputs a letter grade (A+ through D).

### 2. Review the scorecard

Report the results to the user. For any WARN or FAIL items, explain:
- What the check does
- Why it matters
- How to fix it (specific command)

### 3. Check for additional issues

Beyond the script, manually verify:

- **Fork status**: Is this a fork? If yes, check:
  - Upstream push is blocked: `git remote -v` → upstream push URL should be overridden
  - Actions are disabled (if not needed): `gh api repos/{owner}/{repo}/actions/permissions`
  - See `docs/FORK-SECURITY.md` for full guide

- **Secrets in history**: Quick scan for any `.env` files ever committed:
  ```bash
  git log --all --diff-filter=A --name-only -- '*.env' '.env.*' '!*.example'
  ```

- **CODEOWNERS active**: Check if CODEOWNERS lines are uncommented:
  ```bash
  grep -v '^#\|^$' .github/CODEOWNERS
  ```
  If all lines are commented, remind the user to uncomment and fill in their GitHub username.

- **CodeQL configured**: Check if a language is uncommented in `.github/workflows/codeql.yml`

### 4. Offer to fix

For any issues found, offer to run the fix commands. Group them:

**Quick fixes (safe to run now):**
- `bash scripts/secure-repo.sh` (if not already run)
- `bash templates/hooks/setup-hooks.sh` (if hooks missing)

**Manual steps (provide instructions):**
- Commit signing setup (see `docs/BRANCH-PROTECTION.md`)
- CODEOWNERS username (user must provide their GitHub handle)
- CodeQL language selection (user must choose their stack)

### 5. Summary

End with the security grade and a one-line status:
- **A+**: "All protections in place. Sleep well."
- **A/B**: "Core protections active. {N} optional items remaining."
- **C/D**: "Critical gaps found. Run the suggested commands before pushing code."
