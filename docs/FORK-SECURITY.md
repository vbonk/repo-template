# Fork Security Guide

How to securely work with forks of this repository.

## The Fork Model

```
upstream/repo (public, not yours)
       |
       | fork (GitHub creates a linked copy)
       v
you/repo (public, yours) ← origin
       |
       | clone
       v
local working copy
```

## Critical Rules

### 1. Never Commit on the Default Branch

Keep `main` as a clean mirror of upstream. Always branch for your work:

```bash
git checkout -b feature/my-change
```

### 2. Block Upstream Push

Prevent accidental pushes to the parent repository:

```bash
git config remote.upstream.pushurl "NEVER_PUSH_TO_UPSTREAM_USE_PR"
```

Now `git push upstream` will always fail — you must use PRs.

### 3. Review Before Pushing

Always check what you're about to push:

```bash
git diff origin/main...HEAD --stat   # What files changed
git log origin/main..HEAD --oneline  # What commits will be pushed
```

### 4. Sync Regularly

Keep your fork up to date with upstream:

```bash
git fetch upstream
git merge upstream/main
git push origin main
```

## Fork Network Data Leakage

**This is the most important thing most people don't know about forks.**

GitHub forks share a git object store. This means:

- A commit pushed to your fork and then **deleted** (via force-push or branch deletion) may still be **fetchable from the upstream repo** by its SHA hash.
- This applies to every repo in the fork network.
- GitHub's garbage collection runs on an unpredictable schedule — your "deleted" commit may persist for weeks or months.

**Rule: If you accidentally push a secret, ALWAYS rotate the credential immediately. Deleting the commit is NOT sufficient.**

## What's Safe to Push

| Safe | Not safe |
|------|----------|
| Code changes on feature branches | `.env` files |
| Bug fixes, documentation | API keys, tokens, passwords |
| Config files using env vars | Hardcoded credentials |
| Test files | Files with local machine paths |
| New features | Internal hostnames or IPs |

## Contributing Upstream via PR

```bash
# 1. Create a feature branch
git checkout -b fix/improve-error-handling

# 2. Make changes, commit
git add -p
git commit -m "fix: improve error handling for edge case"

# 3. Push to YOUR fork (not upstream)
git push origin fix/improve-error-handling

# 4. Open PR to upstream
gh pr create --repo upstream-owner/upstream-repo
```

## Commit Identity

Your commits include your name and email. Check what's configured:

```bash
git config user.name
git config user.email
```

If you want to use GitHub's no-reply email (hides personal email):

```bash
git config user.email "username@users.noreply.github.com"
```

## Commit Signing

Signed commits prove authorship. Set up SSH signing (recommended):

1. Generate or select an SSH key
2. Add it to GitHub: **Settings > SSH and GPG keys > New SSH key** (type: Signing Key)
3. Configure git:
   ```bash
   git config --global gpg.format ssh
   git config --global user.signingkey ~/.ssh/id_ed25519.pub
   git config --global commit.gpgsign true
   ```

## Security Checklist for Fork Contributors

- [ ] Upstream push URL is blocked
- [ ] Pre-commit hooks installed (`bash templates/hooks/setup-hooks.sh`)
- [ ] Working on a feature branch (not main)
- [ ] No secrets in committed files
- [ ] Reviewed diff before pushing
- [ ] Commit email is appropriate for public visibility

## See Also

- [SECURITY.md](../SECURITY.md) — Vulnerability reporting and incident response
- [BRANCH-PROTECTION.md](BRANCH-PROTECTION.md) — Branch protection setup
- [AI-SECURITY.md](AI-SECURITY.md) — Prompt injection defense
