# ADR-002: Repository Rulesets over Classic Branch Protection

## Status

Accepted (2026-08)

## Context

The template originally used the classic branch-protection API and the tag-protection API. GitHub removed tag protection entirely (August 2024) — the script kept calling the dead endpoint and warned forever. Classic protection also lacks new capabilities (tag rulesets, push rules, PR-only bypass modes), and this repo's own misconfigured ruleset (`~ALL` branches with `always` bypass) blocked Dependabot rebases for months while the docs claimed protections that were not enforced.

## Decision

`secure-repo.sh` creates or updates rulesets by name: "Protect Main" (deletion + non_fast_forward + required status checks on the default branch, admin bypass only via PR) and "Protect Release Tags" (`v*`: no delete/move/update). Scope conditions to `~DEFAULT_BRANCH` — never `~ALL`, which breaks Dependabot's force-push rebases. Bypass mode is `pull_request`, never `always` (an always-bypass defeats the seatbelt for the solo admin it protects).

## Consequences

### Positive

- Tags actually protected again; required checks reject direct pushes to main (verified by live probe)
- Idempotent by name — re-running the script converges instead of duplicating
- Docs, script, and enforced reality finally agree

### Negative

- Rulesets may be plan-gated on private repos (script degrades to WARN with remediation)
- Required-check contexts are CI-job-name-specific; users must edit them when renaming jobs
