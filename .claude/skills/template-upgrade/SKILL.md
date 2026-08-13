---
name: template-upgrade
description: "Reconcile an existing repository descended from vbonk/repo-template with a newer template baseline while preserving project-specific work. Use when asked to upgrade, update, sync, reconcile, refresh, or compare a repo-template-based project; when .repo-template.yaml is present; or when legacy template ancestry is suspected and current template improvements should be reviewed. Distinguish pristine legacy instances from lightly customized and mature projects, use semantic three-way reconciliation instead of file synchronization, and preserve project authority."
---

# Template Upgrade

Use this skill for downstream template maintenance after repository creation. It is not the normal first-agent bootstrap path for a fresh current template instance; that path is Phase 0.

## Source of Truth

Read `docs/TEMPLATE-UPGRADE.md` before performing an upgrade. If the local copy is absent or clearly older than the marker's canonical reference, retrieve the canonical specification referenced by `.repo-template.yaml`.

The SOP is model-neutral and authoritative. This skill is a Claude execution helper, not a replacement for the SOP.

## Activate When

- The user asks to upgrade, update, reconcile, refresh, or compare a repo-template-derived repository.
- `.repo-template.yaml` exists and template compatibility is being reviewed.
- A repository appears to descend from `vbonk/repo-template` but predates the provenance marker.
- A template security, agent-routing, governance, or repository-integrity improvement may need to be adopted downstream.

Do not activate merely because a mature project differs from current `repo-template`. Intentional divergence is expected.

## Execution Contract

1. Determine repository identity and confirm this is not the `vbonk/repo-template` source repository.
2. Read `.repo-template.yaml` when present; otherwise assess legacy ancestry from history and inherited template evidence.
3. Classify project maturity as PRISTINE, LIGHTLY_CUSTOMIZED, PROJECT_MATURE, or AMBIGUOUS.
4. Build the SOP's three-way model:
   - A: historical template baseline,
   - B: current project,
   - C: current template.
5. Review A to C changes by downstream value. Prioritize security, agent safety/routing, and repository integrity; treat source-template marketing and maintenance machinery as non-downstream by default.
6. Reconcile against B semantically. Preserve project-owned behavior and intentional removals. Equivalent or stronger project controls satisfy a template improvement without requiring identical files.
7. Keep project-specific `CLAUDE.md` and `AGENTS.md` project-specific. Ensure they retain a concise Template Ancestry routing rule when `.repo-template.yaml` remains.
8. Verify repository controls that files alone cannot prove, where relevant.
9. Run project validation plus reconciliation-specific validation.
10. Update `.repo-template.yaml` to the current baseline only after successful reconciliation.
11. Report adopted, adapted, equivalent, skipped, and unresolved changes separately.

## Legacy Repositories

Absence of `.repo-template.yaml` does not mean the repository is unrelated to the template. Use multiple independent ancestry signals and label confidence CONFIRMED, LIKELY, or UNKNOWN.

For a confirmed pristine legacy instance, refreshing the inherited substrate and then using Phase 0 is appropriate.

For an established legacy project, never reset it to the current template. Reconcile selectively and add provenance only after the upgrade succeeds.

## Safety Boundaries

- Do not overwrite project architecture, source, README, CI, agent instructions, or other project-owned material with current template versions merely because paths match.
- Do not restore removed template files without a demonstrated project need.
- Do not infer stack, licensing, deployment, or environment configuration from the template.
- Do not mark the new baseline as reconciled before validation passes.
- Use normal repository branch, review, and validation controls.

## Completion Check

Before declaring success, answer:

- What was the previous baseline or ancestry evidence?
- What maturity class is this project?
- Which current template improvements were reviewed?
- Which were adopted, adapted, already satisfied, skipped, or unresolved?
- What project validation passed?
- Were repository-level settings checked where relevant?
- Does the project retain future upgrade routing?
- Does `.repo-template.yaml` now truthfully represent completed reconciliation?
