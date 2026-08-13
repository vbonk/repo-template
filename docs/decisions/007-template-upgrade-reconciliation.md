# ADR 007 — Semantic Reconciliation for Downstream Template Upgrades

**Status:** Accepted  
**Date:** 2026-08-13

## Context

Repositories created from a GitHub template do not remain ordinary upstream branches of the source template. After Phase 0, downstream repositories intentionally diverge: project-specific README files, agent instructions, workflows, architecture, and source replace inherited scaffolding.

A simple file-sync or "make it match current repo-template" approach would therefore destroy legitimate project evolution.

## Decision

Downstream upgrades use semantic reconciliation rather than exact synchronization.

A small `.repo-template.yaml` marker records the source template and a stable `baseline_id`. Upgrade reasoning compares three conceptual states: the historical template baseline, the current project, and the current template baseline.

Fresh/pristine legacy instances may adopt the complete newer substrate after pristine state is verified. Mature repositories evaluate later template capabilities selectively and keep project-owned material authoritative.

The baseline ID is intentionally not a Git commit SHA. A file cannot reliably encode the SHA of the commit that contains itself, and downstream compatibility changes less frequently than individual template commits.

## Consequences

- Future agents can identify the last reconciled template baseline without reconstructing all history.
- Intentional project divergence is not treated as an error.
- Older repositories without the marker remain supported through conservative historical-baseline inference.
- Template releases should bump the baseline ID when downstream compatibility meaningfully changes.
- Phase 0 remains simple and separate from mature-project maintenance.

## Alternatives Rejected

- **Always recreate repositories from the newest template:** loses repository continuity and is unnecessary.
- **Exact upstream file sync:** conflicts with intentional project customization.
- **Full lifecycle state machine:** adds state unrelated to the narrower provenance problem.
- **Embed current Git SHA in the marker:** self-referential and brittle.
