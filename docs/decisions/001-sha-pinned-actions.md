# ADR-001: SHA-Pin All GitHub Actions

## Status

Accepted (2026-03, platform-enforced 2026-08)

## Context

Third-party Actions run with access to the repository. Version tags (`@v4`) are mutable — a compromised action repo can move a tag onto malicious code and every consumer runs it on the next trigger. The 2025 npm supply-chain compromises (chalk/debug) made the moving-reference attack class concrete.

## Decision

Every `uses:` reference is pinned to a full 40-hex commit SHA with a trailing `# vX.Y.Z` comment. Enforcement is layered: an anchored self-test check (`@[0-9a-f]{40}$` on step-key lines — tag pins and `@main` both fail), the same check in Validate Template CI, Dependabot updating the pins, and since 2026-08 the platform-level `sha_pinning_required` Actions policy set by `secure-repo.sh`, so GitHub itself rejects unpinned actions.

## Consequences

### Positive

- Immutable dependencies: a moved tag upstream cannot change what runs here
- Dependabot PRs make updates auditable diffs (old SHA → new SHA)
- Platform enforcement catches what convention misses

### Negative

- Pins go stale without Dependabot; the comment can lie about the SHA (the checker verifies the SHA format, not the comment's claim)
- Slightly noisier workflow files
