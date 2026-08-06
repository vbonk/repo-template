# ADR-005: Drift Detection — Severity Tiers and Fail-Closed Verification

## Status

Accepted (2026-03, fail-closed hardening 2026-08)

## Context

Downstream repos created from the template go stale as the template improves. A reusable workflow compares file blob SHAs against the template. Two design questions: which files matter how much, and what to report when the comparison itself cannot run (rate limit, outage, renamed file). The original implementation silently treated "could not fetch" as "no drift" — reassuring reports during exactly the conditions where drift goes unnoticed.

## Decision

Three severity tiers: error (security-load-bearing: .gitattributes, SECURITY.md — missing fails the run), warn (security tooling: secret-scan workflow, CodeQL, dependency-review, secure-repo.sh, hook templates), info (expected to diverge: ci.yml, dependabot.yml, agent configs). Unverifiable files are counted and FAIL the run as "inconclusive, not clean" — a skipped check is never a pass. Catalog-managed content (e.g. installed skills) is versioned by its own manifest, not this workflow.

## Consequences

### Positive

- Downstream repos learn about security-relevant divergence with proportionate urgency
- Outages produce loud inconclusive runs instead of false green
- Tier lists are explicit and reviewable

### Negative

- Fail-closed means transient GitHub API issues fail scheduled runs (rerun clears)
- Tier lists need maintenance as files are added or renamed
