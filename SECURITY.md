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
