# Security Policy

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please report it responsibly.

### How to Report

1. **Do NOT create a public GitHub issue** for security vulnerabilities
2. Use [GitHub's private vulnerability reporting](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability) (preferred)
3. Or email: <!-- TODO: Add your security contact email -->

### What to Include

- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

### Response Timeline

| Action | Timeframe |
|--------|-----------|
| Acknowledgment | Within 48 hours |
| Status update | Every 7 days |
| Resolution | Depends on severity |

### After Resolution

- We'll coordinate disclosure timing with you
- With permission, we'll credit you in the security advisory

## Supported Versions

<!-- TODO: Update with your version support policy -->

| Version | Supported |
|---------|-----------|
| Latest | Yes |
| Previous major | Security fixes only |
| Older | No |

## Security Best Practices

This repository follows security best practices:

- Dependencies monitored by Dependabot
- GitHub Actions pinned to SHA
- Secrets never committed (see `.gitignore`)
- Push protection enabled (recommended)

## Enabling Additional Security Features

In your repository settings, consider enabling:

1. **Secret scanning** - Detects committed secrets
2. **Push protection** - Blocks pushes with secrets
3. **Dependabot alerts** - Notifies of vulnerable dependencies
4. **Code scanning** - Finds vulnerabilities via CodeQL

See [GitHub Security Features](https://docs.github.com/en/code-security) for setup instructions.

Or run the automated setup: `bash scripts/secure-repo.sh`

## What To Do If a Secret Is Leaked

If a secret (API key, password, token, credential) is accidentally committed:

1. **Rotate the credential immediately** — this is the ONLY reliable mitigation. Do this BEFORE anything else.
2. **Check for unauthorized access** — review audit logs for the affected service to see if the credential was used.
3. **Remove from git history** — use [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/) or `git filter-repo` to purge the secret from all commits.
4. **Force-push the cleaned history** — `git push --force-with-lease` to update the remote.
5. **Request GitHub cache purge** — [contact GitHub Support](https://support.github.com) to clear cached views of the commit.
6. **Monitor for unauthorized usage** — watch for suspicious activity on the affected service for at least 30 days.

> [!WARNING]
> **Fork network caveat:** If your repo has been forked, the commit containing the secret may be accessible from other repos in the fork network even after deletion. GitHub shares object storage across forks. This is why **rotation is the only reliable fix** — deletion alone is not sufficient.

### Prevention

- Install the pre-commit hook: `bash templates/hooks/setup-hooks.sh`
- Configure forbidden tokens in `.git/hooks/forbidden-tokens.txt`
- Use environment variables (`.env` files are gitignored)
- Never hardcode credentials in source files
- See [docs/FORK-SECURITY.md](docs/FORK-SECURITY.md) for fork-specific guidance
